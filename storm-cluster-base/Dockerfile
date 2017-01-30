FROM local/storm-code-base:latest
MAINTAINER  CNWX


RUN \
    # trick to allow service start on installation
    sed -i 's/exit 101/exit 0/' /usr/sbin/policy-rc.d && \  
    chmod +x /usr/sbin/policy-rc.d && \
    wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -  && \
    echo "deb http://packages.elastic.co/logstash/2.3/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elk.list && \
    apt-get update && \ 
    apt-get install -y openssh-server && \
    update-rc.d ssh defaults && \
    apt-get install logstash && \
    sudo chmod +x /etc/init.d/logstash && \
    update-rc.d logstash defaults 95 10
    
ADD logstash.conf /etc/logstash/conf.d/logstash.conf

RUN \
  apt-get update && \
  apt-get install -y supervisor && \
  rm -rf /var/lib/apt/lists/*

RUN groupadd storm; useradd --gid storm --home-dir /home/storm --create-home --shell /bin/bash storm
RUN chown -R storm:storm $STORM_HOME

COPY storm.yaml $STORM_HOME/conf/storm.yaml
ADD config-supervisord.sh /usr/bin/config-supervisord.sh
ADD start-services.sh /usr/bin/start-services.sh

RUN \
    chmod +x /usr/bin/config-supervisord.sh && \
    chmod +x /usr/bin/start-services.sh

RUN echo [supervisord] | tee -a /etc/supervisor/supervisord.conf ; echo nodaemon=true | tee -a /etc/supervisor/supervisord.conf
