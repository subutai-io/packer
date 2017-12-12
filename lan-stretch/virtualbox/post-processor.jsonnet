{
    "output": "{{user `vm_name`}}-{{user `version`}}.box",
    "vagrantfile_template": "virtualbox/Vagrantfile",
    "include": [
    "{{user `ruby`}}/subutai_net.rb",
    "{{user `ruby`}}/subutai_hooks.rb",
    "{{user `ruby`}}/subutai_config.rb"
    ]
}
