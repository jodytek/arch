#!/usr/bin/sh
PASS=$(tr -cd '[:alnum:]' < /dev/urandom | head -c128)
for i in 1 2 3; do 
openssl enc -aes-256-ctr -pass pass:"$PASS" -nosalt </dev/zero | dd bs=64K ibs=64K of=/dev/sda$i status=progress
done