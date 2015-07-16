#!/bin/bash  
# https://mojo.redhat.com/docs/DOC-1034108

#if [ x"$#" != x"5" ]; then
#	echo "$0 <filename> <domain> <foreman_user> <foreman_pass> <foreman_url>"
#	exit 1
#fi
#INPUT=$1  
#DOMAIN=$2  
#foreman_username=$3  
#foreman_password=$4  
#foreman_url=$5  
#  
##transforming the 00:AA:BB:CC:DD:EE:FF MAC to mac00aabbccddeeff  
#cat ${INPUT}  | awk '{print tolower($0)}' |sed 's/://g' | sed 's/^/mac/' | sed 's/^\(.\{15\}\)/\1.'$DOMAIN'/' > tmp_${INPUT}
#  
#while IFS=, read mac host ip; do    echo "I got: $mac $host $ip"; done < tmp_${INPUT}
##changing hostname and primary IP  
#while IFS=, read mac host ip; do curl -k -s -u $foreman_username:$foreman_password -H "Accept: application/json" -H "Content-type: application/json" -X PUT -d '{"name": "'"$host"'", "ip":"'"$ip"'","overwrite": true}' https://${foreman_url}/api/hosts/$mac/; done < tmp_${INPUT}
#  
##rm tmp_${INPUT}

foreman_username=admin
foreman_password=password
foreman_url=10.0.9.8

curl="curl -k -s -u $foreman_username:$foreman_password -H 'Accept: application/json' -H 'Content-type: application/json'"

#curl -k -s -u $foreman_username:$foreman_password -H "Accept: application/json" -H "Content-type: application/json" -X GET https://${foreman_url}/api/hosts/ | jq '.[] | .host | {name:.name, id:.id}'
#curl -k -s -u $foreman_username:$foreman_password -H "Accept: application/json" -H "Content-type: application/json" -X GET https://${foreman_url}/api/hosts/ | jq '.[] | .host | .id'

#${curl} -X GET https://${foreman_url}/api/hosts/ | jq '.[] | .host | .id' | while read host_id; do
#	echo "=> ${host_id}"
#	${curl} -X GET https://${foreman_url}/api/hosts/${host_id}/interfaces | python -m json.tool
#done

#${curl} -X GET https://${foreman_url}/api/hosts/ | python -m json.tool
#${curl} -X GET https://${foreman_url}/api/hosts/controller-1.osp6test.local/ | python -m json.tool
#${curl} -X GET https://${foreman_url}/api/hosts/controller-1.osp6test.local/interfaces/ | python -m json.tool
#${curl} -X GET https://${foreman_url}/api/subnets/ | python -m json.tool

ip=10.0.2.99
host=mac525400ef1446.osp6test.local
newhost=xxx
#${curl} -X PUT -d '{"name": "'"${newhost}"'", "interface_attributes": {"3": {"ip": "'"${ip}"'"}}, "overwrite": true}' https://${foreman_url}/api/hosts/${host}/ | python -m json.tool
#${curl} -X PUT -d '{"host": {"name": "'"${newhost}"'", "interfaces_attributes": {"3": {"ip": "'"${ip}"'"}}, "overwrite": true}}' https://${foreman_url}/api/hosts/${host}/ | python -m json.tool
echo '{"host": {"name": "'"${newhost}"'", "ip": "'"${ip}"'", "interfaces_attributes": {"3": {"ip": "'"${ip}"'"}}, "overwrite": true}}' | python -m json.tool
