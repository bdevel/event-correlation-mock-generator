require_relative 'triggered_event'

class CorrelatedEvents::Feed
  module FeedTriggerShortcuts

    # Set a trigger that will only fire once.
    def once(*trigger_events, &block)
      when_trigger = self.when(*trigger_events, &block)
      when_trigger.then do |f|
        f.subscribers.delete(when_trigger)
      end
      when_trigger
    end

    # Pass in an event that will trigger the effect
    def when(*trigger_events, &block)
      if block_given?
        @subscribers.push CorrelatedEvents::TriggeredEvent.new(self, &block)
      else
        trigger_events.flatten! # make sure it's not a nested array

        # Create a trigger thats based on new events coming into feed.
        new_event = CorrelatedEvents::TriggeredEvent.new(self) do |feed, new_event|
          trigger_events.any?{|t| new_event == t}
        end
        
        @subscribers.push(new_event)
        
      end
      @subscribers.last
    end

    
    
  end# module
end# class
