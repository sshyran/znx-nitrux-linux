#! /bin/sh

# This setup assumes that ONLY ONE device is connected. To support
# data persistence correctly, the filesystem UUID should be passed
# as a kernel parameter.

# -- Prepare the temporary directory

for d in $(awk '{ print $4 }' /proc/partitions); do

	[ -b /dev/$d ] || continue

	blkid /dev/$d | grep -q ZNX_DATA && {
		p=/dev/$d
		s=$(grep $p /proc/mounts | awk '{ print $2 }')

		mkdir $HOME/storage
		chown $(id -un) $HOME/storage
		chmod 700 $HOME/storage
		sudo mount $s $HOME/storage

		break
	}

done
