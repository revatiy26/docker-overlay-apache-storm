FROM local/storm-client:latest

WORKDIR /topology

# Prepare by downloading dependencies
ADD pom.xml /topology/pom.xml
RUN ["mvn", "dependency:resolve"]
RUN ["mvn", "verify"]

# Adding source, compile and package into executable jar with dependencies.
ADD src /topology/src
ADD config.properties /topology/config.properties
RUN ["mvn", "package"]

EXPOSE 4444
ENTRYPOINT ["storm","jar", "target/yourjarname.jar","Full topology class name(include package)","remote"]