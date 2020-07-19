# Arch
a new Arch WS initialization notes and files.

## installation
follow instructions from arch linux wiki.

some notes:

* _wifi_: in the installation process use iw and iwd (check this [arch-wiki-page](https://wiki.archlinux.org/index.php/Iwd)). afterwords you'll probably install networkManager in your machine, so use it instead. set wifi connection following these steps:

		nmcli r (verify that all are enabled, if wifi is off, turn it on using "nmcli r wifi on")
		nmcli d wifi rescan
		nmcli d wifi list
		nmcli d wifi connect <NETWORK> password <PASSWORD>.
* _timedatectl_: verify your system is using the UTC and not the local time zone using:

		timedatectl status (system clock should be syncronized).
	if not, use 

		timedatectl set-ntp true
`TODO` - add a keyboard layout.

`TODO` - add fonts.

`TODO` - add ctrl+c, ctrl+v + clipboard manager

### pacman basic usage
`pacman -Syyy` - Refresh sources

`pacman -S <PACKAGE>` - Install a package

`pacman -Rs <PACKAGE>` - Remove a package and its dependencies

`pacman -Syu` - Upgrade all packages

`pacman -Ql <PACKAGE>` - check which files and folders are owned by a package

`sudo pacman -Rns $(pacman -Qtdq)` - removing orphans

### Packages
pacman packages:

	sudo pacman -S vim htop meld anki git vlc base-devel

many packages are not available directly through pacman and should be installed semi-menualy from aur - Arch User Repository. It's best to search each package in the arch wiki or the official package site, to find the exact installaion process of this app.

`TODO` check about package helpers such as **yay**

The basic installation process is:

	git clone https://aur.archlinux.org/<PACKAGE_NAME>.git
	cd <PACKAGE_NAME>
	makepkg -si
some aur packages:
	
	eclipse snapd timeshift
Note: once the package is installed, it is recognized by pacman, and can be removed using "pacman -R"

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

### HiDPI monitors
to set the correct DPI for your monitors you just need to know its resolution and physical dimensions (in inchs). to check the native resolution typs:

	xdpyinfo | grep -B 2 resolution
and check the physical dimensions using:

	xrandr | grep -w connected
then you just need to devide the resolution by the dimensions to get the native DPI for your monitor.

change the DPI using the following command:

	xrandr --dpi <NEW_DPI>

Notes: you'll probably need to restrt gui for the changes to take effect.

### multiple monitors
check this [arch wiki page](https://wiki.archlinux.org/index.php/Multihead)

see available monitors using:

	xrandr -q
activate specific monitor using:

	xrandr --output <monitor name, e.g. HDMI1> --auto

## awesome wm

Basic key-bindings:

* `<mod> + s`  - shows the help menu for basic operations
* `<mod> + r`  - run prompt
* `<mod> + enter` - open terminal
* `<mod> + space` - change tiling form
* `<mod> + ctrl + r` - restart awesome
* `<mod> + shift + q` - logout
* `<mod> + shift + c` - close window
* `<mod> + arrow` - navigate between tags (workspace)
* `<mod> + k,j` - navigate between windows
* `<mod> + f,m` - enter/exit a. full screen mode. b. max mode respectively
* `<mod> + n/ <mod> + ctrl n` minimize/unminimize

To enable configuration, copy the configuration file from "/etc/xdg/awesome/rc.lua" to "~/.config/awesome/rc.lua"

### applications for windows manager

First we'll want to install an application launcher. "dmenu" is a good option.

	pacman -S dmenu
then run it with `dmenu_run`. It's usefull to create a shortcut for this, I used the `<mod> + d` keybinding by adding these lines in the rc.lua (under "Key bindings"):

	--My bindings
	awful.key({ modkey }, "d", function () awful.spawn("dmenu_run") end,
	          {description = "open dmenu", group = "my keybindings"})
This way the new keybinding will appear in the help menu under "my keybindings"

**image viewer** - [feh](https://wiki.archlinux.org/index.php/Feh) (available via pacman)

Add app viewer in awesome menu, enlarge fonts, change wallpaper, transparicy. Install notification manager, 

### Constumizations

Enable theme modifications by copying the `"/usr/share/awesome/themes/default"` to the `"~/.config/awesome/"` folder, and update the new path in config file (`"~/.config/awesome/rc.lua"`):
`beautiful.init(gears.filesystem.get_configuration_dir() .. "/themes/default/theme.lua")` becomes `beautiful.init(~/.config/awesome/themes/default/theme.lua)`

**Wallpaper**: to change the wallpaper, change the path of theme.wallpaper in theme.lua file.

### Snap packages
To use snap, after installation, one must first enable/start the service with `sudo systemctl start snapd.socket`
	snap install sublime pycharm-community android-studio spotify

**note** pycharm-community will require the `--classic` flag which means that it will have the same access rights as regular packages, instead of being constrained to the snap scope as regular snap packages

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
