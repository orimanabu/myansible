#!/bin/bash  
# https://mojo.redhat.com/docs/DOC-1034108

function usage {
	echo "$0 -d domain -u foreman_user -p foreman_password -f foreman_host -h target_host -n network -a ipaddr"
	exit 1
}

while getopts "d:u:p:f:h:n:a:" o; do
        case ${o} in
	d)
		domain=${OPTARG}
		;;
	u)
		user=${OPTARG}
		;;
	p)
		password=${OPTARG}
		;;
	f)
		foreman=${OPTARG}
		;;
	h)
		host=${OPTARG}
		;;
	n)
		network=${OPTARG}
		;;
	a)
		ipaddr=${OPTARG}
		;;
        *)
                echo "unknown option: ${o}"
                usage
                ;;
        esac
done
shift $((OPTIND - 1))

if [ x"$#" != x"1" ]; then
        usage
fi
op=$1; shift

headers="-H Accept:application/json -H Content-type:application/json"
curl="curl -k -s -u ${user}:${password} ${headers}"

if [ x"$user" = x"" -o x"$password" = x"" -o x"$foreman" = x"" ]; then
	usage
	exit 1
fi

case ${op} in
hosts)
	${curl} -X GET http://${foreman}/api/v2/hosts/ | python -m json.tool
	;;

host-info)
	if [ x"$host" = x"" ]; then usage; fi
	${curl} -X GET http://${foreman}/api/v2/hosts/${host}.${domain} | python -m json.tool
	;;

subnets)
	${curl} -X GET http://${foreman}/api/v2/subnets | python -m json.tool
	;;

interfaces)
	if [ x"$host" = x"" ]; then usage; fi
	${curl} -X GET http://${foreman}/api/v2/hosts/${host}.${domain}/interfaces | python -m json.tool
	;;

interface-update)
	interface_id=$(${curl} -X GET https://${foreman}/api/v2/hosts/${host}.${domain}/interfaces | jq -r '.results[] | select(.subnet_name == "'${network}'") | .id')
	result=$(${curl} -X PUT -d '{"ip":"'"${ipaddr}"'"}' https://${foreman}/api/v2/hosts/${host}.${domain}/interfaces/${interface_id})
	if [ x"$?" = x"0" ]; then
		echo ${result} | python -m json.tool
	else
		echo ${result}
	fi
	;;

*)
	echo "unknown op: ${op}"
	usage
	;;
esac
