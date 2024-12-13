## Build U-boot for mpfs-disco-kit

### Repository

* https://github.com/ikwzm/MPFS-DISCO-KIT-U-Boot

### Download

```console
shell$ git clone --depth=1 -b v2024.09-1 https://github.com/ikwzm/MPFS-DISCO-KIT-U-Boot.git
```

### Build u-boot-spl.sfp and u-boot.img

Pleade refer to the Readme.md of https://github.com/ikwzm/MPFS-DISCO-KIT-U-Boot.git

### Copy uboot.img target/mkfs-disco-kit/uboot/

```console
shell$ cd MPFS-DISCO-KIT-U-Boot
shell$ install -d       ../target/mpfs-disco-kit/u-boot/
shell$ cp uboot.img     ../target/mpfs-disco-kit/u-boot/
```

### Copy uboot.env and boot.scr target/mkfs-disco-kit/boot/

```console
shell$ cd MPFS-DISCO-KIT-U-Boot
shell$ install -d       ../target/mpfs-disco-kit/boot/
shell$ cp uboot.env     ../target/mpfs-disco-kit/boot/
shell$ cp boot.scr      ../target/mpfs-disco-kit/boot/
```

