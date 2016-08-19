
# Return seconds
class Numeric
  def days; self * 24.hours; end
  def hours; self * 60.minutes; end
  def minutes; self * 60; end
end

# Change a range into seconds
class Range
  def days
    self * 24.hours
  end
  
  def hours
    self * 60.minutes
  end
  
  def minutes
    self * 60
  end

  def *(x)
      (min * x)..(max * x)
  end
  
  def to_time
    rand(max - min) + min
  end
end
