#!/usr/bin/sh
pacman -Syyy
pacstrap -i /mnt base --noconfirm
sleep 3
genfstab -U /mnt >> /mnt/etc/fstab
sleep 2
cp -p /nfs/arch-inst.sh /mnt/root/arch-inst.sh
echo "The initial config is complete."
echo "Please run ./arch-inst.sh"
sleep 5
arch-chroot /mnt