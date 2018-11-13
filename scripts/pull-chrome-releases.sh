#!/usr/bin/env bash

declare -A channels
channels[stable]="Stable"
channels[beta]="Beta"
channels[dev]="Dev"
channels[canary]="Canary"

echo "{" > src/data/releases.json
echo "	\"chrome\": {" >> src/data/releases.json

i=1

# Pull the latest release of Google Chrome for each channel
for channel in "${!channels[@]}"; do

	ver=$( curl "https://chromiumdash.appspot.com/fetch_releases?channel=${channels[$channel]}&platform=Mac&num=1" -H "accept-language: en-US,en" -H "user-agent: ChromeDevs Checker" -H "accept: application/json" -H "authority: chromiumdash.appspot.com" | jq ".[0].version" )

	if (( $i < ${#channels[@]} ));then
		theresMore=","
	else
		theresMore=""
	fi
	
	echo "		\"$channel\": $ver$theresMore" >> src/data/releases.json

	((i+=1))
done

echo "	}" >> src/data/releases.json

echo "}" >> src/data/releases.json
