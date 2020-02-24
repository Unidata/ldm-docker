#!/bin/bash

# limit max number of open files to force pqact to close open file descriptors.
ulimit -n 1024

set -e
set -x
export PATH=/home/ldm/bin:$PATH
trap "echo TRAPed signal" HUP INT QUIT KILL TERM

/usr/sbin/crond

#ldmadmin clean
#ldmadmin delqueue
#ldmadmin mkqueue
#ldmadmin start

regutil -s docker.localhost.local /hostname

if [ ! -f /home/ldm/var/queues/ldm.pq ] ; then
    echo "The product queue file home/ldm/var/queues/ldm.pq does not exist. Making new queue."
    ldmadmin mkqueue
else
    # queue exists, test queue "sanity"
    echo "Checking existing product queue with 'pqcat'"
    pqcat -l- -s && pqcheck -F
    if test $? != 0
    then
        echo "Product queue appears corrupt. Deleting and rebuilding."
        ldmadmin delqueue
        ldmadmin mkqueue
    else
        echo "Using existing LDM product queue."
    fi
fi

# never exit
while true; do sleep 10000; done

#ldmadmin watch

#sleep 10

#echo ""
#echo ""
#echo "Hit [RETURN] to exit"
#read
