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

    # don't chown var directory, it takes too long if there is lots of data
    cd ${HOME} && \
        chown -R ldm:ldm $(ls -A | awk '{if($1 != "var"){ print $1 }}') && \
        chown ldm:ldm /var/spool/cron/ldm && chmod 600 /var/spool/cron/ldm && \
        chown root ./bin/ldmd && chmod 4755 ./bin/ldmd && \
        chown root ./bin/hupsyslog && chmod 4755 ./bin/hupsyslog

    sync

    exec gosu ldm "$@"
fi

exec "$@"

