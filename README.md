# marathon

Dockerfile to build marathon docker image

Marathon https://mesosphere.github.io/marathon/

<pre>
docker run -d -e MARATHON_HOSTNAME=$ipaddress -e MARATHON_HTTPS_ADDRESS=$ipaddress \
-e MARATHON_HTTP_ADDRESS=$ipaddress -e MARATHON_MASTER=zk://$node1:2181,$node2:2181,$node3:2181/mesos \
-e MARATHON_ZK=zk://$node1:2181,$node2:2181,$node3:2181/marathon1 \ 
-e MARATHON_FRAMEWORK_NAME=marathon1 --name marathon --net host --restart always <image>
</pre>
