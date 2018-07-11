#! /bin/sh

# -- Install dependencies.

apt-get update
apt-get install -qy wget patchelf file
apt-get install -qy gdisk zsync util-linux btrfs-progs dosfstools grub-common grub-efi-amd64-bin

wget -q https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage -O appimagetool
wget -q https://raw.githubusercontent.com/luis-lavaire/bin/master/copier

chmod +x appimagetool
chmod +x copier
chmod a+x znx


# -- Populate the 'appdir' directory.

mkdir -p appdir/bin
cp znx appdir/bin

echo '
[Desktop Entry]
Type=Application
Name=znx
Exec=wrapper
Icon=znx
Comment="Operating system manager."
Terminal=true
Categories=Utility;
' > appdir/znx.desktop

touch appdir/znx.png


# -- Create a wrapper script.

echo '
#! /bin/sh -x

export LD_LIBRARY_PATH=$APPDIR/usr/lib:$LD_LIBRARY_PATH
export PATH=$PATH:$APPDIR/bin:$APPDIR/sbin:$APPDIR/usr/bin:$APPDIR/usr/sbin
$APPDIR/bin/znx $@' > appdir/bin/wrapper

chmod a+x appdir/bin/wrapper


# -- Copy binaries and its dependencies to appdir.

./copier zsync appdir
./copier blkid appdir
./copier sgdisk appdir
./copier mkfs.vfat appdir
./copier mkfs.btrfs appdir
./copier mountpoint appdir
./copier grub-install appdir
./copier grub-mkimage appdir

mkdir -p appdir/grub-modules
cp /usr/lib/grub/x86_64-efi/* appdir/grub-modules


# -- Generate the AppImage.

(
	cd appdir

	wget -q https://raw.githubusercontent.com/AppImage/AppImages/master/functions.sh
	chmod +x functions.sh
	. ./functions.sh
	delete_blacklisted
	rm functions.sh

	wget -qO AppRun https://github.com/AppImage/AppImageKit/releases/download/continuous/AppRun-x86_64
	wget -qO runtime https://github.com/AppImage/AppImageKit/releases/download/continuous/runtime-x86_64

	chmod a+x AppRun
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
