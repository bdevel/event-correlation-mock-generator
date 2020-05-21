require_relative 'event'

# This is for events that are triggered at a certain time
# and date. 
class CorrelatedEvents::DelayedEvent < CorrelatedEvents::TimedEvent
  def initialize(feed, delay)
    @delay = delay
    super(feed, feed.current_time + pick_time(@delay))
  end

  # Moves the trigger_time forward so it's @delay from new current_time
  def sync_trigger_time()
    @trigger_time = @feed.current_time + pick_time(@delay)
  end

  def pick_time(t)
    if t.is_a?(Range)
      a = t.min
      b = t.max
      rand(b) + a
    else
      t
    end
  end
  
end

