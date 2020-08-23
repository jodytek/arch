#!/usr/bin/sh

pacman -S linux linux-firmware linux-lts linux-headers linux-lts-headers --noconfirm
pacman -S base-devel vim git networkmanager wpa_supplicant wireless_tools \
netctl  btrfs-progs  nfs-utils dhcpcd iw gptfdisk zsh terminus-font \
sudo openssh --noconfirm
systemctl enable NetworkManager
systemctl enable sshd
systemctl enable dhcpcd@wlan0.service
systemctl enable wpa_supplicant@wlan0.service
wpa_passphrase Yoga-Buddha H0rse\$hoe71 > /etc/wpa_supplicant.conf
hostnamectl set-hostname arch-mbp
mount 10.19.71.12:/mnt/Data/arch_build /mnt
cp /mnt/hosts /etc/hosts
cp /mnt/mkinitcpio.conf /etc/mkinitcpio.conf
cp /mnt/locale.gen /etc/locale.gen
cp /mnt/sudoers /etc/sudoers
mkinitcpio -p linux
mkinitcpio -p linux-lts
ln -s /usr/share/zoneinfo/America/Chicago /etc/localtime
locale-gen
echo "R3db@ll1971" | passwd --stdin root
useradd -m -g users -G wheel jody
echo "BumbleB33$" | passwd --stdin jody
su -l jody -c 'git clone https://aur.archlinux.org/yay.git' 
su -l jody -c 'cd yay && makepkg -si --noconfirm' 
su -l jody -c 'yay -S b43-fwcutter b43-firmware --noconfirm'
pacman -S grub efibootmgr dosfstools os-prober mtools --noconfirm
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
mkdir /boot/grub/locale
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
grub-mkconfig -o /boot/grub/grub.cfg
pacman -S intel-ucode xorg-server vidia nvidia-utils nvidia-lts --noconfirm
clear
echo "installation now complete"
sleep 5