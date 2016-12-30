#!/usr/bin/env bash
# Script to get called via launchd every 15 minutes to refresh my fever
# installation.

echo "Starting to refresh fever..."
#curl -L -s --user-agent 'Fever Refresh Cron' 'http://fever.instant-thinking.de/?refresh'
curl -L -s 'https://fever.instant-thinking.de/?refresh'
echo "Finished refreshing fever."
