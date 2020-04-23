{
  "output": "vagrant-subutai-{{user `vm_name`}}-hyperv-{{user `version`}}.box",
  local br = if std.extVar('branch') == "prod" then 
    ".\\buster\\hyperv\\Vagrantfile"
  else
    ".\\buster\\hyperv\\master\\Vagrantfile",
  "vagrantfile_template": br
}
