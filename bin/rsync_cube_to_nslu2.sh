#!/bin/sh

# Backupscript um die wichtigsten Sachen offsite zu sichern. 

#NSLU2IP="nslu2"
#NSLU2IP="myfamily.kicks-ass.org"

#At home Sync (dynamic, go watch the DHCP-Log...)
NSLU2IP="192.168.5.191"

echo "Backup auf die NSLU2 unter $NSLU2IP":

## Cube Backup:

# iPhoto Archives:
rsync -avz --delete "/Volumes/LocalTimeMachine/Backups.backupdb/Cube/Latest/MyBook/iPhoto Libraries" $NSLU2IP:"/opt/cube/"

# iTunes Backup:
rsync -avz --delete "/Volumes/MyBook/cube iTunes" $NSLU2IP:"/opt/cube/"


# Website Backup:
rsync -avz --delete "/Users/dennis/backup/rsnapshot/daily.0/" $NSLU2IP:"/opt/web/"

# Website Backup:
rsync -avz --delete "/Users/dennis/backup/gpg_certs_backup" $NSLU2IP:"/opt/gpg/"
