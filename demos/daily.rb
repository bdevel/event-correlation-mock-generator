
require_relative '../lib/correlated_events'
include CorrelatedEvents

breakfast_foods = %w{cerial no_breakfast eggs smoothie pancakes fruit}.map(&:to_sym)
lunch_foods     = %w{pasta indian falafel pizza}.map(&:to_sym)
dinner_foods    = %w{pizza pasta no_dinner chinese }.map(&:to_sym)
drinks    = %w{water water water soda soda milk juice}.map(&:to_sym)
snacks    = %w{candy chips crackers fruit pretzels carrots}.map(&:to_sym)

days_of_week = %w{monday tuesday wednesday thursday friday saturday sunday}.map(&:to_sym)


# A Feed is the log of a users daily activity.
# The feed starts at time zero and progresses forward
# and events are triggered by time or by other events.
feed = Feed.new(:max_current_time => 356.days)# Specify how many days worth of data to generate.


# Feed#every will call repeated at specified interval.
# Ruby's Range has been extended to do allow a random interval between a range.
feed.every(2..3.days)
  .when(:lunch).wait(10.minutes).then(:bread)

# Feed#at will call the block every day at a certain hour of the day.
feed.when(:wake).wait(16.hours).then do |f|
  f.record(:sleep)
end

feed.when(:wake).wait(8.hours).then(:take_nap)


# More basic examples:

feed.when(:friday, :saturday)
  .prob(0.3)
  .when(:dinner)
  .then(:pizza)

feed.when(:wake)
  .prob(0.8)
  .wait(10..30.minutes)
  .then(:breakfast)


feed.when(:breakfast)
  .prob(0.8)
  .then pick_random(breakfast_foods)


feed.when(:breakfast)
  .then do |f|# allow passing blocks
      f.record breakfast_foods.random()
    end

# Implement Feed#every
feed.every(3.days)
  .then(:call_home)


#### Long Chained events.


feed.when(:pizza)
  .wait(2..3.days)
  .when(:wake)
  .prob(0.90)
  .wait(10.minutes)
  .then(:pimple)



# Make event where the failure to do an action will trigger
# a negative side effect.
take_meds = feed.when(:wake)
    .prob(0.9)# almost always takes meds    
    .wait(15..40.minutes) # after their shower
    .then(:coffee)
    .otherwise(:headache)
    .prob(0.9)
    .delay(45..90.minutes)
    .after(:lunch)

      
# Allow passing many triggers
when_smoke = feed.when(:breakfast, :lunch, :dinner)
                   .then(:smoke)
                     .prob(0.6)# Smokes after a meal 60% of the time..
                     .delay(20..90.minutes)

when_smoke.then(:nausia) # Further, when :smoke is triggered, it call's it's .then
            .after(:using_computer)  # Nausia is triggered 90% of the time after they
            .prob(0.9)             # have been sitting at the computer for
            .delay(15..40.minutes) # 15-40 minutes.



# The Feed must implement ways to search through it's log to allow different
# kinds of triggers.

# Complex back searches. Triggers when certain level of activity is reached.
# Example, user has energy crashes after eating too much sugar
feed.when do |f|
  # Block is passed the feed. It is called for every new event that is logged.
  # The block must return true or false to trigger
  f.past(1.day).count(:sugar) > 3 && f.past(1.day).count(:low_energy) == 0
end
  .then(:low_energy)
    .delay(2..3.hours)
    .prob(0.7)







# Allow combining blocks  .when
is_weekend     = lambda {|f| f.time.friday? || f.time.saturday? }
away_from_home = lambda {|f| f.past(24.hours).count(:home) == 0 }
with_family    = lambda {|f| f.past(2.hours).count(:family) == 0}
with_buddies   = lambda {|f| f.past(2.hours).count(:buddies) > 0}
night_time     = lambda {|f| f.time.hour > 18}

# Please extend Proc to allow for bitise operators to act as logic operators.
#                    OR              NOT           AND            AND
# feed.when(is_weekend | away_from_home ~ with_family & with_buddies & night_time)
#   .then(:alcohol)
#   .probability(0.8)


# Example, get a hang over in the morning
feed.when(:alcohol)
  .then(:headache)
    .prob(0.80)
    .after(:wake)# Will put a trigger waiting for the next :wake event
      .delay(0..40.minutes)


feed.when(:alcohol)
  .then(:low_blood_sugar)
    .prob(0.90)
    .delay(60..120.minutes)


class LogicProc < Proc
  def > (other)
    #...
  end
  def < (other)
    #...
  end
end

def count_today(item)
  return LogicProc.new do |f|
    f.past(f.time.hour.hours).count(item)
  end
end

# Allow Procs to accept < and > comparison to a Proc or Integer
# Here, count_today is function that returns a Proc for the .where.
feed.when(count_today(:coffee) > count_today(:water))
    .then(:headache)
      .prob(0.9)
      .delay(20..120.minutes)

feed.when(count_today(:headache) > 2)
    .then(:asprin)
      .prob(0.9)
      .delay(5..10.minutes)


puts feed.to_csv

# wake, 2010-01-01 12:12:00
# breakfast, 2010-01-01 12:12:00
# eggs, 2010-01-01 12:12:00

