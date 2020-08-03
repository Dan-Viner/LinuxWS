# Arch
a new Arch WS initialization notes and files.

### Installation
follow instructions from arch linux wiki.

a recommanded arch linux installation instruction videos:
* basic installations playlist: ["EF- Tech made simple" playlist](https://www.youtube.com/watch?v=sm_fuBeaOqE&list=PL-odKaUzOz3IT3FLQlXFaRVyNpWW1nj68&index=24). I enjoyed the one for [arch with BTRFS and snapper](https://www.youtube.com/watch?v=sm_fuBeaOqE&t=1175s) in particular.
* understanding the installation process: check [this playlist](https://www.youtube.com/watch?v=wZr9WTfFed0&list=PL2t9VWDusOo-0jF18YvEVhwpxTXlXPunG) by "Nice Micro", and specifically the one about [setting an internet connection](https://www.youtube.com/watch?v=IkI7nNxsh7I)

some notes:

* __wifi__: in the installation process use iw and iwd (check this [arch-wiki-page](https://wiki.archlinux.org/index.php/Iwd)). afterwords you'll probably install networkManager in your machine, so use it instead. set wifi connection following these steps:
		
		nmcli r (verify that all are enabled, if wifi is off, turn it on using "nmcli r wifi on")
		nmcli d wifi rescan
		nmcli d wifi list
		nmcli d wifi connect <NETWORK> password <PASSWORD>.
	you can also use the `nmtui` command as an easy GUI alternative.
* __timedatectl__: verify your system is using the UTC and not the local time zone using:

		timedatectl status (system clock should be syncronized).
	if not, use 

		timedatectl set-ntp true
		
**Note:** I don't understand why some things are done only on the live media in the installlation process and not on the actual system (for example the whole `timedatectl set-ntp true`).

### System recovery

If the data still exists- you can use live-media used for installation to:
* re-mount all the devices as done in the installation process, update /etc/fstab according to the new mounts: `genfstab -U /mnt >> /mnt/etc/fstab`
* chroot into the root mounting point.
* rebuild grub: (in an EFI system: `grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB`, see this [arch wiki page](https://wiki.archlinux.org/index.php/GRUB#Installation_2))
* reconfigure grub using: `grub-mkconfig -o /boot/grub/grub.cfg`
* exit chroot, `umount -a` and reboot

### Pacman basic usage
`sudo pacman -Syyy` - Refresh sources

`sudo pacman -S <PACKAGE>` - Install a package

`sudo pacman -Rs <PACKAGE>` - Remove a package and its dependencies

`sudo pacman -Syu` - Upgrade all packages

`pacman -Ql <PACKAGE>` - check which files and folders are owned by a package

`sudo pacman -Rns $(pacman -Qtdq)` - removing orphans

`comm -23 <(pacman -Qqett | sort) <(pacman -Qqg base-devel | sort | uniq)` - list all the explicit installed packages (besides base-devel group)

### AUR packages

Many packages are not available directly through pacman and should be installed semi-menualy from aur - Arch User Repository. It's best to search each package in the arch wiki or the official package site, to find the exact installaion process of this app.

The basic installation process is:

	git clone https://aur.archlinux.org/<PACKAGE_NAME>.git
	cd <PACKAGE_NAME>
	makepkg -si

Note: once the package is installed, it is recognized by pacman, and can be removed using "pacman -R"

### Snap packages
To use snap, after installation, one must first enable/start the service with `sudo systemctl start snapd.socket`
	
	snap install sublime pycharm-community android-studio spotify

**A note regarding the "--classic" flag**: most of the snap are using by default the "strict" confinement, meaning that they have a very limited access to the system and personal file, and they're basically running as independent units. However, some snaps requires access to the system files (for example pycharm has to use the python interpreter) so they require a "classic" confinement, meaning that they're basically like any normal installed package. To enable the installaion of such packages the user must first enable the access by creating the symlink: `ln -s /var/lib/snapd/snap /snap`, and then to give access permissions to a certain package by adding the `--classic` flag in the package installation. Read more about snap confinements [here](https://snapcraft.io/docs/snap-confinement)

### Adding hebrew support (on X-server)

Check this [Xorg/Keyboard_configuration](https://wiki.archlinux.org/index.php/Xorg/Keyboard_configuration) arch-wiki for detailed information. I just used one of the simplest option by adding an x-conf file under: `/etc/X11/xorg.conf.d/00-keyboard.conf` with this text:

	Section "InputClass"
                Identifier "system-keyboard"
                MatchIsKeyboard "on"
                Option "XkbLayout" "us,il"
                Option "XkbModel" "pc104"
                Option "XkbVariant" "qwerty"
                Option "XkbOptions" "grp:alt_shift_toggle"
	EndSection
In order for the changes to take effect the user need to restart the X-server by running: `sudo systemctl restart display-manager`


`TODO` - add ctrl+c, ctrl+v + clipboard manager, brightness control + redshift, HiDPI monitors, multiple monitors, power management, notifications, bash key-bindings (search history based on a prefix), yay (yarout)

### Sound support

`pacman -S alsa-utils pulseaudio pavucontrol`

alsa-utils should enable applications like `alsamixer` but this app didn't really help me with sound issues. `pulseaudio` is probably crucial for sound drivers, and `pavucontrol` is a gui helper for controling the output/input devices and the volume levels.

### Transparency

`sudo pacman -S xorg-server xdpyinfo xcompmgr`

The `xorg-server`is the basic X-server package, that is probably already installed in the system, and `xdpyinfo` and `xcompmgr` are the composite manager packages.

I'm using awesome WM which has some build-in opacity capabilities, so basically nothing is needed beside a composite manager (xcompmgr in this case) as explained in [this page](https://wiki.archlinux.org/index.php/Awesome#Transparency). However, check [this page](https://wiki.archlinux.org/index.php/Xterm#Automatic_transparency) for explanation on xterm-transparency and [this page](https://wiki.archlinux.org/index.php/Per-application_transparency) for explanation how to achieve per-window transparency (in short - for basic transparency you need the `transset-df` AUR package and the `devilspie` to achieve per-window transparency).

In awesome WM you first need to activate xcompmgr by running `xcompmgr &` and then you can set the transparency for focused and unfocused windows using the following syntax in the rc.lua file:

	client.connect_signal("focus", function(c)
                              c.border_color = beautiful.border_focus
                              c.opacity = 1
                           end)
	client.connect_signal("unfocus", function(c)
                                c.border_color = beautiful.border_normal
                                c.opacity = 0.7
                             end)

## Monitors - Xorg

### Usefull commands

* Mirroring: `xrandr --output HDMI3 --same-as LVDS1`
* check available monitors and their parameters (display-identifier, connection status, active and available resolutions, physical dimensions) - `xrandr`
* check resolusion info - `xdpyinfo | grep -B 2 resolution`
* restart x-server - `sudo systemctl restart display-manager`
* if some syntax error was made in the configuration files and the system failed to restart - load tty with `Alt+shift+F2` and run `startx`. It will tell you where the problem was, and then you can fix it with some text-editor.
* note: I tried `xrandr --dpi <NEW_DPI>` to dynamically change the monitor's DPI but it didn't do anything. It just changed the monitor's alleged dimensions, so that, with the current resolution it will give the desired DPI.

### Recommandation

A. **Multiple monitors- change resolution** - At the end of day, I wasn't convinced that any method is essentialy different than simply changing the resolution, so this is probably the most stright-forward solution. I also wasn't able to detect the performance degradation affected by such change, possible because my eyes are not sensative enough, but it also might be because the physical resolution doesn't really change, obviously, so images and videos that have a build-in resolution can utilize it. It's also a clean solution, since it's done automatically on reboot in you shouldn't run any additional commands later.

To change the relative position of the monitors- it's possible to change the `/etc/X11/xorg.conf.d/...` configurations as a static solution, or change it in an already active session with `xrandr -output <2nd monitor-identifier> --auto --right-of <1st monitor-identifier>`.

B. **Single monitor - add DisplaySize**- A better solution than resolution-change is to add the physical dimensions to the xorg config files under the monitor section like this: `DisplaySize <width> <height>` (I don't know why it's not the default behavior, probably a bug). However this only help in a single-monitor setup. In multi-monitors setup it sometimes takes only the second monitor's dimensions as the dimensions of the entire setup but adds the resolution, so the result doesn't make sense (also looks like a bug)...

### HiDPI monitors
Arch-wiki page: https://wiki.archlinux.org/index.php/HiDPI

HiDPI monitors are monitors with high resolution comparing to a their relative small dimensions, resolting in a high pixel density (high **D**ots **P**er **I**nch) and small pixel size. The main issue that arises here, is that many applications defined their display based on the amount of pixels, which means that the display will appear small and sometimes even unusable.

**Note**: I don't know if it matters, but for some reason, Xorg always sets DPI to 96 as described in [this bug report](https://bugs.freedesktop.org/show_bug.cgi?id=23705). I think it just "fixes" the physical dimensions to match this DPI.

As far as I understand, there is no difference between changing the DPI and changing the resolution, as they're both directly connected trough the physical dimensions of the monitor. 

#### Method 1 - system-wide scaling (per desktop environment)

Scaling the display seems be the most obvious solution, but apparently this is not so easy to achieve. According to arch-wiki such scaling is available in Desktop environments such as Cinnamon, KDE Plasme and Xfce (according to [this forum](https://www.reddit.com/r/linux/comments/cqtfxs/xfce4_the_day_is_finally_here_perfect_hidpi/)). Integer scaling is also available in Gnome via Tweak-Tool and to achieve fractional scaling you can set the scaling via xradr with something like: `xrandr --output <Display-identifier> --scale 1.25x1.25` (Note: this is for zoom out, so **the larger the xrandr scale - the smaller the display**)

#### Method 2 - per-app scaling

The arch-wiki page contains much information about how to get scaling in different applications such as Firefox, MATLAB and Spotify. But this is not a system-wide solution and it requires many configurations.

#### Nethod 3 - chnaging the screen resolution (Xorg)

Before login, Xorg reads the configuration files from `/etc/X11/xorg.conf.d/`. You can change the screen resolution there in the monitors section (see full manual page of Xorg.conf in [here](https://www.x.org/releases/current/doc/man/man5/xorg.conf.5.xhtml)). For example, here's a possible configuration for monitor eDP1 (you can check the monitor identifier by the `xrandr` command) with dimensions of 290x170 (mm^2) and resolution of 1920x1080:

	Section "Monitor"
	### Monitor Identity - Typically HDMI-0 or DisplayPort-0
    	    Identifier    "eDP1" 
	### Setting Resolution and Modes
	    Option "PreferredMode" "1920x1080"
	    DisplaySize 290 170
	EndSection

I found that, for some reason, just writing down the **native resolution and dimensions** already help to improve performance. It's very weird, since it should have done this automatically, but anyway, if the display size is still too small - you can change the resolution to any other of the possible screen resolution that appear on the list in the `xrandr` command.

#### Method 4 - xrandr scaling

The simple command `xrandr --output eDP1 --scale 1.25x1.25` should allow fractional scaling. As mentioned above, it's a **zoom-out** scaling, meaning that the larger the scaling value- the smaller the display.

The main issue with this approach is that the scaling doesn't work that well and the display is a bit ruined. The situation is even worse when using sometimes when it used for enlarging the display (i.e. with a scaling factor smaller than 1) the image gets blurry or not well fits to the monitor dimensions. Therefor it's recommanded to use this option only for downscaling (i.e. with scaling factor larger than 1)

### Multiple monitors
Arch wiki page: https://wiki.archlinux.org/index.php/Multihead

#### Method 1-3: Xorg

Xorg have 3 options for positioning the display of the different monitors: a. **relative** - where should each monitor be located w.r.t another monitot. b. **absolute** - start counting pixels from the top left corner (with no negative values allowed)- in what pixel exactly should each monitor be located. c. **virtual** - combining all the moitors to a single virtual monitors.

Example of **relative** coordinates:

	Section "Monitor"
	    Identifier  "VGA1"
	    Option      "Primary" "true"
	EndSection
	
	Section "Monitor"
	    Identifier  "HDMI1"
	    Option      "LeftOf" "VGA1"
	EndSection
	
Example with **absolute** coordinates:

	Section "Monitor"
	    Identifier  "VGA1"
	    Option      "PreferredMode" "1024x768"
	    Option      "Position" "1920 312"
	EndSection
	
	Section "Monitor"
	    Identifier  "HDMI1"
	    Option      "PreferredMode" "1920x1080"
	    Option      "Position" "0 0"
	EndSection

I didn't try **virtual** coordinates...

#### Metod 4 - xrandr

Exmples:
* native resolution and relative coordinates: `xrandr --output VGA1 --auto --output HDMI1 --auto --right-of VGA1` (the `--auto` is to use the native resolution)
* fixed resolution and absolute coordinates: `xrandr --output VGA1 --mode 1024x768 --pos 1920x0 --output HDMI1 --mode 1920x1080 --pos 0x0`

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

## Applications

**pacman packages**:

In the installation process:

	sudo pacman -S linux-lts linux-lts-headers linux-firmware dosfstools mtools dialog grub-btrfs efibootmgr base base-devel cronie network-manager-applet reflector os-prober xorg-server wireless_tools

Important packages:

	sudo pacman -S awesome lightdm lightdm-webkit2-greeter xterm firefox feh anki dmenu git meld htop gvim vlc readline

For sound support:

	pacman -S alsa-utils pulseaudio pavucontrol
	
Xorg tools:

	pacman -S xcompmgr xf86-video-intel xorg-xdpyinfo xorg-xinit (xorg-xrandr ?)

For clipit:

	sudo pacman -S xdotool intltool gtk3

**AUR packages**: `eclipse snapd clipit (timeshift ?)`

### Display manager

e.g. [lightdm](https://wiki.archlinux.org/index.php/LightDM) with webkit2 greeter: `sudo pacman -S lightdm ligthdm-webkit2-greeter xorg-server` (lightdm is based on X-server, and that's why xorg-server is necessary)

* change the greeter in `/etc/lightdm/lightdm.conf` under `[Seat:*]` ... `greeter-session=lightdm-webkit2-greeter`.
* activate the service using: `systemctl enable lightdm.service`

**Note**: if you don't change the greeter- the DM will try the default greeter, which is the gtk-greeter, and if it is not installed- the DM loading will fail.

### Terminal emulator

e.g. [xterm](https://wiki.archlinux.org/index.php/Xterm) : `sudo pacman -S xterm xorg-xrdb` (xrdb is needed for configurations)

usefull configurations:
* `XTerm.termName: xterm-256color` or `XTerm.termName: xterm`
* `XTerm.vt100.metaSendsEscape: true` (use Alt key as escape, like in other terminals)
* Fonts control: `XTerm.vt100.faceName: Liberation Mono:size=10:antialias=false` and `XTerm.vt100.font: 7x13` see the [arch wiki page](https://wiki.archlinux.org/index.php/Xterm)

### Apps launcher

"dmenu" is a good option for an app-launcher.
Installation: 
	
	pacman -S dmenu

run it with `dmenu_run`. It's usefull to create a shortcut for this, I used the `<mod> + d`.

### Vim

* Copy-paste between external applications and vim: it's recommanded to install `gvim` instead of `vim` (see [this tutorial](https://www.youtube.com/watch?v=E_rbfQqrm7g)). Then you can use the "+" register for copying and pasting like this: copy - `"+y`, paste- `"+p`

### Clipboard manager

See this [arch-wiki](https://wiki.archlinux.org/index.php/Clipboard) to understand the difference between Primary (auto selection) and Clipboard (explicit copy), and for clipboard-manager suggestsions.

For me, nothing worked beside [Clipit](https://github.com/CristianHenzel/ClipIt). Installaion is simply as an AUR package (make sure the "requirements" list is met) and than run clipit (probably should add this as a startup application).

**Note**: auto-pasting simply calls "ctrl+v" command, so in order for this to work on the terminal emulator- you have to change the key-binding of pasting to ctrl+v. For xterm you can add in the .Xresources file:

	! use ctrl-v to paste (important for clipit)
	XTerm.vt100.translations: #override \n\
	    Ctrl <Key>V: insert-selection(CLIPBOARD)


Settings:
1. I chose to use both primary and copy, synchronize clipboard and auto-paste options.
2. run clipboard manually once to check if all the key-board shortcuts are O.K and replace those that didn't work.

### image viewer

[feh](https://wiki.archlinux.org/index.php/Feh) (available via pacman)

### Timeshift
Available as an aur package.

I found that I had the need also to install `cronie` in order for the app to work. I don't know why it wasn't installed by default as a dependency. Than you should activate the service using `sudo systemctl enable cronie.service`.

Because I'm using BTRFS I also included the 'home' subvolume. Note that timeshift only support it if the subvolume was created on the toplevel (5) as @home subvolume (see the [github page](https://github.com/teejee2008/timeshift)).

Timeshift also recommanding the usage of the BTRFS's qgroups. but they need to be enabled first. see [this page](https://btrfs.wiki.kernel.org/index.php/Quota_support) for the full explanation. For me using `sudo btrfs quota enable /` just worked perfectly.

**IMPORTANT NOTE**: restoring a snapshot with timeshift on btrfs is basically just changing the subvolid in the /etc/fstab file to the id of the snapshot. because of that, in order for the restoration to work- the fstab should contain only the `subvolid` and not the actual subvolume name, or else there will be a conflict between the name and the id, and the restoration will fail!
