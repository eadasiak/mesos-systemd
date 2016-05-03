#!/bin/bash

ENCRYPTION_ID=$(etcdctl get /klam-ssh/ENCRYPTION_ID)
ENCRYPTION_KEY=$(etcdctl get /klam-ssh/ENCRYPTION_KEY)
ROLE_NAME=$(etcdctl get /klam-ssh/ROLE_NAME)
KEY_LOCATION_PREFIX=$(etcdctl get /klam-ssh/KEY_LOCATION_PREFIX)
IMAGE=$(etcdctl get /images/klam-ssh)

echo "Running authorizedkeys_command for $1" | systemd-cat -p info -t klam-ssh

docker run --rm -e ROLE_NAME=${ROLE_NAME} -e ENCRYPTION_ID=${ENCRYPTION_ID} -e ENCRYPTION_KEY=${ENCRYPTION_KEY} -e KEY_LOCATION_PREFIX=${KEY_LOCATION_PREFIX} ${IMAGE} /usr/lib/klam/getKeys.py $1
exit 0