require_relative 'event'

# This is for events that are triggered at a certain time
# and date. 
class CorrelatedEvents::ProbableEvent < CorrelatedEvents::Event
  
  def initialize(feed, prob)
    super(feed)
    @prob = prob
    @on_failures = []
  end

  def fire(*args, &block)
    if rand() <= @prob
      super(*args, &block)
    else
      @on_failures.each do |e|
        process_then(e)
      end
    end
  end
      
  def on_failure(effect=nil, &block)
    @on_failures.push(block || effect)
    self
  end


end

