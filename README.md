VM Template Scripts
=======================

Update - These scripts haven't been used in a while.   I've moved away from virtual (mostly) as docker is a much better option for me.  They should still work (since bash lives on forever).

###mount_share_locally
An init.d script.  Mounts samba shares locally to /mnt/samba/{sharename}.  It reads the .smb_credentials and .smb_remote_mounts files in the defined users home directory.

To use, edit the IP and username in the script, the run the following:

    sudo cp mount_shares_locally /etc/init.d/
    sudo chmod +x /etc/init.d/mount_shares_locally
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

You must be logged out of the user you want to rename, its easiest to run this as root (to login to root you need to first set a root password: sudo passwd)


