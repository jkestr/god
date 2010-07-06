require File.dirname(__FILE__) + '/helper'

class TestWatchResque < Test::Unit::TestCase
  def setup
    God.internal_init
    @watch = Watch::Resque.new
    @watch.name = 'foo'
    @watch.start = lambda { }
    @watch.stop = lambda { }
    @watch.prepare
  end
    
  def test_new_process_is_resque
    assert_equal God::ProcessResque, @watch.instance_variable_get("@process").class
  end

end