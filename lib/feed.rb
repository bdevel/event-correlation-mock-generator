require_relative 'timed_event'

class CorrelatedEvents::Feed
  attr_accessor :current_time, :queue
  
  def initialize()
    @queue = []
    @current_time = Time.new(0) # start at 0000-01-01 00:00:00
  end
  
  def at(time_of_day, &block)
    if !time_of_day.is_a?(Time)
      raise "Cannot trigger timed event unless given exact date and time."
    end
    queue_event CorrelatedEvents::TimedEvent.new(self, time_of_day, &block)
  end
  
  def play()
    # Get the first timed event to fire
    while e = @queue.shift # TODO: && @current_time < max_time
      self.current_time = e.trigger_time
      e.fire
    end
  end
  
  private
  def queue_event(e)
    #@queue.each.with_index do |e|
      
    #end
    @queue.push(e)
  end
  
end


class CorrelatedEvents::XFeed

  def initialize()
    @subscribers = []
    @time = Time.new(0)
    @log = []
  end

  ########### Logging Functions #############

  def push(event)
    # TODO: Feed must allow inserting of events back in time,
    #       and allow those inserts to cause other .whens to trigger
    #       atr that prior time stamp.
    if event.is_a?(LogItem)
      @log.push(event)
    else
      @log.push LogItem.new(event, @time)
    end
  end
  

  
  ########### Triggering Functions #############

  def every(time_interval)
    # TODO: Don't allow ranges, better to do .delay 
    self.when do
      time % time_interval
    end
  end
  
  # Call something at a certain time
  def at(time_or_range)
    # Create a time based trigger
    @subscribers.push TriggeredEvent.new(self) do |new_event, feed|
      # TODO
    end
    @subscribers.last
  end

  # Pass in an event that will trigger the effect
  def when(*trigger_events, &block)
    if block
      @subscribers.push TriggeredEvent.new(self, &block)
    else
      # Create a trigger thats based on new events coming into feed.
      @subscribers.push TriggeredEvent.new(self) do |new_event, feed|
        trigger_events.include?(new_event)
      end
    end
    @subscribers.last
  end

  
  ########### Time Functions #############

  def increment_time
    # TODO: I'm not sure of the best way to step through time. We
    #       probably don't want to step every second. Maybe minute or 15 minutes?
    #       There might be a way to chain all the events without stepping the time
    #       but it might be more complicated.
  end

  
  
  ########### Dump Functions #############
  
  def to_csv
    # TODO
    # event,timestamp
    # wake, 2015-04-12 8:00:00
    # breakfast, 2015-04-12 8:00:00
  end

  def each(&block)
    # TODO: ensure it's sorted by time stamp.
    # loop through all events
    @log.each(&block)
  end
  
end

