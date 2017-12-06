require 'test/unit'
require 'fileutils'

require_relative '../subutai_config.rb'

# Tests the SubutaiConfig module
class SubutaiConfigTest < Test::Unit::TestCase
  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    FileUtils.rm_rf SubutaiConfig::PARENT_DIR
    assert_path_not_exist(SubutaiConfig::PARENT_DIR)

    File.delete(SubutaiConfig::CONF_FILE) \
      if File.exist?(SubutaiConfig::CONF_FILE)
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    SubutaiConfig.cleanup!
  end

  # checks defaults without changing any values
  def defaults?
    SubutaiConfig.load_config 'up'
    assert_equal(SubutaiConfig.config.count, 10)

    assert_true(SubutaiConfig.get(:SUBUTAI_PEER))
    assert_false(SubutaiConfig.get(:ALLOW_INSECURE))
    assert_false(SubutaiConfig.get(:SUBUTAI_DESKTOP))

    assert_equal(SubutaiConfig.get(:DESIRED_PORT), 9999)
    assert_equal(SubutaiConfig.get(:SUBUTAI_ENV), :prod)
    assert_equal(SubutaiConfig.get(:SUBUTAI_RAM), 4096)
    assert_equal(SubutaiConfig.get(:SUBUTAI_CPU), 2)

    assert_nil(SubutaiConfig.get(:SUBUTAI_SNAP))
    assert_nil(SubutaiConfig.get(:SUBUTAI_MAN_TMPL))
    assert_nil(SubutaiConfig.get(:APT_PROXY_URL))

    SubutaiConfig::GENERATED_PARAMETERS.each do |p|
      assert_nil(SubutaiConfig.get(p))
    end
  end

  # Raise exception without setting valid cmd
  def test_no_cmd
    assert_raise do
      SubutaiConfig.load_config(nil)
    end
  end

  def test_cleanup!
    SubutaiConfig.load_config('up')
    SubutaiConfig.put('_CONSOLE_PORT', 10_394)
    SubutaiConfig.put('SUBUTAI_PEER', false)
    SubutaiConfig.cleanup!

    assert_path_not_exist(SubutaiConfig::GENERATED_FILE, 'generated.yaml')
  end

  def test_cleanup
    SubutaiConfig.load_config('up')
    SubutaiConfig.put('SUBUTAI_PEER', true)
    assert_path_exist(SubutaiConfig::GENERATED_FILE, 'generated.yaml')

    SubutaiConfig.cleanup
    assert_path_exist(SubutaiConfig::GENERATED_FILE, 'generated.yaml')

    SubutaiConfig.put('SUBUTAI_PEER', true)
    assert_path_exist(SubutaiConfig::GENERATED_FILE, 'generated.yaml')

    SubutaiConfig.load_config('destroy')
    assert_path_exist(SubutaiConfig::GENERATED_FILE, 'generated.yaml')

    SubutaiConfig.cleanup
    assert_path_not_exist(SubutaiConfig::GENERATED_FILE, 'generated.yaml')
  end

  def test_get_put_up
    SubutaiConfig.load_config 'up'

    #
    # Bunch of tests for User Parameters
    #

    # ALLOW_INSECURE
    assert_false(SubutaiConfig.get(:ALLOW_INSECURE))
    assert_true(SubutaiConfig.put(:ALLOW_INSECURE, true))
    assert_true(SubutaiConfig.get(:ALLOW_INSECURE))
    assert_true(SubutaiConfig.get('ALLOW_INSECURE'))

    assert_false(SubutaiConfig.put('ALLOW_INSECURE', false))
    assert_false(SubutaiConfig.get(:ALLOW_INSECURE))
    assert_false(SubutaiConfig.get('ALLOW_INSECURE'))

    # SUBUTAI_DESKTOP
    assert_false(SubutaiConfig.get(:SUBUTAI_DESKTOP))
    assert_true(SubutaiConfig.put(:SUBUTAI_DESKTOP, true))
    assert_true(SubutaiConfig.get(:SUBUTAI_DESKTOP))
    assert_true(SubutaiConfig.get('SUBUTAI_DESKTOP'))

    assert_false(SubutaiConfig.put('SUBUTAI_DESKTOP', false))
    assert_false(SubutaiConfig.get(:SUBUTAI_DESKTOP))
    assert_false(SubutaiConfig.get('SUBUTAI_DESKTOP'))

    # SUBUTAI_PEER
    assert_true(SubutaiConfig.get(:SUBUTAI_PEER))
    assert_false(SubutaiConfig.put(:SUBUTAI_PEER, false))
    assert_false(SubutaiConfig.get(:SUBUTAI_PEER))
    assert_false(SubutaiConfig.get('SUBUTAI_PEER'))

    assert_true(SubutaiConfig.put('SUBUTAI_PEER', true))
    assert_true(SubutaiConfig.get(:SUBUTAI_PEER))
    assert_true(SubutaiConfig.get('SUBUTAI_PEER'))

    # DESIRED_PORT
    assert_equal(SubutaiConfig.get(:DESIRED_PORT), 9999)
    assert_equal(7777, SubutaiConfig.put(:DESIRED_PORT, 7777))
    assert_equal(SubutaiConfig.get(:DESIRED_PORT), 7777)
    assert_equal(SubutaiConfig.get('DESIRED_PORT'), 7777)

    assert_equal(SubutaiConfig.put('DESIRED_PORT', 6666), 6666)
    assert_equal(SubutaiConfig.get(:DESIRED_PORT), 6666)
    assert_equal(SubutaiConfig.get('DESIRED_PORT'), 6666)

    # SUBUTAI_RAM
    assert_equal(SubutaiConfig.get(:SUBUTAI_RAM), 4096)
    assert_equal(8192, SubutaiConfig.put(:SUBUTAI_RAM, 8192))
    assert_equal(SubutaiConfig.get(:SUBUTAI_RAM), 8192)
    assert_equal(SubutaiConfig.get('SUBUTAI_RAM'), 8192)

    assert_equal(SubutaiConfig.put('SUBUTAI_RAM', 2048), 2048)
    assert_equal(SubutaiConfig.get(:SUBUTAI_RAM), 2048)
    assert_equal(SubutaiConfig.get('SUBUTAI_RAM'), 2048)

    # SUBUTAI_CPU
    assert_equal(SubutaiConfig.get(:SUBUTAI_CPU), 2)
    assert_equal(4, SubutaiConfig.put(:SUBUTAI_CPU, 4))
    assert_equal(SubutaiConfig.get(:SUBUTAI_CPU), 4)
    assert_equal(SubutaiConfig.get('SUBUTAI_CPU'), 4)

    assert_equal(SubutaiConfig.put('SUBUTAI_CPU', 6), 6)
    assert_equal(SubutaiConfig.get(:SUBUTAI_CPU), 6)
    assert_equal(SubutaiConfig.get('SUBUTAI_CPU'), 6)

    # SUBUTAI_ENV
    assert_equal(:prod, SubutaiConfig.get(:SUBUTAI_ENV))
    assert_equal(:dev, SubutaiConfig.put(:SUBUTAI_ENV, :dev))
    assert_equal(:dev, SubutaiConfig.get(:SUBUTAI_ENV))
    assert_equal(:dev, SubutaiConfig.get('SUBUTAI_ENV'))

    assert_equal(:prod, SubutaiConfig.put('SUBUTAI_ENV', :prod))
    assert_equal(:prod, SubutaiConfig.get(:SUBUTAI_ENV))
    assert_equal(:prod, SubutaiConfig.get('SUBUTAI_ENV'))

    # SUBUTAI_SNAP
    assert_nil(SubutaiConfig.get(:SUBUTAI_SNAP))
    script = './bogus/path/script.sh'
    assert_equal(script, SubutaiConfig.put(:SUBUTAI_SNAP, script))
    assert_equal(script, SubutaiConfig.get(:SUBUTAI_SNAP))
    assert_equal(script, SubutaiConfig.get('SUBUTAI_SNAP'))

    # SUBUTAI_MAN_TMPL
    assert_nil(SubutaiConfig.get(:SUBUTAI_MAN_TMPL))
    pkg = './bogus/path/management.deb'
    assert_equal(pkg, SubutaiConfig.put(:SUBUTAI_MAN_TMPL, pkg))
    assert_equal(pkg, SubutaiConfig.get(:SUBUTAI_MAN_TMPL))
    assert_equal(pkg, SubutaiConfig.get('SUBUTAI_MAN_TMPL'))

    # APT_PROXY_URL
    assert_nil(SubutaiConfig.get(:APT_PROXY_URL))
    url = 'http://localhost:3124'
    assert_equal(url, SubutaiConfig.put(:APT_PROXY_URL, url))
    assert_equal(url, SubutaiConfig.get(:APT_PROXY_URL))
    assert_equal(url, SubutaiConfig.get('APT_PROXY_URL'))
  end

  def test_get_put_generated
    SubutaiConfig.load_config 'up'

    # _CONSOLE_PORT
    assert_equal(1234, SubutaiConfig.put(:_CONSOLE_PORT, 1234))
    assert_equal(1234, SubutaiConfig.get(:_CONSOLE_PORT))
    assert_equal(1234, SubutaiConfig.get('_CONSOLE_PORT'))

    # _ALT_SNAP
    assert_nil(SubutaiConfig.get(:_ALT_SNAP))
    snap = './bogus/path.snap'
    assert_equal(snap, SubutaiConfig.put(:_ALT_SNAP, snap))
    assert_equal(snap, SubutaiConfig.get(:_ALT_SNAP))
    assert_equal(snap, SubutaiConfig.get('_ALT_SNAP'))

    # _ALT_MANAGEMENT
    assert_nil(SubutaiConfig.get(:_ALT_MANAGEMENT))
    pkg = './bogus/path.deb'
    assert_equal(pkg, SubutaiConfig.put(:_ALT_MANAGEMENT, pkg))
    assert_equal(pkg, SubutaiConfig.get(:_ALT_MANAGEMENT))
    assert_equal(pkg, SubutaiConfig.get('_ALT_MANAGEMENT'))
  end

  def test_print
    SubutaiConfig.load_config('up')
    SubutaiConfig.put('_CONSOLE_PORT', '10009')
    SubutaiConfig.print
  end

  def test_up
    cmd = 'up'
    SubutaiConfig.load_config(cmd)
    assert_equal(cmd, SubutaiConfig.cmd, 'cmd does not equal ' + cmd)
    SubutaiConfig.put('SUBUTAI_PEER', true)
    assert_path_exist(SubutaiConfig::GENERATED_FILE)

    SubutaiConfig.put('SUBUTAI_SNAP', './bogus/path')
    assert_equal('./bogus/path', SubutaiConfig.get('SUBUTAI_SNAP'))
  end

  def test_destroy
    cmd = 'destroy'
    SubutaiConfig.load_config(cmd)
    assert_equal(cmd, SubutaiConfig.cmd, 'cmd does not equal ' + cmd)
  end

  def test_seq0
    cmd = 'up'
    pkg = './bogus/path/management.deb'
    snap = './bogus/path.snap'

    SubutaiConfig.load_config(cmd)
    assert_equal(cmd, SubutaiConfig.cmd, 'cmd does not equal ' + cmd)
    assert_equal(snap, SubutaiConfig.put(:SUBUTAI_SNAP, snap))
    assert_equal(pkg, SubutaiConfig.put(:SUBUTAI_MAN_TMPL, pkg))
    assert_equal(1234, SubutaiConfig.put(:_CONSOLE_PORT, 1234))
    assert_equal(snap, SubutaiConfig.put(:_ALT_SNAP, snap))
    assert_equal(pkg, SubutaiConfig.put(:_ALT_MANAGEMENT, pkg))
    assert_true(SubutaiConfig.put(:ALLOW_INSECURE, true))
    assert_true(SubutaiConfig.put(:SUBUTAI_DESKTOP, true))
    assert_false(SubutaiConfig.put(:SUBUTAI_PEER, false))
    assert_equal(7777, SubutaiConfig.put(:DESIRED_PORT, 7777))
    assert_equal(8192, SubutaiConfig.put(:SUBUTAI_RAM, 8192))
    assert_equal(4, SubutaiConfig.put(:SUBUTAI_CPU, 4))
    assert_equal(:dev, SubutaiConfig.put(:SUBUTAI_ENV, :dev))

    SubutaiConfig.reset

    cmd = 'ssh'
    SubutaiConfig.load_config(cmd)
    assert_equal(cmd, SubutaiConfig.cmd, 'cmd does not equal ' + cmd)
    assert_nil(SubutaiConfig.get(:SUBUTAI_SNAP))
    assert_nil(SubutaiConfig.get(:SUBUTAI_MAN_TMPL))
    assert_false(SubutaiConfig.get(:ALLOW_INSECURE))
    assert_false(SubutaiConfig.get(:SUBUTAI_DESKTOP))
    assert_true(SubutaiConfig.get(:SUBUTAI_PEER))
    assert_equal(9999, SubutaiConfig.get(:DESIRED_PORT))
    assert_equal(4096, SubutaiConfig.get(:SUBUTAI_RAM))
    assert_equal(2, SubutaiConfig.get(:SUBUTAI_CPU))
    assert_equal(:prod, SubutaiConfig.get(:SUBUTAI_ENV))

    # these should not be cleared out by the reset
    assert_equal(snap, SubutaiConfig.get(:_ALT_SNAP))
    assert_equal(pkg, SubutaiConfig.get(:_ALT_MANAGEMENT))

    cmd = 'suspend'
    SubutaiConfig.load_config(cmd)
    assert_equal(cmd, SubutaiConfig.cmd, 'cmd does not equal ' + cmd)

    cmd = 'resume'
    SubutaiConfig.load_config(cmd)
    assert_equal(cmd, SubutaiConfig.cmd, 'cmd does not equal ' + cmd)
  end

  def test_unknown_key
    assert_raise do
      SubutaiConfig.load_config 'up'
      SubutaiConfig.put('foo', 'bar')
    end
  end

  def test_bad_env_value_subutai_yaml_0
    SubutaiConfig.override_conf_file('./nat/ruby/tests/subutai0.yaml')
    assert_raise do
      SubutaiConfig.load_config 'up'
    end
  end

  def test_bad_key_subutai_yaml_1
    SubutaiConfig.override_conf_file('./nat/ruby/tests/subutai1.yaml')
    assert_raise do
      SubutaiConfig.load_config 'up'
    end
  end

  def test_subutai_yaml_2
    SubutaiConfig.override_conf_file('./nat/ruby/tests/subutai2.yaml')
    SubutaiConfig.load_config 'up'
    assert_equal(:master, SubutaiConfig.get(:SUBUTAI_ENV))
    assert_equal(9191, SubutaiConfig.get(:DESIRED_PORT))
    assert_equal(2000, SubutaiConfig.get(:SUBUTAI_RAM))
    assert_equal(6, SubutaiConfig.get(:SUBUTAI_CPU))
    assert_false(SubutaiConfig.get(:SUBUTAI_PEER))
    assert_true(SubutaiConfig.get(:SUBUTAI_DESKTOP))
    assert_true(SubutaiConfig.get(:ALLOW_INSECURE))
    assert_equal('./foo/bar/bogus/path/to/shell/script.sh', SubutaiConfig.get(:SUBUTAI_SNAP))
    assert_equal('./bar/foo/bogus/path/to/deb/pkg/management.deb', SubutaiConfig.get(:SUBUTAI_MAN_TMPL))
    assert_equal('http://some_server:4444', SubutaiConfig.get(:APT_PROXY_URL))
  end

  def test_raises
    assert_raise do
      SubutaiConfig.write?
    end
    assert_raise do
      SubutaiConfig.delete?
    end
    assert_raise do
      SubutaiConfig.read?
    end

    assert_not_nil(SubutaiConfig.config)
  end
end