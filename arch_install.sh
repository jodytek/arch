# Step 1 boot from SD install media, and insert USB Panda wifi
# run commands
ip linl set dev wlan1 down
ip linl set dev wlan0 down
wap_passphrase Yoga-Buddha H0rse\$hoe71 > /etc/wpa_supplicant.conf
wpa_supplicant -B -c /etc/wpa_supplicant.conf -i wlan0
mkdir /nfs
mount 10.19.71.12:/mnt/Data/arch_build  /nfs
/nfs/archinst1.sh