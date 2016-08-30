
class CorrelatedEvents::Event
  attr_accessor :feed, :delay, :prob, :thens, :after#, :failure_thens

  def initialize(feed)
    @feed       = feed
    @delay      = 0
    @prob       = 1.0
    @thens      = []
    @failure_thens = []
    @after      = nil
    @did_fire   = false
  end

  # calls all the blocks that werer pending
  def fire
    if rand() <= @prob
      if @after
        f.subscribers.push(@after)
      else 
        @thens.each do |t|
          process_then(t)
        end
      end
    else
      # @failure_thens.each do |t|
      #   t.call(@feed)
      # end
    end
  end
  
  # Pass in a block or a symbol, or use do block
  def then(effect=nil, &block)
    if block_given?
      @thens.push(block)
    else
      @thens.push(effect)
    end
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

  # def on_failure(effect=nil, &block)
  #   @failure_thens << record_or_block(effect, block)
  # end
  
  # Wait to fire @thens until this event has triggered.
  
  # def after(*trigger_events, &block)
  #   if block_given?
  #     @after = block
  #   else
  #     @after = trigger_events
  #   end
  #   return @after
  # end
  
  def after(*trigger_events, &block)
    # Similar code for feed#when
    if block_given?
      @after = CorrelatedEvents::TriggeredEvent.new(@feed, block)
    else
      trigger_events.flatten!
      @after = CorrelatedEvents::TriggeredEvent.new(@feed) do |feed, new_event|
        trigger_events.any?{|t| new_event == t}
      end
    end

    # Do only once
    @after.then do |f|
      f.subscribers.delete(@after)
    end
    
    # Call all the thens only after firing the after
    outer_event = self
    @after.then do |f|
      outer_event.thens.each do |t|
        process_then(t)
      end
    end
    
    return @after
  end
  
  # def to_s()
  #   # indent
  #   p = @pending.to_s.split("\n").map{|s| "  #{s}"}.join("\n")
    
  #   "When: #{@.inspect} \n" +
  #     "  Then:    #{@thens.inspect} \n" +
  #     "  Delay:   #{@delay.inspect} \n" +
  #     "  Prob:    #{@prob.inspect}\n" +
  #     "  Pending: #{p}\n"
  # end

  private

  def process_then(effect)
    if effect.respond_to?(:call)
      effect.call(@feed)
    else
      @feed.record(effect)
    end
  end
  

  # def process_then(effect)
  #   if @delay > 0 && @after
  #     @feed.in(@delay).then do |f|
  #       #f.once(@after).then(effect)
  #       f.subscribers.push(@after)
  #     end
      
  #   elsif @delay > 0
  #     @feed.in(@delay).then(effect)

  #   elsif @after
  #     @feed.once(@after).then(effect)
      
  #   elsif effect.respond_to?(:call)
  #     effect.call(@feed)
  #   else
  #     @feed.record(effect)
  #   end
  # end
  
end

