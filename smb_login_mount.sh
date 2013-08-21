#! /bin/bash

#-------------------do not edit below here-----------

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root (or sudo)" 1>&2
   exit 1
fi
echo "Enter username for your samba share: "
read smbuser
echo
echo "Enter password for your samba share: "
read -s smbpass
echo
echo "Enter share name you will want to mount: "
read smbmount

echo
echo "Creating .smb_credentials: "
echo "username=$smbuser" > /root/.smb_credentials
echo "password=$smbpass" >> /root/.smb_credentials
echo
echo

echo "Creating .smb_remote_shares: "
echo "[$smbmount]" > /root/.smb_remote_shares
echo


echo "Installing cifs-utils"
apt-get install cifs-utils -y

echo "Check /root/.smb_credentials to verify your samba login info is correct"
echo "Check /root/.smb_remote_shares to verify your samba mounts are correct and add additional mounts"


