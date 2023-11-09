FROM unidata/rockylinux:latest-8

ENV GOSU_VERSION 1.17
ENV GOSU_URL https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64
ENV LDM_VERSION 6.14.5
ENV HOME /home/ldm
ENV PATH $HOME/bin:$PATH

COPY install_ldm.sh $HOME/
COPY install_ldm_root_actions.sh $HOME/
COPY cron/ldm /var/spool/cron/ldm
COPY util $HOME/util
COPY README.md $HOME/
COPY bashrc $HOME/.bashrc
COPY entrypoint.sh /
COPY .profile $HOME

WORKDIR $HOME

RUN yum -y update yum && \
    yum install -y wget spax gcc libxml2-devel make libpng-devel rsyslog perl \
    zlib-devel bzip2 git curl sudo cronie bc net-tools man gnuplot tcl \
    libstdc++-devel chrony && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    # gosu install start
    curl -sSL $GOSU_URL -o /bin/gosu; \
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
    # gosu install end
    mkdir -p /home/ldm/var/{queues,data} && \
    chmod +s /sbin/crond && \
    chmod +x /bin/gosu $HOME/install_ldm.sh $HOME/install_ldm_root_actions.sh \
     /entrypoint.sh && \
    $HOME/install_ldm.sh && \
    $HOME/install_ldm_root_actions.sh

COPY runldm.sh $HOME/bin/
RUN chmod +x $HOME/bin/runldm.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["runldm.sh"]
