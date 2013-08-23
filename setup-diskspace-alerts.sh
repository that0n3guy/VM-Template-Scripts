#!/bin/bash

if [[ $EUID -ne 0 ]]; then
        echo "You must be root (or sudo) to do this..." 1>&2
        exit 100
fi

echo "Creating /root/scripts folder "
mkdir /root/scripts -p

echo "Whats the email you want the alerts to be sent too?"
read youremail

echo "Adding diskAlert script"


echo '#!/bin/sh' > /root/scripts/diskAlert
echo "df -H | grep -vE '^Filesystem|none|cdrom' | awk '{ print \$5 \" \" \$1 }' | while read output;" >> /root/scripts/diskAlert
echo 'do' >> /root/scripts/diskAlert
echo '  echo $output' >> /root/scripts/diskAlert
echo "  usep=\$(echo \$output | awk '{ print \$1}' | cut -d'%' -f1  )" >> /root/scripts/diskAlert
echo "  partition=\$(echo \$output | awk '{ print \$2 }' )" >> /root/scripts/diskAlert
echo '  if [ $usep -ge 90 ]; then' >> /root/scripts/diskAlert
echo '    echo "Running out of space \"$partition ($usep%)\" on $(hostname) as on $(date)" |' >> /root/scripts/diskAlert
echo "     mail -s \"Alert: Almost out of disk space \$usep%\" $youremail" >> /root/scripts/diskAlert
echo '  fi' >> /root/scripts/diskAlert
echo 'done ' >> /root/scripts/diskAlert

chmod +x /root/scripts/diskAlert
echo
#echo "Adding script to cron"
#( crontab -l 2>/dev/null | grep -Fv diskAlert ; printf -- "10 0 * * * /root/scripts/diskAlert" ) | crontab

echo "Done, please add the following line to 'crontab -e'"
echo '10 0 * * * /root/scripts/diskAlert'
