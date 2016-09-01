
class CorrelatedEvents::Event
  attr_accessor :feed, :delay, :prob, :thens, :after#, :failure_thens

  def initialize(feed)
    @feed       = feed
    @thens      = []
  end
  
  # Pass in a block or a symbol, or use do block
  def then(*effects, &block)
    @thens.push(block || effects)
    return self
  end

  def wait(delay)
    event = CorrelatedEvents::DelayedEvent.new(@feed, delay)
    self.then do |f|
      # only queue after fireing. But update to new time.
      event.sync_trigger_time()
      @feed.queue_event(event)
    end
    return event
  end
  
  def prob(fraction)
    event = CorrelatedEvents::ProbableEvent.new(@feed, fraction)
    self.then do
      # Fire will do it's probable stuff.
      event.fire
    end
    return event
  end
  
  # Returns a new TriggerOnceEvent will add it'self to the feeds
  # subscribers after this event is fired.
  def when(*triggers, &block)
    # Create a new triggered_event to return.
    # After we fire, we'll add then trigger to the fee's subscriber list
    event = CorrelatedEvents::TriggerOnceEvent.new(@feed, *triggers, &block)
    self.then do
      @feed.subscribe(event)
    end
    return event
  end
  
  # calls all the blocks that werer pending
  def fire
    @thens.each do |t|
      process_then(t)
    end
  end
  
  private

  def process_then(effect)
    if effect.respond_to?(:call)
      effect.call(@feed)
    elsif effect.is_a?(Array)
      effect.each {|e| process_then(e)}      
    else
      @feed.record(effect)
    end
  end
  
end

