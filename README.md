# ![znx](https://nxos.b-cdn.net/wp-content/uploads/2019/10/znx_logo-min.png)

[![Build Status](https://travis-ci.org/Nitrux/znx.svg?branch=master)](https://travis-ci.org/Nitrux/znx)

- Parallel deployments of Linux distributions.
- Atomic upgrades.
- Differential updates.

For more information about how `znx` works, please refer to the [documentation](https://github.com/Nitrux/znx/wiki).

In the image below, you can see `znx`'s boot menu.

![](https://cdn-images-1.medium.com/max/1200/1*b4eeOQ8ZR30RUtPv5sJ9NA.png)

To try it out, [download the AppImage](https://github.com/Nitrux/znx/releases), give execution permissions
to the AppImage, and run znx as root.

---

Examples.

- Initialize a device:
```
znx init /dev/sdX
```

- Restore the ESP of a device:
```
znx fix-esp /dev/sdX
```

- Deploy an image:
```
znx deploy /dev/sdX vendor/release http://foo.bar/image.iso
znx deploy /dev/sdX vendor/release /path/to/image.iso
```

- Rename an image:
```
znx rename /dev/sdX vendor/release new/name
```

- Update an image:
```
znx update /dev/sdX vendor/release
```

- Check the availability of updates for an image:
```
znx check-update /dev/sdX vendor/release
```

- Revert an update (downgrade):
```
znx rollback /dev/sdX vendor/release
```

- Reset an image to a pristine state:
```
znx reset /dev/sdX vendor/release
```

- Delete an image's backup:
```
znx clean /dev/sdX vendor/release
```

- Remove an image:
```
znx remove /dev/sdX vendor/release
```

- Show the status of an image:
```
znx status /dev/sdX vendor/release
```

- List the deployed images on a device:
```
znx list /dev/sdX
```

---

To find the desired device, you may use the `lsblk` command.

**NOTE:**
_If you are not so into typing commands in a terminal, you can check [znx-gui](https://github.com/Nitrux/znx-gui), which is a graphical frontend for `znx`, and is provided as an AppImage._

# Issues
If you find problems with the contents of this repository please create an issue.

©2019 Nitrux Latinoamericana S.C.
