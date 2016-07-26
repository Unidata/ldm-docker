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
# LDM HOME
###

ENV HOME /home/ldm

WORKDIR $HOME

# So crond can run as user ldm
RUN chmod +s /sbin/crond

###
# Install the ldm
###

COPY install_ldm.sh /home/ldm/

RUN chmod +x $HOME/install_ldm.sh
RUN $HOME/install_ldm.sh

##
# Set up some environmental variables.
##

ENV PATH $HOME/bin:$PATH

##
# Fix setuids
##

RUN chmod +s $HOME/bin/hupsyslog
RUN chown root $HOME/bin/hupsyslog

RUN chmod +s $HOME/bin/ldmd
RUN chown root $HOME/bin/ldmd

##
# Create ldm directories conistent with registry.xml
##

RUN mkdir -p $HOME/var/queues

# This directory will ultimately be mounted outside the container
RUN mkdir -p $HOME/var/data

##
# Copy over some files.
##

COPY runldm.sh $HOME/

COPY README.md $HOME/

##
# crontab for scouring
##

COPY crontab /var/spool/cron/ldm

RUN chown ldm:ldm /var/spool/cron/ldm

RUN chmod 600 /var/spool/cron/ldm

##
# Make ldm directories owned by ldm
##

RUN chown -R ldm:ldm /home/ldm

USER root

##
# Execute script.
##

CMD $HOME/runldm.sh
