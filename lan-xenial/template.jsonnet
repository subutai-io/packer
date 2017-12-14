{
   "builders": [
        import "virtualbox/builder.jsonnet",
   ],
   "post-processors": [
      [
         {
            "compression_level": 9,
            "keep_input_artifact": false,
            "only": [
               "virtualbox-iso"
            ],
            "override": {
               "virtualbox": import "virtualbox/post-processor.jsonnet"
            },
            "type": "vagrant"
         }
      ]
   ],
  "provisioners": [
    {
      "type": "file",
      "source": "{{user `http`}}/virtualbox-interfaces",
      "destination": "/tmp/virtualbox-interfaces"
    },
    {
      "type": "file",
      "source": "{{user `http`}}/fix-vagrant.service",
      "destination": "/tmp/fix-vagrant.service"
    },
    {
      "type": "file",
      "source": "{{user `http`}}/fix-vagrant",
      "destination": "/tmp/fix-vagrant"
    },
    {
      "override": {
        "virtualbox-iso": import "virtualbox/provisioner.jsonnet",
      },
      "type": "shell"
    }
  ],
   "variables": import "variables.jsonnet"
}
