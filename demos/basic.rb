require_relative '../lib/correlated_events'

feed = CorrelatedEvents::Feed.new(:max_current_time => 24.hours)

puts "Feed at #{feed.current_time}"

feed.at(feed.current_time + 8.hours)
  .then do |f|
  puts "8 hours later.. #{f.current_time}"
end


feed.wait(3.minutes)
  .then do |f|
  puts "3 minutes later... #{f.current_time}"
end

feed.at(feed.current_time + 4.hours) 
  .then do |f|
  f.every(1.hour) do |f2|
    # Log a :new_hour item, and pass a property called `time` to the log item
    f2.record :new_hour, time: f2.current_time.strftime("%H:%M")
  end
end

feed
  .once(:begining_of_log)# Only fire once.
  .then do |f|
    puts "#{f.log.last.name} was just logged."
  end


feed
  .when(:new_hour)# fires whenever :new_hour is logged
  .then do |f|
    puts "New Hour #{f.log.last.time}"
  end

feed.record(:begining_of_log)


feed.play()



