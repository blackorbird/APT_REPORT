#!/bin/bash
apt-get update
apt-get install vim
apt-get install screen



apt-get install curl
apt-get install sudo
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs
npm install -g forever
npm install -g forever-service


npm install native-dns


echo -e "\033[1m Please Choose DNS zone For Panel : google.com\033[0m"
read wbemzone

echo -e "\033[1m Please Choose Webmail  For Panel : webmail.google.com\033[0m"
read wbemwebmail


echo -e "\033[1m Please Choose Webmail  For Panel : webmail.google.com\033[0m"
read wbemwebmail

echo -e "\033[1m Please Choose authorative ip  For Panel : \033[0m"
read wbemauthorativeip


echo -e "\033[1m Please Choose Server IP  For Panel : webmail.google.com\033[0m"

read wbemserverip




authorative