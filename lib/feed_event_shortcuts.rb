
class CorrelatedEvents::Feed
  module FeedEventShortcuts

    
    # Shortcut helper to create a timed event and push into queue.
    def at(date_time)
      if !date_time.respond_to?(:year)
        raise "Cannot trigger timed event unless given exact date and time."
      end
      
      e = CorrelatedEvents::TimedEvent.new(self, date_time)
      queue_event e
    end
    
    # Shortcut to execute a block at the current_time plus an interval.
    def wait(time_add)
      e = CorrelatedEvents::DelayedEvent.new(self, time_add)
      queue_event e
    end

    # Shortcut to make repeating timed event. Note, this will fire at the current_time
    # plus what ever interval is specified. Use within an #at to
    # set at a specific time of day.
    def every(time_add)
      self.wait(time_add)
        .then(&block)
        .then {|f| f.every(time_add).then(&block) }
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

  
