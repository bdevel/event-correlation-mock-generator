require_relative 'test_helpers'

describe CorrelatedEvents::Feed do
  before do
    @feed = CorrelatedEvents::Feed.new
  end


  describe "initialization" do
    it "takes start_time" do
      t = Time.now
      feed = Feed.new(start_time: t)
      assert_equal t, feed.current_time
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

    it "will queue events in order" do
      e1 = OpenStruct.new(trigger_time: 3.hours)
      e2 = OpenStruct.new(trigger_time: 4.hours)
      
      @feed.queue_event e2
      @feed.queue_event e1
      assert_equal e1, @feed.queue[0]
      assert_equal e2, @feed.queue[1]
    end
    
  end
  

  #############   TRIGGERS ####################

  describe "#at" do
    it "inserts TimedEvent into queue" do
      b = Proc.new{"do nothing"}
      @feed.at(@feed.current_time + 8.hours, &b)
      assert_equal CorrelatedEvents::TimedEvent, @feed.queue.last.class
    end
    
    it "updates current_time before firing" do
      expected_time = @feed.current_time + 2.hours
      actual_time = nil
      @feed.at(expected_time).then do |f|
        actual_time = f.current_time
      end
      @feed.play()
      assert_equal expected_time, actual_time
    end
  end
  
  describe "#wait" do
    it "inserts TimedEvent into queue with current_time + interval" do
      @feed.wait(8.hours){}
      assert_equal CorrelatedEvents::DelayedEvent, @feed.queue.last.class
      assert_equal (@feed.current_time + 8.hours), @feed.queue.last.trigger_time
    end
    
  end

  
  describe "#once" do
    it "inserts subscriber and removes it after fire" do
      fires = []
      @feed.once(:foo).then() {|f| fires << f.log.last.name }
      @feed.record(:baz)
      @feed.record(:foo)
      @feed.record(:foo)
      assert_equal [:foo], fires
      assert_equal 0, @feed.subscribers.size
    end
  end

  describe "#when" do
    it "will push a subscriber" do
      assert @feed.subscribers.size == 0, "Subscribers not empty"
      @feed.when(:foo)
      assert_equal CorrelatedEvents::TriggeredEvent, @feed.subscribers.last.class
    end
    
    it "will trigger for matches" do
      @feed.when(:foo, :bar)
      assert @feed.subscribers.last.trigger.call(nil, :foo), "did not match for foo"
      assert @feed.subscribers.last.trigger.call(nil, :bar), "did not match for bar"
    end

    it "will take custom block" do
      did_check = false
      @feed.when(){|f, e| did_check = e == :yes}
      @feed.subscribers.last.event_notification(:yes)
      assert_equal true, did_check
    end

  end
  
  ####### Logging Tests ##########
  
  describe "#record" do
    it "will push into log" do
      assert_equal 0, @feed.log.size
      @feed.record(:foo)
      assert_equal 1, @feed.log.size
      assert @feed.log.last.is_a?(CorrelatedEvents::Feed::LogItem)
    end
    
    it "will include properties" do
      @feed.record(:bar, :is_good? => true)
      assert @feed.log.last.is_good?
    end

  end
  
  
end

