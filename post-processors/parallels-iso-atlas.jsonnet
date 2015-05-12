{
  "type": "atlas",
  "token": "{{user `atlas_token`}}",
  "only": ["parallels-iso"],
  "artifact": "{{user `atlas_username`}}/{{user `atlas_name`}}",
  "artifact_type": "vagrant.box",
  "metadata": {
    "provider": "parallels",
    "version": "{{user `version`}}",
    "created_at": "{{timestamp}}"
  }
}

