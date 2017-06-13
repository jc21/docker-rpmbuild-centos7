FROM centos:7

MAINTAINER Jamie Curnow <jc@jc21.com>

# Yum
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum localinstall -y --nogpgcheck http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm && \
    yum -y install deltarpm && \
    yum -y update && \
    yum -y install which mock git wget curl kernel-devel rpmdevtools rpmlint rpm-build sudo gcc-c++ make automake autoconf yum-utils scl-utils scl-utils-build

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
RUN adduser -G wheel rpmbuilder
ADD .rpmmacros /home/rpmbuilder/
USER rpmbuilder

WORKDIR /home/rpmbuilder

