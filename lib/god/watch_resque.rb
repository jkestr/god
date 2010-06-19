require 'forwardable'

module God
  class Watch
    class Resque < Watch

    extend Forwardable
    def_delegators :@process, :worker_group, :worker_id, :worker_queues, :worker_limit

    def self.worker
      God.watch do |w|
        w.group = 'resque'
        w.name  = "resque-#{self.worker_group}-#{worker_id}".gsub(/\*/,'star')
        w.start = "rake resque:work"
        w.env   = { "QUEUE" => queues }
        
        yield
        
        # determine the state on startup
        w.transition(:init, { true => :up, false => :start }) do |on|
          on.condition(:process_running) do |c|
            c.running = true
          end
        end

        # determine when process has finished starting
        w.transition([:start, :restart], :up) do |on|
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
        w.transition(:up, :start) do |on|
          on.condition(:process_running) do |c|
            c.running = false
          end
        end

        w.transition(:up, :stop) do |on|
          on.condition(:resque_over) do |c|
            c.queues   = w.worker_limits
            c.running  = true
          end
        end

        w.transition(:stop, :start) do |on|
          on.condition(:resque_under) do |c|
            c.queues   = w.worker_limits
            c.running  = false
          end
        end
        
      end
    end

    def initialize
      super
      @process = God::Process::Resque.new
    end

    
  end
  
end
