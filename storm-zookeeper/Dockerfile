FROM ubuntu:14.04
MAINTAINER  CNWX

ARG MYID
ARG SERVER1
ARG SERVER2
ARG SERVER3

ENV ZOO_LOG_DIR /opt/zookeeper/logs 
ENV ZOO_LOG4J_PROP 'INFO,ROLLINGFILE'

#Install Java,Supervisor, Zookeeper
RUN \
  apt-get update && \
  apt-get install -y software-properties-common && \
  echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java7-installer && \
  apt-get install -y supervisor && \
  apt-get install -y openssh-server && \
  update-rc.d ssh defaults && \
  apt-get autoremove -y && \
  cd /opt/ && \
  wget http://apache.org/dist/zookeeper/zookeeper-3.4.9/zookeeper-3.4.9.tar.gz && \
  tar -xvzf zookeeper-3.4.9.tar.gz && \
  mv /opt/zookeeper-3.4.9 /opt/zookeeper && \
  mkdir /var/lib/zookeeper && \
  echo "$MYID" | tee -a /var/lib/zookeeper/myid && \
  rm -rf /var/cache/oracle-jdk7-installer /var/lib/cache /var/lib/log

ADD log4j.properties /opt/zookeeper/bin/
ADD zoo.cfg /opt/zookeeper/conf/zoo.cfg
ADD logstash.conf /etc/logstash/conf.d/logstash.conf
ADD config-supervisord.sh /usr/bin/config-supervisord.sh
ADD start-services.sh /usr/bin/start-services.sh

RUN \
    chmod +x /usr/bin/config-supervisord.sh && \
    chmod +x /usr/bin/start-services.sh && \
    echo server.1="$SERVER1":2888:3888 | tee -a /opt/zookeeper/conf/zoo.cfg && \
    echo server.2="$SERVER2":2888:3888 | tee -a /opt/zookeeper/conf/zoo.cfg && \
    echo server.3="$SERVER3":2888:3888 | tee -a /opt/zookeeper/conf/zoo.cfg

RUN echo [supervisord] | tee -a /etc/supervisor/supervisord.conf ; echo nodaemon=true | tee -a /etc/supervisor/supervisord.conf

RUN \
    /usr/bin/config-supervisord.sh zookeeper && \
    mkdir /opt/zookeeper/logs && \
    sed -i 's/exit 101/exit 0/' /usr/sbin/policy-rc.d && \
    chmod +x /usr/sbin/policy-rc.d && \
    wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -  && \
    echo "deb http://packages.elastic.co/logstash/2.3/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elk.list && \
    apt-get update && \ 
    apt-get install logstash && \
    chmod +x /etc/init.d/logstash && \
    update-rc.d logstash defaults 95 10

    
EXPOSE 2181 2888 3888

CMD /usr/bin/start-services.sh
