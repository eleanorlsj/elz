#!/bin/bash

# Install relevant applications on the local computer

APPS="curl whois sshpass openssh-server geoip-bin"

sudo apt-get update -y
sudo apt-get install -y $APPS

# Check if connection is from your origin country. If no, continue (tools: curl, who is)

sudo curl -s ifconfig.me > ip.txt
ip=$(cat ip.txt)
cat ip.txt | xargs -L1 geoiplookup | cut -d " " -f5 > loc.txt
loc=$(cat loc.txt)

if [ "$loc" = 'Singapore' ];
then
	echo "You are not anonymous"
	git clone https://github.com/htrgouvea/nipe 
	sudo cpan install Try::Tiny Config::Simple JSON
	cd nipe	
	sudo perl nipe.pl install			
	sudo perl nipe.pl start
	
	sudo curl -s ifconfig.me > newip.txt
	newip=$(cat newip.txt)
	cat newip.txt | xargs -L1 geoiplookup | cut -d " " -f5 > newloc.txt
	newloc=$(cat newloc.txt)
	echo "You are now surfing from $newloc"	

else	
	echo "you are anonymous!" 
fi		


### Once connection is anonymous, communicate via SSH & execute nmap scans and who is queries tools: sshpass,ssh

sshpass -p $PSS ssh root@$VPS
sudo apt install nmap
sudo apt install whois

nmap 1.1.1.1
whois 1.1.1.1

