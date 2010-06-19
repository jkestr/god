module God
  module Conditions
    
    class ResqueOver < PollCondition
    
      attr_accessor :queues
    
      def initialize
        super
        @queues = []
      end
      
      def valid?
        valid = true
        valid &= complain("No queues to watch. c.queues << ['queue', 1.zillion]", self) if self.queues.empty?
        valid
      end
      
      def test
        self.queues.any? do |queue, limit|
          Resque.size(queue) > limit
        end
      end

    end
    
  end
end