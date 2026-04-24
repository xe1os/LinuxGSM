#!/bin/bash

curl "https://raw.githubusercontent.com/GameServerManagers/LinuxGSM/${GITHUB_REF#refs/heads/}/lgsm/data/serverlist.csv" | grep -v '^[[:blank:]]*$' > serverlist.csv

echo -n "{" > "shortnamearray.json"
echo -n "\"include\":[" >> "shortnamearray.json"

while read -r line; do
	shortname=$(echo "$line" | awk -F, '{ print $1 }')
	export shortname
	servername=$(echo "$line" | awk -F, '{ print $2 }')
	export servername
	gamename=$(echo "$line" | awk -F, '{ print $3 }')
	export gamename
	distro=$(echo "$line" | awk -F, '{ print $4 }')
	export distro
	# Legacy servers that require Ubuntu 22.04 or older
	if [ "${shortname}" == "bfv" ]; then
		runner="ubuntu-22.04"
	else
		runner="ubuntu-latest"
	fi
	{
		echo -n "{";
		echo -n "\"shortname\":";
		echo -n "\"${shortname}\"";
		echo -n ",\"runner\":";
		echo -n "\"${runner}\"";
		echo -n "},";
	} >> "shortnamearray.json"
done < <(tail -n +2 serverlist.csv)
sed -i '$ s/.$//' "shortnamearray.json"
echo -n "]" >> "shortnamearray.json"
echo -n "}" >> "shortnamearray.json"
rm serverlist.csv
