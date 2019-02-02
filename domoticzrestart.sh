# Domoticz automate restart script
# Made by: mAiden / Ricardo
# Last edit on: 02-02-2019

#!/bin/bash
dt=$(date '+%d/%m/%Y %H:%M:%S')
CONFIG=/home/domoticz/domoticz_state_checker.txt
STATUS=`curl -s --connect-timeout 2 --max-time 5 "Accept: application/json" "http://192.168.0.177:8080/json.htm?type=devices&rid=1" | grep "status"| awk -F: '{print $2}'|sed 's/,//'| sed 's/\"//g'`
if [ $STATUS ] ; then
   echo "Domoticz online"
   echo "$STATUS"
   exit
else
   sleep 5
   STATUS2=`curl -s --connect-timeout 2 --max-time 5 "Accept: application/json" "http://192.168.0.177:8080/json.htm?type=devices&rid=1" | grep "status"| awk -F: '{print $2}'|sed 's/,//'| sed 's/\"//g'`
   if [ $STATUS2] ; then
      exit
   else
      sleep 5
      STATUS3=`curl -s --connect-timeout 2 --max-time 5 "Accept: application/json" "http://192.168.0.177:8080/json.htm?type=devices&rid=1" | grep "status"| awk -F: '{print $2}'|sed 's/,//'| sed 's/\"//g'`
      if [ $STATUS3 ] ; then
         exit
      else
         NOW=$(date +"%Y-%m-%d_%H%M%S")
         cp /var/log/domoticz.log /home/domoticz/domoticz-$NOW.txt
         echo "Domoticz offline"
         #You can send a Pushover message here
         sudo service domoticz.sh restart
         echo "$NOW, Domoticz was offline. Restarted Domoticz...." >> "$CONFIG"
      fi
   fi
fi
