#!/bin/sh

# Your computer's timezone offset 
OFFSET=`date "+%z" | cut -c 2-3` 

# All the following is in ZULU (GMT) time 
YEAR=`grep -m 1 "<date>" /private/var/db/.TimeMachine.Results.plist | cut -c 8-11` 
MONTH=`grep -m 1 "<date>" /private/var/db/.TimeMachine.Results.plist | cut -c 13-14` 
DAY=`grep -m 1 "<date>" /private/var/db/.TimeMachine.Results.plist | cut -c 16-17` 
ZULU_HOUR=`grep -m 1 "<date>" /private/var/db/.TimeMachine.Results.plist | cut -c 19-20` 
MINUTE=`grep -m 1 "<date>" /private/var/db/.TimeMachine.Results.plist | cut -c 22-23` 
SECOND=`grep -m 1 "<date>" /private/var/db/.TimeMachine.Results.plist | cut -c 25-26` 

# Corrects for your computer's timezone 
HOUR=`expr $ZULU_HOUR + $OFFSET` 

# If the TZ shift rolled you back a day you have to adjust the DAY 
# If the Day rolls to 0, I didn't bother with the roll back because of the huge issues 
# of which month you roll back on and what not. The proper solution would be to do proper 
# date math, but I haven't figured out how to do that in shell unless you're using the 
# current system time. But here, I'm using a generated time. 
if [ $HOUR -lt 0 ] ; then 
HOUR=`expr '24' + $HOUR` 
DAY=`expr $DAY - '1'` 
fi 

# Just for formatting. It adds the preceding zero to the number if it's a single digit. 
if [ $HOUR -lt 10 ] ; then 
HOUR=`echo 0$HOUR` 
fi 
#if [ $DAY -lt 10 ] ; then 
#	DAY=`echo 0$DAY` 
#fi 

echo Last Mini Backup finished at "$DAY.$MONTH.$YEAR $HOUR:$MINUTE"
