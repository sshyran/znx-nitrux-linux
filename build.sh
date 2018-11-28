#! /bin/sh

# -- Install dependencies.

apt-get -qq -y update
apt-get -qq -y install wget patchelf file libcairo2
apt-get -qq -y install busybox-static axel gdisk zsync util-linux btrfs-tools dosfstools grub-common grub2-common grub-efi-amd64-bin

wget -q https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage -O appimagetool
wget -q https://raw.githubusercontent.com/luis-lavaire/bin/master/copier

chmod +x appimagetool
chmod +x copier
chmod +x znx


# -- Write the commit that generated this build.

sed -i "s/@TRAVIS_COMMIT@/${1:0:7}/" znx


# -- Populate appdir.

mkdir -p appdir/bin
cp znx appdir
cp grub.cfg appdir

printf \
'[Desktop Entry]
Type=Application
Name=znx
Exec=znx
Icon=znx
Comment="Operating system manager."
Terminal=true
Categories=Utility;
OnlyShowIn=
' > appdir/znx.desktop


# -- Create a wrapper script.

printf \
'#! /bin/sh

export LD_LIBRARY_PATH=$APPDIR/usr/lib:$LD_LIBRARY_PATH
export PATH=$PATH:$APPDIR/bin:$APPDIR/sbin:$APPDIR/usr/bin:$APPDIR/usr/sbin
exec $APPDIR/znx $@
' > appdir/AppRun

chmod a+x appdir/AppRun


# -- Install busybox.

./copier busybox appdir
/bin/busybox --install -s appdir/bin


# -- Copy binaries and its dependencies to appdir.

./copier axel appdir
./copier zsync appdir
./copier blkid appdir
./copier sgdisk appdir
./copier wipefs appdir
./copier mkfs.vfat appdir
./copier mkfs.btrfs appdir


# -- Build GRUB's boot image.

grub-mkimage \
	-C xz \
	-O x86_64-efi \
	-o appdir/bootx64.efi \
	boot linux search normal configfile \
	part_gpt btrfs fat iso9660 loopback \
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
ARCH=x84_64 ./appimage-wrapper appimagetool appdir out/znx
