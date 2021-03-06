require_relative 'test_helpers'

describe TimedEvent do

  it "will push block on init" do
    b = Proc.new {}
    e = TimedEvent.new(nil, nil)
    e.then(b)
    assert_equal [b], e.thens
  end

  
  it "accepts a block for init and then" do
    ran_1 = false
    ran_2 = false
    b2    = lambda {|f| ran_2 = true}
    
    e = TimedEvent.new(nil, nil).then do
      ran_1 = true
    end
    e.then(b2)

    assert ran_1 == false, "already ran block 1"
    assert ran_2 == false, "already ran block 2"
    
    e.fire
    
    assert ran_1, "did not run block 1"
    assert ran_2, "did not run block 2"
  end

end
