sudo service logstash start
sudo service ssh start
echo "storm.local.hostname: `hostname -i`" >> $STORM_HOME/conf/storm.yaml
supervisord
