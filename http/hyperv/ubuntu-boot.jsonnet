[
    "<esc><wait10><esc><esc><enter><wait>",
    "linux /install/vmlinuz ",
    "preseed/url=http://{{.HTTPIP}}:{{.HTTPPort}}/hyperv/xenial.cfg ",
    "debian-installer=en_US auto locale=en_US kbd-chooser/method=us ",
    "hostname={{user `hostname`}} ",
    "fb=false debconf/frontend=noninteractive ",
    "keyboard-configuration/modelcode=SKIP keyboard-configuration/layout=USA ",
    "keyboard-configuration/variant=USA console-setup/ask_detect=false <enter>",
    "initrd /install/initrd.gz<enter>",
    "boot<enter>"
]