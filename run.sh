#!/bin/bash

DATE_STR=`date +%Y-%m-%d-%H-%M`
TARGET_FILENAME=mongo-$MONGO_DB-$DATE_STR.tar.gz
TARGET_DIR=/workdir/data/archive

TARGET_PATH=$TARGET_DIR/$TARGET_FILENAME

if [[ -z "$MONGO_URI" && -z "$MONGO_HOST" ]]; then
    echo "Error: Both MONGO_URI and MONGO_HOST are empty"
    exit 1
fi

if ! gsutil ls gs://$BACKUPS_GS_BUCKET > /dev/null; then
    echo "Expected valid storage bucket at BACKUPS_GS_BUCKET"
    exit 1
fi

echo "Starting backup"
echo $DATE_STR > /workdir/data/backup.start.date

rm -f /workdir/data/backup.date
rm -rf $TARGET_DIR
mkdir -p $TARGET_DIR

CONNECTION_ARGS= "-h ${MONGO_HOST}"
if [[ -n "$MONGO_URI" ]]; then 
    CONNECTION_ARGS="--uri ${MONGO_URI}"
else 
    if [[ -n "$MONGO_DB" ]]; then
        CONNECTION_ARGS+=" -d ${MONGO_DB}"
    fi  
fi

echo "Performing backup..."
mongodump $CONNECTION_ARGS --gzip --archive=$TARGET_PATH

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