require_relative 'event'

# This is for events that are triggered at a certain time
# and date. 
class CorrelatedEvents::TimedEvent < CorrelatedEvents::Event
  include Comparable
  
  attr_accessor :trigger_time
  
  def initialize(feed, trigger_time)
    super(feed)
    @trigger_time = trigger_time
  end
  
  def <=>(other)
    self.trigger_time <=> other.trigger_time
  end
  
end

