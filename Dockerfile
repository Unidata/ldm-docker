###
# LDM base dockerfile
###

FROM centos:7

###
# Update the system. Install stuff.
###

RUN yum update yum

# clean up (optimize now)

RUN yum install -y wget pax gcc libxml2-devel make libpng-devel rsyslog perl \
    zlib-devel bzip2 git curl perl sudo cronie bc net-tools man gnuplot


###
# gosu is a non-optimal way to deal with the mismatches between Unix user and
# group IDs inside versus outside the container resulting in permission
# headaches when writing to directory outside the container.
###

ENV GOSU_VERSION 1.10

ENV GOSU_URL https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64

RUN gpg --keyserver pgp.mit.edu --recv-keys \
	B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& curl -sSL $GOSU_URL -o /bin/gosu \
	&& chmod +x /bin/gosu \
	&& curl -sSL $GOSU_URL.asc -o /tmp/gosu.asc \
	&& gpg --verify /tmp/gosu.asc /bin/gosu \
	&& rm /tmp/gosu.asc

###
# Set up ldm user account
###

RUN useradd -ms /bin/bash ldm

RUN echo "ldm ALL=NOPASSWD: ALL" >> /etc/sudoers

RUN echo 'ldm:docker' | chpasswd

###
# LDM version
###

ENV LDM_VERSION 6.13.6

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

RUN $HOME/install_ldm.sh

RUN $HOME/install_ldm_root_actions.sh

###
# crontab for scouring
###

COPY crontab /var/spool/cron/ldm

RUN chown ldm:ldm /var/spool/cron/ldm

RUN chmod 600 /var/spool/cron/ldm

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
# Execute script.
##

CMD ["runldm.sh"]
