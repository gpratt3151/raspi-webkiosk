#!/bin/bash
#<measurement>[,<tag-key>=<tag-value>...] <field-key>=<field-value>[,<field2-key>=<field2-value>...] [unix-nano-timestamp]

#Distributor ID: Raspbian
#Description:    Raspbian GNU/Linux 9.4 (stretch)
#Release:        9.4
#Codename:       stretch
mapfile -t ARRAY < <(lsb_release --all -s)

IP=$(ifconfig wlan0 | grep "inet " | awk '{ print $2 }')
MAC=$(ifconfig wlan0 | grep "ether " | awk '{ print $2 }')
LOAD=$(uptime)
LOAD_1=$(echo "${LOAD}" | awk '{ print $10}' | sed 's/,//g')
LOAD_5=$(echo "${LOAD}" | uptime | awk '{ print $11}' | sed 's/,//g')
LOAD_15=$(echo "${LOAD}" | uptime | awk '{ print $12}' | sed 's/,//g')
curl -i -XPOST 'http://telemetry:8086/write?db=digital_signage&precision=s' --data-binary \
"signs,hostname=screen0,location=texas,type=Raspberry_Pi_Zero_W mac_address=\"${MAC}\",ip_address=\"${IP}\",load_1_min=${LOAD_1},load_5_min=${LOAD_5},load_15_min=${LOAD_15},Distributor_ID=\"${ARRAY[0]}\",Description=\"${ARRAY[1]}\",Release=\"${ARRAY[2]}\",Codename=\"${ARRAY[3]}\"
"
