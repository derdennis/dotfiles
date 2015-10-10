#!/usr/bin/env bash

/usr/bin/rsync -rav --delete-after --out-format "%o  %n" /Users/dennis/Documents/archive/ mini:/Users/dennis/Documents/archive
