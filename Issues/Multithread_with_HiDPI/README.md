## Monitors - Xorg

### Usefull commands

* Mirroring: `xrandr --output HDMI3 --same-as LVDS1`
* check available monitors and their parameters (display-identifier, connection status, active and available resolutions, physical dimensions) - `xrandr`
* check resolusion info - `xdpyinfo | grep -B 2 resolution`
* restart x-server - `sudo systemctl restart display-manager`
* if some syntax error was made in the configuration files and the system failed to restart - load tty with `Alt+shift+F2` and run `startx`. It will tell you where the problem was, and then you can fix it with some text-editor.
* note: I tried `xrandr --dpi <NEW_DPI>` to dynamically change the monitor's DPI but it didn't do anything. It just changed the monitor's alleged dimensions, so that, with the current resolution it will give the desired DPI.

### Conclusions

HiDPI does not work well with linux, it seems that most people uses monitors with the same size, so it's a bit better this way... These are the best solution that I came up with for my setup of 2 monitors with different sizes:

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
