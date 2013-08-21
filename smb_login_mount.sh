#! /bin/bash

#-------------------do not edit below here-----------
echo "Enter username for your samba share: "
read smbuser
echo
echo "Enter username for your samba share: "
read smbpass
echo
echo "Enter share name you will want to mount: "
read smbmount

echo
echo "Creating .smb_credentials: "
echo "username=$smbuser" > ~/.smb_credentials
echo "password=$smbpass" >> ~/.smb_credentials
echo
echo

echo "Creating .smb_remote_shares: "
echo "[$smbmount]" > ~/.smb_remote_shares
echo


echo "Installing cifs-utils"
sudo apt-get install cifs-utils -y

echo "Check ~/.smb_credentials to verify your samba login info is correct"
echo "Check ~/.smb_remote_shares to verify your samba mounts are correct and add additional mounts"


