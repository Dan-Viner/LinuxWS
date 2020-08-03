## BTRFS

COW file-system.

There are several options for subvolume structurs as you can see [here](https://btrfs.wiki.kernel.org/index.php/SysadminGuide). I used the "flat" layout, with seperate subvolumes for @home and @ (root), as this structure is supported by timeshift (if you want to backup home folder as well).

Anyway, it's recommanded to unmount the top folder in which the subvolume were created, and instead mount the subvolumes (for example @ can be mounted to /mnt and the @home can be mounted to /mnt/home). This is important in order to enable fanctionalities such as sanpshots of the root directory.

### Checking free-space

On non-RAID system: The first command: `sudo btrfs fi show` shows the allocated space out of the total available space ("used" means "allocated" and not really used). The second command: `btrfs fi df /` shows the used space out of the allocated space (for full explanation check [this](https://btrfs.wiki.kernel.org/index.php/FAQ)).

To enable 'quota' on BTRFS type `btrfs quota enable <path>` and check the output of `btrfs qgroup show <path>` (see the [full article](https://btrfs.wiki.kernel.org/index.php/Quota_support))

### Top-level subvolume

To create a top-level subvolume first mount the root (the entire device, e.g. /dev/sda3 and **not a specific subvolume**) into some mounting point. Then you can use this mounting point to manage the subvolumes by creating new ones or deleting old ones.

### Restoring data from snapshots

* Restoring specific file can be done simply by mounting the snapshot with the desired file into some mounting point and copying the data from there.
* Replacing entire top-leevl subvolumes can be done by changing the subvol (or subvolid) in the `/etc/fstab` file.
* Replacing the **root subvolume** require 2 things: a. update the /etc/fstab file like in any other subvolume. b. a is not enough because the boot-loader is resposible to load the root subvolume, and the /etc/fstab is obviously not available on this stage. So the [kernel parameters](https://wiki.archlinux.org/index.php/Kernel_parameters#Configuration) should also be updated to reflect this change (see [here](https://wiki.archlinux.org/index.php/Btrfs#Mounting_subvolume_as_root)). With GRUB as a bootloader, for example, I just changed the subvolume (`ootflags=subvol`) in the grub configuration file (`/boot/grub/grub.cfg`)
