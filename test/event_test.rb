require_relative 'test_helpers'

describe Event do
  
  before :each do 
    @feed = Feed.new
    @event = Event.new(@feed)
  end
  

  describe TriggerOnceEvent do
    it "will remove from subscribers afting firing" do
      e = TriggerOnceEvent.new(@feed, :nap)
      assert_equal [], @feed.subscribers

      @feed.subscribe(e)
      e.fire
      assert_equal [], @feed.subscribers
    end
  end
  
  describe "#wait" do
    it "will insert with correct time after fire" do
      
      delay = 10.days
      now   = @event.feed.current_time.dup
      w     = @event.wait(delay)
      
      assert_equal now + delay, w.trigger_time
      assert w.respond_to?(:then)
      assert_equal 0, @feed.queue.size
      
      @event.fire
      
      assert_equal 1, @feed.queue.size
      assert_equal w, @feed.queue.last
      assert_equal now + delay, w.trigger_time

      #assert_equal now + delay, @feed.queue.last.trigger_time
    end
  end

  
  describe "#prob" do
    it "will go when 100 percent" do
      did_run = false
      @event.prob(100).then() {did_run = true}
      @event.fire
      assert did_run
    end

    it "will not go when 0 percent" do
      did_run = false
      @event.prob(0.0).then {did_run = true}
      @event.fire
      assert_equal false, did_run
    end

    it "will run on_failures" do
      did_run = false
      @event.prob(0.0).then.on_failure {did_run = true}
      @event.fire
      assert did_run
    end
  end

  
  describe "#when" do
    it "will return a TriggerOnceEvent that adds itself to the subscribers after fire" do
      e = TriggerOnceEvent.new(@feed, :nap)
      assert_equal [], @feed.subscribers
      
      w = e.when(:wake) # this returns a new event
      assert_equal [], @feed.subscribers  
      e.fire
      
      assert_equal [w], @feed.subscribers
    end
  end

  it "will run all the .thens" do
    @ran_1 = false
    @ran_2 = false
    b1    = lambda {|f| @ran_1 = true}
    b2    = lambda {|f| @ran_2 = true}
    

    @event.then(b1)
    @event.then(b2)

    assert @ran_1 == false, "already ran block 1"
    assert @ran_2 == false, "already ran block 2"
    
    @event.fire
    
    assert @ran_1, "did not run block 1"
    assert @ran_2, "did not run block 2"
  end

  it "will log properly" do
    @event.then(:foo, :bar)
    @event.fire
    assert_equal [:foo, :bar], @feed.log.map(&:name)
  end


  it "run a Proc passed as an to #then" do
    did_run = false
    p = lambda {|f| did_run = true}
    @event.then(p)
    @event.fire
    assert did_run
  end


end
