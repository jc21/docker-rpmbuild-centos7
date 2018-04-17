FROM centos:7

MAINTAINER Jamie Curnow <jc@jc21.com>
LABEL maintainer="Jamie Curnow <jc@jc21.com>"

# Yum
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum localinstall -y https://yum.jc21.com/jc21-yum.rpm && \
    yum -y install deltarpm && \
    yum -y update && \
    yum -y install which mock git wget curl kernel-devel rpmdevtools rpmlint rpm-build sudo gcc-c++ make automake autoconf yum-utils scl-utils scl-utils-build cmake libtool

# Common packages that get required by my builds
RUN yum -y install aspell-devel bzip2-devel chrpath cyrus-sasl-devel enchant-devel fastlz-devel firebird-devel fontconfig-devel freetds-devel freetype-devel gettext-devel gmp-devel \
    httpd-devel krb5-devel libacl-devel libcurl-devel libdb-devel libedit-devel liberation-sans-fonts libevent-devel libgit2 libicu-devel libjpeg-turbo-devel libuuid-devel libuuid \
    libmcrypt-devel libmemcached-devel libpng-devel libtidy-devel libtiff-devel libtool-ltdl-devel libwebp-devel libX11-devel libXpm-devel libxml2-devel \
    libxslt-devel memcached net-snmp-devel openldap-devel openssl-devel pam-devel pcre-devel perl-generators postgresql-devel recode-devel sqlite-devel \
    ssmtp systemd-devel systemtap-sdt-devel tokyocabinet-devel unixODBC-devel zlib-devel \
    && yum clean all \
    && rm -rf /var/cache/yum

# Rust
RUN curl -sSf https://static.rust-lang.org/rustup.sh | sh -s -- --channel=nightly --disable-sudo -y

# build files
ADD bin/build-spec /bin/
ADD bin/build-all /bin/

# Sudo
ADD etc/sudoers.d/wheel /etc/sudoers.d/
RUN chown root:root /etc/sudoers.d/*

# Remove requiretty from sudoers main file
RUN sed -i '/Defaults    requiretty/c\#Defaults    requiretty' /etc/sudoers

# Rpm User
RUN adduser -G wheel rpmbuilder \
    && mkdir -p /home/rpmbuilder/rpmbuild/{BUILD,SPECS,SOURCES,BUILDROOT,RPMS,SRPMS,tmp} \
    && chmod -R 777 /home/rpmbuilder/rpmbuild

ADD .rpmmacros /home/rpmbuilder/
USER rpmbuilder

WORKDIR /home/rpmbuilder

