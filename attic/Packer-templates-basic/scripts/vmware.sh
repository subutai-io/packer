#!/bin/bash
sudo apt-get -y install gcc build-essential linux-headers-$(uname -r)

# Install the standard tools defaults
cd /tmp
tar -zxf /tmp/tools.tgz
/tmp/vmware-tools-distrib/vmware-install.pl --default
rm /tmp/tools.tgz
rm -rf /tmp/vmware-tools-distrib

# Must patch for Ubuntu 14.04.2 due to tools issues
cd /usr/lib/vmware-tools/modules/source
tar xf vmhgfs.tar
grep -q d_u.d_alias vmhgfs-only/inode.c && echo "already patched" && exit 0
sed -i -e s/d_alias/d_u.d_alias/ vmhgfs-only/inode.c
cp -p vmhgfs.tar vmhgfs.tar.orig
tar cf vmhgfs.tar vmhgfs-only
vmware-config-tools.pl -d -m

echo -n '.host:/ /mnt/hgfs vmhgfs defaults,ttl=5,uid=1000,gid=1000,nobootwait 0 0' >> /etc/fstab
