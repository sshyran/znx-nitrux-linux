#! /bin/sh


#    Install dependencies.

apt -qq update > /dev/null
apt -yy install wget patchelf file libcairo2 mtools xorriso axel gdisk zsync btrfs-progs dosfstools grub-common grub2-common grub-efi-amd64 grub-efi-amd64-bin git autoconf gettext automake libtool-bin autopoint pkg-config libncurses5-dev bison


# -- Update xorriso, grub, util-linux.

files='
http://mirrors.kernel.org/ubuntu/pool/universe/libi/libisoburn/xorriso_1.5.0-1build1_amd64.deb
http://mirrors.kernel.org/ubuntu/pool/universe/libi/libisoburn/libisoburn1_1.5.0-1build1_amd64.deb
http://mirrors.kernel.org/ubuntu/pool/universe/libb/libburn/libburn4_1.5.0-1_amd64.deb
http://mirrors.kernel.org/ubuntu/pool/universe/libi/libisofs/libisofs6_1.5.0-1_amd64.deb
http://mirrors.kernel.org/ubuntu/pool/main/r/readline/libreadline8_8.0-1_amd64.deb
http://mirrors.kernel.org/ubuntu/pool/main/r/readline/readline-common_8.0-1_all.deb
http://mirrors.kernel.org/ubuntu/pool/main/n/ncurses/libtinfo6_6.1+20181013-2ubuntu2_amd64.deb
http://mirrors.kernel.org/ubuntu/pool/main/g/grub2/grub-efi-amd64-bin_2.02-2ubuntu8.13_amd64.deb
http://mirrors.kernel.org/ubuntu/pool/main/g/grub2/grub-common_2.02-2ubuntu8.13_amd64.deb
http://mirrors.kernel.org/ubuntu/pool/main/g/grub2/grub2-common_2.02-2ubuntu8.13_amd64.deb
http://mirrors.kernel.org/ubuntu/pool/main/u/util-linux/libmount1_2.34-0.1ubuntu2_amd64.deb
http://mirrors.kernel.org/ubuntu/pool/main/u/util-linux/libsmartcols1_2.34-0.1ubuntu2_amd64.deb
'

mkdir /deb_files

for x in $files; do
printf "$x"
    wget -q -P /deb_files $x
done

dpkg -iR /deb_files
dpkg --configure -a
rm -r /deb_files


#    Add tooling for AppImage.

wget -q https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage -O appimagetool
wget -q https://gitlab.com/nitrux/tools/build-utilities/raw/master/copier
wget -q https://gitlab.com/nitrux/tools/build-utilities/raw/master/mkiso

chmod +x appimagetool
chmod +x copier
chmod +x mkiso
chmod +x appdir/znx


#    Build util-linux 2.34.

git clone --depth 1 --single-branch --branch v2.34 https://github.com/karelzak/util-linux.git

(
	cd util-linux

	./autogen.sh
	./configure

	make -j$(nproc)
	make -j$(nproc) install
)


#   Remove old libsmartcols libraries for lsblk to find the correct one

rm /lib/x86_64-linux-gnu/libsmartcols.so.1*
rm /lib/x86_64-linux-gnu/libmount.so.1*


#    Copy binaries and its dependencies to appdir.

./copier mkiso appdir
./copier axel appdir
./copier mcopy appdir
./copier zsync appdir
./copier lsblk appdir
./copier sgdisk appdir
./copier wipefs appdir
./copier xorriso appdir
./copier mkfs.vfat appdir
./copier mkfs.btrfs appdir


#    Build GRUB's boot image.

grub-mkimage \
	-C xz \
	-O x86_64-efi \
	-p /boot/grub \
	-o appdir/bootx64.efi \
	boot linux search normal configfile \
	part_gpt btrfs ext2 fat iso9660 loopback \
	test keystatus gfxmenu regexp probe \
	efi_gop efi_uga all_video gfxterm font \
	echo read ls cat png jpeg halt reboot


#   Variables for generating the AppImage.

ARCH=$(uname -m)
TRAVIS_COMMIT=${1:0:7}
TRAVIS_BRANCH=$2

RELEASE_NAME="znx-$TRAVIS_BRANCH-$TRAVIS_COMMIT-$ARCH.AppImage"
UPDATE_URL="zsync|https://github.com/Nitrux/znx/releases/download/continuous-$TRAVIS_BRANCH/$RELEASE_NAME"


#    Write the commit hash that generated this build.

sed -i "s/@TRAVIS_COMMIT@/$TRAVIS_COMMIT/" appdir/znx


#   Generate the AppImage.

(
	cd appdir

	wget -q https://raw.githubusercontent.com/AppImage/AppImages/master/functions.sh
	chmod +x functions.sh
	. ./functions.sh
	delete_blacklisted
	rm functions.sh

	find lib/x86_64-linux-gnu -type f -exec patchelf --set-rpath '$ORIGIN/././' {} \;
	find bin -type f -exec patchelf --set-rpath '$ORIGIN/../lib/x86_64-linux-gnu' {} \;
	find sbin -type f -exec patchelf --set-rpath '$ORIGIN/../lib/x86_64-linux-gnu' {} \;
	find usr/bin -type f -exec patchelf --set-rpath '$ORIGIN/../../lib/x86_64-linux-gnu' {} \;
	find usr/sbin -type f -exec patchelf --set-rpath '$ORIGIN/../../lib/x86_64-linux-gnu' {} \;
)

wget -q https://raw.githubusercontent.com/Nitrux/appimage-wrapper/master/appimage-wrapper
chmod a+x appimage-wrapper

mkdir out
./appimage-wrapper appimagetool -u "$UPDATE_URL" appdir out/$RELEASE_NAME
