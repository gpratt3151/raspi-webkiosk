#! /bin/bash
set -x

# mqttmyip.sh
# Posts the IP address of an interface to an MQTT queue
#
# Use: mqttmyip [interfacename]
# Author: Simen Sommerfeldt, based on work by San Bergmans (www.sbprojects.net)

# Configuration variables
RPINAME="GoDojo"

#MQTT broker. If this isn´t up check https://github.com/mqtt/mqtt.github.io/wiki/public_brokers
MQTTHOST="telemetry.infra.corp.local"

# Change this to become something unique, so that you get your own topic path
MQTTPREFIX="digital-signs"

# Get interface name from parameters
if [ $# -eq 0 ]
then
 IFC="wlan0"
else
 IFC="$1"
fi

ifconfig $IFC &> /dev/null
if [ $? -ne 0 ]
then
 exit 1
fi

# Get current private IP address for the selected interface
#PRIVATE=$(ifconfig $IFC | grep "inet addr:" | awk '{ print $2 }')
#PRIVATE=${PRIVATE:5}
IP=$(ifconfig wlan0 | grep "inet " | awk '{ print $2 }')
MAC=$(ifconfig wlan0 | grep "ether " | awk '{ print $2 }')
# Exit if IP address is empty
#if [ -z $IP ]
#then
# exit 0
#fi

/usr/bin/mosquitto_pub -h $MQTTHOST -t "$MQTTPREFIX/$RPINAME/$IFC/ip" -m "$IP"
/usr/bin/mosquitto_pub -h $MQTTHOST -t "$MQTTPREFIX/$RPINAME/$IFC/mac" -m "$MAC"
