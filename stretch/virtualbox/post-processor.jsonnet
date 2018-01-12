{
    "output": "{{user `vm_name`}}-{{user `version`}}.box",
    "vagrantfile_template": "{{user `base_dir`}}/stretch/virtualbox/Vagrantfile",
    "include": [
        "{{user `ruby`}}/subutai_net.rb",
        "{{user `ruby`}}/subutai_hooks.rb",
        "{{user `ruby`}}/subutai_config.rb",
    ]
}
