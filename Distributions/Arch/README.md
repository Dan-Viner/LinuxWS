# Arch
a new Arch WS initialization notes and files.

## Installation
follow instructions from arch linux wiki.

a recommanded arch linux installation instruction videos:
* basic installations playlist: ["EF- Tech made simple" playlist](https://www.youtube.com/watch?v=sm_fuBeaOqE&list=PL-odKaUzOz3IT3FLQlXFaRVyNpWW1nj68&index=24). I enjoyed the one for [arch with BTRFS and snapper](https://www.youtube.com/watch?v=sm_fuBeaOqE&t=1175s) in particular.
* understanding the installation process: check [this playlist](https://www.youtube.com/watch?v=wZr9WTfFed0&list=PL2t9VWDusOo-0jF18YvEVhwpxTXlXPunG) by "Nice Micro", and specifically the one about [setting an internet connection](https://www.youtube.com/watch?v=IkI7nNxsh7I)

some notes:

* _wifi_: in the installation process use iw and iwd (check this [arch-wiki-page](https://wiki.archlinux.org/index.php/Iwd)). afterwords you'll probably install networkManager in your machine, so use it instead. set wifi connection following these steps:

		nmcli r (verify that all are enabled, if wifi is off, turn it on using "nmcli r wifi on")
		nmcli d wifi rescan
		nmcli d wifi list
		nmcli d wifi connect <NETWORK> password <PASSWORD>.
you can also use the `nmtui` command as an easy GUI alternative.
* _timedatectl_: verify your system is using the UTC and not the local time zone using:

		timedatectl status (system clock should be syncronized).
	if not, use 

		timedatectl set-ntp true
		
**Note:** I don't understand why some things are done only on the live media in the installlation process and not on the actual system (for example the whole `timedatectl set-ntp true`).

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
In order for the changes to take affect the user need to restart the X-server by running: `sudo systemctl restart display-manager`


`TODO` - add fonts.

`TODO` - add ctrl+c, ctrl+v + clipboard manager

### Pacman basic usage
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

### Multiple monitors
check this [arch wiki page](https://wiki.archlinux.org/index.php/Multihead)

see available monitors using:

	xrandr -q
activate specific monitor using:

	xrandr --output <monitor name, e.g. HDMI1> --auto

## Awesome wm

**awesome** is a windows manager, and not a full desktop environment, meaning that it doesn't come with many (or any) additional applications that making the user experience easier, such as panel, notifications, settings (to control sound, monitors, power management and everything else) etc.

The main reason (for me) to use a windows manger and not a desktop environment is for learning purposes. The fact that you don't have all this applications installed by default- ecourages self-invastigations.

This [youtube video](https://www.youtube.com/watch?v=Obzf9ppODJU&t=500s) explains the basic consepts of tiling window mangement, and makes a comprehensible comparison between the different choices. The key differences are:

* **The programming language**: different window managers are based on different language, so the configurations can be easier if you're already familiar with the language of the window manger you're using. awsome is based on the [Lua programming language](https://en.wikipedia.org/wiki/Lua_(programming_language)).
* **The minimalistic level**: some WM are more minimalistic than others, in terms of the additional applications that are installed by default alongside the actual window-manager. awsome is pretty minimalistic, but definately not the most minimalistic WM available.
* **The Tiling method**: the 2 basic types are manual and dynamic TWM. Manual TWM gives you a choice each time to split a window verticaly or horizontaly. Dynamic TWM, howere, comes with a predefined set of tiling method that will determine where the next window is going to be opened. awesom is a dynamic WM that comes with a set of 12 predefined tiling options (and a floating option as well).
* **The multiple-monitor handling method**: some WM shows the same workspces in all monitors, so if you're on WS 1 in monitor 1 as well as in monitor 2 - you'll see the same set of windows. However, other WMs, like awesome, have different set of WSs (or tags), so WS 1 in each monitor is actualy a different WS. There is usualy a key combination for trnsfaring a window between monitors, in such TWM.


Awesome comes with a pre-installed panel, but the user will have to manually install things like: app-launcher (e.g. dmenu), terminal-emulator (xterm is the default for awesome) and other applications.



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

### Applications for windows manager

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

**A note regarding the "--classic" flag**: most of the snap are using by default the "strict" confinement, meaning that they have a very limited access to the system and personal file, and they're basically running as independent units. However, some snaps requires access to the system files (for example pycharm has to use the python interpreter) so they require a "classic" confinement, meaning that they're basically like any normal installed package. To enable the installaion of such packages the user must first enable the access by creating the symlink: `ln -s /var/lib/snapd/snap /snap`, and then to give access permissions to a certain package by adding the `--classic` flag in the package installation. Read more about snap confinements [here](https://snapcraft.io/docs/snap-confinement)

### Timeshift
Available as an aur package.

I found that I had the need also to install `cronie` in order for the app to work. I don't know why it wasn't installed by default as a dependency.

Because I'm using BTRFS I also included the 'home' subvolume. Note that timeshift only support it if the subvolume was created on the toplevel (5) as @home subvolume (see the [github page](https://github.com/teejee2008/timeshift)).

Timeshift also recommanding the usage of the BTRFS's qgroups. but they need to be enabled first. see [this page](https://btrfs.wiki.kernel.org/index.php/Quota_support) for the full explanation. For me using `sudo btrfs quota enable /` just worked perfectly.

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
