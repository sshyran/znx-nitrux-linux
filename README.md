# znx

[![Build Status](https://travis-ci.org/Nitrux/znx.svg?branch=master)](https://travis-ci.org/Nitrux/znx)

- Parallel deployments of Linux distributions.
- Upgrade the systems in an atomic way.
- Update the images with differential content (just the missing or modified blocks are downloaded).

For more information about how `znx` works, please refer to the [documentation](https://github.com/Nitrux/znx/wiki).

In the image below, you can see `znx`'s boot menu.

![](https://cdn-images-1.medium.com/max/1200/1*b4eeOQ8ZR30RUtPv5sJ9NA.png)

To try it out, [download the AppImage](https://github.com/Nitrux/znx/releases), give execution permissions
to the AppImage and run as root:

```
./znx init /dev/sdX
./znx deploy /dev/sdX nitrux/stable http://repo.nxos.org:8000/nitrux_release_stable
```

**NOTE:**
_If you are not so into typing commands in a terminal, you can check [znx-gui](https://github.com/Nitrux/znx-gui), which
is a Qt-based frontend for `znx`, and is provided as an AppImage._

Be sure to replace `/dev/sdX` with the name of your device. These commands will initialize
the storage device and deploy the `nitrux/stable` image on the device.
