{
  "type": "vagrant-s3",
  "only": ["virtualbox-iso"],
  "region": "us-east-1",
  "bucket": "packer-artifacts",
  "box_name": "subutai-basic-{{user `version`}}-virtualbox.box",
  "manifest": "subutai-basic-{{user `version`}}-virtualbox.json",
  "box_dir": "boxes",
  "access_key": "{{user `aws_key`}}",
  "secret_key": "{{user `aws_secret`}}",
  "version": "{{user `version`}}"
},
{
  "type": "vagrant-s3",
  "only": ["vmware-iso"],
  "region": "us-east-1",
  "bucket": "packer-artifacts",
  "box_name": "subutai-basic-{{user `version`}}-vmware.box",
  "manifest": "subutai-basic-{{user `version`}}-vmware.json",
  "box_dir": "boxes",
  "access_key": "{{user `aws_key`}}",
  "secret_key": "{{user `aws_secret`}}",
  "version": "{{user `version`}}"
}

