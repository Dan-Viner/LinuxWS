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

### Pacman basic usage
`pacman -Syyy` - Refresh sources

`pacman -S <PACKAGE>` - Install a package

`pacman -Rs <PACKAGE>` - Remove a package and its dependencies

`pacman -Syu` - Upgrade all packages

`pacman -Ql <PACKAGE>` - check which files and folders are owned by a package

`sudo pacman -Rns $(pacman -Qtdq)` - removing orphans

### Aur packages

Many packages are not available directly through pacman and should be installed semi-menualy from aur - Arch User Repository. It's best to search each package in the arch wiki or the official package site, to find the exact installaion process of this app.

The basic installation process is:

	git clone https://aur.archlinux.org/<PACKAGE_NAME>.git
	cd <PACKAGE_NAME>
	makepkg -si

Note: once the package is installed, it is recognized by pacman, and can be removed using "pacman -R"

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

### HiDPI monitors
to set the correct DPI for your monitors you just need to know its resolution and physical dimensions (in inchs). to check the native resolution typs:

	xdpyinfo | grep -B 2 resolution
and check the physical dimensions using:

	xrandr | grep -w connected
then you just need to devide the resolution by the dimensions to get the native DPI for your monitor.

change the DPI using the following command:

	xrandr --dpi <NEW_DPI>

Notes: you'll probably need to restrt gui for the changes to take effect.

### Multiple monitors
check this [arch wiki page](https://wiki.archlinux.org/index.php/Multihead)

see available monitors using:

	xrandr -q
activate specific monitor using:

	xrandr --output <monitor name, e.g. HDMI1> --auto

## BTRFS

COW file-system.

There are several options for subvolume structurs as you can see [here](https://btrfs.wiki.kernel.org/index.php/SysadminGuide). I used the "flat" layout, with seperate subvolumes for @home and @ (root), as this structure is supported by timeshift (if you want to backup home folder as well).

Anyway, it's recommanded (for some reason) to not mount the top folder in which the subvolume were created, and instead mount the @ subvolume and mount the other subvolume under the mounting point of @ (for example @ can be mounted to /mnt and the @home can be mounted to /mnt/home).

**Note**: Initially I installed only the @ subvolume and then I tried to create a @home subvolume in the top level but I didn't mange to achieve that as anywhere I tried to create the subvolume- it is already inside the system. So if, for example I went for the root directory "/" and created a @home subvolume- then I basically also created the /@home path, and I couldn't choose it as a seperated subvolume and mount it to a different location.

### Checking free-space

On non-RAID system: The first command: `sudo btrfs fi show` shows the allocated space out of the total available space ("used" means "allocated" and not really used). The second command: `btrfs fi df /` shows the used space out of the allocated space (for full explanation check [this](https://btrfs.wiki.kernel.org/index.php/FAQ)).

To enable 'quota' on BTRFS type `btrfs quota enable <path>` and check the output of `btrfs qgroup show <path>` (see the [full article](https://btrfs.wiki.kernel.org/index.php/Quota_support))

## Applications

pacman packages:

	sudo pacman -S vim htop meld anki git vlc base-devel

some aur packages:
	
	eclipse snapd timeshift

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

### Snap packages
To use snap, after installation, one must first enable/start the service with `sudo systemctl start snapd.socket`
	
	snap install sublime pycharm-community android-studio spotify

**A note regarding the "--classic" flag**: most of the snap are using by default the "strict" confinement, meaning that they have a very limited access to the system and personal file, and they're basically running as independent units. However, some snaps requires access to the system files (for example pycharm has to use the python interpreter) so they require a "classic" confinement, meaning that they're basically like any normal installed package. To enable the installaion of such packages the user must first enable the access by creating the symlink: `ln -s /var/lib/snapd/snap /snap`, and then to give access permissions to a certain package by adding the `--classic` flag in the package installation. Read more about snap confinements [here](https://snapcraft.io/docs/snap-confinement)

### Timeshift
Available as an aur package.

I found that I had the need also to install `cronie` in order for the app to work. I don't know why it wasn't installed by default as a dependency. Than you should activate the service using `sudo systemctl enable cronie.service`.

Because I'm using BTRFS I also included the 'home' subvolume. Note that timeshift only support it if the subvolume was created on the toplevel (5) as @home subvolume (see the [github page](https://github.com/teejee2008/timeshift)).

Timeshift also recommanding the usage of the BTRFS's qgroups. but they need to be enabled first. see [this page](https://btrfs.wiki.kernel.org/index.php/Quota_support) for the full explanation. For me using `sudo btrfs quota enable /` just worked perfectly.

**IMPORTANT NOTE**: restoring a snapshot with timeshift on btrfs is basically just changing the subvolid in the /etc/fstab file to the id of the snapshot. because of that, in order for the restoration to work- the fstab should contain only the `subvolid` and not the actual subvolume name, or else there will be a conflict between the name and the id, and the restoration will fail!


### Gnome
	sudo dnf install gnome-tweak-tool dconf-editor

#### Gnome-extensions
	"topIcons plus" "dash to panel" "system monitor"
  
### Virtual machine
	sudo dnf install @Virtualization virt-manager -y


### Hebrew support
	sudo dnf install culmus-* alef-fonts* google-noto-sans-hebrew-fonts
when opening a file- you'll have to choose the right encoding.
#### Sublime
add "show_encoding": true to the user settings, and then the encoding will appear at the bottom of the window, click on it to switch to a different encoding.
RTL is not supported as far as I saw
#### Gedit (Gnome)
first add the encodings to gedit preferences through dconf-editor: /org/gnome/gedit/preferences/encodings/candidate-encodings/
I used this value: ['UTF-8', 'ISO-8859-15', 'UTF-16', 'ISO-8859-8', 'windows-1255'].
open file through the gedit app, and before the actual opening- change the encoding in the bottom (windows-1255 should work fine).
Partial RTL support

### Timeshift
How to work with timeshift: https://www.youtube.com/watch?v=OMiCcFy4oGM&t=447s
Note: according to this tutorial from 2019 timshift might not work so well on Fedora because SELinux is enabled. I tried it and it worked fine, so I don't know...
You can check SELinux's status with "sestatus". See some more explanation regarding SELinux in: https://howto.lintel.in/enable-disable-selinux-centos/


### multimedia codecs
	sudo dnf -y install gstreamer1-plugins-base gstreamer1-plugins-good gstreamer1-plugins-ugly gstreamer1-plugins-bad-free gstreamer1-plugins-bad-freeworld gstreamer1-plugins-bad-free-extras
	
### Dnf plugin
	sudo dnf install 'dnf-command(leaves)'
now "dnf leaves" will show all the packages that are not required by any other package
