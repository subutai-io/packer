{
   "builders": [
        import ".\\stretch\\hyperv\\builder.jsonnet",
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
               "hyperv": import ".\\stretch\\hyperv\\post-processor.jsonnet"
            },
            "type": "vagrant"
         }
      ]
   ],
  "provisioners": [
    {
      type: "file",
      source: ".\\http\\stretch.sources.list",
      destination: "/tmp/sources.list"
    },
    {
      "override": {
        "hyperv-iso": import ".\\stretch\\hyperv\\provisioner.jsonnet",
      },
      "type": "shell"
    },
  ],
   "variables": import ".\\stretch\\variables.jsonnet"
}
