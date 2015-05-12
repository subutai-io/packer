{
  builders: [
    import "builders/null.jsonnet",
    import "builders/virtualbox-ovf.jsonnet",
    import "builders/vmware-vmx.jsonnet",
    import "builders/parallels-pvm.jsonnet",
  ],
  "variables": import "variables.jsonnet",
  "provisioners": [
    {
      "type": "file",
      "source": "./downloads/",
      "destination": "/home/vagrant"
    },
    {
      "type": "shell",
      "scripts": [
        "scripts/checks.sh",
        "scripts/java.sh",
        "scripts/atlas_sdk.sh",
        "scripts/atlassian.sh",
        "scripts/confluence.sh",
        "scripts/crowd.sh",
        "scripts/jira.sh",
        "scripts/stash.sh",
        "scripts/build_time.sh",
        "scripts/cleanup.sh"
      ]
    }
  ],
  "post-processors": [ [
    import "post-processors/vagrant.jsonnet",
    import "post-processors/virtualbox-ovf-s3.jsonnet",
    import "post-processors/vmware-vmx-s3.jsonnet",
    import "post-processors/parallels-pvm-s3.jsonnet"
  ] ]
}
