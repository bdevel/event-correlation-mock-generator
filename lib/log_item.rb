require 'ostruct'

class CorrelatedEvents::Feed
  class LogItem < OpenStruct
    
    def initialize(timestamp, name, properties)
      super({
              name: name,
              timestamp: timestamp
            }.merge(properties))
    end


    # pass another log item or a symbol or string
    def ==(other)
      if other.respond_to?(:name)
        self.name == other.name
      else
        self.name == other
      end
    end
    
  end
end
