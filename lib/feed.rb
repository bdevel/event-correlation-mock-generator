require_relative 'timed_event'
require_relative 'trigger_once_event'
require_relative 'probable_event'
require_relative 'delayed_event'
require_relative 'feed_event_shortcuts'
require_relative 'log_item'

class CorrelatedEvents::Feed
  include FeedEventShortcuts
  
  class MaxTimeReached < Exception; end;

  
  attr_accessor :current_time,# State of feed.
                :queue, # Upcoming time events 
                :log,# The history of recorded events.
                :prefs, # preference options
                :subscribers # who is watching the feed for new events

  # Options:
  #   start_time: defaults to 0000-01-01 00:00:00
  #   max_current_time: when to stop play from running queued events
  def initialize(**prefs)
    @prefs        = prefs
    @queue        = []# Time based events
    @subscribers  = [] # Triggered events who wants to be notified of new events
    @current_time = prefs[:start_time] || Time.new(0) # start at 0000-01-01 00:00:00
    @log          = []

    # if they passed in 24.hours, then set it to a real time
    if @prefs[:max_current_time].is_a?(Numeric)
      @prefs[:max_current_time] = @current_time + @prefs[:max_current_time]
    end

  end


  ###################################################

  # Starts
  def play()
    # Get the first timed event to fire
    while e = @queue.shift
      begin
        # Shift the current time to trigger time, then fire event
        self.current_time = e.trigger_time
      rescue MaxTimeReached
        @queue.unshift e # put back in queue since we didn't run it
        break
      end
      # Fire now!
      e.fire
    end
  end
  
  
  # Put an entry onto the log
  def record(name, **properties)
    new_entry = LogItem.new(current_time, name, **properties)
    @log.push(new_entry)
    # todo, instead of notifying everyone, just use a hashmap
    # so a subscriber can monitor a single channel name
    @subscribers.each do |s|
      s.event_notification(new_entry)
    end
  end
  
  def current_time=(new_time)
    if @prefs[:max_current_time] && new_time > @prefs[:max_current_time]
      @current_time =  @prefs[:max_current_time]
      raise MaxTimeReached.new("max time reached")
    end
    # New time is good. Lets continue.
    @current_time = new_time
  end


  def subscribe(obj)
    @subscribers.push(obj)
    self
  end

  def unsubscribe(obj)
    @subscribers.delete(obj)
    self
  end


  ########### Triggers #############
  
  def once(*args, &block)
    e = CorrelatedEvents::TriggerOnceEvent.new(self, *args, &block)
    subscribe(e)
    return e
  end  

  def when(*args, &block)
    e = CorrelatedEvents::TriggeredEvent.new(self, *args, &block)
    subscribe(e)
    return e
  end
  
  
end

