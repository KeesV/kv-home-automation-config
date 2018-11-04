#!/bin/bash

CONTAINER=$1
USER=$2
TARGETFILE=$3
echo "Creating backup of container matching" $CONTAINER
CONTAINER_ID=`docker ps -l --filter "name=$CONTAINER" -q`

if [ -z "$CONTAINER_ID" ]
then
    echo "Couldn't find any container matching $CONTAINER"
else
    echo "Found container with id $CONTAINER_ID"
    echo "Going to take backup using user '$USER' to target file '$TARGETFILE'"
    docker exec -t $CONTAINER_ID pg_dumpall -c -U $USER > $TARGETFILE
    echo "Backup finished!"
fi
