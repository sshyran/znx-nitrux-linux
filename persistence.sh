#! /bin/sh -x

# This setup assumes that ONLY ONE device is connected. To support
# data persistence correctly, the filesystem UUID should be passed
# as a kernel parameter.

# -- Storage location.

STORAGE=$HOME/storage


# Find where is the boot device mounted at and bind-mount the /home
# directory.

for d in $(awk '{ print $4 }' /proc/partitions); do

	p=/dev/$d

	[ -b $p ] || \
		continue

	blkid $p | grep -q ZNX_DATA && {

		mkdir -p $STORAGE
		chown $(id -un) $STORAGE
		chmod 744 $STORAGE

		sudo mount -o bind $(grep $p /proc/mounts | cut -d ' ' -f 2) $STORAGE
		break

	}

done
