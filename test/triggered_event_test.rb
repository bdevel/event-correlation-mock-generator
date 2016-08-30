require_relative 'test_helpers'

describe TriggeredEvent do
  before do
    @feed = Feed.new
  end

  describe "#then" do
    it "returns itself" do
      e = TriggeredEvent.new(@feed) do |f, new_event|
        true
      end
      assert_equal e.object_id, e.then(:bar).object_id
    end
    
    # it "sets @then for symbols" do
    #   e = Event.new(:foo, $feed)
    #   e.then(:bar)
    #   assert_equal :bar, e.then
    # end
    
  end
  
end

