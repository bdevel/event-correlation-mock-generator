require_relative 'triggered_event'

class CorrelatedEvents::TriggerOnceEvent <CorrelatedEvents::TriggeredEvent

  # After firing, then remove yourself from the feed's subscribers.
  def fire
    super
    @feed.unsubscribe(self)
  end
    
end
