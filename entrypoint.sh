#!/bin/bash
set -e

if [ "$1" = 'runldm.sh' ]; then

    chown -R ldm:ldm ${HOME} && \
        chown root ${HOME}/bin/ldmd && chmod 4755 ${HOME}/bin/ldmd && \
        chown root ${HOME}/bin/hupsyslog && chmod 4755 ${HOME}/bin/hupsyslog

    sync

    exec gosu ldm "$@"
fi

exec "$@"

