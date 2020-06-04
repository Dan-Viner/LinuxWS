# Fedora
a new Fedora 30 WS initialization notes and files.

### starting up
	sudo dnf update -y

### RPM Fusion repositories
#### free repositories:
	sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

#### non-free repositories:
	sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

### Packages
	sudo dnf install vim htop meld anki git lyx eclipse snapd vlc timeshift thunderbird tlp
	
### Snap packages
	snap install sublime pycharm-community android-studio spotify
	
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
how to work with timeshift: https://www.youtube.com/watch?v=OMiCcFy4oGM&t=447s
Note: according to this tutorial from 2019 timshift might not work so well on Fedora because SELinux is enabled.
  you can check SELinux's status with "sestatus"
  see full article: https://howto.lintel.in/enable-disable-selinux-centos/


### multimedia codecs
	sudo dnf -y install gstreamer1-plugins-base gstreamer1-plugins-good gstreamer1-plugins-ugly gstreamer1-plugins-bad-free gstreamer1-plugins-bad-freeworld gstreamer1-plugins-bad-free-extras
	
### Dnf plugin
	sudo dnf install 'dnf-command(leaves)'
now "dnf leaves" will show all the packages that are not required by any other package
