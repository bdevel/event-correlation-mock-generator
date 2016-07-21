
breakfast = %w{cerial no_breakfast eggs smoothie pancakes fruit}.map(&:to_sym)
lunch     = %w{pasta indian falafel pizza}.map(&:to_sym)
dinner    = %w{pizza pasta no_dinner chinese }.map(&:to_sym)
drinks    = %w{water water water soda soda milk juice}.map(&:to_sym)
snacks    = %w{candy chips crackers fruit pretzels carrots}.map(&:to_sym)

days_of_week = %w{monday tuesday wednesday thursday friday saturday sunday}.map(&:to_sym)



feed = Feed.new

# Trigger event after cause that is reported in the morning after a couple days
feed.when(:pizza)
    .then(:acne)
      .delay(2..3.days) # few days later..
      .prob(0.7)# 70% likely it will be reported
      .after(:wake) # Only fire after wake is triggered
        .prob(0.8) # 80% likely they will report it
        .delay(15..40.minutes) # reported after making the bed
    

# Make event where the failure to do an action will trigger
# a negative side effect.
feed.when(:wake)
    .then(:blood_pressure_meds)
      .prob(0.9)# almost always takes meds
      .delay(15..40.minutes) # after their shower
      .on_failure # When the probablity failes to trigger, do the then
        .then(:dizzy)
          .after(:lunch)
          .prob(0.9)
          .delay(45..90.minutes)

      

feed.when(:wake, :breakfast, :lunch, :dinner)
    .then(:smoke)
      .prob(0.6)
      .delay(20..90.minutes) # after their shower
      .then(:nausia)
        .after(:lunch)
        .prob(0.9)
        .delay(15..40.minutes)

# Search mechanisms

feed.past(1.day).count(:smoke)



days_to_generate = 365

while feed.time < days_to_generate.days
  feed.increment_time
end



# Things to test and target:
#   - Late lunch = low energy
#   - pizza  = headaches
#   - exercise = weight loss
#   - pizza = weight gain
#   - lots of tv = low energy
