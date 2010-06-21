require 'forwardable'

module God
  class Watch
    class Resque < Watch

      extend Forwardable
      def_delegators :@process, :worker_name, :worker_id, :worker_queues, :worker_limit

      def initialize
        super
        @process = God::Process::Resque.new
        self.env ||= {}
      end

      def self.worker
        God.task(God::Watch::Resque) do |w|
          yield w
          w.group = 'resque'
          w.name  = "resque-#{w.worker_name}-#{worker_id}".gsub(/\*/,'star')
          w.start = "rake resque:work"
          w.env   = { "QUEUE" => w.worker_queues }
        
          transition(:init, { true => :up, false => :start }) do |on|
            on.condition(:process_running) do |c|
              c.running = true
            end
          end

          # determine when process has finished starting
          transition([:start, :restart], :up) do |on|
            on.condition(:process_running) do |c|
              c.running  = true
            end

            # failsafe
            on.condition(:tries) do |c|
              c.times = 5
              c.transition = :start
            end
          end

          # start if process is not running
          transition(:up, :start) do |on|
            on.condition(:process_running) do |c|
              c.running = false
            end
          end

          transition(:up, :sleeping) do |on|
            on.condition(:resque_over) do |c|
              c.queues   = w.worker_limits
              c.running  = true
            end
          end

          transition(:sleeping, :start) do |on|
            on.condition(:resque_under) do |c|
              c.queues   = w.worker_limits
              c.running  = false
            end
          end
        end
      end

    end
  end  
end
