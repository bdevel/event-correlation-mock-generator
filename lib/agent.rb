require_relative 'timed_event'
require_relative 'trigger_once_event'
require_relative 'probable_event'
require_relative 'delayed_event'

class CorrelatedEvents::Agent
  
  #  behaviours Behaviours::EatsFood, Behaviours::WakesAndSleeps
  def initialize()
    activate_behaviours()
  end

  ######## Class Methods ########
  def self.behaviours(*modules)
    @@behaviours ||= []
    @@behaviours += modules
  end


  ############## Event methods  ##########
  
  # Shortcut helper to create a timed event and push into queue.
  def at(date_time)
    raise "Agent#at does not support supplying a block" if block_given?
    if !date_time.respond_to?(:year)
      raise "Cannot trigger timed event unless given exact date and time."
    end
    
    e = CorrelatedEvents::TimedEvent.new(self, date_time)
    queue_event e
  end
  
  # Shortcut to execute a block at the current_time plus an interval.
  def wait(time_add)
    raise "Agent#wait does not support supplying a block" if block_given?
    e = CorrelatedEvents::DelayedEvent.new(self, time_add)
    queue_event e
  end

  # Shortcut to make repeating timed event. Note, this will fire at the current_time
  # plus what ever interval is specified. Use within an #at to
  # set at a specific time of day.
  def every(time_add)
    raise "Agent#every does not support supplying a block" if block_given?
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
  
  

  
  private
  def activate_behaviours
    @@behaviours.each do |b|
      to_call = b.activate
      if to_call
        self.instance_eval(&to_call)
      end
    end
  end
  
end


# class Person < CorrelatedEvents::Agent
#   behaviours BloodSugar
#   def initialize()
#     super
#   end
# end

# agent = Person.new
# puts agent.blood_sugar
