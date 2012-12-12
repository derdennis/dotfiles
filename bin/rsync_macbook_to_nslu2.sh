#!/bin/sh

#Internet Sync
#NSLU2IP="myfamily.kicks-ass.org"

#At family Sync
NSLU2IP="192.168.1.5"

#At home Sync (dynamic, go watch the DHCP-Log...)
NSLU2IP="192.168.5.191"


echo "Backup auf die NSLU2" unter $NSLU2IP

## MacBook Backup:

# Documents
rsync -avz --delete "/Users/dennis/Documents" $NSLU2IP:"/opt/macbook/"

# Code
rsync -avz --delete "/Users/dennis/Code" $NSLU2IP:"/opt/macbook/"

# Desktop
rsync -avz --delete "/Users/dennis/Desktop" $NSLU2IP:"/opt/macbook/"

# iPhoto Libraries
rsync -avz --delete "/Users/dennis/Pictures/iPhoto Libraries" $NSLU2IP:"/opt/macbook/"
