{
   "builders": [
        import ".\\buster\\hyperv\\builder.jsonnet",
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
               "hyperv": import ".\\buster\\hyperv\\post-processor.jsonnet"
            },
            "type": "vagrant"
         }
      ]
   ],
  "provisioners": [
    {
      type: "file",
      source: ".\\http\\buster.sources.list",
      destination: "/tmp/sources.list"
    },
    {
      "override": {
        "hyperv-iso": import ".\\buster\\hyperv\\provisioner.jsonnet",
      },
      "type": "shell"
    },
  ],
   "variables": import ".\\buster\\variables.jsonnet"
}
