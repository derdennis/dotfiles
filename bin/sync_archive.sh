#!/usr/bin/env bash

date > /var/log/archive_rsync.log
/usr/bin/rsync -rav --delete-after --out-format "%o  %n" /Users/dennis/Documents/archive/ mini:/Users/dennis/Documents/archive >> /var/log/archive_rsync.log

#/usr/bin/osascript -e 'display notification "Synced the archive to the mini." with title "Archive Sync"'
