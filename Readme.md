# Atassian Development Image Build

This image is great for building plugins and testing them. The Atlassian SDK is
installed along with standalone versions of each product if you want to deploy
and test your plugin on them.

## Feature List

* Builds from subutai/basic build
* Uses jsonnet to break up large configuration into peices and enable comments
* Downloads all Atlassian components automatically
* Uses the vagrant user to run Atlassian services








## Environment Parameters and User Configuration Variables

We have the following user configuration varables of which some depend on 
envionment based settings. For up to date information see the variables.jsonnet
file in the root directory:

* null_host - the IP address of the null builder host for testing
* apt_proxy_url - the url of the apt-cacher-ng proxy
* apt_proxy_host - the hostname of the apt-cacher-ng host
* hostname - the hostname to use for the image
* ssh_name - the name of the ssh user to provision the machine
* ssh_pass - the password of the ssh user ssh_name to provision the machine
* aws_key - the aws access key id for the s3 upload post-processor plugin
* aws_secret - the aws secret for the s3 upload post-processor plugin
* atlas_name - the name of the image for atlas
* atlas_username - the name or org of the image for atlas

### Some Feature Notes

Do not worry about the apt proxy settings persisting. Once the built image is
started in an environment that does not have the proxy present the /etc/rc.local
script will delete the proxy settings if the proxy is not present. This way
apt-get operations will not freeze.

The ssh_name and ssh_pass should match the user created in the preseed file. If
the preseed file settings for the admin user are changed then you must change
these values respectively in the base.json file or vice versa. 

The S3 plugin must be built and added to packer to operate properly. See the 
following to clone, compile and install the pluggin:

   https://github.com/lmars/packer-post-processor-vagrant-s3

Also note that this works only if eu-west-1 is used due to some issues with
v4 signature requirements with other AWS regions.

# Notes and Running

For parallels builds on Mac OS X you will need to install the parallels 
virtualization SDK for your version. Otherwise you will get the following 
error:

```
Build 'parallels-iso' errored: Error sending boot command: prltype error: Traceback (most recent call last):
  File "/var/folders/5j/rb7z6w752vn8729h7h9xs2x80000gn/T/prltype464914580", line 3, in <module>
    import prlsdkapi
ImportError: No module named prlsdkapi
```

For debugging purposes there is a null builder but it requires a host to test
the scripts without the long build time of installation. You can have a host
out there that is a basic installation to act as a null builder host to use.

When running use the -only=virtualbox-iso or -except=null option to avoid 
a broken build if you do not have a null builder host available.

You can use the simple build.sh script to build all the supported hypervisor
images. Note that parallels will fail if you're not on a mac system so you 
might want to use the except flag for parallels-iso and null builders.

# To Do List

* Switch from vanilla S3 uploads to using Ctlas Cloud post processor to 
  remove the manual step to setup the vagrant versions and providers in 
  Atlas Cloud.
* Add additional images for: QEMU KVM, Amazon EC2, OpenStack, DigitalOcean.
* Look into various tactics to shrink down the image size. I am sure we 
  have a lot of junk files for unnecessary package, kernels, and services 
  that are not really needed.

