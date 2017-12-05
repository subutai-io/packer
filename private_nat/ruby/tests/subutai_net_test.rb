require 'test/unit'
require_relative '../subutai_net.rb'

# Tests the subutai_net module
class SubutaiNetTest < Test::Unit::TestCase
  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_find_port
    raise "port was #{port}: should have been 2000 or greater" if \
      find_port(2000) < 2000
  end

  def test_failure
    assert_false(port_open?('127.0.0.1', 1))
    assert_raise do
      port_open?('abc', 0)
    end
  end
end
