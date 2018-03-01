#!/bin/bash
set -e

if [ "$1" = 'runldm.sh' ]; then

    USER_ID=${LDM_USER_ID:-1000}
    GROUP_ID=${LDM_GROUP_ID:-1000}

    ###
    # LDM user
    ###
    groupadd -r ldm -g ${GROUP_ID} && \
    useradd -u ${USER_ID} -g ldm -ms /bin/bash -c "LDM user" ldm

    # All of this is to avoid chowning -R var/data which will take too long if
    # there is a lot of data
    for i in /. /var /var/data /var/queues /var/logs
    do
        j=${HOME}$i
        if [ -d "$j" ]; then
            chown ldm:ldm "$j"
        fi
    done

    # chown everything in ${HOME} except var/data which will take too long
    cd ${HOME} && chown -R ldm:ldm $(ls -A | awk '{if($1 != "var"){ print $1 }}')

    # deal with cron for user ldm
    if [ -f /var/spool/cron/ldm ]; then
        chown ldm:ldm /var/spool/cron/ldm && chmod 600 /var/spool/cron/ldm
    fi

    chown root ${HOME}/bin/hupsyslog ${HOME}/bin/ldmd

    chmod 4755 ${HOME}/bin/hupsyslog ${HOME}/bin/ldmd

    sync

    exec gosu ldm "$@"
fi

exec "$@"
