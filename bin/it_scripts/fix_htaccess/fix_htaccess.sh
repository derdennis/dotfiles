#!/bin/bash

file="/Users/dennis/Sites/new/.htaccess"

sed -i '' 's@\(^RewriteCond %{HTTP_HOST}.*\)@#\1@' $file
sed -i '' 's@\(^RewriteRule \^(\.\*)$ https://instant-thinking.de.*\)@#\1@' $file
sed -i '' 's@\(^# Get rid of www.*\)@#\1 The following two lines get uncommented every five minutes by a script on the mini@' $file

