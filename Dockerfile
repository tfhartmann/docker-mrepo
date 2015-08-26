# Install PuppetDB Server
FROM centos:centos6
MAINTAINER Tim Hartmann <tfhartmann@gmail.com>

RUN yum install epel-release -y && \
    yum install http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm -y
RUN yum install -y puppet \
    apt-mirror \
    tar \
    hardlink \
    hostname \
    wget \
    unzip \
    rsync \
    python-pip

RUN mkdir -p /etc/mrepo.conf.d
RUN mkdir -p /mrepo/www
RUN puppet module install puppetlabs-mrepo
ADD conf/init.pp /tmp/init.pp
RUN puppet apply /tmp/init.pp --verbose
RUN chown -R apache:apache /mrepo
RUN echo 'set dns:order "inet inet6"' >> /etc/lftp.conf

ADD conf/mrepo.conf /etc/mrepo.conf 
ADD conf/repos.conf /etc/mrepo.conf.d/repos.conf 
ADD scripts/run-mrepo.sh /tmp/run-mrepo.sh
# Run MRepo and/or apache
CMD [ "/tmp/run-mrepo.sh" ]

# Expose Web ports
EXPOSE 80
