{
    "output": "{{user `vm_name`}}-{{user `version`}}.box",
    "vagrantfile_template": "virtualbox/Vagrantfile",
    "include": [
    "../ruby/subutai_net.rb",
    "../ruby/subutai_hooks.rb",
    "../ruby/subutai_config.rb"
    ]
}
