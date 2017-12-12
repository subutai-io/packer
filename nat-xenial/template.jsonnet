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
               "virtualbox": import "virtualbox/post-processor.jsonnet",
            },
            "type": "vagrant"
         }
      ]
   ],
   "provisioners": [
      {
         "override": {
            "virtualbox-iso": import "virtualbox/provisioner.jsonnet",
         },
         "type": "shell"
      }
   ],
   "variables": import "variables.jsonnet"
}
