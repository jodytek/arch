#!/usr/bin/sh
pacman -S reflector --noconfirm
reflector -c "US" -f 12 -l 10 -n 12 --sort rate --save /etc/pacman.d/mirrorlist
pacman -S linux linux-firmware linux-lts linux-headers linux-lts-headers --noconfirm
pacman -S vi vim git base-devel go sudo btrfs-progs nfs-utils iwd intel-ucode openssh snapper neofetch --noconfirm
pacman -S xorg-server xorg-xinit plasma-desktop sddm --noconfirm
pacman -S xorg-server xorg-xinit --noconfirm
bootctl install

mount 10.19.71.12:/mnt/Data/arch_build /mnt
cp /mnt/sudoers /etc/sudoers
cp /mnt/locale.gen /etc/locale.gen
cp /mnt/sshd_config /etc/ssh/sshd_config
cp /mnt/mkinitcpio.conf /etc/mkinitcpio.conf
cp /mnt/loader.conf /boot/loader/loader.conf
cp /mnt/arch.conf /boot/loader/entries/arch.conf
cp /mnt/20-wired.network /etc/systemd/network/20-wired.network
cp /mnt/25-wireless.network /etc/systemd/network/25-wireless.network

UUID=`cat /etc/fstab |grep '^UUID' |cut -f2 -d'='|head -n1|awk '{print $1}'`
echo "options root=UUID=$UUID   rw rootflags=subvol=/@" >> /boot/loader/entries/arch.conf
ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime
hwclock --systohc
locale-gen
hostnamectl set-hostname arch-mbp

useradd -m -g users -G wheel jody
passwd jody
passwd
su - jody
    git clone https://aur.archlinux.org/yay.git
    cd yay && makepkg -si --noconfirm
    cd ..
    yay -S b43-firmware --noconfirm
    yay -S brave-bin --noconfirm
    yay -S hyper --noconfirm
    yay -S nvidia-340xx nvidia-340xx-utils --noconfirm
    cp /mnt/.xinitrc ~/
    git clone https://aur.archlinux.org/aic94xx-firmware.git
    cd aic94xx-firmware
    makepkg -sri
    cd ..
    git clone https://aur.archlinux.org/wd719x-firmware.git
    cd wd719x-firmware
    makepkg -sri
    exit
nvidia-xinit
mkinitcpio -p linux
mkinitcpio -p linux-lts
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
systemctl enable iwd.service
systemctl enable sshd.service

systemctl enable sddm.service
bootctl list


umount /mnt
exit
umount -a 
reboot

# after reboot
iwctl --passphrase H0rse\$hoe71 station wlan0 connect Yoga-Buddha