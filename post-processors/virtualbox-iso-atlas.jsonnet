{
  "type": "atlas",
  "token": "{{user `atlas_token`}}",
  "only": ["virtualbox-iso"],
  "artifact": "{{user `atlas_username`}}/{{user `atlas_name`}}",
  "artifact_type": "vagrant.box",
  "metadata": {
    "provider": "virtualbox",
    "version": "{{user `version`}}",
    "created_at": "{{timestamp}}"
  }
}

