VM Template Scripts
=======================

###mount_share_locally
An init.d script.  Mounts samba shares locally to /mnt/samba/{sharename}.  It reads the .smb_credentials and .smb_remote_mounts files in the defined users home directory.

To use, edit the IP and username in the script, the run the following:

    sudo cp mount_shares_locally /etc/init.d/
    sudo update-rc.d mount_shares_locally defaults


Then run the smb_login_mount.sh script

Then run:

    sudo service mount_shares_locally start

[later] To unmount, run:

    sudo service mount_shares_locally stop


###smb_login_mount.sh
A simple bash script that allows you to easily define the samba login details for mount_share_locally as well as which shares you want to mount.

###change_username.sh
A bash script that allows you to a linux username and deletes the root password (so you can't login via ssh)


