module God
  class ProcessResque < Process

      attr_accessor :worker_name, :worker_id, :worker_queues, :worker_limits

      def initialize
        super
        @worker_limits = []
        @worker_queues = [] 
      end

      def valid?
        valid = true
      
        if self.worker_name.nil?
          valid = false
          applog(self, :error, "No resque worker name was specified")
        end
      
        if self.worker_id.nil?
          valid = false
          applog(self, :error, "No resque worker id was specified")
        end
      
        if self.worker_queues.nil?
          valid = false
          applog(self, :error, "No resque queues were specified")
        end

        return valid
      end

  end
end
