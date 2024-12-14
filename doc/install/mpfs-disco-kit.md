## Microchip PolarFire SoC FPGA Discovery Kit

### Downlowd from github

** Note: Downloading the entire repository takes time, so download the source code from https://github.com/ikwzm/MPFS-FPGA-Ubuntu22.04/releases. **

```console
shell$ wget https://github.com/ikwzm/MPFS-FPGA-Ubuntu22.04/archive/refs/tags/v5.0.2.tar.gz
shell$ tar xfz v5.0.2.tar.gz
shell$ cd MPFS-FPGA-Ubuntu22.04-5.0.2
```

### File Description

 * target/mpfs-disco-kit
   + boot/
     - uboot.env                                                : U-Boot environment 
     - uEnv.txt                                                 : U-Boot environment variables for linux boot
     - boot.scr                                                 : U-Boot Script file
     - devicetree-6.6.51-mpfs-fpga-first-mpfs-disco-kit.dtb     : Linux Device Tree Blob   
     - devicetree-6.6.51-mpfs-fpga-first-mpfs-disco-kit.dts     : Linux Device Tree Blob
   + u-boot/
     - uboot.img                                                : U-Boot Image 
 * files/
     - vmlinuz-6.6.51-mpfs-fpga-first-1                         : Linux Kernel Image
 * ubuntu22.04-rootfs.tgz.files/                                : Ubuntu22.04 Root File System
   + x00 .. x09                                                 : (splited files)
 * debian/
   - linux-image-6.6.51-mpfs-fpga-first_6.6.51-mpfs-fpga-1_riscv64.deb   : Linux Image Package
   - linux-headers-6.6.51-mpfs-fpga-first_6.6.51-mpfs-fpga-1_riscv64.deb : Linux Headers Package
   - u-dma-buf-6.6.51-mpfs-fpga-first_5.0.3-0_riscv64.deb                : u-dma-buf(5.0.3) Device Driver and Services Package

### Format SD-Card

[./doc/install/format-disk-mpfs-disco-kit.md](format-disk-mpfs-disco-kit.md)

### Write to SD-Card

#### Mount SD-Card

```console
shell# export DISKDEV=/dev/sdc
shell# mount ${DISKDEV}1 /mnt/usb1
shell# mount ${DISKDEV}3 /mnt/usb2
```
#### Make Primary Partition

```console
shell# dd if=target/mpfs-disco-kit/u-boot/uboot.img of=${DISKDEV}2 bs=64k
11+1 records in
11+1 records out
741216 bytes (741 kB, 724 KiB) copied, 0.0678967 s, 10.9 MB/s
```

#### Make Boot Partition

```console
shell# cp target/mpfs-disco-kit/boot/*                     /mnt/usb1
shell# gzip -d -c files/vmlinuz-6.6.51-mpfs-fpga-first-1 > /mnt/usb1/vmlinux-6.6.51-mpfs-fpga-first
```

#### Make RootFS Partition

```console
shell# cat ubuntu22.04-rootfs.tgz.files/* | tar xfz - -C /mnt/usb2
shell# mkdir                                             /mnt/usb2/home/fpga/debian
shell# cp debian/*                                       /mnt/usb2/home/fpga/debian
```

#### Add boot partition mount position to /etc/fstab

```console
shell# cat <<EOT >> /mnt/usb2/etc/fstab
/dev/mmcblk0p1	/mnt/boot	auto	defaults	0	0
EOT
shell# mkdir /mnt/usb2/mnt/boot
```

#### Unmount SD-Card

```console
shell# umount /mnt/usb1
shell# umount /mnt/usb2
```

