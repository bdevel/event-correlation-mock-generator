require_relative 'test_helpers'

describe CorrelatedEvents::Feed do
  before do
    @feed = CorrelatedEvents::Feed.new
  end

  describe "#at" do
    it "inserts TimedEvent into queue" do
      b = Proc.new{"do nothing"}
      @feed.at(@feed.current_time + 8.hours, &b)
      assert_equal CorrelatedEvents::TimedEvent, @feed.queue.last.class
      assert @feed.queue.last.thens.include?(b), "thens does not include given block"
    end
    
  end
  
  
  describe "#when" do
    it "must respond positively" do
    end
  end
  
end

