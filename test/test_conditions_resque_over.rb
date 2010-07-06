require File.dirname(__FILE__) + '/helper'
require 'resque'

class TestConditionsResqueOver < Test::Unit::TestCase

  def test_under_returns_false
    c = Conditions::ResqueOver.new
    c.queues = [[:queue, 100]]
    Resque.stubs(:size).returns(0)
    assert_equal false, c.test
  end
  
  def test_over_returns_true
    c = Conditions::ResqueOver.new
    c.queues = [[:queue, 100]]
    Resque.stubs(:size).returns(101)
    assert_equal true, c.test
  end

end