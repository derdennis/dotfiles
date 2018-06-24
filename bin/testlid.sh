#!/usr/bin/env bash

clamshellmode=$(ioreg -r -k AppleClamshellState -d 4 | grep AppleClamshellState  | tr -d ' ' |cut -d "=" -f 2)

echo $clamshellmode

if [[ $clamshellmode == 'Yes' ]]; then
    echo "We are in Clamshellmode. Can't take your picture!"
else
    echo "We are not in Clamshellmode. Say 'Cheese'!"
fi
