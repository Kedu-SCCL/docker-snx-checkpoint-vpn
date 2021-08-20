#! /bin/bash
IFS=$'\n'
SNX_DOCKER_NAME="snx-vpn"
SNX_DOCKER_IP="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $SNX_DOCKER_NAME)"
for tbl in $(docker exec -it snx-vpn netstat -nr|grep tunsnx)
do
    #read dest gw mask flags mss windows irtt iface <<< $tbl
    IFS=' ' read -r -a array <<< "$tbl"
    echo "Route Added - Destination: ${array[0]} | Mask: ${array[2]}"
    route add -net ${array[0]} netmask ${array[2]} gw $SNX_DOCKER_IP
done
