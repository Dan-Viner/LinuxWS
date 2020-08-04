Some applications notes from 03.08.2020 with arch-linux

## Applications

**pacman packages**:

In the installation process:

	sudo pacman -S linux-lts linux-lts-headers linux-firmware dosfstools mtools dialog grub-btrfs efibootmgr base base-devel cronie network-manager-applet reflector os-prober xorg-server wireless_tools

Important packages:

	sudo pacman -S awesome lightdm lightdm-webkit2-greeter xterm firefox xreader feh anki dmenu git meld htop gvim vlc readline

For sound support:

	pacman -S alsa-utils pulseaudio pavucontrol
	
Xorg tools:

	pacman -S xcompmgr xf86-video-intel xorg-xdpyinfo xorg-xinit (xorg-xrandr ?)

For clipit:

	sudo pacman -S xdotool intltool gtk3
	
For Lyx:

	sudo pacman -S texlive-most texlive-lang biber lyx

**AUR packages**: `eclipse snapd clipit culmus (timeshift ?)`

### Display manager

e.g. [lightdm](https://wiki.archlinux.org/index.php/LightDM) with webkit2 greeter: `sudo pacman -S lightdm ligthdm-webkit2-greeter xorg-server` (lightdm is based on X-server, and that's why xorg-server is necessary)

* change the greeter in `/etc/lightdm/lightdm.conf` under `[Seat:*]` ... `greeter-session=lightdm-webkit2-greeter`.
* activate the service using: `systemctl enable lightdm.service`

**Note**: if you don't change the greeter- the DM will try the default greeter, which is the gtk-greeter, and if it is not installed- the DM loading will fail.

### Terminal emulator

I chose [xterm](https://wiki.archlinux.org/index.php/Xterm)

Installation: `sudo pacman -S xterm xorg-xrdb readline` (xrdb is needed for Xresources configurations and readline is needed for inputrc configurations)

Usefull configurations - .Xresources:
* `XTerm.termName: xterm-256color` or `XTerm.termName: xterm`
* `XTerm.vt100.metaSendsEscape: true` (use Alt key as escape, like in other terminals)
* Fonts control: `XTerm.vt100.faceName: Liberation Mono:size=10:antialias=false` and `XTerm.vt100.font: 7x13`

See this [man page](https://jlk.fjfi.cvut.cz/arch/manpages/man/xterm.1) for full list of control options from .Xresources: 


**inputrc**: 

To enable `.inputrc` operations and key-bindings install `readline` ([arch wiki](https://wiki.archlinux.org/index.php/Readline)). Then:
* Check the available options for readline in the [linux man page](https://linux.die.net/man/3/readline) or in the [GNU Readline Library](https://tiswww.case.edu/php/chet/readline/readline.html)
* Finally, check See the Xterm control sequences [here](https://www.x.org/docs/xterm/ctlseqs.pdf) (the escape sequence is `"\e"`)

I used the arrowes for a prefix oriented history-search by adding these lines in the .inputrc file:

	"\e[A": history-search-backward
	"\e[B": history-search-forward


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
1. I chose to use both primary and copy, and I also marked the auto-paste option. However, I left the "synchronize clipboard" option unmarked to distinguish explicit copy for primary selection.
2. run clipboard manually once to check if all the key-board shortcuts are O.K and replace those that didn't work.

### image viewer

[feh](https://wiki.archlinux.org/index.php/Feh) (available via pacman)

### Timeshift
Available as an aur package.

I found that I had the need also to install `cronie` in order for the app to work. I don't know why it wasn't installed by default as a dependency. Than you should activate the service using `sudo systemctl enable cronie.service`.

Because I'm using BTRFS I also included the 'home' subvolume. Note that timeshift only support it if the subvolume was created on the toplevel (5) as @home subvolume (see the [github page](https://github.com/teejee2008/timeshift)).

Timeshift also recommanding the usage of the BTRFS's qgroups. but they need to be enabled first. see [this page](https://btrfs.wiki.kernel.org/index.php/Quota_support) for the full explanation. For me using `sudo btrfs quota enable /` just worked perfectly.

**IMPORTANT NOTE**: restoring a snapshot with timeshift on btrfs is basically just changing the subvolid in the /etc/fstab file to the id of the snapshot. because of that, in order for the restoration to work- the fstab should contain only the `subvolid` and not the actual subvolume name, or else there will be a conflict between the name and the id, and the restoration will fail!


### Lyx

See [the instruction for hebrew support](https://math-wiki.com/index.php?title=%D7%94%D7%95%D7%A8%D7%90%D7%95%D7%AA_%D7%9C%D7%94%D7%AA%D7%A7%D7%A0%D7%AA_LyX) and this [arch-wiki](https://wiki.archlinux.org/index.php/TeX_Live) page.

Installation:

	sudo pacman -S texlive-most texlive-lang biber lyx
	
For hebrew support install also the `culmus` package (available as an AUR package)

**Note**: some applications were not available via my mirror so I had to update the mirror list with additional mirrors, and then all the packages were found
