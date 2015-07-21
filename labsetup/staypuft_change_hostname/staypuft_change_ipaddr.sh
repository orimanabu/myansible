#!/bin/bash  
# https://mojo.redhat.com/docs/DOC-1034108

if [ x"$#" != x"6" ]; then
	echo "$0 <filename> <DOMAIN> <foreman_user> <foreman_pass> <foreman_url> <network>"
	exit 1
fi
INPUT=$1  
DOMAIN=$2  
foreman_username=$3  
foreman_password=$4  
foreman_url=$5  
network=$6
  
#transforming the 00:AA:BB:CC:DD:EE:FF MAC to mac00aabbccddeeff  
cat ${INPUT}  | awk '{print tolower($0)}' |sed 's/://g' | sed 's/^/mac/' | sed 's/^\(.\{15\}\)/\1.'$DOMAIN'/' > tmp_${INPUT}
  
while IFS=, read dummy mac host ip; do    echo "I got: $mac $host $ip"; done < tmp_${INPUT}
#changing hostname and primary IP  
#while IFS=, read dummy mac host ip; do curl -k -s -u $foreman_username:$foreman_password -H "Accept: application/json" -H "Content-type: application/json" -X PUT -d '{"name": "'"$host"'", "ip":"'"$ip"'","overwrite": true}' https://$foreman_url/api/hosts/$mac/; done < tmp_${INPUT}
while IFS=, read dummy mac host ip; do
	#echo curl -k -s -u $foreman_username:$foreman_password -H "Accept: application/json" -H "Content-type: application/json" -X GET https://${foreman_url}/api/v2/hosts/${host}.${DOMAIN}/interfaces
	#curl -k -s -u $foreman_username:$foreman_password -H "Accept: application/json" -H "Content-type: application/json" -X GET https://${foreman_url}/api/v2/hosts/${host}.${DOMAIN}/interfaces | python -m json.tool
	#curl -k -s -u $foreman_username:$foreman_password -H "Accept: application/json" -H "Content-type: application/json" -X GET https://${foreman_url}/api/v2/hosts/${host}.${DOMAIN}/interfaces | jq -r '.results[] | select(.subnet_name == "'${network}'") | .id'
	interface_id=$(curl -k -s -u $foreman_username:$foreman_password -H "Accept: application/json" -H "Content-type: application/json" -X GET https://${foreman_url}/api/v2/hosts/${host}.${DOMAIN}/interfaces | jq -r '.results[] | select(.subnet_name == "'${network}'") | .id')
	echo "interface_id: ${interface_id}"
	
	curl -k -s -u $foreman_username:$foreman_password -H "Accept: application/json" -H "Content-type: application/json" -X PUT -d '{"ip":"'"$ip"'"}' https://$foreman_url/api/v2/hosts/${host}.${DOMAIN}/interfaces/${interface_id}
done < tmp_${INPUT}
  
#rm tmp_${INPUT}
