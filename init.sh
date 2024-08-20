#!/bin/bash

if [ -n "${BOOT_SCRIPT}" ]; then
    bash -c "${BOOT_SCRIPT}"
fi

if [ -n "${X11_SCRIPT}" ]; then
    mkdir -p /root/.config/autostart
    echo "[Desktop Entry]
Encoding=UTF-8
Version=0.9.4
Type=Application
Name=xterm
Comment=
Exec=xterm ${X11_SCRIPT}
OnlyShowIn=XFCE;
RunHook=0
StartupNotify=false
Terminal=false
Hidden=false
" > /root/.config/autostart/webbian-startup.desktop
else
    rm -f /root/.config/autostart/webbian-startup.desktop
fi

if [ -n "$PASSWORD" ]; then
export USER=root
/usr/bin/expect <<EOF
spawn "/usr/bin/vncpasswd"
expect "Password:"
send "$PASSWORD\r"
expect "Verify:"
send "$PASSWORD\r"
expect "(y/n)?"
send "n\r"
expect eof
exit
EOF
fi

set -x

mkdir -p /run/dbus
dbus-daemon --system

touch ~/.Xauthority
touch ~/.Xresources

vncserver -localhost no :0 -geometry $GEOMETRY -depth 24

sleep 3
xauth generate :0 . trusted 
xauth add ${HOST}:0 . $(xxd -l 16 -p /dev/urandom)
xauth list 

./utils/novnc_proxy --vnc localhost:5900 --listen 4900