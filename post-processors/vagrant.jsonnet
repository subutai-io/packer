{
  "type": "vagrant",
  "only": ["virtualbox-ovf", "vmware-vmx", "parallels-pvm"],
  "compression_level": 0,
  
  // leave these without the -iso otherwise they will not take
  "override": {
    "virtualbox": {
      "output": "subutai-{{user `boxname`}}-{{user `version`}}-virtualbox.box",
    },
    "vmware": {
      "output": "subutai-{{user `boxname`}}-{{user `version`}}-vmware.box",
    },
    "parallels": {
      "output": "subutai-{{user `boxname`}}-{{user `version`}}-parallels.box",
    }
  },
  "keep_input_artifact": true
}

