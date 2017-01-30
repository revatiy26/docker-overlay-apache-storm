FROM ubuntu:14.04
MAINTAINER  CNWX
# Install Java.
RUN \
  apt-get update && \
  apt-get install -y software-properties-common && \
  echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java7-installer && \
  apt-get autoremove -y && \
  apt-get install -y wget tar make && \
  apt-get install -y maven && \
  apt-get update && \
  apt-get install -y build-essential checkinstall && \
  apt-get install -y libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev && \
  wget http://python.org/ftp/python/2.7.5/Python-2.7.5.tgz && \
  tar -xvf Python-2.7.5.tgz -C /opt && \
  cd /opt/Python-2.7.5 && \
  ./configure && \
  make install && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk7-installer /var/lib/cache /var/lib/log

#comment our existing key condition
RUN sed -i 's/jdk.certpath.disabledAlgorithms=/#jdk.certpath.disabledAlgorithms=/' /usr/lib/jvm/java-7-oracle/jre/lib/security/java.security
RUN echo 'jdk.certpath.disabledAlgorithms=RSA keySize < 1024' | sudo tee -a /usr/lib/jvm/java-7-oracle/jre/lib/security/java.security

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle
ENV STORM_VERSION 1.0.1
ENV STORM_HOME /opt/apache-storm-$STORM_VERSION
ENV PYTHON /usr/local/bin/python2.7
ENV PATH $JAVA_HOME/bin:/usr/local/bin:/usr/bin:$PATH

# Download and Install Apache Storm
RUN wget http://apache.mirrors.ovh.net/ftp.apache.org/dist/storm/apache-storm-$STORM_VERSION/apache-storm-$STORM_VERSION.tar.gz && \
tar -xzvf apache-storm-$STORM_VERSION.tar.gz -C /opt && \
rm -rf apache-storm-$STORM_VERSION.tar.gz

RUN ln -s $STORM_HOME/bin/storm /usr/bin/storm
