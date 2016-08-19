require_relative '../lib/correlated_events'

feed = CorrelatedEvents::Feed.new()

feed.at(feed.current_time + 8.hours) do |f|
  puts "at #{f.current_time}"
end

# starting at when???
feed.every(1.day) do |f|
  puts "at #{f.current_time}"
end


feed.play()

