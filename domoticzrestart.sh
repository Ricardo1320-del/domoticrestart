#!/bin/bash
# Made by mAiden / Ricardo
# Last edit on: 02-02-2019

dt=$(date '+%d/%m/%Y %H:%M:%S')
CONFIG=/home/domoticz/domoticz_state_checker.txt
STATUS=`curl -s --connect-timeout 2 --max-time 5 "Accept: application/json" "http://XXX:XXX:XXX:XXX:XXX/json.htm?type=devices&rid=1" | grep "status"| awk -F: '{print $2}'|sed 's/,//'| sed 's/\"//g'`
if [ $STATUS ]; then
   echo "Domoticz online"
   echo "$STATUS"
   curl -s "Accept: application/json" "http://XXX:XXX:XXX:XXX:XXX/json.htm?type=command&param=udevice&idx=idx&nvalue=0&svalue=Domoticz%20Online"
else
   sleep 5
   STATUS2=`curl -s --connect-timeout 2 --max-time 5 "Accept: application/json" "http://XXX:XXX:XXX:XXX:XXX/json.htm?type=devices&rid=1" | grep "status"| awk -F: '{print $2}'|sed 's/,//'| sed 's/\"//g'`
   fi
   if [ $STATUS2 ]; then
      exit
   else
      sleep 5
      STATUS3=`curl -s --connect-timeout 2 --max-time 5 "Accept: application/json" "http://XXX:XXX:XXX:XXX:XXX/json.htm?type=devices&rid=1" | grep "status"| awk -F: '{print $2}'|sed 's/,//'| sed 's/\"//g'`
      if [ $STATUS3 ]; then
	  exit
      else
         NOW=$(date +"%Y-%m-%d_%H%M%S")
         cp /tmp/domoticz.txt /home/domoticz/domoticz-$NOW.txt
         echo "Domoticz offline"
         curl --silent -u """Pushbullet apikey"":" -d type="note" -d body="Domoticz was offline. Restarted Domoticz...." -d title="Restarted Domoticz." 'https://api.pushbullet.com/v2/pushes'
         sudo service domoticz.sh restart
         echo "$NOW, Domoticz was offline. Restarted Domoticz...." >> "$CONFIG"
		 sleep 10
		 curl -s "Accept: application/json" "http://XXX:XXX:XXX:XXX:XXX/json.htm?type=command&param=udevice&idx=idx&nvalue=0&svalue=Domoticz%20Restarted"
		 fi
         fi
fi

