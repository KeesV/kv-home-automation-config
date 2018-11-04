#!/bin/bash

CONTAINER=$1
TARGETDIR=$2
echo "Creating backup of container matching" $CONTAINER
CONTAINER_ID=`docker ps -l --filter "name=$CONTAINER" -q`

if [ -z "$CONTAINER_ID" ]
then
    echo "Couldn't find any container matching $CONTAINER"
else
    echo "Found container with id $CONTAINER_ID"
    echo "Going to take backup using to target dir '$TARGETDIR'"
    docker exec -t $CONTAINER_ID mkdir -p /backup
    docker exec -t $CONTAINER_ID influxd backup -portable /backup
    docker cp $CONTAINER_ID:/backup $TARGETDIR
    docker exec -t $CONTAINER_ID rm -rf /backup
    echo "Backup finished!"
fi
