require_relative '../lib/correlated_events'

feed = CorrelatedEvents::Feed.new(start_time: Time.now,
                                   max_current_time: Time.now + 6.days)

jump_day = lambda do |f|
  puts "At #{f.current_time}"

  trigger_time = f.current_time + 1.day
  f.at(trigger_time, &jump_day)
end

feed.at(feed.current_time, &jump_day)
