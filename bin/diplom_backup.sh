#!/bin/sh

# Sync to Dropbox
rsync -avz --delete ~/Documents/FOM/Diplomarbeit/ ~/Dropbox/Diplomarbeit_Backup/

# Sync to isnemail
rsync -avz --delete ~/Documents/FOM/Diplomarbeit/ root@isnemail01.essen.de:/root/backup/Dennis_Diplomarbeit_Backup/
