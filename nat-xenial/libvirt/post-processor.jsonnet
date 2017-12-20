{
    "output": "{{user `vm_name`}}-{{user `version`}}-libvirt.box",
    "vagrantfile_template": "{{user `base_dir`}}/nat-xenial/libvirt/Vagrantfile",
    "include": [
        "{{user `ruby`}}/subutai_net.rb",
        "{{user `ruby`}}/subutai_hooks.rb",
        "{{user `ruby`}}/subutai_config.rb",
    ]
}
