#!/bin/bash

# limit max number of open files to force pqact to close open file descriptors.
ulimit -n 1024

set -e
set -x
export PATH=/home/ldm/bin:$PATH
trap "echo TRAPed signal" HUP INT QUIT KILL TERM

/usr/sbin/crond
/usr/sbin/crond reload

ldmadmin clean
ldmadmin delqueue
ldmadmin mkqueue
ldmadmin start

# never exit
while true; do sleep 10000; done

#ldmadmin watch

#sleep 10

#echo ""
#echo ""
#echo "Hit [RETURN] to exit"
#read
