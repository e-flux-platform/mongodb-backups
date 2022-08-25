#!/bin/bash

MONGO_HOST=`cat /workdir/MONGO_HOST.env`
MONGO_DB=`cat /workdir/MONGO_DB.env`
BACKUPS_GS_BUCKET=`cat /workdir/BACKUPS_GS_BUCKET.env`
DATE_STR=`date +%Y-%m-%d-%H-%M`
TARGET_FILENAME=mongo-$MONGO_DB-$DATE_STR.tar.gz
TARGET_DIR=/workdir/data/archive

TARGET_PATH=$TARGET_DIR/$TARGET_FILENAME

echo "Starting backup"
echo $DATE_STR > /workdir/data/backup.start.date

rm -rf $TARGET_DIR
mkdir -p $TARGET_DIR

mongodump -h $MONGO_HOST -d $MONGO_DB --gzip --archive=$TARGET_PATH

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
