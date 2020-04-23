#!/bin/bash

if [ -z "$PASSWORD" ]; then
  PASSWORD="ubuntai"
fi

cat > $BASE_DIR/http/buster.cfg <<-EOF
# Account setup
d-i passwd/root-login boolean false
d-i passwd/user-fullname string Subutai User
d-i passwd/username string subutai
d-i passwd/user-password password $PASSWORD
d-i passwd/user-password-again password $PASSWORD
d-i user-setup/encrypt-home boolean false
d-i user-setup/allow-password-weak boolean true

# Clock and time zone setup
d-i clock-setup/utc boolean true
d-i time/zone string UTC
d-i clock-setup/ntp boolean true

# Network Conifgurations
d-i netcfg/choose_interface select auto
d-i netcfg/get_hostname subutai
d-i netcfg/get_domain vm

# Partitioning
d-i   partman-auto/disk                  string   /dev/sda
d-i   partman-auto/method                string   lvm
d-i   partman-auto-lvm/guided_size       string   max
d-i   partman-auto/purge_lvm_from_device boolean  true
d-i   partman-lvm/device_remove_lvm      boolean  true
d-i   partman-lvm/confirm                boolean  true
d-i   partman-lvm/confirm_nooverwrite    boolean  true
d-i   partman-auto/confirm               boolean  true
EOF

cat $BASE_DIR/http/partition.cfg >> http/buster.cfg

cat >> $BASE_DIR/http/buster.cfg <<-EOF
d-i   partman/confirm_write_new_label  boolean true
d-i   partman-partitioning/confirm_write_new_label boolean true
d-i   partman/choose_partition select finish
d-i   partman/confirm boolean true
d-i   partman/confirm_nooverwrite boolean true

# from boxcutter
d-i partman-auto/choose_recipe select atomic
d-i partman-lvm/confirm_nooverwrite boolean true

# silences unmounted partition
d-i partman-basicmethods/method_only boolean false

# Scan another CD or DVD?
apt-cdrom-setup apt-setup/cdrom/set-first boolean false

EOF

if [ "$PROXY_ON" == "true" ]; then
cat >> $BASE_DIR/http/buster.cfg <<-EOF
# Detected proxy live repo proxy so using apt-cache-ng
d-i mirror/country string manual
d-i mirror/http/hostname string $DI_MIRROR_HOSTNAME
d-i mirror/http/directory string /debian
d-i mirror/http/proxy string
d-i mirror/http/mirror select $DI_MIRROR_MIRROR

EOF
else
cat >> $BASE_DIR/http/buster.cfg <<-EOF
# No live proxy, using normal package mirrors
d-i     mirror/country          string enter information manually
d-i     mirror/http/hostname    string http.us.debian.org
d-i     mirror/http/directory   string /debian
d-i     mirror/suite            string stable
d-i     mirror/http/proxy       string

EOF
fi

cat >> $BASE_DIR/http/buster.cfg <<-EOF
# Don't send reports back to the project
popularity-contest popularity-contest/participate boolean false
# Package selection
tasksel tasksel/first multiselect standard
# Automatically install grub to the MBR
d-i grub-installer/only_debian boolean true
d-i grub-installer/bootdev string default
# Turn off last message about the install being complete
d-i finish-install/reboot_in_progress note

EOF

#
# We don't want this until after restart
#
# if [ -z "$INTERFACES" ]; then
# cat >> ./http/buster.cfg <<-EOF
# d-i late_command string wget $INTERFACES -O /etc/network/interfaces
# EOF
# fi

cat $BASE_DIR/http/packages.cfg >> $BASE_DIR/http/buster.cfg
