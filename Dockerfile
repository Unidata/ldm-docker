FROM rockylinux:9

ENV GOSU_VERSION=1.19
ENV GOSU_URL=https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64
ENV LDM_VERSION=6.15.0
ENV HOME=/home/ldm
ENV PATH=$HOME/bin:$PATH

COPY install_ldm.sh $HOME/
COPY install_ldm_root_actions.sh $HOME/
COPY cron/ldm /var/spool/cron/ldm
COPY util $HOME/util
COPY README.md $HOME/
COPY bashrc $HOME/.bashrc
COPY entrypoint.sh /
COPY .profile $HOME

WORKDIR $HOME

RUN dnf -y update && \
    dnf -y install dnf-plugins-core epel-release && \
    dnf config-manager --set-enabled devel && \
    dnf -y install spax && \
    dnf config-manager --set-disabled devel && \
    dnf -y install \
        bc bzip2 chrony cronie gcc git gnuplot \
        libpng-devel libstdc++-devel libxml2-devel make man-db net-tools perl \
        procps-ng rsyslog sudo tcl wget zlib-devel && \
    dnf clean all && rm -rf /var/cache/dnf && \
    # gosu install start
    curl -sSL $GOSU_URL -o /bin/gosu; \
    curl -sSL $GOSU_URL.asc -o /tmp/gosu.asc; \
    export GNUPGHOME="$(mktemp -d)"; \
    export KEY=B42F6819007F00F88E364FD4036A9C25BF357DD4; \
    for server in $(shuf -e keyserver.ubuntu.com \
                            hkp://keyserver.ubuntu.com:80 ) ; do \
        gpg --batch --keyserver "$server" --recv-keys $KEY && break || : ; \
    done; \
    gpg --batch --verify /tmp/gosu.asc /bin/gosu; \
    rm -rf "$GNUPGHOME" /tmp/gosu.asc; \
    # gosu install end
    mkdir -p /home/ldm/var/{queues,data} && \
    chmod +s /usr/sbin/crond && \
    chmod +x /bin/gosu $HOME/install_ldm.sh $HOME/install_ldm_root_actions.sh \
     /entrypoint.sh && \
    $HOME/install_ldm.sh && \
    $HOME/install_ldm_root_actions.sh

COPY runldm.sh $HOME/bin/
RUN chmod +x $HOME/bin/runldm.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["runldm.sh"]
