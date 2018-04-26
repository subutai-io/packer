[
    "<esc><wait>",
    "install",
    " auto",
    "interface=auto ",
    " url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/stretch.cfg",
    " debian-installer=en_US",
    " locale=en_US",
    " keymap=us",
    " netcfg/get_hostname=subutai",
    " netcfg/get_domain=vm ",
    "<enter>",
]