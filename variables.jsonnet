{
    "ssh_name": "vagrant",
    "ssh_pass": "vagrant",
    "hostname": "jekyll-site",
    "boxname": "jekyll-site",
    "version": "1.0.0",
    "null_host": "172.16.3.20",
    "aws_key": "{{env `AWS_ACCESS_KEY_ID`}}",
    "aws_secret": "{{env `AWS_SECRET_ACCESS_KEY`}}",
    
    // this is for Atlas Cloud - the new Vagrant Cloud
    "atlas_username": "subutai",
    "atlas_name": "base",
    "atlas_token": "{{env `ATLAS_TOKEN`}}",

    // versions of various products
    "ruby_ver": "2.2.2",
    "node_ver": "v0.12.2",
    "site_home": "/vagrant",

    "ovf_path": "{{env `BASIC_OVF_PATH`}}",
    "vmx_path": "{{env `BASIC_VMX_PATH`}}",
    "pvm_path": "{{env `BASIC_PVM_PATH`}}"
}

