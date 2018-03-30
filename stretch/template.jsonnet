{
   "builders": [
     import "libvirt/builder.jsonnet",
     import "virtualbox/builder.jsonnet",
   ],
   "post-processors": [
      [
         {
            "compression_level": 9,
            "keep_input_artifact": false,
            "only": [
               "virtualbox-iso",
               "qemu",
            ],
            "override": {
              "virtualbox": import "virtualbox/post-processor.jsonnet",
              "libvirt": import "libvirt/post-processor.jsonnet",
            },
            "type": "vagrant"
         }
      ]
   ],
   "provisioners": [
      {
        type: "file",
        source: "http/stretch.sources.list",
        destination: "/tmp/sources.list"
      },
      {
         "override": {
            "virtualbox-iso": import "virtualbox/provisioner.jsonnet",
            "qemu": import "libvirt/provisioner.jsonnet",
         },
         "type": "shell"
      },
   ],
   "variables": import "variables.jsonnet",
}
