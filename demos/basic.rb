require_relative '../lib/correlated_events'

feed = CorrelatedEvents::Feed.new(:max_current_time => 24.hours)

puts "Feed at #{feed.current_time}"

feed.at(feed.current_time + 8.hours) do |f|
  puts "8 hours later.. #{f.current_time}"
end


feed.in(3.minutes) do |f|
  puts "3 minutes later... #{f.current_time}"
end


feed.at(feed.current_time + 4.hours) do |f|
  f.every(1.hour) do |f2|
    puts "  Time is #{f2.current_time.strftime("%H:%M")}"
  end
end


feed
  .when(:begining_of_log)
  .then do |f|
     puts "#{f.log.last.name} was just logged."
    f.record(:has_started_logging)
  end


feed.record(:begining_of_log)

# starting at when???
#feed.every(1.day) do |f|
#  puts "at #{f.current_time}"
#end


feed.play()

