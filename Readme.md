# Jekyll Site Development Box Packer Template

This packer template uses the 'subutai/basic' machine images to build a vagrant
box for use with jekyll based websites. 

## Features

* Uses Jsonnet for modular packer JSON files with comments
* Installs ruby, node, and Jekyll
* Jekyll is setup to run as a service with jekyll serve using node
* Automatically downloads node based on the version in variables.jsonnet
* Configuration provided in variables.jsonnet to set
** the box name
** the box version
** the ruby version
** the node version
** the site home: set to /vagrant
** can be configured to use other ovf, vmx, and pvm images
* Has ~/start_jekyll.sh and ~/stop_jekyll.sh scripts for quick start and stop

## Usage

In order to generate boxes from this packer template, you'll need to install
jsonnet, and of course have packer and the required hypervisors installed. You 
will also need to have the basic repository cloned and built to have the base
ovf, vmx, and pvm images present. The jekyll-site repository must sit as a 
sibling directory next to the basic repository clone. So hence:

    <parent>
       |
       o-- basic
       |
       o-- jekyll-site

The jekyll-site build script will pick up the images built in the basic project
and use them as the base image.

If not on a Mac OS X machine or you don't have one of the hypervisors installed
edit the build.sh to exclude the vmware and parallels builders. In the 
template.jsonnet file you can use a C++ single line comment '//' to comment
out the builders. Don't worry about trailing commas, jsonnet handles that for
you. 

You can vagrant up and start up jekyll service as the vagrant user using the
provided start and stop scripts in the vagrant users home directory. You can
also use the service facility like so:

    sudo service jekyll-serve start
    sudo service jekyll-serve stop

If you want the service to start and stop on vagrant up you can setup the 
default run levels like so:

    sudo update-rc.d jekyll-serve defaults

Or instead it might be best to provision the start using the following line 
in your vagrant file:

    config.vm.provision "shell", inline: "sudo service jekyll-serve start"

Note that this box will be installed on the Atlas Cloud using 
'subutai/jekyll-site' as the organization qualified name. 

## To Do List

* Image is large, let's figure out a way to shrink it down:
** Use packer snapshotting feature which should come out soon
** Use some mechanism to remove files from the basic image used
** Do we really need everything on this box?

