{
  "builders": [
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
        "LANGUAGE=en_US.UTF-8",
        "LANG=en_US.UTF-8",
        "LC_ALL=en_US.UTF-8",
        "NODE_VER={{user `node_ver`}}",
        "RUBY_VER={{user `ruby_ver`}}",
        "SITE_HOME={{user `site_home`}}",
      ],
      "scripts": [
        "scripts/checks.sh",
        "scripts/locale.sh",
        "scripts/packages.sh",
        "scripts/node.sh",
        "scripts/ruby.sh",
        "scripts/jekyll.sh",
        "scripts/build_time.sh",
        "scripts/cleanup.sh"
      ]
    }
  ],
  "post-processors": [ [
    import "post-processors/vagrant.jsonnet",
  ] ]
}
