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
:: # Partitioning example
::  If the system has free space you can choose to only partition that space.
::  This is only honoured if partman-auto/method (below) is not set.
::  Alternatives: custom, some_device, some_device_crypto, some_device_lvm.
:: d-i partman-auto/init_automatically_partition select biggest_free
(
echo d-i netcfg/get_hostname subutai
echo d-i netcfg/get_domain vm
)>>.\http\xenial.cfg

(
::  If one of the disks that are going to be automatically partitioned
::  contains an old LVM configuration, the user will normally receive a
::  warning. This can be preseeded away...
echo d-i partman-lvm/device_remove_lvm boolean true
::  The same applies to pre-existing software RAID array:
echo d-i partman-md/device_remove_md boolean true
echo d-i partman-lvm/confirm_nooverwrite boolean trued-i 
::  And the same goes for the confirmation to write the lvm partitions.
echo d-i partman-lvm/confirm boolean true

::  For LVM partitioning, you can select how much of the volume group to use
::  for logical volumes.

:: d-i partman-auto-lvm/guided_size string 10GB
:: d-i partman-auto-lvm/guided_size string 50%

::  You can choose one of the three predefined partitioning recipes:
::  - atomic: all files in one partition
::  - home:   separate /home partition
::  - multi:  separate /home, /usr, /var, and /tmp partitions
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

:: ::  Controlling how partitions are mounted
::  The default is to mount by UUID, but you can also choose "traditional" to
::  use traditional device names, or "label" to try filesystem labels before
::  falling back to UUIDs.
:: d-i partman/mount_style select uuid

(
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
echo d-i   partman-auto/expert_recipe         string                         \
echo    grub-efi-boot-root ::                                                \
echo         1 1 1 free                                                      \
echo             $bios_boot{ }                                               \
echo             method{ biosgrub }                                          \
echo         .                                                               \
echo         256 256 256 fat32                                               \
echo             $primary{ }                                                 \
echo             method{ efi }                                               \
echo             format{ }                                                   \
echo         .                                                               \
echo                                                                         \
echo         1024 5000 1024 ext3                                             \
echo                 $primary{ }                                             \
echo                 $bootable{ }                                            \
echo                 method{ format }                                        \
echo                 format{ }                                               \
echo                 use_filesystem{ }                                       \
echo                 filesystem{ ext3 }                                      \
echo                 label{ boot }                                           \
echo                 mountpoint{ /boot }                                     \
echo         .                                                               \
echo                                                                         \
echo         1000 1000 1400000000 ext4                                       \
echo                 $defaultignore{ }                                       \
echo                 $primary{ }                                             \
echo                 method{ lvm }                                           \
echo                 device{ /dev/sda }                                      \
echo                 vg_name{ main }                                         \
echo         .                                                               \
echo                                                                         \
echo         1024 1000 100% linux-swap                                       \
echo                 $defaultignore{ }                                       \
echo                 $lvmok{ }                                               \
echo                 lv_name{ swap }                                         \
echo                 in_vg{ main }                                           \
echo                 method{ swap }                                          \
echo                 format{ }                                               \
echo         .                                                               \
echo                                                                         \
echo         2048 1000 4096 ext4                                             \
echo                 $defaultignore{ }                                       \
echo                 $lvmok{ }                                               \
echo                 lv_name{ root }                                         \
echo                 in_vg{ main }                                           \
echo                 method{ format }                                        \
echo                 format{ }                                               \
echo                 use_filesystem{ }                                       \
echo                 filesystem{ ext4 }                                      \
echo                 mountpoint{ / }                                         \
echo         .                                                               \
echo                                                                         \
echo         4096 1000 32768 ext4                                            \
echo                 $defaultignore{ }                                       \
echo                 $lvmok{ }                                               \
echo                 lv_name{ var }                                          \
echo                 in_vg{ main }                                           \
echo                 method{ format }                                        \
echo                 format{ }                                               \
echo                 use_filesystem{ }                                       \
echo                 filesystem{ ext4 }                                      \
echo                 mountpoint{ /var }                                      \
echo         .                                                               \
echo                                                                         \
echo         8192 1000 8192 ext4                                             \
echo                 $defaultignore{ }                                       \
echo                 $lvmok{ }                                               \
echo                 lv_name{ usr }                                          \
echo                 in_vg{ main }                                           \
echo                 method{ format }                                        \
echo                 format{ }                                               \
echo                 use_filesystem{ }                                       \
echo                 filesystem{ ext4 }                                      \
echo                 mountpoint{ /usr }                                      \
echo         .                                                               \
echo                                                                         \
echo         8192 1000 8192 ext4                                             \
echo                 $defaultignore{ }                                       \
echo                 $lvmok{ }                                               \
echo                 lv_name{ opt }                                          \
echo                 in_vg{ main }                                           \
echo                 method{ format }                                        \
echo                 format{ }                                               \
echo                 use_filesystem{ }                                       \
echo                 filesystem{ ext4 }                                      \
echo                 mountpoint{ /opt }                                      \
echo         .                                                               \
echo                                                                         \
echo         2048 1000 4096 ext4                                             \
echo                 $defaultignore{ }                                       \
echo                 $lvmok{ }                                               \
echo                 lv_name{ home }                                         \
echo                 in_vg{ main }                                           \
echo                 method{ format }                                        \
echo                 format{ }                                               \
echo                 use_filesystem{ }                                       \
echo                 filesystem{ ext4 }                                      \
echo                 mountpoint{ /home }                                     \
echo         .                                                               \
echo                                                                         \
echo         1024 1000 2048 ext4                                             \
echo                 $defaultignore{ }                                       \
echo                 $lvmok{ }                                               \
echo                 lv_name{ btrfs }                                        \
echo                 in_vg{ main }                                           \
echo                 method{ format }                                        \
echo                 format{ }                                               \
echo                 filesystem{ btrfs }                                     \
echo         .
echo d-i   partman/confirm_write_new_label  boolean true
)>>.\http\xenial.cfg

(
::  silences unmounted partition
echo d-i partman-basicmethods/method_only boolean false

::  Scan another CD or DVD?
echo apt-cdrom-setup apt-setup/cdrom/set-first boolean false

::  No live proxy, using normal package mirrors
echo d-i     mirror/country          string enter information manually
echo d-i     mirror/http/hostname    string archive.ubuntu.org
echo d-i     mirror/http/directory   string /ubuntu
echo d-i     mirror/suite            string stable
echo d-i     mirror/http/proxy       string

::  Default user
echo d-i passwd/user-fullname string subutai
echo d-i passwd/username string subutai
echo d-i passwd/user-password password ubuntai
echo d-i passwd/user-password-again password ubuntai
echo d-i user-setup/encrypt-home boolean false
echo d-i user-setup/allow-password-weak boolean true

::  Upgrade packages after debootstrap? (none, safe-upgrade, full-upgrade)
::  (note: set to none for speed)
echo d-i pkgsel/upgrade select none

echo d-i grub-installer/only_debian boolean true
echo d-i grub-installer/with_other_os boolean true
echo d-i grub-installer/timeout string 0
echo d-i grub-installer/bootdev string default


echo d-i finish-install/reboot_in_progress note

echo d-i pkgsel/update-policy select none

echo choose-mirror-bin mirror/http/proxy string
::  Minimum packages (see postinstall.sh)

echo d-i pkgsel/include string openssh-server ntp curl net-tools dnsutils linux-tools-$(uname -r) linux-cloud-tools-$(uname -r) linux-cloud-tools-common cifs-utils

echo d-i preseed/late_command string in-target apt-get install -y --install-recommends linux-virtual-lts-xenial linux-tools-virtual-lts-xenial linux-cloud-tools-virtual-lts-xenial;
echo d-i grub-installer/force-efi-extra-removable boolean true

::  change boot
echo d-i preseed/late_command string \
echo d-i preseed/late_command string                                                   \
echo     mkdir -p /target/boot/efi/EFI/BOOT && \
echo     cp /target/boot/efi/EFI/ubuntu/* /target/boot/efi/EFI/BOOT && \
echo     cd /target/boot/efi/EFI/BOOT/ && mv shimx64.efi BOOTX64.EFI
)>>.\http\xenial.cfg    