@echo off

:: You can set your own password
set PASSWORD=ubuntai

type nul>.\http\stretch.cfg

(
:: Account setup 
echo d-i passwd/root-login boolean false
echo d-i passwd/user-fullname string Subutai User
echo d-i passwd/username string subutai
echo d-i passwd/user-password password %PASSWORD%
echo d-i passwd/user-password-again password %PASSWORD%
echo d-i user-setup/encrypt-home boolean false
echo d-i user-setup/allow-password-weak boolean true

:: Clock and time zone setup
echo d-i clock-setup/utc boolean true
echo d-i time/zone string UTC
echo d-i clock-setup/ntp boolean true

:: Network Conifgurations
echo d-i netcfg/choose_interface select auto
echo d-i netcfg/get_hostname subutai
echo d-i netcfg/get_domain vm

:: Partitioning
echo d-i   partman-auto/disk                  string   /dev/sda
echo d-i   partman-auto/method                string   lvm
echo d-i   partman-auto-lvm/guided_size       string   max
echo d-i   partman-auto/purge_lvm_from_device boolean  true
echo d-i   partman-lvm/device_remove_lvm      boolean  true
echo d-i   partman-lvm/confirm                boolean  true
echo d-i   partman-lvm/confirm_nooverwrite    boolean  true
echo d-i   partman-auto/confirm               boolean  true
)>>.\http\stretch.cfg

type .\http\partition.cfg>>.\http\stretch.cfg

(
echo d-i   partman/confirm_write_new_label  boolean true
echo d-i   partman-partitioning/confirm_write_new_label boolean true
echo d-i   partman/choose_partition select finish
echo d-i   partman/confirm boolean true
echo d-i   partman/confirm_nooverwrite boolean true

:: from boxcutter
echo d-i partman-auto/choose_recipe select atomic
echo d-i partman-lvm/confirm_nooverwrite boolean true

:: silences unmounted partition
echo d-i partman-basicmethods/method_only boolean false

:: Scan another CD or DVD?
echo apt-cdrom-setup apt-setup/cdrom/set-first boolean false
)>>.\http\stretch.cfg

(
:: No live proxy, using normal package mirrors
echo d-i     mirror/country          string enter information manually
echo d-i     mirror/http/hostname    string http.us.debian.org
echo d-i     mirror/http/directory   string /debian
echo d-i     mirror/suite            string stable
echo d-i     mirror/http/proxy       string
)>>.\http\stretch.cfg

(
:: Don't send reports back to the project
echo popularity-contest popularity-contest/participate boolean false
:: Package selection
echo tasksel tasksel/first multiselect standard
:: Automatically install grub to the MBR
echo d-i grub-installer/only_debian boolean true
echo d-i grub-installer/bootdev string default
:: Turn off last message about the install being complete
echo d-i finish-install/reboot_in_progress note
)>>.\http\stretch.cfg

type .\http\packages.cfg>>.\http\stretch.cfg

(
echo d-i preseed/late_command string sed -i -e "s/.*PermitRootLogin.*/PermitRootLogin yes/g" /target/etc/ssh/sshd_config ; chroot /target /bin/bash -c 'service ssh stop ; apt-get install hyperv-daemons' ;
)>>.\http\stretch.cfg