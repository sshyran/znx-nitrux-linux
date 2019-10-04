Usage Guide
===========

.. note::
    ZNX requires to be run as root.

    This guide is written taking into consideration that :code:`sudo` is available
    for the user running the commands.

Initializing Device
^^^^^^^^^^^^^^^^^^^
To use ZNX, the devices needs to be initialized first with the :code:`init` command.

.. warning::
    This command will **REWRITE** the partition table and **WIPE** all the data. Make sure
    to backup all the data before running this command.

* Find the block device of the disk you want to use with znx with :code:`blkid`.
  Let's say the device is :code:`/dev/sdb`
* Run the following command to initialize the device : 
  :code:`sudo znx init /dev/sdb`

Deploying Image
^^^^^^^^^^^^^^^

Naming Convention
-----------------

Deploying an ISO requires you to give a name. The name will be used by all the other commands
to perform operations specific to an installation (like updating, removing, etc).

The naming convention consists of two parts, a :code:`vendor` and :code:`release`, and has to
in the format :code:`<vendor>/<release>`

Each of :code:`vendor` and :code:`release` should follow these rules :

* At least one character
* Can consist only :code:`a-z`, :code:`A-Z`, :code:`0-9` and :code:`_`

**Examples** : :code:`nitrux/stable`, :code:`nitrux/development`

----

An ISO Image can be deployed to a device in one of the following two ways :

Deploying Local ISO
-------------------
If you already have the ISO downloaded, use this command to deploy the ISO :
::
    sudo znx deploy /dev/sdX <name> </path/to/image.iso>

Deploying Remote ISO
--------------------
You can also deploy remote ISOs as follows :
::
    sudo znx deploy /dev/sdX <name> <http://foo.bar/image.iso>

Updating Installation
^^^^^^^^^^^^^^^^^^^^^
With ZNX, updates are **ATOMIC**, which means an image will either be updated or get rollback
to the last state if an update fails. This ensures the installation is always in a usable state.

An installed system can be updated with the following command : 
::
    znx update /dev/sdX <name>

Reverting Update
^^^^^^^^^^^^^^^^
If an installed update needs to be reverted, it can be done without any consequences.
The installation will rollback to the last state before the update.

.. note::
    This will **NOT WIPE** any user-data.

An installation can be reverted to the last state with the following command :
::
    znx revert /dev/sdX <name>

Removing Installation
^^^^^^^^^^^^^^^^^^^^^
.. warning::
    This will **WIPE** all user-data of the installed image. Make sure to backup the data (if needed)

To remove an installed image and all it's user-data, use the command :
::
    znx clean /dev/sdX vendor/release

Renaming Installation
^^^^^^^^^^^^^^^^^^^^^
Rename an already installed image with :
::
    znx rename /dev/sdX <old-name> <new-name>

Cleaning Update Cache
^^^^^^^^^^^^^^^^^^^^^
Updating an image requires some stuffs to be downloaded. The cache can be cleaned with the command :
::
    znx clean /dev/sdX <name>

Resetting Installation
^^^^^^^^^^^^^^^^^^^^^^
.. warning::
    This will **WIPE** all user-data of the installed image. Make sure to backup the data (if needed)

ZNX allows users to reset an installation to base state.

Resetting an image can be done with the command :
::
    znx reset /dev/sdX <name>

Statistics
^^^^^^^^^^
Get some nerdy stats for an image with the following command :
::
    znx stats /dev/sdX <name>

List of Deployed Images
^^^^^^^^^^^^^^^^^^^^^^^
To get the list of deployed images, use the command :
::
    znx list /dev/sdX

Restoring ESP
^^^^^^^^^^^^^
If the ESP (EFI System Partition) gets corrupted, ZNX can restore it with the command :
::
    znx restore /dev/sdX