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

`TODO` - brightness control + redshift, power management, notifications, bash key-bindings (search history based on a prefix)

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
