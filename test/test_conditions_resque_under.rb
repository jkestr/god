require File.dirname(__FILE__) + '/helper'

class TestConditionsResqueUnder < Test::Unit::TestCase
  
  def test_under_returns_true
    c = Conditions::ResqueUnder.new
    c.queues = [[:queue, 100]]
    Resque.stubs(:size).returns(0)
    assert_equal true, c.test
  end
  
  def test_over_returns_false
    c = Conditions::ResqueUnder.new
    c.queues = [[:queue, 100]]
    Resque.stubs(:size).returns(101)
    assert_equal false, c.test
  end

end