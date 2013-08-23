#!/bin/bash
# from: http://www.havetheknowhow.com/Configure-the-server/Install-ssmtp.html
#    and http://zackreed.me/articles/39-send-system-email-with-gmail-and-ssmtp
# 
# This script installs ssmtp on ubuntu (possibly debian) and configures
#  /etc/ssmtp/ssmtp.conf for basic email sending

if [[ $EUID -ne 0 ]]; then
        echo "You must be root (or sudo) to do this DOH...." 1>&2
        exit 100
fi



echo "What is your smtp username?"
read username
echo "What is your smtp password?"
read password
echo "What the email address?"
read email
echo "What is the from domain (eg: gmail.com)?"
read domain
echo "What is the smtp server (eg: smtp.gmail.com)?"
read smtpserver
echo "What is the smtp SSL port (eg: 587)?"
read port


apt-get install ssmtp


echo 
echo "#"> /etc/ssmtp/ssmtp.conf
echo "# Config file for sSMTP sendmail">> /etc/ssmtp/ssmtp.conf
echo "#">> /etc/ssmtp/ssmtp.conf
echo "# The person who gets all mail for userids < 1000">> /etc/ssmtp/ssmtp.conf
echo "# Make this empty to disable rewriting.">> /etc/ssmtp/ssmtp.conf
echo "#root=postmaster">> /etc/ssmtp/ssmtp.conf
echo "root=$email">> /etc/ssmtp/ssmtp.conf
echo "">> /etc/ssmtp/ssmtp.conf
echo "# The place where the mail goes. The actual machine name is required no">> /etc/ssmtp/ssmtp.conf
echo "# MX records are consulted. Commonly mailhosts are named mail.domain.com">> /etc/ssmtp/ssmtp.conf
echo "#mailhub=mail">> /etc/ssmtp/ssmtp.conf
echo "mailhub=$smtpserver:$port">> /etc/ssmtp/ssmtp.conf
echo "">> /etc/ssmtp/ssmtp.conf
echo "AuthUser=$username">> /etc/ssmtp/ssmtp.conf
echo "AuthPass=$password">> /etc/ssmtp/ssmtp.conf
echo "UseTLS=YES">> /etc/ssmtp/ssmtp.conf
echo "UseSTARTTLS=YES">> /etc/ssmtp/ssmtp.conf
echo "">> /etc/ssmtp/ssmtp.conf
echo "# Where will the mail seem to come from?">> /etc/ssmtp/ssmtp.conf
echo "#rewriteDomain=">> /etc/ssmtp/ssmtp.conf
echo "rewriteDomain=$domain">> /etc/ssmtp/ssmtp.conf
echo "">> /etc/ssmtp/ssmtp.conf
echo "# The full hostname">> /etc/ssmtp/ssmtp.conf
echo "#hostname=MyMediaServer.home">> /etc/ssmtp/ssmtp.conf
echo "hostname=$email">> /etc/ssmtp/ssmtp.conf
echo "">> /etc/ssmtp/ssmtp.conf
echo "# Are users allowed to set their own From: address?">> /etc/ssmtp/ssmtp.conf
echo "# YES - Allow the user to specify their own From: address">> /etc/ssmtp/ssmtp.conf
echo "# NO - Use the system generated From: address">> /etc/ssmtp/ssmtp.conf
echo "FromLineOverride=YES">> /etc/ssmtp/ssmtp.conf




