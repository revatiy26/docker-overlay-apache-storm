# docker-overlay-apache-storm : Apache storm cluster and zookeeper ensemble built on docker overlay network.

## Synopsis
This project creates apache-storm cluster and zookeeper cluster of docker containers using docker overlay network.

## Docker Container/Image components

1.storm-client: This container represents storm-client which can be used to perform all the necessary command-line operations on storm-cluster.e.g. killing your topology.
  
   Please visit [http://storm.apache.org/releases/1.0.1/Command-line-client.html](url "Storm-client")  for more information.

2.storm-nimbus: This container represents nimbus or master node in a storm-cluster.

3.storm-supervisor: This container represents worker node in a storm-cluster.

4.storm-ui: This container represents ui-view in a storm-cluster.

5.storm-cluster-base : This image performs all the required steps for creating storm components such as storm-nimbus,storm-ui, and storm-supervisor.

6.storm-code-base : This image installs all the required softwares for creating storm-cluster-base,storm-client,storm-nimbus,storm-ui ,storm-supervisor and any storm topology.

7.Topology container: Dockerfile for this container is included in run-your-topology directory.This container exits after uploading topology jar to storm's master node i.e. storm-nimbus container.

## Build /Run


**1. Initial set up**: I have used external key-value store instead of Docker's SWARM API to create overlay network.

To achieve this, we need some nodes with docker-host installed on each one.We will be running a kv store container such as consul on one of the node.

        docker run -d -p 8500:8500 -h consul --name consul progrium/consul -server -bootstrap

Our other nodes will connect to this node where our kv store is running.To achieve this, we need to configure docker daemon process .


*   For boot2docker :  Edit docker daemon start script.Put following config next to the line `/usr/local/bin/docker daemon -D -g "$DOCKER_DIR"` in dockerd start script.
    Make sure to restart dockerd process after editing the script.Perform all these steps on all other nodes as well

        -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --cluster-store=consul://node-name-where-consul-is- running:8500/network --cluster-advertise=my-ip-address:2375

   

*   For RHEL linux   :Please visit [https://docs.docker.com/engine/admin/](url "configuring docker daemon on linux") 
     and follow all the given instructions in the section 'configuring docker' under CentOS / Red Hat Enterprise Linux / Fedora. Update/Add ExecStart config in the docker.conf file as  follows.Perform all these steps on all other nodes as well.
    
       ExecStart=/usr/bin/dockerd -H fd:// -D --tls=true --tlscert=/var/docker/server.pem --tlskey=/var/docker/serverkey.pem -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --cluster-store=consul://node-name-where-consul-is- running:8500/network --cluster-advertise=my-ip-address:2375


Please visit [https://docs.docker.com/engine/userguide/networking/get-started-overlay/](url "Docker overlay network")  for more information about this network

**2. Create the network**: After step 1 you are all set to create your overlay network.Create your network on any of the node.

        docker network create -d overlay --subnet=10.10.10.0/24 STORMNET


**3. Build images**: Build all the images on your nodes in following order.Also, you can replace 'local' with your repository name.(Distribute your images on different nodes but you will need base images on each )

        docker build  --no-cache -t local/storm-code-base:latest .
        docker build  --no-cache -t local/storm-client:latest .
        docker build  --no-cache -t local/storm-cluster-base:latest .
        docker build  --no-cache -t local/storm-nimbus:latest .
        docker build  --no-cache -t local/storm-supervisor:latest .
        docker build  --no-cache -t local/storm-ui:latest .


**4. Run containers** : run all the containers under your network STORMNET as follows:

*   Run zookeeper  
    
   We need zookeeper cluster for co-ordination within storm-cluster.Run docker-compose.yml from directory storm-zookeeper as follows.This will create zookeeper ensemble for you.

	    docker-compose up -d

This command builds and run each service from docker-compose.yml file separately .Given Dockerfile will be used to build and create containers.Docker-compose is useful when you need to create and run multiple containers at the same time.for e.g zookeeper cluster, client-server app , frontend-appserver-db app etc.

You need to make sure docker-compose is installed on the node where you are running your cluster.

*   Run ui and nimbus 

        docker run -d --name storm-ui --restart=on-failure --label storm-cluster -p 0.0.0.0:8888:8080 --net STORMNET local/storm-ui

   (Use name 'storm-nimbus') 
   
        docker run -d --name storm-nimbus --restart=on-failure --label storm-cluster -p 0.0.0.0:49627:6627 --net STORMNET local/storm-nimbus
   

*   Run multiple supervisor or workers 

        docker run -d --name storm-supervisor1 --restart=on-failure  --label storm-cluster --net STORMNET local/storm-supervisor
        docker run -d --name storm-supervisor2 --restart=on-failure  --label storm-cluster --net STORMNET local/storm-supervisor
        docker run -d --name storm-supervisor3 --restart=on-failure  --label storm-cluster --net STORMNET local/storm-supervisor

*   Run your storm client if required.(to perform some command line operation)

        docker run -itd --name storm-client --net STORMNET local/storm-client

*   Finally, run your topology container to submit your topology.This container exits after submitting/uploading topology jar to master/nimbus node.

        docker run -d --name ciitopology --net STORMNET local/testtopology 

**5. Cluster UI** : Visit your storm-ui on browser with address:  
 
        your mapped host for storm-ui container :8888
