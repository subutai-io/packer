require 'yaml'

# Vagrant Driven Subutai Configuration
module SubutaiConfig
  PARENT_DIR = './.vagrant'.freeze
  GENERATED_FILE = PARENT_DIR + '/generated.yaml'.freeze
  CONF_FILE = './subutai.yaml'.freeze
  USER_CONF_FILE = File.expand_path('~/.subutai.yaml').freeze
  SUBUTAI_ENVIRONMENTS = %i[prod master dev].freeze
  USER_PARAMETERS = %i[
    DESIRED_PORT ALLOW_INSECURE SUBUTAI_ENV
    SUBUTAI_CPU SUBUTAI_RAM SUBUTAI_PEER SUBUTAI_SNAP
    SUBUTAI_DESKTOP SUBUTAI_MAN_TMPL APT_PROXY_URL
  ].freeze
  GENERATED_PARAMETERS = %i[
    _CONSOLE_PORT _ALT_SNAP _ALT_MANAGEMENT
  ].freeze

  # Used for testing
  @conf_file_override = nil

  # Vagrant command currently being executed, must not be nil
  @cmd = nil

  # Hash of generated/calculated settings preserved through commands
  @generated = {}

  # Smart defaults to use for configuration settings
  @defaults = {
    # Implemented configuration parameters
    DESIRED_PORT: 9999,      # integer for console port
    ALLOW_INSECURE: false,   # boolean to enable insecure CDN and snap
    SUBUTAI_ENV: :prod,      # subutai environment to use
    SUBUTAI_PEER: true,      # to provision or not console (peer)
    SUBUTAI_RAM: 4096,       # RAM memory assigned to the vm
    SUBUTAI_CPU: 2,          # virtual CPU's assign to the vm

    # Configuration parameters below have not been implemented
    SUBUTAI_SNAP: nil,       # alternative snap to provision
    SUBUTAI_DESKTOP: false,  # installs a desktop with tray and p2p client
    SUBUTAI_MAN_TMPL: nil,   # alternative management template to provision
    APT_PROXY_URL: nil       # configure apt proxy URL
  }

  # User provided configuration settings
  @config = @defaults.clone

  def self.write?
    raise 'SubutaiConfig.cmd not set' if @cmd.nil?
    @cmd == 'up'
  end

  def self.delete?
    raise 'SubutaiConfig.cmd not set' if @cmd.nil?
    @cmd == 'destroy'
  end

  def self.read?
    raise 'SubutaiConfig.cmd not set' if @cmd.nil?
    @cmd != 'up'
  end

  def self.generated?(key)
    GENERATED_PARAMETERS.include? key
  end

  def self.cmd
    @cmd
  end

  def self.config
    @config
  end

  def self.override_conf_file(filepath)
    @conf_file_override = filepath
  end

  def self.conf_file
    return CONF_FILE if @conf_file_override.nil?
    @conf_file_override
  end

  def self.get(key)
    key_sym = key.to_sym

    if key_sym == :SUBUTAI_ENV
      env = @config[key_sym].to_sym
      raise "#{env} invalid SUBUTAI_ENV" \
        unless SUBUTAI_ENVIRONMENTS.include?(env)
    end

    @config[key_sym]
  end

  # Write through to save configuration values
  def self.put(key, value)
    raise "Undefined configuration parameter: #{key}" \
      unless USER_PARAMETERS.include?(key.to_sym)     \
      || GENERATED_PARAMETERS.include?(key.to_sym)
    @config.store(key.to_sym, value)
    @generated.store(key.to_sym, value) if generated? key

    store
    value
  end

  # Load generated values preserved across vagrant commands
  def self.load_generated
    return false unless read? && File.exist?(GENERATED_FILE)
    temp = YAML.load_file(GENERATED_FILE)
    temp.each do |key, value|
      @generated.store(key.to_sym, value)
      @config.store(key.to_sym, value)
    end
  end

  # Stores ONLY generated configuration from YAML files
  def self.store
    return false unless write?
    FileUtils.mkdir_p(PARENT_DIR) if write? && !Dir.exist?(PARENT_DIR)
    stringified = Hash[@generated.map { |k, v| [k.to_s, v.to_s] }]
    File.open(GENERATED_FILE, 'w') { |f| f.write stringified.to_yaml }
  end

  def self.set_env(key, value)
    raise "Invalid #{key} value of #{value}: use prod, master, or dev" \
          unless SUBUTAI_ENVIRONMENTS.include?(value)
    @config.store(key, value)
  end

  def self.load_config_file(config_file)
    temp = YAML.load_file(config_file)
    temp.each_key do |key|
      raise "Invalid key in YAML file: '#{key}'" \
          unless USER_PARAMETERS.include?(key.to_sym)

      if key.to_sym == :SUBUTAI_ENV
        set_env(key.to_sym, temp[key].to_sym)
      elsif !temp[key].nil?
        @config.store(key.to_sym, temp[key])
      end
    end
  end

  # Loads the generated and user configuration from YAML files
  def self.load_config(cmd)
    raise 'SubutaiConfig.cmd not set' if cmd.nil?
    @cmd = cmd

    # Load YAML based user and local configuration if they exist
    load_config_file(USER_CONF_FILE) if File.exist?(USER_CONF_FILE)
    load_config_file(conf_file) if File.exist?(conf_file)

    # Load overrides from the environment, and generated configurations
    ENV.each do |key, value|
      @config.store(key, value) if USER_PARAMETERS.include? key
    end
    load_generated

    put(:_ALT_SNAP, snap_handler(get(:SUBUTAI_SNAP))) \
      unless get(:SUBUTAI_SNAP).nil?
    put(:_ALT_MANAGEMENT, snap_handler(get(:SUBUTAI_MAN_TMPL))) \
      unless get(:SUBUTAI_MAN_TMPL).nil?
    put(:_CONSOLE_PORT, find_port(get(:DESIRED_PORT))) if get(:SUBUTAI_PEER)
  end

  def self.reset
    @cmd = nil
    @config = @defaults.clone
    @generated = {}
    @conf_file_override = nil
  end

  # Destroys the generated file if vagrant destroy is used
  def self.cleanup
    cleanup! if delete?
  end

  def self.cleanup!
    reset
    File.delete GENERATED_FILE if File.exist?(GENERATED_FILE)
  end

  def self.print
    puts
    puts ' ==> User provided configuration: '
    puts ' --------------------------------------------------------------------'

    @config.each do |key, value|
      puts "#{('       ' + key.to_s).ljust(25)} => #{value}" \
        unless generated? key
    end

    puts
    puts ' ==> Generated settings preserved across command runs:'
    puts ' --------------------------------------------------------------------'

    @config.each do |key, value|
      puts "#{('     + ' + key.to_s).ljust(25)} => #{value}" if generated? key
    end
  end
end

at_exit do
  SubutaiConfig.cleanup unless SubutaiConfig.cmd.nil?
end
