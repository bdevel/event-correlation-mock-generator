
class Time
  # hour of day as a float
  def hod
    hour + min / 60.0 + sec / 60.0 / 60
  end

  # seconds of day.
  def sod
    hod * 60 * 60
  end
  
  def tomorrow
    day = 24 * 60 * 60
    Time.at(self.to_i - self.sod + day)
  end
  
end
