#!/bin/bash
# Source the environment
. ./environment.sh

# Raspberry Pi Information
#Distributor ID: Raspbian
#Description:    Raspbian GNU/Linux 9.4 (stretch)
#Release:        9.4
#Codename:       stretch
mapfile -t ARRAY < <(lsb_release --all -s)

# See if the Influx database exists
/usr/bin/curl --silent -i -XPOST http://telemetry.infra.corp.local:8086/query --data-urlencode "q=SHOW DATABASES"| grep -q digital_signage ; RC=$?
if [ $RC -ne 0 ]
then
# Create the database
  echo "Database not found!"
  echo "Creating Datbase: service_catalog"
  /usr/bin/curl --silent -i -XPOST http://telemetry.infra.corp.local:8086/query --data-urlencode "q=CREATE DATABASE digital_signage" >/dev/null
fi

#LOAD=$(/bin/cat /proc/loadavg)
#LOAD_1=$(echo "${LOAD}" | /usr/bin/awk '{ print $1 }') 
#LOAD_5=$(echo "${LOAD}" | /usr/bin/awk '{ print $2 }') 
#LOAD_15=$(echo "${LOAD}" | /usr/bin/awk '{ print $3 }')

TV_STATUS=$(echo pow 0 | /usr/bin/cec-client -s -d 1 | /usr/bin/tail -1 | /usr/bin/awk ' { print $3 } ')

# Influx Data Needs to be in this format
#<measurement>[,<tag-key>=<tag-value>...] <field-key>=<field-value>[,<field2-key>=<field2-value>...] [unix-nano-timestamp]

/usr/bin/curl -i -XPOST 'http://telemetry.infra.corp.local:8086/write?db=digital_signage&precision=s' --data-binary \
"device,host=${HOSTNAME},mac_address=${MAC},location=lg.godojo.south.pointwest.coppell.texas,type=Raspberry_Pi_Zero_W ip_address=\"${IP}\",Distributor_ID=\"${ARRAY[0]}\",Description=\"${ARRAY[1]}\",Release=\"${ARRAY[2]}\",Codename=\"${ARRAY[3]}\",TV_status=\"${TV_STATUS}\" "

#/usr/bin/curl -i -XPOST 'http://telemetry.infra.corp.local:8086/write?db=digital_signage&precision=s' --data-binary \
#"load,mac_address=${MAC},location=lg.godojo.south.pointwest.coppell.texas,type=Raspberry_Pi_Zero_W load_1_min=${LOAD_1},load_5_min=${LOAD_5},load_15_min=${LOAD_15}"

#Simulation
IP=$(echo $IP | sed 's/1/2/g')
MAC=$(echo $MAC | sed 's/a/b/g')
/usr/bin/curl -i -XPOST 'http://telemetry.infra.corp.local:8086/write?db=digital_signage&precision=s' --data-binary \
"device,host=512b27027dec,mac_address=${MAC},location=door.godojo.south.pointwest.coppell.texas,type=Raspberry_Pi_Zero_W ip_address=\"${IP}\",Distributor_ID=\"${ARRAY[0]}\",Description=\"${ARRAY[1]}\",Release=\"${ARRAY[2]}\",Codename=\"${ARRAY[3]}\" "

#LOAD_15=$LOAD_1
#/usr/bin/curl -i -XPOST 'http://telemetry.infra.corp.local:8086/write?db=digital_signage&precision=s' --data-binary \
#"load,mac_address=${MAC},location=door.godojo.south.pointwest.coppell.texas,type=Raspberry_Pi_Zero_W load_1_min=${LOAD_1},load_5_min=${LOAD_5},load_15_min=${LOAD_15}"
