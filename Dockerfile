FROM ubuntu:14.04

RUN locale-gen en_US.UTF-8

ENV DEBIAN_FRONTEND noninteractive

# set default java environment variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

RUN apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common \
    && add-apt-repository ppa:openjdk-r/ppa -y \
    && apt-get update \
    && apt-get install -y --no-install-recommends openjdk-8-jre-headless \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

# workaround for bug on ubuntu 14.04 with openjdk-8-jre-headless

RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF \
    && echo deb http://repos.mesosphere.io/ubuntu trusty main > /etc/apt/sources.list.d/mesosphere.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y --force-yes mesos wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && cd /usr \
    && mkdir opt \
    && cd opt \
    && mkdir marathon \
    && cd marathon \
    && wget https://downloads.mesosphere.com/marathon/releases/1.6.322/marathon-1.6.322-2bf46b341.tgz -O marathon.tar.gz \
    && tar -xzvf marathon.tar.gz --strip 1 \
    && ln -s /usr/opt/marathon/bin/* /usr/bin/ \
    && rm marathon.tar.gz

COPY marathon.conf /etc/init/
COPY marathon /usr/init.d/

CMD ["marathon"]

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

