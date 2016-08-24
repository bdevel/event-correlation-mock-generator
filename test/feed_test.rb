require_relative 'test_helpers'

describe CorrelatedEvents::Feed do
  before do
    @feed = CorrelatedEvents::Feed.new
  end

  it "takes start_time" do
    t = Time.now
    feed = Feed.new(start_time: t)
    assert_equal t, feed.current_time
  end
  
  describe "#at" do
    it "inserts TimedEvent into queue" do
      b = Proc.new{"do nothing"}
      @feed.at(@feed.current_time + 8.hours, &b)
      assert_equal CorrelatedEvents::TimedEvent, @feed.queue.last.class
      assert @feed.queue.last.thens.include?(b), "thens does not include given block"
    end
    
  end
  
  describe "#in" do
    it "inserts TimedEvent into queue with current_time + interval" do
      @feed.in(8.hours){}
      assert_equal CorrelatedEvents::TimedEvent, @feed.queue.last.class
      assert_equal (@feed.current_time + 8.hours), @feed.queue.last.trigger_time
    end
    
  end


  ###### EVENTS
  
  def event_mock(ttime, *opt)
    out = Minitest::Mock.new
          .expect(:trigger_time, ttime)
    out.expect(:fire, nil) if opt.include?(:fire)
    out
  end
  
  describe "queueing and playing" do
    it "will pull events from the queue on play" do
      # Make sure it asks for trigger_time
      # and it gets fired
      ttime       = Time.now
      timed_event = event_mock(ttime, :fire)
      
      @feed.queue.push(timed_event)
      @feed.current_time = Time.now - 2.hours
      @feed.play

      # should have updated to events trigger time
      assert_equal ttime, @feed.current_time
      timed_event.verify
    end
    
    
    it "will stop playing when max time reached" do
      max_time = Time.now + 3.hours
      @feed = Feed.new(:max_current_time => max_time)
      
      timed_event = Minitest::Mock.new
                    .expect(:trigger_time, max_time + 1.second)

      @feed.queue.push(timed_event)
      begin
        @feed.play()
        assert false, "did not raise max time reached"
      rescue Exception => e
        assert_match /max.*time/i, e.to_s
      end
      timed_event.verify
    end
    
  end
  
  
  it "will queue events in order" do
    e1 = OpenStruct.new(trigger_time: 3.hours)
    e2 = OpenStruct.new(trigger_time: 4.hours)
    
    @feed.queue_event e2
    @feed.queue_event e1
    assert_equal e1, @feed.queue[0]
    assert_equal e2, @feed.queue[1]
  end
  


  # TRIGGERS

  describe "#when" do
    it "must respond positively" do
    end
  end
  
  
  # TODO:
  # It should update it's current_time to the next timed event's time trigger
  # before firing the event. 
  
end

