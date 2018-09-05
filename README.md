# znx

[![Build Status](https://travis-ci.org/Nitrux/znx.svg?branch=master)](https://travis-ci.org/Nitrux/znx)

`znx` allows the user to perform the following:

- Make parallel deployments of bootable ISO images (Linux-based distributions are expected).
- Upgrade the systems in an safe (atomic) way.
- Update the images based on differential content.

For more information about how `znx` works, please refer to the [documentation](https://github.com/Nitrux/znx/wiki).

In the image below, you can see `znx`'s boot menu.

![](https://i.imgur.com/YcBBARM.png)


To try it out, just grab an USB stick or and external drive and run:

```
# ./znx init /dev/sdb
# ./znx deploy ubuntu/xenial http://cdimage.ubuntu.com/xenial/daily-live/current/xenial-desktop-amd64.iso.zsync
```

Be sure to replace `/dev/sdb` with the actual device name of your device.
Those commands will, first, initialize the device, and, second, deploy Ubuntu Xenial on the device. Reboot.

To save your data, please download and run the `persistence.sh` script found in this repository (run as a normal
user, not as root).
