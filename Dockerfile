###
# LDM base dockerfile
###

FROM centos:7

###
# Update the system. Install stuff.
###

RUN yum update yum

# clean up (optimize now)

RUN yum install -y wget pax gcc libxml2-devel make libpng-dev rsyslog perl \
    zlib-devel bzip2 git curl perl sudo cronie bc net-tools man

###
# Set up ldm user account
###

RUN useradd -ms /bin/bash ldm

RUN echo "ldm ALL=NOPASSWD: ALL" >> /etc/sudoers

RUN echo 'ldm:docker' | chpasswd

###
# LDM version
###

ENV LDM_VERSION 6.13.4

###
# LDM HOME
###

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

USER ldm

RUN $HOME/install_ldm.sh

# make root actions must be run as root
USER root

RUN $HOME/install_ldm_root_actions.sh

###
# crontab for scouring
###

COPY crontab /var/spool/cron/ldm

RUN chown ldm:ldm /var/spool/cron/ldm

RUN chmod 600 /var/spool/cron/ldm

###
# back to user ldm
###

USER ldm

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

COPY runldm.sh $HOME/

COPY README.md $HOME/

##
# Execute script.
##

CMD $HOME/runldm.sh
