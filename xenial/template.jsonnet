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
      type: "file",
      source: "http/xenial.sources.list",
      destination: "/tmp/sources.list"
    },
    {
      "override": {
        "virtualbox-iso": import "virtualbox/provisioner.jsonnet",
      },
      "type": "shell"
    },
  ],
   "variables": import "variables.jsonnet"
}
