#!/bin/bash
echo "quick and dirty bootpart update"
mount -t tmpfs -o size=1500m tmpfs /mnt/ramdrive
cd /mnt/ramdrive
wget https://www.candlesmarthome.com/img/partitions/boot_partition.fs.tar.gz -O boot_partition.fs.tar.gz
zcat boot_partition.fs.tar.gz | tar -xvf -
mkdir -p bootpart
mount -t vfat boot_partition.fs bootpart
if [ ! -f bootpart/candle_version.txt ]; then
  echo "Error, bootpart files do no exist"
  exit 1
fi
cd bootpart
cp -r * /boot
echo "done"
