#!/usr/bin/env bash
#########################################################################################
# Created by John Woods
# Quick way to update Back Track before a client
# File checks weren't done on things installed by default in BT5rc2
# Script wasn't tested on any pre-BT5rc2 systems.
# It was done quick, feel free to improve the script and add the tools you like to use
# It just updates some tools I like to use not every tool, add to it!
# I'm using Nessus right now so that is the vul scanner it updates.
# I like to put fuzzdb in the web dir, you will too if you use my script.
# I added rc2-rc3 upgrade in there for other people, I hope someone uses it.  :-)
# Updated it in Feb 2013.  I stole some new code from Martin (purehat) Bos
# Who is a darn good shell coder and probably won't mind.  lol
#########################################################################################
echo -e "\e[1;34m[*] Checking connectivity\e[0m"
echo
sleep 2
TESTHOST="google.com"

TEST=`ping -c1 $TESTHOST|grep "1 packets transmitted"|cut --delimiter="," -f 3`
PASS=" 0% packet loss"

if [ "$TEST" = "$PASS" ]; then
        echo -e "\e[1;34m[*] Congratz bro! t3h Interntz is working\e[0m"

sleep 3
echo
echo -e "\e[1;34m[*] Updating the entire system...\e[0m"
echo
apt-get update && apt-get upgrade -y
echo
sleep 2
echo -e "\e[1;34m[*]Making sure you are at rc3.\e[0m"
if [ ! -d /pentest/passwords/rainbowcrack ] ;
then
echo -e "\e[1;34m[*]You are still rc2, tisk, tisk, fixing that.\e[0m"
uname -m |grep i686
if [ $? -eq 0 ] ;
then
echo -e "\e[1;34m[*]Installing 32 bit packages.\e[0m"
apt-get install libcrafter blueranger dbd inundator intersect mercury cutycapt trixd00r artemisa rifiuti2 netgear-telnetenable jboss-autopwn deblaze sakis3g voiphoney apache-users phrasendrescher kautilya manglefizz rainbowcrack rainbowcrack-mt lynis-audit spooftooph wifihoney twofi truecrack uberharvest acccheck statsprocessor iphoneanalyzer jad javasnoop mitmproxy ewizard multimac netsniff-ng smbexec websploit dnmap johnny unix-privesc-check sslcaudit dhcpig intercepter-ng u3-pwn binwalk laudanum wifite tnscmd10g bluepot dotdotpwn subterfuge jigsaw urlcrazy creddump android-sdk apktool ded dex2jar droidbox smali termineter bbqsql htexploit smartphone-pentest-framework fern-wifi-cracker powersploit webhandler -y
else
uname -m |grep x86_64
	if [ $? -eq 0 ] ;
	then
	echo -e "\e[1;34m[*]Installing 64 bit packages.\e[0m"
	apt-get install libcrafter blueranger dbd inundator intersect mercury cutycapt trixd00r rifiuti2 netgear-telnetenable jboss-autopwn deblaze sakis3g voiphoney apache-users phrasendrescher kautilya manglefizz rainbowcrack rainbowcrack-mt lynis-audit spooftooph wifihoney twofi truecrack acccheck statsprocessor iphoneanalyzer jad javasnoop mitmproxy ewizard multimac netsniff-ng smbexec websploit dnmap johnny unix-privesc-check sslcaudit dhcpig intercepter-ng u3-pwn binwalk laudanum wifite tnscmd10g bluepot dotdotpwn subterfuge jigsaw urlcrazy creddump android-sdk apktool ded dex2jar droidbox smali termineter multiforcer bbqsql htexploit smartphone-pentest-framework fern-wifi-cracker powersploit webhandler -y
	else
	echo -e "\e[1;34m[*]Couldn't detect system type, you need to manually upgrade.\e[0m"
	fi
fi
fi
echo
sleep 2
echo -e "\e[1;34m[*]Updating MSF.\e[0m"
/opt/metasploit/msf3/msfupdate
echo
sleep 2
echo -e "\e[1;34m[*]Updating Fast Track.\e[0m"
cd /pentest/exploits/fasttrack
./fast-track.py -c 1
echo
sleep 2
echo -e "\e[1;34m[*]Upading SET.\e[0m"
cd /pentest/exploits/set
./set-update
echo
sleep 2
echo -e "\e[1;34m[*]Updating W3AF.\e[0m"
cd /pentest/web/w3af
svn update
echo
sleep 2
echo -e "\e[1;34m[*]Updating Nessus.\e[0m"
if [ -f /opt/nessus/sbin/nessus-update-plugins ] ;
then
	cd /opt/nessus/sbin
	./nessus-update-plugins
else
	echo -e "\e[1;34m[*]Install Nessus and try again, or not.\e[0m"
fi
echo
sleep 2
echo -e "\e[1;34m[*]updating sqlmap.\e[0m"
cd /pentest/database/sqlmap
./sqlmap.py --update
echo
sleep 2
echo -e "\e[1;34m[*]Updating Fuzzdb - Important for Burp.\e[0m"
if [ -d /pentest/web/fuzzdb ] ;
then
	cd /pentest/web/fuzzdb
	svn update
else
	echo -e "\e[1;34m[*]Fuzzdb not found, installing at /pentest/web/fuzzdb.\e[0m"
	cd /pentest/web
	svn checkout http://fuzzdb.googlecode.com/svn/trunk fuzzdb
fi
echo
sleep 2
echo -e "\e[1;34m[*]Updating exploitdb.\e[0m"
cd /pentest/exploits/exploitdb
svn update
echo
sleep 2
echo -e "\e[1;34m[*]Updating aircrack.\e[0m"
if [ -x /pentest/wireless/aircrack-ng/scripts/airodump-ng-oui-update ] ;
then
/pentest/wireless/aircrack-ng/scripts/airodump-ng-oui-update
else
chmod 744 /pentest/wireless/aircrack-ng/scripts/airodump-ng-oui-update
/pentest/wireless/aircrack-ng/scripts/airodump-ng-oui-update
fi
echo
sleep 2
echo -e "\e[1;34m[*]Updating nmap.\e[0m"
svn co --username guest --password "" https://svn.nmap.org/nmap /opt/nmap-svn
cd /opt/nmap-svn
./configure && make
CM=`/usr/local/bin/nmap -V |tr -d '\n' |cut -c 14-20`
NM=`/opt/nmap-svn/nmap -V |tr -d '\n' |cut -c 14-20`
if [ $NM = $CM ]; then
	echo -e "\e[1;34m[*]Nmap already up to date.\e[0m"
else
	mv /usr/local/bin/nmap /usr/local/bin/nmap.old
	mv /usr/local/share/namp /usr/local/share/nmap.old
	make install
fi
echo
sleep 2
echo -e "\e[1;34m[*]All done.\e[0m"

else
        echo -e "\e[1;34m[*] You do not apear to have an Internet connection connection\e[0m"
        echo -e "\e[1;34m[*] Please connect to t3h Internetz and rerun this script\e[0m"

fi

exit 0
