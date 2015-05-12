{
  "type": "vagrant",
  "only": ["virtualbox-ovf", "vmware-vmx", "parallels-pvm"],
  "compression_level": 9,
  
  // leave these without the -iso otherwise they will not take
  "override": {
    "virtualbox": {
      "output": "subutai-atlas-dev-{{user `version`}}-virtualbox.box",
    },
    "vmware": {
      "output": "subutai-atlas-dev-{{user `version`}}-vmware.box",
    },
    "parallels": {
      "output": "subutai-atlas-dev-{{user `version`}}-parallels.box",
    }
  },
  "keep_input_artifact": true
}

