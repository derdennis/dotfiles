#!/bin/sh
# ssh to port 22, use triple DES and start a SOCKS-Proxy on Port 1080
ssh -p 22 -c 3des -D 1080 dennis@linuxbox.homeunix.com \
# Tunnel the mailports from 1blu to localhost \
-L 10144/imap.1blu.de/143 -L 10026/smtp.1blu.de/25 \
# Tunnel the iTunes Port from Cube to localhost for remote library sharing \
-L 3689/127.0.0.1/3689 
# Tunnel the Cubes VNC Port to localhost \
-L 5901/127.0.0.1/5900
# Tunnel the Cube mailports to localhost \
-L 10993/127.0.0.1/993 -L 10027/127.0.0.1/25 \
# Tunnel VNC and the mobile EyeTV port from Mac mini to localhost \
-L 5903/192.168.5.3/5900 -L 2170/192.168.5.3/2170 \
# Tunnel the m0n0wall HTTPS Port to localhost \
-L 10443/192.168.5.1/443             
