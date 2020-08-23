#!/usr/bin/sh
PASS=$(tr -cd '[:alnum:]' < /dev/urandom | head -c128)
for i in 1 2 3; do 
openssl enc -aes-256-ctr -pass pass:"$PASS" -nosalt </dev/zero | dd bs=64K ibs=64K of=/dev/sda$i status=progress
done
DRIVE=/dev/sda
sgdisk --zap-all $DRIVE
sgdisk --clear \
       --new=1:0:+550MiB --typecode=1:ef00 --change-name=1:EFI \
       --new=2:0:+8GiB   --typecode=2:8200 --change-name=2:swap \
       --new=3:0:+60GiB  --typecode=3:8300 --change-name=3:system \
       $DRIVE
mkfs.fat -F32 -n EFI /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mkfs.btrfs /dev/sda3
pacman -Syyy
pacman -S btrfs-progs --noconfirm
mount -t btrfs -o compress=lzo /dev/sda3 /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@snapshots
umount /mnt
mount -t btrfs -o noatime,compress=lzo,subvol=@ /dev/sda3 /mnt
mkdir -p /mnt/boot/EFI
mkdir -p /mnt/home
mkdir -p /mnt/.snapshots
mount -t btrfs -o noatime,compress=lzo,subvol=@home /dev/sda3 /mnt/home
mount -t btrfs -o noatime,compress=lzo,subvol=@snapshots /dev/sda3 /mnt/.snapshots
mount /dev/sda1 /mnt/boot/EFI
pacman -Syyy
pacstrap -i /mnt base --noconfirm
genfstab -U /mnt >> /mnt/etc/fstab
cp -p /nfs/arch-inst.sh /mnt/root/arch-inst.sh
echo "The initial config is complete."
echo "Please run ./arch-inst.sh"
arch-chroot /mnt