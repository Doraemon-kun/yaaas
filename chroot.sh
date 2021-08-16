# Add your local timezone to localtime config and set the timezone to the system
ln -sf /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime
timedatectl set-timezone Asia/Ho_Chi_Minh

# Again, enable NTP, but for the new system
timedatectl set-ntp 1

# Apply time to BIOS
hwclock --systohc

# Localization with locale and keymap
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
localectl set-locale LANG="en_US.UTF-8" LC_TIME="en_US.UTF-8"
localectl set-keymap us

# Ask for hostname and apply it
read -p "Hey! Enter hostname please? " hostname
echo "$hostname" >> /etc/hostname

# Apply hosts file
echo -e "127.0.0.1     localhost\n::1           localhost\n127.0.1.1     $hostname.localdomain $hostname" >> /etc/hosts

# Set configurations for boot image and apply it
sed -i 's/^HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)/HOOKS=(base udev autodetect keyboard keymap consolefont modconf block encrypt filesystems fsck)/' /etc/mkinitcpio.conf
mkinitcpio -P

# Install grub and configure it
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch
cp grub /etc/default/
grub-mkconfig -o /boot/grub/grub.cfg

# Enable NetworkManager (ignore the error)
systemctl enable --now NetworkManager

# Config sudoers
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

# Ask for username and password and create that user
read -p "Hey! Enter your username of choice? " username
useradd --create-home $username

# Change password of that user and add them to wheel group
passwd $username
usermod -aG wheel $username

# Configure pacman
curl -s "https://archlinux.org/mirrorlist/?country=HK&country=ID&country=JP&country=SG&country=TW&country=TH&country=US&protocol=https&ip_version=4&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 15 - > /etc/pacman.d/mirrorlist
nc=$(grep -c ^processor /proc/cpuinfo)
sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$nc"/g' /etc/makepkg.conf
sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T $nc -z -)/g' /etc/makepkg.conf

# Install more necessary packages
sudo pacman -Sy --noconfirm xorg-server xorg-xinit xorg-xinput xorg-drivers picom openvpn pulseaudio pavucontrol bash-completion cronie gufw htop neofetch numlockx openssh p7zip unrar unzip wget zsh zsh-completions btrfs-progs dosfstools exfat-utils gparted ntfs-3g parted nautilus gedit clang cmake python xdg-user-dirs

# Finalizing
export HOME="/home/$username"
xdg-user-dirs-update

# Exit out
exit
umount -R /mnt

# Goodbye
clear
echo "The installation is conpleted now, please enter 'reboot' to reboot your new system."