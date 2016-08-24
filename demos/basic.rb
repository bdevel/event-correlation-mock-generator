require_relative '../lib/correlated_events'

feed = CorrelatedEvents::Feed.new()

puts "Feed at #{feed.current_time}"

feed.at(feed.current_time + 8.hours) do |f|
  puts "8 hours later.. #{f.current_time}"
end


feed.in(3.minutes) do |f|
  puts "3 minutes later... #{f.current_time}"
end


feed
  .when(:begining_of_log)
  .then do |f|
  puts "#{f.log.last.name} was just logged."
    f.record(:has_started_logging)
  end

feed.record(:begining_of_log)
puts feed.log.inspect


# starting at when???
#feed.every(1.day) do |f|
#  puts "at #{f.current_time}"
#end


feed.play()

