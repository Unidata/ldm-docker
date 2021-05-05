#!/bin/bash
set -e

# set umask:
umask 0002

if [ "$1" = 'runldm.sh' ]; then

    USERNAME=${LDM_USERNAME:-ldm}
    USER_ID=${LDM_USER_ID:-1000}
    GROUP_ID=${LDM_GROUP_ID:-1000}

    ###
    # LDM user
    ###
    groupadd -r ${USERNAME} -g ${GROUP_ID} && \
    useradd -u ${USER_ID} -g ${USERNAME} -ms /bin/bash -c "LDM user" ${USERNAME}

    # All of this is to avoid chowning -R var/data which will take too long if
    # there is a lot of data
    for i in /. /var /var/data /var/queues /var/logs
    do
        j=${HOME}$i
        if [ -d "$j" ]; then
            chown ${USERNAME}:${USERNAME} "$j"
        fi
    done

    # add group permissions to product queue
    chmod 775 /home/ldm/var/queues
    if [ -f /home/ldm/var/queues/ldm.pq ]; then
        chmod 664 /home/ldm/var/queues/ldm.pq
    fi

    # chown everything in ${HOME} except var/data which will take too long
    cd ${HOME} && chown -R ${USERNAME}:${USERNAME} $(ls -A | awk '{if($1 != "var"){ print $1 }}')

    # deal with cron for user ldm
    if [ -f /var/spool/cron/ldm ]; then
        if ! [[ "ldm" == "${USERNAME}" ]]; then
            mv /var/spool/cron/ldm /var/spool/cron/${USERNAME}
        fi
        chown ${USERNAME}:${USERNAME} /var/spool/cron/${USERNAME} && chmod 600 /var/spool/cron/${USERNAME}
    fi

    chown root ${HOME}/bin/hupsyslog ${HOME}/bin/ldmd

    chmod 4755 ${HOME}/bin/hupsyslog ${HOME}/bin/ldmd

    sync

    exec gosu ${USERNAME} "$@"
fi

exec "$@"
