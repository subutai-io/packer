{
   "builders": [
        import "libvirt/builder.jsonnet",
        import "virtualbox/builder.jsonnet",
        import "vmware/builder.jsonnet",
        import "parallels/builder.jsonnet",
   ],
   "post-processors": [
      [
         {
            "compression_level": 9,
            "keep_input_artifact": false,
            "only": [
               "virtualbox-iso",
               "qemu",
               "vmware-iso",
               "parallels-iso",
            ],
            "override": {
               "virtualbox": import "virtualbox/post-processor.jsonnet",
               "libvirt": import "libvirt/post-processor.jsonnet",
               "vmware": import "vmware/post-processor.jsonnet",
               "parallels": import "parallels/post-processor.jsonnet",
            },
            "type": "vagrant"
         }
      ]
   ],
  "provisioners": [
    {
      type: "file",
      source: "http/bionic.sources.list",
      destination: "/tmp/sources.list"
    },
    {
      "override": {
        "virtualbox-iso": import "virtualbox/provisioner.jsonnet",
        "qemu": import "libvirt/provisioner.jsonnet",
        "vmware-iso": import "vmware/provisioner.jsonnet",
        "parallels-iso": import "parallels/provisioner.jsonnet",
      },
      "type": "shell"
    },
  ],
   "variables": import "variables.jsonnet"
}
