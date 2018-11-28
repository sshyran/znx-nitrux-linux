# znx

[![Build Status](https://travis-ci.org/Nitrux/znx.svg?branch=master)](https://travis-ci.org/Nitrux/znx)

![](https://raw.githubusercontent.com/Nitrux/znx/master/appdir/znx.png)

`znx` allows the user to perform the following:

- Make parallel deployments of Linux distributions.
- Upgrade the systems in a safe (atomic) way.
- Update the images based on differential content.

For more information about how `znx` works, please refer to the [documentation](https://github.com/Nitrux/znx/wiki).

In the image below, you can see `znx`'s boot menu.

![](https://i.imgur.com/YcBBARM.png)


To try it out, [download the AppImage](https://github.com/Nitrux/znx/releases), grab a USB stick or and external drive and run as UID 0 (root):

```
# ./znx init /dev/sdX
# ./znx deploy /dev/sdX nitrux/stable http://repo.nxos.org:8000/nitrux_release_stable
```

Be sure to replace `/dev/sdX` with the actual device name of your device. These commands will initialize the storage device and deploy the `nitrux/stable` image on the target computer. Reboot.
