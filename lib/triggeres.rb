
class CorrelatedEvents::Triggers

  def self.at_time(hod)
    return Proc.new do |f|
      fct = f.current_time# feed current time
      feed_hod = fct.hour + fct.min / 60.0 + fct.sec / 60.0 /60
      hod.round(2) == feed_hod.round(2)
    end
  end
  
end
