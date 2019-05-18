#! /bin/sh

# -- Variables passed by the docker command.

TRAVIS_COMMIT=$1
TRAVIS_BRANCH=$2


# -- Install dependencies.

apt-get -qq -y update > /dev/null
apt-get -qq -y install wget patchelf file libcairo2 > /dev/null
apt-get -qq -y install xorriso axel gdisk zsync util-linux btrfs-progs dosfstools grub-common grub2-common grub-efi-amd64 grub-efi-amd64-bin > /dev/null

wget -q https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage -O appimagetool
wget -q https://raw.githubusercontent.com/luis-lavaire/bin/master/copier
wget -q https://raw.githubusercontent.com/nitrux/mkiso/master/mkiso

chmod +x appimagetool
chmod +x copier
chmod +x mkiso
chmod +x appdir/znx


# -- Write the commit that generated this build.

sed -i "s/@TRAVIS_COMMIT@/${TRAVIS_COMMIT:0:7}/" appdir/znx


# -- Copy binaries and its dependencies to appdir.

./copier mkiso appdir
./copier axel appdir
./copier zsync appdir
./copier lsblk appdir
./copier sgdisk appdir
./copier wipefs appdir
./copier xorriso appdir
./copier mkfs.vfat appdir
./copier mkfs.btrfs appdir


# -- Build GRUB's boot image.

grub-mkimage \
	-C xz \
	-O x86_64-efi \
	-o appdir/bootx64.efi \
	-p /boot/grub \
	boot linux search normal configfile \
	part_gpt btrfs ext2 fat iso9660 loopback \
	test keystatus gfxmenu regexp probe \
	efi_gop efi_uga all_video gfxterm font \
	echo read ls cat png jpeg halt reboot


# -- Generate the AppImage.

(
	cd appdir

	wget -q https://raw.githubusercontent.com/AppImage/AppImages/master/functions.sh
	chmod +x functions.sh
	. ./functions.sh
	delete_blacklisted
	rm functions.sh

	wget -qO runtime https://github.com/AppImage/AppImageKit/releases/download/continuous/runtime-x86_64
	chmod a+x runtime

	find lib/x86_64-linux-gnu -type f -exec patchelf --set-rpath '$ORIGIN/././' {} \;
	find bin -type f -exec patchelf --set-rpath '$ORIGIN/../lib/x86_64-linux-gnu' {} \;
	find sbin -type f -exec patchelf --set-rpath '$ORIGIN/../lib/x86_64-linux-gnu' {} \;
	find usr/bin -type f -exec patchelf --set-rpath '$ORIGIN/../../lib/x86_64-linux-gnu' {} \;
	find usr/sbin -type f -exec patchelf --set-rpath '$ORIGIN/../../lib/x86_64-linux-gnu' {} \;
)

wget -q https://raw.githubusercontent.com/Nitrux/appimage-wrapper/master/appimage-wrapper
chmod a+x appimage-wrapper

mkdir out
ARCH=x84_64 ./appimage-wrapper appimagetool appdir out/znx_$TRAVIS_BRANCH


# -- Embed update information in the AppImage.

UPDATE_URL="zsync|https://github.com/Nitrux/znx/releases/download/continuous-development/znx_$TRAVIS_BRANCH"

printf "$UPDATE_URL" | dd of=".AppImage" bs=1 seek=33651 count=512 conv=notrunc 2> /dev/null
