require_relative 'test_helpers'
require_relative '../ext/time'

describe Time do
  
  it "returns proper #hod" do
    assert_equal 1 + 1.0/60 + 1.0/60/60, Time.new(1969, 4, 20, 1, 1 ,1).hod
  end

  it "returns proper #sod" do
    assert_equal (60 * 60) + 60 + 1, Time.new(1969, 4, 20, 1, 1 ,1).sod
  end
  
  it "returns proper #tomorrow" do
    assert_equal Time.new(1969, 4, 21), Time.new(1969, 4, 20, 1, 1 ,1).tomorrow
  end

  it "returns zero time for #tomorrow" do
    tmr = Time.new(1969, 4, 20, 1, 1 ,1).tomorrow
    assert_equal 0, tmr.hour
    assert_equal 0, tmr.min
    assert_equal 0, tmr.sec
  end
  
end


