#!/bin/bash

# Part of the system update process
# Used on Mac OS to split a mounted SD card image into smaller separate part
# Those are then placed in candlesmarthome.com/img/partitions

export GZIP=-9
DIRPATH="partitions-new"

mkdir -p "$DIRPATH"

DISKUL=$(diskutil list | grep Linux | grep disk4s4)
echo "DISKUTIL LINE: $DISKUL"

# if [ -n "$DISKUL" ]; then
if [[ $DISKUL == *"Linux"*"disk4s4"* ]]; then
    echo "Using disk 4"
    cd "$DIRPATH"
    rm -rf ./*
    
    diskutil unmount /dev/disk4s1
    dd if=/dev/disk4s1 of=boot_partition.fs
    dd if=/dev/disk4s2 of=system_partition.fs

else
    
    echo "DISK 4 DOES NOT EXIST, TRYING DISK 5"
    
    DISKUL=$(diskutil list | grep Linux | grep disk5s4)
    echo "DISKUTIL LINE: $DISKUL"
    
    if [[ $DISKUL == *"Linux"*"disk5s4"* ]]; then
        echo "Using disk 5"
        cd "$DIRPATH"
        rm -rf ./*
    
        diskutil unmount /dev/disk5s1
        dd if=/dev/disk5s1 of=boot_partition.fs
        dd if=/dev/disk5s2 of=system_partition.fs

    else
        echo "DISK 5 DOES NOT EXIST, TRYING DISK 6"
    
        DISKUL=$(diskutil list | grep Linux | grep disk6s4)
        echo "DISKUTIL LINE: $DISKUL"
    
        if [[ $DISKUL == *"Linux"*"disk6s4"* ]]; then
            echo "Using disk 6"
            cd "$DIRPATH"
            rm -rf ./*
        
            diskutil unmount /dev/disk6s1
            dd if=/dev/disk6s1 of=boot_partition.fs
            dd if=/dev/disk6s2 of=system_partition.fs
    
        else
            echo "ERROR, DISK 6 ALSO DOES NOT EXIST. ABORTING."    
            exit 1
        
        fi
    fi
fi
    

if [ -f system_partition.fs ]; then

    tar -czf boot_partition.fs.tar.gz boot_partition.fs
    tar -czf system_partition.fs.tar.gz system_partition.fs

    md5sum boot_partition.fs.tar.gz | awk '{ print $1 }' | tr -d \\n > boot_partition.fs.tar.gz.checksum
    md5sum system_partition.fs.tar.gz | awk '{ print $1 }' | tr -d \\n > system_partition.fs.tar.gz.checksum

#    rm boot_partition.fs
#    rm system_partition.fs
    
    echo "done"
    ls -l
    exit 0

else
    echo "ERROR, system_partition.fs does not exist. Aborting."
    exit 1
fi
