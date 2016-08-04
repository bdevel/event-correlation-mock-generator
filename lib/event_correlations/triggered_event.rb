
class TriggeredEvent
  #attr_reader :feed, :trigger, :delay, :prob, :then, :pending
  
  def initialize(feed, &trigger_proc)
    @feed       = feed
    @trigger    = trigger_proc
    @delay      = 0
    @prob       = 1.0
    @then       = nil
    @pending    = nil
  end

  def then(effect=nil, &block)
    @then = block || effect
    return self
  end

  def delay(range_or_int)
    @delay = range_or_int
    return self
  end
  
  def prob(fraction)
    @prob = fraction
    return self
  end

  def after(later_event)
    @pending = Event.new(later_event)
    return self
  end
  
  def to_s()
    # indent
    p = @pending.to_s.split("\n").map{|s| "  #{s}"}.join("\n")
    
    "When: #{@event.inspect} \n" +
      "  Then:    #{@then.inspect} \n" +
      "  Delay:   #{@delay.inspect} \n" +
      "  Prob:    #{@prob.inspect}\n" +
      "  Pending: #{p}\n"
  end
  
end
