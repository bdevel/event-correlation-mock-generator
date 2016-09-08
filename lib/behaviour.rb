
module CorrelatedEvents::Behaviour
  module ClassMethods  
    def activate(&block)
      if block_given?
        @activate_callback = block
      else
        @activate_callback
      end
    end
  end
  
  def self.included( other )
    other.extend( ClassMethods )
  end
end



# module BloodSugar
#   include CorrelatedEvents::Behaviour
  
#   attr_accessor :blood_sugar
  
#   activate do
#     @blood_sugar = 100
#     puts "doing activate"
#     self
#       .when(:sugar, :carbs, :rice, :wheat)
#       .wait(1.hour).then {@blood_sugar = [@blood_sugar + 40, 160].min }# 160 max
    
#     # After two hours meal should return to baseline.
#     self.ever(30.minutes).then do
#       @blood_sugar = [@blood_sugar - 5, 80].max# min of 80
#     end
#   end
  
# end

