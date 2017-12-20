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
               "qemu",
               "virtualbox-iso",
            ],
            "override": {
               "libvirt": import "libvirt/post-processor.jsonnet",
               "virtualbox": import "virtualbox/post-processor.jsonnet",
            },
            "type": "vagrant"
         }
      ]
   ],
   "provisioners": [
      {
         "override": {
            "qemu": import "libvirt/provisioner.jsonnet",
            "virtualbox-iso": import "virtualbox/provisioner.jsonnet",
         },
         "type": "shell"
      }
   ],
   "variables": import "variables.jsonnet",
}
