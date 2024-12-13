### Format SD-Card for Microchip PolarFire SoC FPGA Discovery Kit

#### Delete old partitions

````console
shell# export DISKDEV=/dev/sdc
shell# gdisk $DISKDEV
GPT fdisk (gdisk) version 1.0.8

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.

Command (? for help): o
This option deletes all partitions and creates a new protective MBR.
Proceed? (Y/N): y

Command (? for help): p
Disk /dev/sda: 61069312 sectors, 29.1 GiB
Model: SD/MMC          
Sector size (logical/physical): 512/512 bytes
Disk identifier (GUID): 63982B54-E22F-4F65-B0ED-7713C54B05F3
Partition table holds up to 128 entries
Main partition table begins at sector 2 and ends at sector 33
First usable sector is 34, last usable sector is 61069278
Partitions will be aligned on 2048-sector boundaries
Total free space is 61069245 sectors (29.1 GiB)

Number  Start (sector)    End (sector)  Size       Code  Name

Command (? for help): q
````

#### Create new partions

There are tree ways

1. run scripts/format-disk-mpfs-disco-kit.sh
2. run gdisk step-by-step (not discussed hear)
3. run other tools(not discussed hear)


###### scripts/format-disk-mpfs-disco-kit.sh

````sh:scripts/format-disk-mpfs-disco-kit.sh
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
````

```console
shell$ sh scripts/format-disk-mpfs-disco-kit.sh

GPT fdisk (gdisk) version 1.0.8

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.

Command (? for help): 
Command (? for help): This option deletes all partitions and creates a new protective MBR.
Proceed? (Y/N): 
Command (? for help): Partition number (1-128, default 1): First sector (34-61069278, default = 2048) or {+-}size{KMGTP}: Last sector (2048-61069278, default = 61069278) or {+-}size{KMGTP}: Current type is 8300 (Linux filesystem)
Hex code or GUID (L to show codes, Enter = 8300): Changed type of partition to 'Microsoft basic data'

Command (? for help): Partition number (2-128, default 2): First sector (34-61069278, default = 526336) or {+-}size{KMGTP}: Last sector (526336-61069278, default = 61069278) or {+-}size{KMGTP}: Current type is 8300 (Linux filesystem)
Hex code or GUID (L to show codes, Enter = 8300): Changed type of partition to 'BIOS boot partition'

Command (? for help): Partition number (3-128, default 3): First sector (34-61069278, default = 542720) or {+-}size{KMGTP}: Last sector (542720-61069278, default = 61069278) or {+-}size{KMGTP}: Current type is 8300 (Linux filesystem)
Hex code or GUID (L to show codes, Enter = 8300): Changed type of partition to 'Linux filesystem'

Command (? for help): Partition number (1-3): Enter name: 
Command (? for help): Partition number (1-3): Enter name: 
Command (? for help): Partition number (1-3): Enter name: 
Command (? for help): Disk /dev/sda: 61069312 sectors, 29.1 GiB
Model: SD/MMC          
Sector size (logical/physical): 512/512 bytes
Disk identifier (GUID): F62CCEAC-1417-4974-9403-305DB94D0239
Partition table holds up to 128 entries
Main partition table begins at sector 2 and ends at sector 33
First usable sector is 34, last usable sector is 61069278
Partitions will be aligned on 2048-sector boundaries
Total free space is 2014 sectors (1007.0 KiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048          526335   256.0 MiB   0700  boot
   2          526336          542719   8.0 MiB     EF02  primary
   3          542720        61069278   28.9 GiB    8300  rootfs

Command (? for help): 
Final checks complete. About to write GPT data. THIS WILL OVERWRITE EXISTING
PARTITIONS!!

Do you want to proceed? (Y/N): OK; writing new GUID partition table (GPT) to /dev/sda.
The operation has completed successfully.
```

#### Create file systems

````console
shell# export DISKDEV=/dev/sdc
shell# mkfs.vfat ${DISKDEV}1
shell# mkfs.ext4 ${DISKDEV}3
````

