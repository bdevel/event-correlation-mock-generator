require_relative 'triggered_event'

class CorrelatedEvents::Feed
  module FeedTriggerShortcuts

    # Pass in an event that will trigger the effect
    def when(*trigger_events, &block)
      if block_given?
        @subscribers.push CorrelatedEvents::TriggeredEvent.new(self, &block)
      else
        # todo; feed first in params?
        # Create a trigger thats based on new events coming into feed.
        new_event = CorrelatedEvents::TriggeredEvent.new(self) do |feed, new_event|
          trigger_events.any?{|t| new_event == t}
        end
        
        @subscribers.push(new_event)
        
      end
      @subscribers.last
    end

  end
end
