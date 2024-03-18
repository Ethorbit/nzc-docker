#!/bin/sh
FILE_COUNT=10000

# Perform write operations with dd
echo "Performing write operations..."
for i in $(seq 1 $FILE_COUNT); do
    (dd if=/dev/zero of=/volume/file_$i bs=1 count=1024)
done

echo "Symlinking them all."
cp -pdRns "/volume/"* /volume2/
#rsync -av --progress --link-dest=/volume/ /volume/ /volume2/

echo "Deleting all files"
rm -r /volume/*
rm -r /volume2/*
