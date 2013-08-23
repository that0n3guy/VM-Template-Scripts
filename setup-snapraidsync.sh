#!/bin/bash
if [[ $EUID -ne 0 ]]; then
        echo "You must be root (or sudo) to do this..." 1>&2
        exit 100
fi

echo "Creating /root/scripts folder "
mkdir /root/scripts -p
echo
echo "Installing curl"
apt-get install cifs-utils curl
echo
echo "Downloading snapraid sync script to /root/scripts/SnapraidSync.sh"
curl -o /root/scripts/SnapraidSync.sh https://raw.github.com/that0n3guy/VM-Template-Scripts/master/SnapraidSync.sh
chmod +x /root/scripts/SnapraidSync.sh
echo
echo "What do you want the delete threshhold to be (eg: 50)?"
read -e delthresh
echo
echo "What email address should this script notifiy you at?"
read -e email
echo
echo "What email subject should the notification have?"
read -e subject
echo
echo "What is the path to the a content file (eg: /var/snapraid/content)?"
read -e contentfile
echo
echo "What is the path to the the parrity file (eg: /mnt/disk1/parity)?"
read -e parityfile

sed -i sed -i "s/EMAIL_SUBJECT_PREFIX=.*\+/EMAIL_SUBJECT_PREFIX='$subject'" /root/scripts/SnapraidSync.sh
sed -i sed -i "s/EMAIL_ADDRESS=.*\+/EMAIL_ADDRESS='$email'" /root/scripts/SnapraidSync.sh
sed -i sed -i "s/DEL_THRESHOLD=.*\+/DEL_THRESHOLD=$delthresh" /root/scripts/SnapraidSync.sh
sed -i sed -i "s/CONTENT_FILE=.*\+/CONTENT_FILE='$contentfile'" /root/scripts/SnapraidSync.sh
sed -i sed -i "s/PARITY_FILE=.*\+/PARITY_FILE=$parityfile" /root/scripts/SnapraidSync.sh

echo
echo
echo "Done, please check the variables at the top of /root/scripts/SnapraidSync.sh"
echo
echo 'Also, you will probably want to setup something like the text below "in crontab -e":'
echo '15 0 * * * /root/scripts/SnapraidSync.sh'
