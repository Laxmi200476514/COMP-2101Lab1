#!/bin/bash

#This command is used to dispaly the Hostname
echo "Host Name of your System is: "$HOSTNAME

#This command is used to diplay the DNS Domain name if available if there's none then it will give a blank output
echo "DNS Domain name of your system is: "$dnsdomainname

#This command shows the running OS name with its version
echo "Operating System Name and it's Version:"
cat /etc/os-release | grep PRETTY_NAME

#This command shows all the IP adresses present in the system
echo "IP Adresses: "
hostname -I

#This command is used to get the Disk status
echo "Filesytem Status:"
df -ht ext4