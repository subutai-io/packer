{
  builders: [
    import "builders/null.jsonnet",
    import "builders/virtualbox-iso.jsonnet",
    import "builders/vmware-iso.jsonnet",
    import "builders/parallels-iso.jsonnet",
  ],
  "variables": import "variables.jsonnet",
  "provisioners": [
    {
      "type": "file",
      "only": ["vmware-iso"],
      "source": "VMwareTools-9.9.2-2496486.tar.gz",
      "destination": "/tmp/tools.tgz"
    },
    {
      "type": "shell",
      "environment_vars": [
        "APT_PROXY_URL={{user `apt_proxy_url`}}",
        "APT_PROXY_HOST={{user `apt_proxy_host`}}"
      ],
      "override": { 
        "virtualbox-iso": import "provisioners/virtualbox-iso.jsonnet",
        "vmware-iso": import "provisioners/vmware-iso.jsonnet",
        "parallels-iso": import "provisioners/parallels-iso.jsonnet",
        "null": import "provisioners/null.jsonnet"
      }
    }
  ],
  "post-processors": [ [
    import "post-processors/vagrant.jsonnet",

    //
    // Seems these do not work. Would be nice to avoid having to deal with
    // upload then going manually over to Atlas Cloud and setting up the
    // boxes manually. Right now we have to use S3 to make this work properly.
    //
    // import "post-processors/virtualbox-iso-atlas.jsonnet",
    // import "post-processors/vmware-iso-atlas.jsonnet",
    // import "post-processors/parallels-iso-atlas.jsonnet",
    
    // import "post-processors/virtualbox-iso-s3.jsonnet",
    // import "post-processors/vmware-iso-s3.jsonnet",
    // import "post-processors/parallels-iso-s3.jsonnet"
  ] ]
}
