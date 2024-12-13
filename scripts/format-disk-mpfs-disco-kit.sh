#!/bin/sh

if [ -z ${DISKDEV} ]; then
    echo "Error: DISKDEV is not defined."
    exit 1
fi
if [ -f ${DISKDEV} ]; then
    echo "Error: ${DISKDEV} can not write."
    exit 1
fi

sed -e 's/\s*\([\+0-9a-zA-Z\-]*\).*/\1/' << EOF | gdisk ${DISKDEV}
          #
  o       # create a new empty GUID partition table (GPT)
  y       # Proceed? (Y/N)
  n       # add a new partition
  1       #   Partition number=1
          #   First sector=default(2048)
  +256M   #   Size=256M
  0700    #   Type=Microsoft basic data
  n       # add a new partition
  2       #   Partition number=2
          #   First sector=default
  +8M     #   Size=8M
  21686148-6449-6E6F-744E-656564454649 #   Type='BIOS boot partition'
  n       # add a new partition
  3       #   Partition number=3
          #   First sector=default
          #   Last  sector=default
  8300    #   Type=Linux filesystem
  c       # change a partition's name
  1       #   Partition number=1
  boot    #   Enter name='boot'
  c       # change a partition's name
  2       #   Partition number=2
  primary #   Enter name='primary'
  c       # change a partition's name
  3       #   Partition number=3
  rootfs  #   Enter name='rootfs'
  p       # print partitions
  w       # write table to disk and exit
  y       # Do you want to proceed? (Y/N)
EOF

