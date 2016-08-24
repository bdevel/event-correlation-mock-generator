require_relative 'event'

class CorrelatedEvents::TriggeredEvent < CorrelatedEvents::Event
  #attr_reader :feed, :trigger, :delay, :prob, :then, :pending
  
  def initialize(feed, &block)
    super(feed)
    @trigger = block
    puts "got trigger of #{block.class}" 
  end

  # Feed subscribers will get a notification
  # with this method. 
  def event_notification(new_entry)
    if @trigger.call(@feed, new_entry)
      fire()
    end
  end
  
  def ready?
    @trigger.call()
  end
  
end
