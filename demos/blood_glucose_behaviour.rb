
module BloodGlucose
  include CorrelatedEvents::Behaviour
  
  attr_accessor :blood_glucose
  
  activate do
    @blood_glucose = 100
    
    self.when(:glucose, :carbs, :rice, :wheat)
      .wait(1.hour).then {shift_blood_glucose(+40) }
    
    # After two hours meal should return to baseline.
    # Should also continue downward all day.
    self.ever(30.minutes).then do
      shift_blood_glucose(-5)
    end
  end


  
  def shift_blood_glucose(amount)
    new_value = @blood_glucose + amount
    # set a band between 80 and 160
    if new_value < 80
      new_value = 80
      
    elsif new_value > 160
      new_value = 160
    end
    @blood_glucose = new_value
  end
  
end

