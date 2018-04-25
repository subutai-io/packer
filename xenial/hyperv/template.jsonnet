{
   "builders": [
        import "builder.jsonnet",
   ],
   "post-processors": [
      [
         {
            "compression_level": 9,
            "keep_input_artifact": false,
            "only": [
               "hyperv-iso"
            ],
            "override": {
               "hyperv": import "post-processor.jsonnet"
            },
            "type": "vagrant"
         }
      ]
   ],
  "provisioners": [
    {
      type: "file",
      source: "..\\..\\http\\xenial.sources.list",
      destination: "/tmp/sources.list"
    },
    {
      "override": {
        "hyperv-iso": import "provisioner.jsonnet",
      },
      "type": "shell"
    },
  ],
   "variables": import "..\\variables.jsonnet"
}
