FROM debian:bookworm

LABEL org.opencontainers.image.authors="Victor Seva <linuxmaniac@torreviejawireless.org>"

# Atualização da data de build para forçar refresh
ENV REFRESHED_AT=2024-03-07
ENV SHM_MEMORY=64
ENV PKG_MEMORY=8

# Atualiza apt, instala dependências básicas de forma robusta
RUN rm -rf /var/lib/apt/lists/* && \
    sed -i 's|http://deb.debian.org|https://deb.debian.org|g' /etc/apt/sources.list && \
    apt-get update --fix-missing && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qq --assume-yes \
        gnupg \
        wget \
        apt-transport-https \
        ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Adiciona repositório Kamailio 5.8
RUN echo "deb https://deb.kamailio.org/kamailio58 bookworm main" > /etc/apt/sources.list.d/kamailio.list && \
    wget -O /tmp/kamailiodebkey.gpg https://deb.kamailio.org/kamailiodebkey.gpg && \
    gpg --output /etc/apt/trusted.gpg.d/deb-kamailio-org.gpg --dearmor /tmp/kamailiodebkey.gpg

# Instala Kamailio e módulos
RUN apt-get update --fix-missing && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qq --assume-yes \
        kamailio=5.8.0+bpo12 \
        kamailio-autheph-modules=5.8.0+bpo12 \
        kamailio-berkeley-bin=5.8.0+bpo12 \
        kamailio-berkeley-modules=5.8.0+bpo12 \
        kamailio-cnxcc-modules=5.8.0+bpo12 \
        kamailio-cpl-modules=5.8.0+bpo12 \
        kamailio-dbg=5.8.0+bpo12 \
        kamailio-erlang-modules=5.8.0+bpo12 \
        kamailio-extra-modules=5.8.0+bpo12 \
        kamailio-geoip-modules=5.8.0+bpo12 \
        kamailio-geoip2-modules=5.8.0+bpo12 \
        kamailio-ims-modules=5.8.0+bpo12 \
        kamailio-json-modules=5.8.0+bpo12 \
        kamailio-kazoo-modules=5.8.0+bpo12 \
        kamailio-ldap-modules=5.8.0+bpo12 \
        kamailio-lua-modules=5.8.0+bpo12 \
        kamailio-lwsc-modules=5.8.0+bpo12 \
        kamailio-memcached-modules=5.8.0+bpo12 \
        kamailio-microhttpd-modules=5.8.0+bpo12 \
        kamailio-mongodb-modules=5.8.0+bpo12 \
        kamailio-mono-modules=5.8.0+bpo12 \
        kamailio-mqtt-modules=5.8.0+bpo12 \
        kamailio-mysql-modules=5.8.0+bpo12 \
        kamailio-nats-modules=5.8.0+bpo12 \
        kamailio-nth=5.8.0+bpo12 \
        kamailio-outbound-modules=5.8.0+bpo12 \
        kamailio-perl-modules=5.8.0+bpo12 \
        kamailio-phonenum-modules=5.8.0+bpo12 \
        kamailio-postgres-modules=5.8.0+bpo12 \
        kamailio-presence-modules=5.8.0+bpo12 \
        kamailio-python3-modules=5.8.0+bpo12 \
        kamailio-rabbitmq-modules=5.8.0+bpo12 \
        kamailio-radius-modules=5.8.0+bpo12 \
        kamailio-redis-modules=5.8.0+bpo12 \
        kamailio-ruby-modules=5.8.0+bpo12 \
        kamailio-sctp-modules=5.8.0+bpo12 \
        kamailio-secsipid-modules=5.8.0+bpo12 \
        kamailio-snmpstats-modules=5.8.0+bpo12 \
        kamailio-sqlite-modules=5.8.0+bpo12 \
        kamailio-systemd-modules=5.8.0+bpo12 \
        kamailio-tls-modules=5.8.0+bpo12 \
        kamailio-unixodbc-modules=5.8.0+bpo12 \
        kamailio-utils-modules=5.8.0+bpo12 \
        kamailio-websocket-modules=5.8.0+bpo12 \
        kamailio-wolftls-modules=5.8.0+bpo12 \
        kamailio-xml-modules=5.8.0+bpo12 \
        kamailio-xmpp-modules=5.8.0+bpo12 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Diretório de configuração como volume
VOLUME /etc/kamailio

# Entrypoint
ENTRYPOINT ["kamailio", "-DD", "-E", "-m", "${SHM_MEMORY}", "-M", "${PKG_MEMORY}"]
