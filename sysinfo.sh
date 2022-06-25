#!/bin/bash

#This command is used to dispaly the Hostname
echo "Report for "$HOSTNAME
echo "=========================="

#This command is used to display FQDN of host machine 
hn=$(hostname --fqdn)
echo "FQDN: "$hn

#This command shows the running OS name with its version
os=$(head -n5 /etc/os-release | grep PRETTY_NAME | cut -f 2 -d '"')
echo "Operating System name and version: "$os

#This command shows all the IP adresses present in the system
hostIp=$(hostname -I)
echo "IP Adresses: "$hostIp

#This command is used to get the Free Disk Space
fs=$(df -ht ext4 | grep /dev/sda3 | cut -f 13 -d ' ')
echo "Root Filesystem Free Space: "$fs

echo "=========================="

