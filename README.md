# znx

[![Build Status](https://travis-ci.org/Nitrux/znx.svg?branch=master)](https://travis-ci.org/Nitrux/znx)

- Parallel deployments of Linux distributions.
- Upgrade the systems in an atomic way.
- Update the images with differential content (just the missing or modified blocks are downloaded).

For more information about how `znx` works, please refer to the [documentation](https://github.com/Nitrux/znx/wiki).

In the image below, you can see `znx`'s boot menu.

![](https://cdn-images-1.medium.com/max/1200/1*b4eeOQ8ZR30RUtPv5sJ9NA.png)

To try it out, [download the AppImage](https://github.com/Nitrux/znx/releases), give execution permissions
to the AppImage, download a compatible ISO file and run znx as root.

```
Usage: znx <option | command>

Options:

  -v, --version                          Print the commit hash that generated this binary.
  -h, --help                             Print this help.

Commands:

  init <device>                           Initialize the storage device.
  restore <device>                        Restore the ESP (EFI System Partition) of the given device.
  deploy <device> <image> <URL | path>    Deploy an image on a storage device. Do not use whitespaces in filenames.
  update <device> <image>                 Update the specified image.
  revert <device> <image>                 Revert to the previous version of the image.
  clean <device> <image>                  Remove the backup that is created during an update.
  reset <device> <image>                  Delete all user data of the specified image.
  remove <device> <image>                 Remove the specified image.
  stats <device> <image>                  Show statistics about the provided image.
  list <device>                           List the deployed images.

Examples:

  Initialize a device:
  - znx init /dev/sdX

  Restore the ESP of a device:
  - znx restore /dev/sdX

  Deploy an image:
  - znx deploy /dev/sdX vendor/release http://foo.bar/image.iso
  - znx deploy /dev/sdX vendor/release /path/to/image.iso

  Update an image:
  - znx update /dev/sdX vendor/release

  Revert an update (downgrade):
  - znx revert /dev/sdX vendor/release

  Delete the backup of an image:
  - znx clean /dev/sdX vendor/release

  Reset an image to its original state:
  - znx reset /dev/sdX vendor/release

  Remove an image:
  - znx remove /dev/sdX vendor/release

  Show statistics about an image:
  - znx stats /dev/sdX vendor/release

  List the deployed images on a device:
  - znx list /dev/sdX
```

Be sure to replace `/dev/sdX` with the name of your device, use the commands `lsblk`, `fdisk` or `blkid` to find the correct device.
