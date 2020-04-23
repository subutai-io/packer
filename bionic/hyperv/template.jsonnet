{
   "builders": [
        import ".\\bionic\\hyperv\\builder.jsonnet",
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
               "hyperv": import ".\\bionic\\hyperv\\post-processor.jsonnet"
            },
            "type": "vagrant"
         }
      ]
   ],
  "provisioners": [
    {
      type: "file",
      source: ".\\http\\bionic.sources.list",
      destination: "/tmp/sources.list"
    },
    {
      "override": {
        "hyperv-iso": import ".\\bionic\\hyperv\\provisioner.jsonnet",
      },
      "type": "shell"
    },
  ],
   "variables": import ".\\bionic\\variables.jsonnet"
}
