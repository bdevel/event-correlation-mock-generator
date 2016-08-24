
class CorrelatedEvents::Event
  attr_accessor :feed, :delay, :prob, :thens, :pending

  def initialize(feed)
    @feed       = feed
    @delay      = 0
    @prob       = 1.0
    @thens      = []
    @pending    = []
    @did_fire   = false
  end

  # calls all the blocks that werer pending
  def fire
    # TODO: fail if check prob
    @thens.each do |t|
      t.call(@feed)
      #@did_fire = true
    end
  end
  
  #def did_fire?
  #  @did_fire
  #end
  
  # Tells if it's ready to be fired.
  def ready?
    
  end
  
  # Pass in a block or a symbol, or use do block
  def then(effect=nil, &block)
    if block
      @thens.push block
    elsif effect.respond_to?(:call)
      @thens.push effect
    else
      # push a new proc that that has the name of whatever
      # object the effect is.. hopefully a symbol.
      @thens.push lambda do |f|
        @feed.record(effect)
      end
    end
    
    #@thens.push(effect || block)
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

  # TODO:
  #def after(later_event)
  #  @pending = Event.new(later_event)
  #  return self
  #end
  
  # def to_s()
  #   # indent
  #   p = @pending.to_s.split("\n").map{|s| "  #{s}"}.join("\n")
    
  #   "When: #{@.inspect} \n" +
  #     "  Then:    #{@thens.inspect} \n" +
  #     "  Delay:   #{@delay.inspect} \n" +
  #     "  Prob:    #{@prob.inspect}\n" +
  #     "  Pending: #{p}\n"
  # end
  
end

