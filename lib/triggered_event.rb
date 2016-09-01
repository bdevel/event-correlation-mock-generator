require_relative 'event'

class CorrelatedEvents::TriggeredEvent < CorrelatedEvents::Event
  attr_reader :trigger

  # First argument is the feed, then the remaining
  # is the list of triggers. Usually a list of symbols.
  # Or, you can pass a block.
  def initialize(feed, *trigger_events, &block)
    super(feed)
    #@trigger = block

    if block_given?
      @trigger = block
    else
      trigger_events.flatten! # make sure it's not a nested array

      # Check if the new event is in the trigger_events
      @trigger = Proc.new do |feed, new_event|
        trigger_events.any?{|t| new_event == t}
      end
    end

    # Add self to the feed's subscribers
    @feed.subscribers.push(self)
  end

  # Feed subscribers will get a notification
  # with this method. 
  def event_notification(new_entry)
    if @trigger.call(@feed, new_entry)
      fire()
    end
  end
  
end
