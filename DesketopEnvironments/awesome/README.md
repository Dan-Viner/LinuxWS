## Awesome wm

### Overview

**awesome** is a windows manager, actually, not a full desktop environment, meaning that it doesn't come with many (or any) additional applications that making the user experience easier, such as panel, notifications, settings (to control sound, monitors, power management and everything else) etc.

The main reason (for me) to use a windows manger and not a desktop environment is for learning purposes. The fact that you don't have all this applications installed by default- ecourages self-invastigations.

This [youtube video](https://www.youtube.com/watch?v=Obzf9ppODJU&t=500s) explains the basic consepts of tiling window mangement, and makes a comprehensible comparison between the different choices. The key differences are:

* **The programming language**: different window managers are based on different language, so the configurations can be easier if you're already familiar with the language of the window manger you're using. awsome is based on the [Lua programming language](https://en.wikipedia.org/wiki/Lua_(programming_language)).
* **The minimalistic level**: some WM are more minimalistic than others, in terms of the additional applications that are installed by default alongside the actual window-manager. awsome is pretty minimalistic, but definately not the most minimalistic WM available.
* **The Tiling method**: the 2 basic types are manual and dynamic TWM. Manual TWM gives you a choice each time to split a window verticaly or horizontaly. Dynamic TWM, howere, comes with a predefined set of tiling method that will determine where the next window is going to be opened. awesom is a dynamic WM that comes with a set of 12 predefined tiling options (and a floating option as well).
* **The multiple-monitor handling method**: some WM shows the same workspces in all monitors, so if you're on WS 1 in monitor 1 as well as in monitor 2 - you'll see the same set of windows. However, other WMs, like awesome, have different set of WSs (or tags), so WS 1 in each monitor is actualy a different WS. There is usualy a key combination for trnsfaring a window between monitors, in such TWM.

Awesome comes with a pre-installed panel, but the user will have to manually install things like: app-launcher (e.g. dmenu), terminal-emulator (xterm is the default for awesome) and other applications.

### Basic key-bindings

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

### Constumizations

Enable theme modifications by copying the `"/usr/share/awesome/themes/default"` to the `"~/.config/awesome/"` folder, and update the new path in config file (`"~/.config/awesome/rc.lua"`):
`beautiful.init(gears.filesystem.get_configuration_dir() .. "/themes/default/theme.lua")` becomes `beautiful.init(~/.config/awesome/themes/default/theme.lua)`

#### Wallpaper
To change the wallpaper, change the path of theme.wallpaper in theme.lua file.

#### key-bindings
To add a user-defined key-binding you need to add an awful.key in the key binding, and specify the key combination and the function to run. Here's an exmple for running `dmenu` using Mod+d:

	--My bindings
	awful.key({ modkey }, "d", function () awful.spawn("dmenu_run") end,
	          {description = "open dmenu", group = "my keybindings"})
The additional description + group options are to set an awesome help-menu entry.

### floating apps
To set some apps to always be open in a floating mode - you need to set the appropriate rule in the rc.lua file. Usually there are already some applications that are set by default with this option, so you can just search for "floating clients" and add the apps to the "instance" list. The basic form of the rule is:

	{ rule = { name = "MPlayer" },
  	properties = { floating = true } }

#### opacity
In order to enable opacity, you first need to install a composire manager. For example `sudo pacman -S xorg-server xdpyinfo xcompmgr` (see https://wiki.archlinux.org/index.php/Xcompmgr). Awesome comes with builed-in opacity capabilities, so not much else is needed. So, install `xcompmgr` and activate it by running `xcompmgr &`. You'll also need to update the rc.lua file with the desired opacity rules. These are my settings:

	client.connect_signal("focus", function(c)
                              c.border_color = beautiful.border_focus
			      if c.class and c.class:lower():find("firefox") then
			      		c.opacity = 0.9
			      elseif if c.class and c.class:lower():find("feh") then
			      		c.opacity = 1
			      else
                              		c.opacity = 0.8
			      end
                           end)
	client.connect_signal("unfocus", function(c)
                                c.border_color = beautiful.border_normal
                                c.opacity = 0.7
                             end)

For extended capabilities I also used [this github page](https://github.com/blueyed/awesome-opacity). The init file (which is also available in this repository) contain all the necessary opacity controls. Then I added these key-bindings for dynamic control over the opacity in the current window using "Mod,Shift,+/-":

	-- my client-specific key-bindings
	awful.key({ modkey, "Shift"}, "-", function(c) opacity.adjust(c, -0.05) end),
	awful.key({ modkey, "Shift"}, "=", function(c) opacity.adjust(c, 0.05) end),
	
#### startup applications
Start applications using `awful.util.spawn()` in the rc.lua file. An example from my configurations:

	do
	  local cmds =
	  {
	    "xcompmgr"
	    "firefox",
	    "xterm",
	    "pycharm-community"
	  }
	
	  for _,i in pairs(cmds) do
	    awful.util.spawn(i)
	  end
	end
Note that "xcompmgr" is required in order for the opacity to work on start-up without the need to call `xcompmgr &` manually each time.
