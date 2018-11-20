FROM ubuntu:14.04

RUN locale-gen en_US.UTF-8

ENV DEBIAN_FRONTEND noninteractive
ENV MARATHON_VERSION 1.6.322

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
    && cd /usr/share \
    && mkdir marathon \
    && cd marathon \
    && wget https://github.com/mesosphere/marathon/archive/v${MARATHON_VERSION}.tar.gz -O marathon.tar.gz \
    && tar -xzvf marathon.tar.gz --strip 1 \
    && ln -s /usr/share/marathon/bin/* /usr/bin/

CMD ["marathon", "--no-logger"]

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

