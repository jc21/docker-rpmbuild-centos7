FROM centos:7

MAINTAINER Jamie Curnow <jc@jc21.com>
LABEL maintainer="Jamie Curnow <jc@jc21.com>"

# Disable the mirrorlist because god damn are they useless.
RUN sed -i 's/^mirrorlist=/#mirrorlist=/' /etc/yum.repos.d/CentOS-Base.repo \
    && sed -i 's/^#baseurl=/baseurl=/' /etc/yum.repos.d/CentOS-Base.repo

# Yum
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum localinstall -y https://yum.jc21.com/jc21-yum.rpm
RUN yum -y install deltarpm centos-release-scl
RUN yum-config-manager --enable rhel-server-rhscl-7-rpms
RUN yum -y update
RUN yum -y install devtoolset-7 which mock git wget curl kernel-devel rpmdevtools rpmlint rpm-build sudo gcc-c++ make automake autoconf yum-utils scl-utils scl-utils-build cmake libtool expect
RUN yum -y install aspell-devel bzip2-devel chrpath cyrus-sasl-devel enchant-devel fastlz-devel firebird-devel fontconfig-devel freetds-devel freetype-devel gettext-devel gmp-devel \
    httpd-devel krb5-devel libacl-devel libcurl-devel libdb-devel libedit-devel liberation-sans-fonts libevent-devel libgit2 libicu-devel libjpeg-turbo-devel libuuid-devel libuuid \
    libmcrypt-devel libmemcached-devel libpng-devel libtidy-devel libtiff-devel libtool-ltdl-devel libwebp-devel libX11-devel libXpm-devel libxml2-devel \
    libxslt-devel memcached net-snmp-devel openldap-devel openssl-devel pam-devel pcre-devel perl-generators postgresql-devel recode-devel sqlite-devel \
    ssmtp systemd-devel systemtap-sdt-devel tokyocabinet-devel unixODBC-devel zlib-devel epel-rpm-macros \
    RUN yum clean all
RUN rm -rf /var/cache/yum

# Fix scl problem: https://bugs.centos.org/view.php?id=14773
RUN rm -rf /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo

# build files
ADD bin/build-spec /bin/
ADD bin/build-all /bin/

# Sudo
ADD etc/sudoers.d/wheel /etc/sudoers.d/
RUN chown root:root /etc/sudoers.d/*

# Remove requiretty from sudoers main file
RUN sed -i '/Defaults    requiretty/c\#Defaults    requiretty' /etc/sudoers

# Rpm User
RUN adduser -G wheel rpmbuilder
RUN mkdir -p /home/rpmbuilder/rpmbuild/{BUILD,SPECS,SOURCES,BUILDROOT,RPMS,SRPMS,tmp}
RUN chmod -R 777 /home/rpmbuilder/rpmbuild

ADD .rpmmacros /home/rpmbuilder/
USER rpmbuilder

WORKDIR /home/rpmbuilder

