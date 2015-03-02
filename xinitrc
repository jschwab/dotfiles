#!/bin/sh

# from /etc/skel/.xinitrc
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi


# if it exists, use .Xresources
if [ -s .Xresources ]; then
    xrdb -merge ~/.Xresources
fi

# switch to set
setxkbmap -option ctrl:swapcaps

# start xbindkeys
xbindkeys

# password and key management
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

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
