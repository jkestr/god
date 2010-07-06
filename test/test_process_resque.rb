require File.dirname(__FILE__) + '/helper'

module God
  class Process
    # def fork
    #   raise "You forgot to stub fork"
    # end
    
    def exec(*args)
      raise "You forgot to stub exec"
    end
  end
end

class TestProcessResque < Test::Unit::TestCase
  def setup
    God.internal_init
    @p = God::ProcessResque.new
    @p.name = 'foo'
    @p.start = 'qux'
    @p.log = 'bar'
    @p.stubs(:test).returns true # so we don't try to mkdir_p
    Process.stubs(:detach) # because we stub fork
    
    ::Process::Sys.stubs(:setuid).returns(true)
    ::Process::Sys.stubs(:setgid).returns(true)
  end
  
  # valid?
  
  def test_valid_should_return_true_if_worker_name_specified
    @p.worker_name = "resque_process"
    @p.worker_id = "worker_1"
    @p.worker_queues = [["queue", 100]]
    assert @p.valid?
  end
  
  def test_valid_should_return_true_worker_id_specified
    @p.worker_name = "resque_process"
    @p.worker_id = "worker_1"
    @p.worker_queues = [["queue", 100]]
    assert @p.valid?
  end
  
  def test_valid_should_return_true_queues_specified
    @p.worker_name = "resque_process"
    @p.worker_id = "worker_1"
    @p.worker_queues = [["queue", 100]]
    assert @p.valid?
  end

end
