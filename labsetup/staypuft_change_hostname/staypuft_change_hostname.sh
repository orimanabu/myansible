#!/bin/bash  
# https://mojo.redhat.com/docs/DOC-1034108

if [ x"$#" != x"5" ]; then
	echo "$0 <filename> <domain> <foreman_user> <foreman_pass> <foreman_url>"
	exit 1
fi
INPUT=$1  
DOMAIN=$2  
foreman_username=$3  
foreman_password=$4  
foreman_url=$5  
  
#transforming the 00:AA:BB:CC:DD:EE:FF MAC to mac00aabbccddeeff  
cat ${INPUT}  | awk '{print tolower($0)}' |sed 's/://g' | sed 's/^/mac/' | sed 's/^\(.\{15\}\)/\1.'$DOMAIN'/' > tmp_${INPUT}
  
while IFS=, read dummy mac host ip; do    echo "I got: $mac $host $ip"; done < tmp_${INPUT}
#changing hostname and primary IP  
#while IFS=, read dummy mac host ip; do curl -k -s -u $foreman_username:$foreman_password -H "Accept: application/json" -H "Content-type: application/json" -X PUT -d '{"name": "'"$host"'", "ip":"'"$ip"'","overwrite": true}' https://$foreman_url/api/hosts/$mac/; done < tmp_${INPUT}
while IFS=, read dummy mac host ip; do curl -k -s -u $foreman_username:$foreman_password -H "Accept: application/json" -H "Content-type: application/json" -X PUT -d '{"name": "'"$host"'", "ip":"'"$ip"'","overwrite": true}' https://$foreman_url/api/hosts/mac${mac}.${DOMAIN}/; done < tmp_${INPUT}
  
#rm tmp_${INPUT}
