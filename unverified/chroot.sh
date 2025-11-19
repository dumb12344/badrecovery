mount --bind /dev /localroot/dev
mount --bind /proc /localroot/proc
mount --bind /sys /localroot/sys
chroot /localroot
