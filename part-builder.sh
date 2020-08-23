#!/usr/bin/sh
DRIVE=/dev/sda
sgdisk --zap-all $DRIVE
sgdisk --clear \
       --new=1:0:+550MiB --typecode=1:ef00 --change-name=1:EFI \
       --new=2:0:+8GiB   --typecode=2:8200 --change-name=2:swap \
       --new=3:0:+60GiB  --typecode=3:8300 --change-name=3:system \
       $DRIVE
sleep5 
mkfs.fat -F32 -n EFI /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mkfs.btrfs --label system /dev/sda3
mount -t btrfs -o compress=lzo LABEL=system /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@snapshots
umount -/mnt
mount -t btrfs -o noatime,compress=lzo,subvol=@ LABEL=system /mnt
mkdir -p /mnt/{boot,home,.snapshots}
mount -t btrfs -o noatime,compress=lzo,subvol=@home LABEL=system /mnt/home
mount -t btrfs -o noatime,compress=lzo,subvol=@snapshots LABEL=system /mnt/.snapshots
sleep 3