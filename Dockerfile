###
# LDM base dockerfile
###

FROM centos:7

###
# Update the system. Install stuff.
###

RUN yum -y update yum

# clean up (optimize now)

RUN yum install -y wget pax gcc libxml2-devel make libpng-devel rsyslog perl \
    zlib-devel bzip2 git curl sudo cronie bc net-tools man gnuplot tcl \
    libstdc++-static

###
# gosu is a non-optimal way to deal with the mismatches between Unix user and
# group IDs inside versus outside the container resulting in permission
# headaches when writing to directory outside the container.
###

ENV GOSU_VERSION 1.11

ENV GOSU_URL https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64

RUN curl -sSL $GOSU_URL -o /bin/gosu; \
	curl -sSL $GOSU_URL.asc -o /tmp/gosu.asc; \
        export GNUPGHOME="$(mktemp -d)"; \
        export KEY=B42F6819007F00F88E364FD4036A9C25BF357DD4; \
        for server in $(shuf -e ha.pool.sks-keyservers.net \
                                hkp://p80.pool.sks-keyservers.net:80 \
                                keyserver.ubuntu.com \
                                hkp://keyserver.ubuntu.com:80 \
                                keyserver.pgp.com \
                                pgp.mit.edu) ; do \
            gpg --batch --keyserver "$server" --recv-keys $KEY && break || : ; \
        done; \
        gpg --batch --verify /tmp/gosu.asc /bin/gosu; \
        rm -rf "$GNUPGHOME" /tmp/gosu.asc; \
        chmod +x /bin/gosu

###
# LDM version
###

ENV LDM_VERSION 6.13.14.28

###
# LDM HOME
###

# User LDM does not exist yet. See entrypoint.sh
RUN mkdir -p /home/ldm

ENV HOME /home/ldm

WORKDIR $HOME

# So crond can run as user ldm
RUN chmod +s /sbin/crond

###
# Install the ldm
###

COPY install_ldm.sh $HOME/

COPY install_ldm_root_actions.sh $HOME/

RUN chmod +x $HOME/install_ldm.sh

RUN chmod +x $HOME/install_ldm_root_actions.sh

RUN $HOME/install_ldm.sh

RUN $HOME/install_ldm_root_actions.sh

###
# crontab for scouring
###

COPY cron/ldm /var/spool/cron/ldm

###
# copy scouring utilities
###

COPY util $HOME/util

##
# Set the path
##

ENV PATH $HOME/bin:$PATH

##
# Create ldm directories conistent with registry.xml
##

RUN mkdir -p $HOME/var/queues

# This directory will ultimately be mounted outside the container
RUN mkdir -p $HOME/var/data

##
# Copy over some additional files.
##

COPY runldm.sh $HOME/bin/

RUN chmod +x $HOME/bin/runldm.sh

COPY README.md $HOME/

##
# entrypoint
##

COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

##
# .profile
##

COPY .profile $HOME


##
# Execute script.
##

CMD ["runldm.sh"]
