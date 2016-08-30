
class CorrelatedEvents::Feed
  module FeedEventShortcuts
    # Shortcut helper to create a timed event and push into queue.
    def at(date_time, &block)
      if !date_time.respond_to?(:year)
        raise "Cannot trigger timed event unless given exact date and time."
      end
      
      queue_event CorrelatedEvents::TimedEvent.new(self, date_time, &block)
    end
    
    # Shortcut to take current time and add an interval
    def in(time_add, &block)
      trigger_time = @current_time + time_add
      queue_event CorrelatedEvents::TimedEvent.new(self, trigger_time, &block)
    end

    # Shortcut to make repeating timed event. Note, this will trigger at the current_time
    # plus what ever interval is specified. Use in combination with #at to set at a specific time of day.
    def every(time_add, &block)
      self.in(time_add, &block).then do |f|
        f.every(time_add, &block)
      end
    end
    
    # Safely pushes a new event onto the queue.
    def queue_event(e)
      if !e.respond_to?(:trigger_time)
        raise "Cannot queue an object that doesn't have a trigger time."
      end
      # TODO, queue gets very large, this is not an optamized function.
      @queue.push(e).sort_by!(&:trigger_time)
      return e
    end
    
  end
end

  
