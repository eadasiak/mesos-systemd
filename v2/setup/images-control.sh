#!/bin/bash

source /etc/environment

if [ "${NODE_ROLE}" != "control" ]; then
    exit 0
fi

if [ "$(etcdctl get images-control-bootstrapped)" == "true" ]; then
    echo "control-tier images already bootstrapped, skipping"
    exit 0
fi
etcdctl set images-control-bootstrapped true

etcdctl set /images/chronos      "behance/chronos:chronos-2.4.0-0.1.20151007110204.ubuntu1404-mesos-0.25.0-0.2.70.ubuntu1404"
etcdctl set /images/fd           "behance/flight-director:latest"
etcdctl set /images/hud          "behance/flight-director-hud:latest"
etcdctl set /images/marathon     "mesosphere/marathon:v0.13.0"
etcdctl set /images/mesos-master "mesosphere/mesos-master:0.25.0-0.2.70.ubuntu1404"
etcdctl set /images/zk-exhibitor "behance/docker-zk-exhibitor:latest"
etcdctl set /images/cfn-signal   "behance/docker-cfn-bootstrap:latest"

# pull down images serially to avoid a FS layer clobbering bug in docker 1.6.x
docker pull jenkins
docker pull behance/docker-dd-agent-mesos
docker pull $(etcdctl get /images/chronos)
docker pull $(etcdctl get /images/fd)
docker pull $(etcdctl get /images/hud)
docker pull $(etcdctl get /images/marathon)
docker pull $(etcdctl get /images/mesos-master)
docker pull $(etcdctl get /images/zk-exhibitor)
docker pull $(etcdctl get /images/cfn-signal)
