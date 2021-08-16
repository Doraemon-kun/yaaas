#!/usr/bin/env bash
#---------------------------------------
#       Yet Another ArchLinux Automate Script (YAAAS)
#   Created by: AM
#   Created for: ArchLinux 2021.08.01 (Linux Kernel Version: 5.13.10)
#   This script is partly based on ChrisTitusTech/ArchMatic. Please check his version of the script, because he inspired me to create this one.
#---------------------------------------
clear

# Information
echo "--------------------------------------------------------------"
echo "Welcome to Yet Another ArchLinux Automate Script (YAAAS). This script is created by AM for installing and configuring ArchLinux new system that suit my own needs."
echo "I suggest you to read the source of this file, and the others one included in this repository, so you can know what will the script do and avoid making some faulty mistakes."
echo "--------------------------------------------------------------"
echo "This script WILL NOT partition your drive, WILL NOT install any window manager or desktop environment, and the script WILL ASSUME that you use UEFI boot mode, so please make sure that you use the correct boot mode."
echo "We assume that you have verified the authencity of the ISO boot disk, are booting from the installation media, and have a stable Internet connection."
echo "We WILL NOT RESPONSIBLE for making some faulty mistakes via running this script, so please be careful!!!"
echo "--------------------------------------------------------------"
echo "YOU ARE DOING THIS AT YOUR OWN RISK!!!!"
echo "--------------------------------------------------------------"
echo "Do you want to continue? [Press any key to continue | Ctrl-C to exit this script]"
read lastconfirm

# Starting the installation with some minor configurations
echo "--------------------------------------------------------------"
echo "Installing necessary packages and set some configuration"
echo "--------------------------------------------------------------"
# Enable NTP
timedatectl set-ntp true

# Install packages and configure the mirrorlist file
pacman -Sy --noconfirm pacman-contrib
curl -s "https://archlinux.org/mirrorlist/?country=HK&country=ID&country=JP&country=SG&country=TW&country=TH&country=US&protocol=https&ip_version=4&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 15 - > /etc/pacman.d/mirrorlist

# Partitioning the disk (SHOULD NOT BE ENABLE AND WILL NOT BE ENABLE BY DEFAULT. And if you want to use it, USE AT YOUR OWN RISK!)
# clear
# parted /dev/sda mklabel gpt
# parted /dev/sda mkpart primary 1 300
# parted /dev/sda mkpart primary "301 -1"
# cryptsetup -y -v luksFormat /dev/sda2
# cryptsetup open /dev/sda2 cryptroot
# mkfs.ext4 /dev/mapper/cryptroot
# mount /dev/mapper/cryptroot /mnt
# mkfs.fat -F32 /dev/sda1
# mkdir /mnt/boot
# mount /dev/sda1 /mnt/boot

# Starting installing ArchLinux to /dev/sda2
echo "--------------------------------------------------------------"
echo "Let's start installing Arch now! We are installing it into the main partition!"
echo "--------------------------------------------------------------"
# Install necessary packages to the new system
pacstrap /mnt base base-devel linux linux-firmware vim nano sudo open-vm-tools networkmanager dhclient man-db man-pages texinfo efibootmgr grub curl pacman-contrib git --noconfirm --needed

# Generate fstab 
genfstab -U /mnt >> /mnt/etc/fstab

# Get ready for chroot
cp ./grub /mnt/root
cp ./chroot.sh /mnt/root
clear
echo "--------------------------------------------------------------"
echo "We have passed through the first part of the installation (I don't know if it fail or not, you should track the output of each commands) and now chrooted to the new system."
echo "But we haven't done yet, we still have the second part of the installation. To run it, simply cd to the root directory, and run 'chroot.sh', it will install the rest for you"
echo "One more warning, if you don't use system encryption, please remove the encrypt word in line 25 of the new script file (The one start with HOOKS) and remove line 30 (the one that copy grub file to destination folder) or your installation will be trashed (but fixable)"
echo "--------------------------------------------------------------"

# Chroot
arch-chroot /mnt