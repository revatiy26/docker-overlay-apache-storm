echo [program:zookeeper] | tee -a /etc/supervisor/conf.d/zookeeper.conf
echo command=/opt/zookeeper/bin/zkServer.sh start-foreground | tee -a /etc/supervisor/conf.d/zookeeper.conf
echo user=root | tee -a /etc/supervisor/conf.d/zookeeper.conf
echo autostart=true | tee -a /etc/supervisor/conf.d/zookeeper.conf
echo startsecs=10 | tee -a /etc/supervisor/conf.d/zookeeper.conf
echo startretries=999 | tee -a /etc/supervisor/conf.d/zookeeper.conf