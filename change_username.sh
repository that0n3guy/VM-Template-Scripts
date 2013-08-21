#! /bin/bash


#---------------------------do not edit below here-----------
#Assign existing hostname to $hostn
hostn=$(cat /etc/hostname)



#Ask for new hostname $newhost
echo "Enter username you want to change: "
read OLDUSER


#Display existing hostname
echo "Existing hostname is $hostn"
#Ask for new hostname $newhost
echo "Enter new hostname: "
read NEWHOSTNAME


#Ask for new hostname $newhost
echo "Enter new username to replace $OLDUSER: "
read NEWUSER

# from http://www.ubuntututorials.com/change-username-ubuntu-12-04/
# You should be running this from root... if not
#     set the password of root (sudo passwd root) then login via ssh as root
#     don't forget to logout of existing user

#change the user stuff
usermod  -l $NEWUSER $OLDUSER
usermod -m -d /home/$NEWUSER $NEWUSER
passwd $NEWUSER

#change the hostname... also see: http://www.ducea.com/2006/08/07/how-to-change$
if ! sed -i "s/$hostn/$NEWHOSTNAME/g" /etc/hosts; then
        log "FATAL: failed to NEWHOSTNAME in /etc/hosts"
        exit 1
fi
if ! sed -i "s/$hostn/$NEWHOSTNAME/g" /etc/hostname; then
        log "FATAL: could not set NEWHOSTNAME in /etc/hostname"
        exit 1
fi

#relock the root password
passwd root -d -l

#reboot
echo "Please reboot now by typing: reboot"

