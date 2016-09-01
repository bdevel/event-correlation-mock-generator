
module CorrelatedEvents
end

class CorrelatedEvents::Agent
#  behaviours Behaviours::EatsFood, Behaviours::WakesAndSleeps
    def initialize()
      puts "doing agent init"
    end
end

class Person < CorrelatedEvents::Agent
  
  module BloodSugar
    def self.activate(agent)
      @blood_sugar = 100

      agent
        .when(:sugar, :carbs, :rice, :wheat)
        .wait(1.hour).then {@blood_sugar = [@blood_sugar + 40, 160].min }# 160 max
        
      # After two hours meal should return to baseline.
      agent.ever(30.minutes).then do
        @blood_sugar = [@blood_sugar - 5, 80].max# min of 80
      end
    end
  end
  
  behaviours BloodSugar

  def initialize()
    super
  end
  
end


module CorrelatedEvents::Behaviours

  module EatsFood
    def self.activate(agent)
      puts "activating agent!"
      #agent.when(:lunch).then(:pizza)
      
      
    end
  end

end


agent = Person.new


CorrelatedEvents::Behaviours::EatsFood.activate(agent)
