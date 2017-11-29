
require 'yaml'

module SubConf

    # Loads the extended YAML configuration which might not exist. Either way the 
    # smart defaults in the extconf below will be overwritten using the
    # config_by_layout function that uses directory structure to infer config
    # settings.
    @conffile = "subutai.yaml"

    # Start with some smart defaults
    @conf = {
        # Implemented configuration parameters
        "DESIRED_PORT"      => 9999,       # integer for console port
        "ALLOW_INSECURE"    => false,      # boolean to enable insecure CDN and snap
        "SUBUTAI_ENV"       => "prod",     # subutai environment to use
        "SUBUTAI_PEER"      => true,       # whether or not to provision the managemetn console (peer)

        # Configuration parameters below have not been implemented
        "SUBUTAI_SNAP"      => nil,        # alternative snap to provision
        "SUBUTAI_DESKTOP"   => false,      # installs a desktop environment with tray and p2p client
        "SUBUTAI_MAN_TMPL"  => nil,        # alternative subutai management template to provision
        "APT_PROXY_URL"     => nil         # if provided apt configuration is altered to use this proxy
    }

    def self.conffile
        return @conffile
    end

    def self.get(key)
        return @conf[key]
    end

    def self.put(key, value)
        return @conf.store(key, value)
    end

    def self.conf
        return @conf
    end

    def self.load
        # Override smart defaults if extended yaml configuration exists
        if File.exist?(@conffile)
            @conf = YAML.load_file(@conffile)
        end
    end
  
    def self.env
        ENV.each do |key, value|
            @conf.store(key, value)
        end
    end

    def self.print 
        puts
        puts "==> Provisioner configuration settings used:"
        puts "    ----------------------------------------"
        puts "    CONSOLE_PORT:      => #{conf['CONSOLE_PORT']}"
        puts "    DESIRED_PORT:      => #{conf['DESIRED_PORT']}"
        puts "    ALLOW_INSECURE:    => #{conf['ALLOW_INSECURE']}"
        puts "    SUBUTAI_ENV:       => #{conf['SUBUTAI_ENV']}"
        puts "    SUBUTAI_PEER:      => #{conf['SUBUTAI_PEER']}"      
        puts "    SUBUTAI_SNAP:      => #{conf['SUBUTAI_SNAP']}"      
        puts "    SUBUTAI_DESKTOP:   => #{conf['SUBUTAI_DESKTOP']}"
        puts "    SUBUTAI_MAN_TMPL:  => #{conf['SUBUTAI_MAN_TMPL']}"
        puts "    APT_PROXY_URL:     => #{conf['APT_PROXY_URL']}"
        puts
    end
end