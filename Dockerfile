FROM centos:7
MAINTAINER Nhan Le <nhanleehoai@yahoo.com>

ENV SHA1=CB7F8D15424EED19C44B5D7D21789FDCCC409207 \
	GPG_KEY=461D2D1B577F40C58EC2FE060CF65F72E4609424 
	
ARG DISTRO_NAME=kafka_2.12-2.0.0

WORKDIR /tmp

RUN yum update -y && \
yum install wget net-tools telnet iproute traceroute -y && \
wget --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2Ftechnetwork%2Fjava%2Fjavase%2Fdownloads%2Fjre8-downloads-2133155.html; oraclelicense=accept-securebackup-cookie"  \
-q -O jre.rpm http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jre-8u181-linux-x64.rpm &&\
yum localinstall jre.rpm -y && \
wget -q "https://archive.apache.org/dist/kafka/2.0.0/$DISTRO_NAME.tgz" && \
wget -q "https://archive.apache.org/dist/kafka/2.0.0/$DISTRO_NAME.tgz.asc" && \
gpg --keyserver ha.pool.sks-keyservers.net --recv-key "$GPG_KEY" || \
gpg --keyserver  hkp://p80.pool.sks-keyservers.net:80 --recv-key "$GPG_KEY" && \
gpg --verify $DISTRO_NAME.tgz.asc $DISTRO_NAME.tgz && \
echo "$SHA1 $DISTRO_NAME.tgz" | sha1sum -c && \
mkdir -p /opt/kafka && \
tar --strip-components 1 -xzf $DISTRO_NAME.tgz -C /opt/kafka &&\
rm -f kafka*.* && rm -f jre.rpm &&\
rm -rf /var/cache/yum 

ENV PATH=$PATH:/opt/kafka/bin

#ENTRYPOINT 
CMD ["/opt/kafka/bin/kafka-server-start.sh"]


