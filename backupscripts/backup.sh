#!/bin/bash

BASEDIR=/home/kees/backup
BASESRCDIR=/home/kees/data

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

echo "Script being called from $SCRIPTDIR"

mkdir -p $BASEDIR/src

# DSMR Reader
mkdir -p $BASEDIR/src/dsmr
$SCRIPTDIR/backup_postgrescontainer.sh dsmrdb dsmrreader $BASEDIR/src/dsmr/dsmrreader.sql

# Grafana
mkdir -p $BASEDIR/src/grafana
mkdir -p $BASEDIR/src/grafana/db
$SCRIPTDIR/backup_postgrescontainer.sh grafana-db $GRAFANA_POSTGRES_USER $BASEDIR/src/grafana/db/grafana.sql
cp -R $BASESRCDIR/grafana/data $BASEDIR/src/grafana/data

# Home assistant
mkdir -p $BASEDIR/src/homeassistant/db
$SCRIPTDIR/backup_postgrescontainer.sh hass-db $HA_POSTGRES_USER $BASEDIR/src/homeassistant/db/homeassistant.sql

# Influxdb
mkdir -p $BASEDIR/src/influxdb
$SCRIPTDIR/backup_influxdbcontainer.sh influxdb $BASEDIR/src/influxdb

# Mosquitto
mkdir -p $BASEDIR/src/mosquitto
cp -R $BASESRCDIR/mosquitto $BASEDIR/src/mosquitto

# Portainer
mkdir -p $BASEDIR/src/portainer
cp -R $BASESRCDIR/portainer $BASEDIR/src/portainer

# Prometeus
# Intentionally skipped. We don't care so much about historical data

# SabNZBD
mkdir -p $BASEDIR/src/sabnzbd
cp -R $BASESRCDIR/sabnzbd $BASEDIR/src/sabnzbd

# SickChill
mkdir -p $BASEDIR/src/sickchill
cp -R $BASESRCDIR/sickchill $BASEDIR/src/sickchill

# Traefik
mkdir -p $BASEDIR/src/traefik
cp -R $BASESRCDIR/traefik $BASEDIR/src/traefik

# echo "Creating tar file..."
TIMESTAMP=`/bin/date +%Y%m%d%H%M%S`
BACKUPFILE=backup_"$HOSTNAME"_"$TIMESTAMP" # backups will be named "backup_<hostname>_YYYYMMDDHHMMSS.db.gz"
BACKUPFILEGZ="$BACKUPFILE".tar.gz
tar -cvpzf $BASEDIR/$BACKUPFILEGZ $BASEDIR/src

echo "Copying tar file to NAS..."
mkdir -p /mnt/backup/$HOSTNAME
cp $BASEDIR/$BACKUPFILEGZ /mnt/backup/$HOSTNAME/
echo "Removing temporary files..."
rm -rf $BASEDIR

echo "Deleting old backups..."
/usr/bin/find /mnt/backup/$HOSTNAME/ -name '*.tar.gz' -mtime +31 -print -delete

echo "Backup for $HOSTNAME done!"