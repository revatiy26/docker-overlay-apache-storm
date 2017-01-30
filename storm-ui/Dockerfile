FROM local/storm-cluster-base:latest
MAINTAINER  CNWX

RUN /usr/bin/config-supervisord.sh ui

EXPOSE 8080
CMD /usr/bin/start-services.sh
