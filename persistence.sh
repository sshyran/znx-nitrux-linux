#! /bin/sh -x

# This setup assumes that ONLY ONE device is connected. To support
# data persistence correctly, the filesystem UUID should be passed
# as a kernel parameter.

# -- Storage location.

STORAGE=$HOME/storage

for d in $(awk '{ print $4 }' /proc/partitions); do

	[ -b /dev/$d ] || continue


	blkid /dev/$d | grep -q ZNX_DATA && {
		p=/dev/$d

		mkdir -p $STORAGE
		chown $(id -un) $STORAGE
		chmod 700 $STORAGE

		sudo mount -o bind $(grep $p /proc/mounts | cut -d ' ' -f 2) $STORAGE
		break
	}

done
