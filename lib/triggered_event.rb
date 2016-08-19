require_relative 'event'

class CorrelatedEvents::TriggeredEvent < CorrelatedEvents::Event
  #attr_reader :feed, :trigger, :delay, :prob, :then, :pending
  
  def initialize(feed, &trigger_proc)
    super(feed)
    @trigger = trigger_proc
  end

end
