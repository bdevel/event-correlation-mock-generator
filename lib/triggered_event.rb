require_relative 'event'

class CorrelatedEvents::TriggeredEvent < CorrelatedEvents::Event
  attr_reader :trigger
  
  def initialize(feed, &block)
    super(feed)
    @trigger = block
  end

  # Feed subscribers will get a notification
  # with this method. 
  def event_notification(new_entry)
    if @trigger.call(@feed, new_entry)
      fire()
    end
  end
  
end
