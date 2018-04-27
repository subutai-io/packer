@echo off

:: You can set your own password
set PASSWORD=ubuntai

type nul>.\http\xenial.cfg

:: Options to set on the command line
(
echo d-i debian-installer/locale string en_US.utf8
echo d-i console-setup/ask_detect boolean false
echo d-i console-setup/layout string us

echo d-i netcfg/get_hostname string nl-ams-basebox3
echo d-i netcfg/get_domain string unassigned-domain

echo d-i time/zone string UTC
echo d-i clock-setup/utc-auto boolean true
echo d-i clock-setup/utc boolean true

echo d-i kbd-chooser/method select American English

echo d-i netcfg/wireless_wep string

echo d-i base-installer/kernel/override-image string linux-server

echo d-i debconf debconf/frontend select Noninteractive

echo d-i pkgsel/install-language-support boolean false
echo tasksel tasksel/first multiselect standard, ubuntu-server
)>>.\http\xenial.cfg

:: ## Partitioning
(
echo d-i netcfg/get_hostname subutai
echo d-i netcfg/get_domain vm
)>>.\http\xenial.cfg

(
::  If one of the disks that are going to be automatically partitioned
echo d-i partman-lvm/device_remove_lvm boolean true
::  The same applies to pre-existing software RAID array:
echo d-i partman-md/device_remove_md boolean true
echo d-i partman-lvm/confirm_nooverwrite boolean trued-i 
::  And the same goes for the confirmation to write the lvm partitions.
echo d-i partman-lvm/confirm boolean true

::  For LVM partitioning, you can select how much of the volume group to use
echo d-i partman-auto/choose_recipe select atomic

echo d-i partman-partitioning/confirm_write_new_label boolean true
echo d-i partman/choose_partition select finish
echo d-i partman/confirm boolean true
echo d-i partman/confirm_nooverwrite boolean true

::  This makes partman automatically partition without confirmation.
echo d-i partman-md/confirm boolean true
echo d-i partman-partitioning/confirm_write_new_label boolean true
echo d-i partman/choose_partition select finish
echo d-i partman/confirm boolean true
echo d-i partman/confirm_nooverwrite boolean true

echo d-i partman-md/confirm_nooverwrite boolean true
)>>.\http\xenial.cfg

(
::  Controlling how partitions are mounted
echo d-i partman-partitioning/no_bootable_gpt_biosgrub boolean false
echo d-i partman-partitioning/no_bootable_gpt_efi boolean false
echo d-i partman-efi/non_efi_system boolean true

echo d-i   partman-auto/disk                  string   /dev/sda
echo d-i   partman-auto/method                string   lvm
echo d-i   partman-auto-lvm/guided_size       string   max
echo d-i   partman-auto/purge_lvm_from_device boolean  true
echo d-i   partman-lvm/device_remove_lvm      boolean  true
echo d-i   partman-lvm/confirm                boolean  true
echo d-i   partman-lvm/confirm_nooverwrite    boolean  true
echo d-i   partman-auto/confirm               boolean  true
)>>.\http\xenial.cfg

type .\http\hyperv\partition.cfg>>.\http\xenial.cfg

(
echo.    
echo d-i partman-basicmethods/method_only boolean false
echo apt-cdrom-setup apt-setup/cdrom/set-first boolean false
)>>.\http\xenial.cfg

(
::  No live proxy, using normal package mirrors
echo d-i     mirror/country          string enter information manually
echo d-i     mirror/http/hostname    string archive.ubuntu.org
echo d-i     mirror/http/directory   string /ubuntu
echo d-i     mirror/suite            string stable
echo d-i     mirror/http/proxy       string
)>>.\http\xenial.cfg

(
::  Default user
echo d-i passwd/user-fullname string subutai
echo d-i passwd/username string subutai
echo d-i passwd/user-password password %PASSWORD%
echo d-i passwd/user-password-again password %PASSWORD%
echo d-i user-setup/encrypt-home boolean false
echo d-i user-setup/allow-password-weak boolean true
)>>.\http\xenial.cfg

(
::  Upgrade packages after debootstrap? (none, safe-upgrade, full-upgrade)
echo d-i pkgsel/upgrade select none
echo d-i grub-installer/only_debian boolean true
echo d-i grub-installer/with_other_os boolean true
echo d-i grub-installer/timeout string 0
echo d-i grub-installer/bootdev string default

echo d-i finish-install/reboot_in_progress note
echo d-i pkgsel/update-policy select none

echo choose-mirror-bin mirror/http/proxy string
)>>.\http\xenial.cfg

type .\http\hyperv\packages.cfg>>.\http\xenial.cfg