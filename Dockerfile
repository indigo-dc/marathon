FROM ubuntu:16.04

ARG marathon_version

ENV DEBIAN_FRONTEND noninteractive

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF && \
echo deb http://repos.mesosphere.com/ubuntu trusty main > /etc/apt/sources.list.d/mesosphere.list && \
apt-get update && \
apt-get install --no-install-recommends -y --force-yes openjdk-8-jre-headless mesos marathon=${marathon_version} && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/usr/share/marathon/bin/marathon"]

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

