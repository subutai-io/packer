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
      "environment_vars": [
        "CONF_VER={{user `conf_ver`}}",
        "JIRA_VER={{user `jira_ver`}}",
        "CROWD_VER={{user `crowd_ver`}}",
        "STASH_VER={{user `stash_ver`}}",
      ],
      "scripts": [
        "scripts/checks.sh",
        "scripts/disk.sh",
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
  ] ]
}
