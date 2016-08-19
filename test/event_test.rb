require_relative 'test_helpers'

describe Event do
  
  it "has .then" do
    ran_1 = false
    ran_2 = false
    b1    = lambda {|f| ran_1 = true}
    b2    = lambda {|f| ran_2 = true}
    
    e = Event.new(nil)
    e.then(b1)
    e.then(b2)

    assert ran_1 == false, "already ran block 1"
    assert ran_2 == false, "already ran block 2"
    
    e.fire
    
    assert ran_1, "did not run block 1"
    assert ran_2, "did not run block 2"
  end

end
