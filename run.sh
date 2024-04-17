#!/bin/bash

DATE_STR=`date +%Y-%m-%d-%H-%M`
TARGET_FILENAME=mongo-$MONGO_DB-$DATE_STR.tar.gz
TARGET_DIR=/workdir/data/archive

TARGET_PATH=$TARGET_DIR/$TARGET_FILENAME

if ! gsutil ls gs://$BACKUPS_GS_BUCKET > /dev/null; then
    echo "Expected valid storage bucket at BACKUPS_GS_BUCKET"
    exit 1
fi

echo "Starting backup"
echo $DATE_STR > /workdir/data/backup.start.date

rm -f /workdir/data/backup.date
rm -rf $TARGET_DIR
mkdir -p $TARGET_DIR

if [[ -z ${MONGO_DB+x} ]]; then
    echo "Backing up all databases"
    mongodump -h $MONGO_HOST --gzip --archive=$TARGET_PATH
else
    echo "Backing up database $MONGO_DB"
    mongodump -h $MONGO_HOST -d $MONGO_DB --gzip --archive=$TARGET_PATH
fi

gsutil cp $TARGET_PATH gs://$BACKUPS_GS_BUCKET/$TARGET_FILENAME

if [ ! $? -eq 0 ]; then
    echo "Error copying file to Google Storage!!"
    exit 1
fi

rm -f $TARGET_PATH.tar.gz
rm -rf $TARGET_DIR

DATE_STR=`date +%Y-%m-%d-%H-%M`
echo $DATE_STR > /workdir/data/backup.date

gsutil cp /workdir/data/backup.date gs://$BACKUPS_GS_BUCKET

curl -I $HEARTBEAT_URL
