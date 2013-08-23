#!/bin/bash
#######################################################################
# this is a helper script that keeps snapraid parity info in sync with
# your data. Here's how it works:
#   1) it first calls diff to figure out if the parity info is out of sync
#   2) if there are changed files (i.e. new, changed, moved or removed),
#         it then checks how many files were removed.
#   3) if the deleted files exceed X (configurable), it triggers an
#         alert email and stops. (in case of accidental deletions)
#   4) otherwise, it will call sync.
#   5) when sync finishes, it sends an email with the output to user.
#
# $Author: sidney $
# $Revision: 5 $
# $Date: 2011-10-16 09:28:44 +1100 (Sun, 16 Oct 2011) $
# $HeadURL: file:///svnrepo/linuxScripts/snapraid_diff_n_sync.sh $
#
# From http://www.havetheknowhow.com/scripts/SnapRAIDSync.txt and 
#    http://sourceforge.net/p/snapraid/discussion/1677233/thread/385e8cf5
#
#######################################################################

EMAIL_SUBJECT_PREFIX="[MyMediaServerName] SnapRAID - "
EMAIL_ADDRESS="YourEmailAddress@gmail.com"
DEL_THRESHOLD=20

CONTENT_FILE="/var/snapraid/content"
PARITY_FILE="/media/HD204UI_2/SNAPRaid_Parity"

LOG_FILE="/tmp/snapraid.log"

## INTERNAL TEMP VARS ##
TMP_OUTPUT="/tmp/snapraid.out"

# redirect all stdout to log file (leave stderr alone thou)
exec >> $LOG_FILE

# timestamp the job
echo "[`date`] SnapRAID Job started."
echo "SnapRAID DIFF Job started on `date`" > $TMP_OUTPUT
echo "----------------------------------------" >> $TMP_OUTPUT

#TODO - mount and unmount parity disk on demand!

#sanity check first to make sure we can access the content and parity files
if [ ! -e $CONTENT_FILE ]; then
  echo "[`date`] ERROR - Content file ($CONTENT_FILE) not found!"
  echo "ERROR - Content file ($CONTENT_FILE) not found!" >> $TMP_OUTPUT
  exit 1;
fi

if [ ! -e $PARITY_FILE ]; then
  echo "[`date`] ERROR - Parity file ($PARITY_FILE) not found!"
  echo "ERROR - Parity file ($PARITY_FILE) not found!" >> $TMP_OUTPUT
  exit 1;
fi

# run the snapraid DIFF command
echo "[`date`] Running DIFF Command."
/usr/local/bin/snapraid diff >> $TMP_OUTPUT

# wait for the above cmd to finish
wait

echo "----------------------------------------" >> $TMP_OUTPUT
echo "SnapRAID DIFF Job finished on `date`" >> $TMP_OUTPUT

DEL_COUNT=$(grep ^Remove $TMP_OUTPUT | wc -l - | cut -d' ' -f1)
ADD_COUNT=$(grep ^Add $TMP_OUTPUT | wc -l - | cut -d' ' -f1)
MOVE_COUNT=$(grep ^Move $TMP_OUTPUT | wc -l - | cut -d' ' -f1)
UPDATE_COUNT=$(grep ^Update $TMP_OUTPUT | wc -l - | cut -d' ' -f1)

echo "SUMMARY of changes - Added [$ADD_COUNT] - Deleted [$DEL_COUNT] - Moved [$MOVE_COUNT] - Updated [$UPDATE_COUNT]" >> $TMP_OUTPUT

# check if files have changed
#if [ "grep -E 'Add|Remove' $TMP_OUTPUT 1> /dev/null" ]; then
if [ $DEL_COUNT -gt 0 -o $ADD_COUNT -gt 0 -o $MOVE_COUNT -gt 0 -o $UPDATE_COUNT -gt 0 ]; then
    # YES, check if number of deleted files exceed DEL_THRESHOLD
    if [ $DEL_COUNT -gt $DEL_THRESHOLD ]; then
        # YES, lets inform user and not proceed with the sync just in case
        echo "Number of deleted files ($DEL_COUNT) exceeded threshold ($DEL_THRESHOLD). NOT proceeding with sync job. Please run sync manually if this is not an error condition." >> $TMP_OUTPUT
    /usr/bin/mail -s "$EMAIL_SUBJECT_PREFIX WARNING - Number of deleted files ($DEL_COUNT) exceeded threshold ($DEL_THRESHOLD)" "$EMAIL_ADDRESS" < $TMP_OUTPUT
    echo "WARNING - Deleted files ($DEL_COUNT) exceeded threshold ($DEL_THRESHOLD). Check $TMP_OUTPUT for details. NOT proceeding with sync job."
    else
        # NO, delete threshold not reached, lets run the sync job
        echo "Deleted files ($DEL_COUNT) did not exceed threshold ($DEL_THRESHOLD), proceeding with sync job." >> $TMP_OUTPUT
        echo "[`date`] Changes detected [A-$ADD_COUNT,D-$DEL_COUNT,M-$MOVE_COUNT,U-$UPDATE_COUNT] and deleted files ($DEL_COUNT) is below threshold ($DEL_THRESHOLD). Running SYNC Command."
        echo "SnapRAID SYNC Job started on `date`" >> $TMP_OUTPUT
        echo "----------------------------------------" >> $TMP_OUTPUT
        /usr/local/bin/snapraid sync >> $TMP_OUTPUT
        #wait for the job to finish
        wait
        echo "----------------------------------------" >> $TMP_OUTPUT
        echo "SnapRAID SYNC Job finished on `date`" >> $TMP_OUTPUT
        /usr/bin/mail -s "$EMAIL_SUBJECT_PREFIX Sync Job COMPLETED" "$EMAIL_ADDRESS" < $TMP_OUTPUT
    fi
else
    # NO, so lets log it and exit
    echo "[`date`] No change detected. Nothing to do"
fi

echo "[`date`] Job ended."

exit 0;
