FROM centos:7
LABEL ruicky, ruicky.wang@outlook.com

# Docker Build Arguments, For further upgrade
ENV ORANGE_PATH="/usr/local/orange"
ARG LOR_VERSION="0.3.4"
ENV ORANGE_VERSION="0.8.1"

ADD docker-entrypoint.sh docker-entrypoint.sh

#  1) Set the bootstrap scripts
#  2) Install yum dependencies
#  3) Cleanup
#  4) Install Dependencies
#  5) Install lor
#  6) Install orange
#  7) Cleanup
#  8) dnsmasq
#  9) Add User
# 10) Add configuration file & bootstrap file
# 11) Fix file permission
RUN \
    chmod 755 docker-entrypoint.sh \
    && mv docker-entrypoint.sh /usr/local/bin \
    # Install Dependencies
    && cd /tmp \
    && yum install -y wget \
    && wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && rpm -ivh epel-release-latest-7.noarch.rpm \
    && yum install -y yum-utils \
    && yum-config-manager --add-repo https://openresty.org/package/centos/openresty.repo \
    && yum install -y openresty openresty-resty curl git automake autoconf \
    && yum install -y gcc pcre-devel openssl-devel libtool gcc-c++ luarocks cmake3 lua-devel \
    && ln -s /usr/bin/cmake3 /usr/bin/cmake \
    # Install lor
    && cd /tmp \
    && curl -fSL https://github.com/sumory/lor/archive/v${LOR_VERSION}.tar.gz -o lor.tar.gz \
    && tar zxf lor.tar.gz \
    && cd lor-${LOR_VERSION} \
    && make install \
    # Install orange
    && cd /tmp \
    && curl -fSL https://github.com/orlabs/orange/archive/v${ORANGE_VERSION}.tar.gz -o orange.tar.gz \
    && tar zxf orange.tar.gz \
    && cd orange-${ORANGE_VERSION} \
    && make install \
    # clean tmp
    && cd / \
    && rm -rf /tmp/* \
    # change dnsmasq
    && echo "user=root" > /etc/dnsmasq.conf \
    && echo 'domain-needed' >> /etc/dnsmasq.conf \
    && echo 'listen-address=127.0.0.1' >> /etc/dnsmasq.conf \
    && echo 'resolv-file=/etc/resolv.dnsmasq.conf' >> /etc/dnsmasq.conf \
    && echo 'conf-dir=/etc/dnsmasq.d' >> /etc/dnsmasq.conf \
    # This upstream dns server will cause some issues
    && echo 'INTERNAL_DNS' >> /etc/resolv.dnsmasq.conf \
    && echo 'nameserver 8.8.8.8' >> /etc/resolv.dnsmasq.conf \
    && echo 'nameserver 8.8.4.4' >> /etc/resolv.dnsmasq.conf \
    # add user
    && useradd www \
    && echo "www:www" | chpasswd \
    && echo "www   ALL=(ALL)       ALL" >> /etc/sudoers \
    && mkdir -p ${ORANGE_PATH}/logs \
    && chown -R www:www ${ORANGE_PATH}/*

EXPOSE 7777 80 9999

# Daemon
ENTRYPOINT ["docker-entrypoint.sh"]