#!/bin/bash

source /etc/environment

HOMEDIR=$(eval echo "~`whoami`")

AWS_CREDS=""
if [ ! -z $AWS_ACCESS_KEY ]; then
    AWS_CREDS=" -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY \
     -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_KEY "
fi

sudo docker run --rm \
    -v ${HOMEDIR}:/data/ $AWS_CREDS behance/docker-aws-s3-downloader \
     us-east-1 $CONTROL_TIER_S3SECURE_BUCKET .mesos-master

while read line; do
    etcdctl set $line
done < ${HOMEDIR}/.mesos-master

Environment="principal=etcdctl get principal"
Environment="secret=etcdctl get secret"

sudo mkdir /etc/mesos-master
sudo touch /etc/mesos-master/passwd

echo "$($principal) $($secrets)" >> /etc/mesos-master/passwd
