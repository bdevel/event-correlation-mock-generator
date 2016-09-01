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
        e.fire
      end
    end
  end
    
  # If fails probablity
  def on_failure
    e = Event.new(@feed)
    @on_failures.push(e)
    return e
   end


end

