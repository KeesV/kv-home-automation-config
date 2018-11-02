#!/bin/bash

mkdir -p ./backup/src

### Directories to backup
echo "Copying directories to temporary location"
cp -Rv ./dashticz ./backup/src/dashticz
cp -Rv ./domoticz ./backup/src/domoticz
cp -Rv ./mosquitto ./backup/src/mosquitto
cp -Rv ./nginx ./backup/src/nginx
cp -Rv ./node-red ./backup/src/node-red
cp -Rv ./sickrage ./backup/src/sickrage
cp -Rv ./letsencrypt ./backup/src/letsencrypt
cp -Rv ./homeassistant ./backup/src/homeassistant
cp -Rv ./grafana ./backup/src/grafana
cp -Rv ./influxdb ./backup/src/influxdb
cp -v ./backup.sh ./backup/src/

echo "Creating tar file..."
TIMESTAMP=`/bin/date +%Y%m%d%H%M%S`
BACKUPFILE=backup_"$HOSTNAME"_"$TIMESTAMP" # backups will be named "backup_<hostname>_YYYYMMDDHHMMSS.db.gz"
BACKUPFILEGZ="$BACKUPFILE".tar.gz
tar -cvpzf ./backup/$BACKUPFILEGZ ./backup/src

echo "Copying tar file to NAS..."
mkdir -p /mnt/backup/$HOSTNAME
cp ./backup/$BACKUPFILEGZ /mnt/backup/$HOSTNAME/
rm -rf ./backup

echo "Deleting old backups..."
/usr/bin/find /mnt/backup/$HOSTNAME/ -name '*.tar.gz' -mtime +31 -print -delete

echo "Backup for $HOSTNAME done!"