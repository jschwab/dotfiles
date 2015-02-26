#!/bin/sh

# if it exists, use .Xresources
if [ -s .Xresources ]; then
    xrdb -merge ~/.Xresources
fi

# switch to set
setxkbmap -option ctrl:swapcaps

# start xbindkeys
xbindkeys

# use gnome keyring without the rest of gnome desktop
# https://wiki.archlinux.org/index.php/GNOME_Keyring#Use_Without_GNOME

# Start a D-Bus session
source /etc/X11/xinit/xinitrc.d/30-dbus

# Start GNOME Keyring
/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh > $HOME/.keyring/Gnome
source $HOME/.keyring/Gnome

# You probably need to do this too:
export SSH_AUTH_SOCK
export GPG_AGENT_INFO
export GNOME_KEYRING_CONTROL
export GNOME_KEYRING_PID

touch $HOME/.dbus/Xdbus
chmod 600 $HOME/.dbus/Xdbus
env | grep DBUS_SESSION_BUS_ADDRESS > $HOME/.dbus/Xdbus
echo 'export DBUS_SESSION_BUS_ADDRESS' >> $HOME/.dbus/Xdbus

# fire up the screensaver
xscreensaver -no-splash &

# Set up an icon tray
 
trayer --edge top --align right --SetDockType true --SetPartialStrut true \
 --expand true --width 90 --widthtype pixel --height 22 --transparent true --alpha 0 --tint 0x000000 &

if [ -x /usr/bin/nm-applet ] ; then
   nm-applet --sm-disable &
fi

# start pulse audio
/usr/bin/start-pulseaudio-x11

# start aerofs
aerofs

# turn off bell
xset -b

# launch xmonad
exec xmonad
