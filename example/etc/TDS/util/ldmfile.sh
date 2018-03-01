#!/bin/sh
#--------------------------------------------------------------------------
#
# Name:    ldmfile.sh
#
# Purpose: file a LDM product and log the product's receipt
#
# Note:    modify the 'LOG' file to suit your needs
#
# History: 20030815 - Created for Zlib-compressed GINI image filing
#          20070822 - Updated to provide additional messages
#          20070903 - Fixed logic bug
#          20070905 - Switched to use of 'dirname'
#          20090405 - Added creation of a directory in which the latest
#                       KEEP number of files are saved
#          20111214 - changed 'tail' option '+{KEEP}' to '--lines=+{KEEP}'
#                       to work under Linux
#          20150224 - added logic to check if system is SunOS or Linux,
#                       based on feedback and suggestions from Tom Y.
#                       ~ sarms
#
#--------------------------------------------------------------------------

SHELL=sh
export SHELL

# Number of files to keep in link directory
KEEP=96

# Date+program name, log file name
pathname=$1
program="`date -u +'%b %d %T'` `basename $0`[$$]:"
message="FILE: $1"

# Send all messages to the log file
if [ $# -eq 2 ]; then
   logfile=$2
else
   logfile=var/logs/ldm-mcidas.log
fi
exec >>$logfile 2>&1

# Create output directory
fname=`basename $1`
dname=`dirname $1`
mkdir -p $dname >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo $program "ERROR: unable to create directory $dname for $fname"
  pathname=/dev/null
fi

# Create link directory
curdir=`dirname $dname`/current
mkdir -p $curdir >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo $program "ERROR: unable to create directory $curdir for $fname"
  pathname=/dev/null
fi

# Write the log message and output
echo $program $message
cat > $pathname

# Create a link to the file just written
ln $pathname $curdir/$fname

# Keep a maximum of $KEEP files in the link directory
cd $curdir
KEEP=`expr $KEEP + 1`

case `uname -s` in
SunOS)
  files=`ls -r | tail +${KEEP}`
  ;;
*)
  files=`ls -r | tail --lines=+${KEEP}`
  ;;
esac

if [ ! -z "$files" ]; then
  #echo rm -f $files
  rm -f $files
fi

# Done
exit 0
