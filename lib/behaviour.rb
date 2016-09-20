
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

