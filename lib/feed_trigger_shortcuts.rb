require_relative 'triggered_event'

class CorrelatedEvents::Feed
  module FeedTriggerShortcuts

    # Pass in an event that will trigger the effect
    def when(*trigger_events, &block)
      if block_given?
        @subscribers.push CorrelatedEvents::TriggeredEvent.new(self, &block)
      else
        puts "adding new subsciber"
        # todo; test for triggered event. feed first in params?
        # Create a trigger thats based on new events coming into feed.
        new_event = CorrelatedEvents::TriggeredEvent.new(self) do |new_event, feed|
          # return tru to fire if any trigger events pass true for
          # new_event==(other) Which should compare .name by default
          #trigger_events.any?{|t| new_event == t}
          puts "========="
          true
        end
        
        puts "Pushing"
        @subscribers.push(new_event)
        
      end
      @subscribers.last
    end

  end
end
