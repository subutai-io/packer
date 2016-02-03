{
  "scripts": 
    [
      "scripts/checks.sh",
      "scripts/sudo.sh",
      "scripts/build_time.sh",
      "scripts/authorized_keys.sh",
      "scripts/apt_proxy.sh",
      "scripts/apt.sh",
      "scripts/rc_local.sh",
      "scripts/cleanup.sh"
    ],
  "execute_command": "export APT_PROXY_HOST='{{user `apt_proxy_host`}}'; export APT_PROXY_URL='{{user `apt_proxy_url`}}'; echo 'vagrant' | sudo -E -S sh '{{ .Path }}'"
}

