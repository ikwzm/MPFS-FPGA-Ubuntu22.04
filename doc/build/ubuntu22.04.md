## Build Ubuntu 22.04 RootFS

### Setup parameters 

```console
shell$ apt-get install qemu-user-static debootstrap binfmt-support
shell$ export targetdir=ubuntu22.04-rootfs
shell$ export distro=jammy
```

### Build ubuntu22.04-rootfs with QEMU

### Build the root file system in $targetdir(=ubuntu22.04-rootfs)

```console
shell$ mkdir                                               $PWD/$targetdir
shell$ sudo debootstrap --arch=riscv64 --foreign $distro   $PWD/$targetdir
shell$ sudo cp /usr/bin/qemu-riscv64-static                $PWD/$targetdir/usr/bin
shell$ sudo cp /etc/resolv.conf                            $PWD/$targetdir/etc
shell$ sudo cp scripts/build-ubuntu22.04-rootfs.sh         $PWD/$targetdir
shell$ sudo cp debian/*.deb                                $PWD/$targetdir
shell$ sudo mount -vt proc proc                            $PWD/$targetdir/proc
shell$ sudo mount -vt devpts devpts -o gid=5,mode=620      $PWD/$targetdir/dev/pts
````

#### Change Root to ubuntu22.04

```console
shell$ sudo chroot $PWD/$targetdir
```

There are two ways

1. run build-ubuntu22.04-rootfs.sh (easy)
2. run this chapter step-by-step (annoying)

#### Setup APT

````console
ubuntu22.04-rootfs# distro=jammy
ubuntu22.04-rootfs# export LANG=C
ubuntu22.04-rootfs# /debootstrap/debootstrap --second-stage
````

```console
ubuntu22.04-rootfs# cat <<EOT > /etc/apt/sources.list
deb http://ports.ubuntu.com/ubuntu-ports jammy main restricted universe multiverse
deb-src http://ports.ubuntu.com/ubuntu-ports jammy main restricted universe multiverse
deb http://ports.ubuntu.com/ubuntu-ports jammy-updates main restricted universe multiverse
deb-src http://ports.ubuntu.com/ubuntu-ports jammy-updates main restricted universe multiverse
deb http://ports.ubuntu.com/ubuntu-ports jammy-security main restricted universe multiverse
deb-src http://ports.ubuntu.com/ubuntu-ports jammy-security main restricted universe multiverse
EOT
```

```console
ubuntu22.04-rootfs# cat <<EOT > /etc/apt/apt.conf.d/71-no-recommends
APT::Install-Recommends "0";
APT::Install-Suggests   "0";
EOT
```

```console
ubuntu22.04-rootfs# apt -y update
ubuntu22.04-rootfs# apt -y upgrade
```

#### Install Core applications

```console
ubuntu22.04-rootfs# apt install -y locales dialog
ubuntu22.04-rootfs# dpkg-reconfigure locales
ubuntu22.04-rootfs# apt install -y net-tools openssh-server ntpdate resolvconf sudo less hwinfo ntp tcsh zsh file
```

Here, please select "160. en_US.UTF-8 UTF-8" and "2. C.UTF-8"
Set a different locales if necessary.

#### Setup hostname

```console
ubuntu22.04-rootfs# echo ubuntu-fpga > /etc/hostname
```

#### Setup root password

```console
ubuntu22.04-rootfs# passwd
```

This time, we set the "admin" at the root' password.

To be able to login as root from Zynq serial port.

```console
ubuntu22.04-rootfs# cat <<EOT >> /etc/securetty
# Seral Port for Xilinx Zynq
ttyPS0
ttyPS1
EOT
```

#### Add a new guest user

```console
ubuntu22.04-rootfs# adduser fpga
```

This time, we set the "fpga" at the fpga'password.

```console
ubuntu22.04-rootfs# echo "fpga ALL=(ALL:ALL) ALL" > /etc/sudoers.d/fpga
```

#### Setup sshd config

```console
ubuntu22.04-rootfs# sed -i -e 's/#PasswordAuthentication/PasswordAuthentication/g' /etc/ssh/sshd_config
```

#### Setup Time Zone

```console
ubuntu22.04-rootfs# dpkg-reconfigure tzdata
```

or if noninteractive set to Asia/Tokyo

```console
ubuntu22.04-rootfs# echo "Asia/Tokyo" > /etc/timezone
ubuntu22.04-rootfs# dpkg-reconfigure -f noninteractive tzdata
```

#### Setup fstab

```console
ubuntu22.04-rootfs# cat <<EOT > /etc/fstab
none            /config         configfs        defaults        0       0
EOT
```

#### Setup /lib/firmware

```console
ubuntu22.04-rootfs# mkdir /lib/firmware
```

#### Install Development applications

```console
ubuntu22.04-rootfs# apt install -y build-essential
ubuntu22.04-rootfs# apt install -y pkg-config
ubuntu22.04-rootfs# apt install -y curl
ubuntu22.04-rootfs# apt install -y git git-lfs
ubuntu22.04-rootfs# apt install -y kmod
ubuntu22.04-rootfs# apt install -y flex bison
ubuntu22.04-rootfs# apt install -y u-boot-tools device-tree-compiler
ubuntu22.04-rootfs# apt install -y libssl-dev
ubuntu22.04-rootfs# apt install -y socat
ubuntu22.04-rootfs# apt install -y ruby rake ruby-msgpack ruby-serialport
ubuntu22.04-rootfs# apt install -y python3 python3-dev python3-setuptools python3-wheel python3-pip python3-numpy
ubuntu22.04-rootfs# pip3 install msgpack-rpc-python
```

#### Install Other applications

```console
ubuntu22.04-rootfs# apt install -y samba
ubuntu22.04-rootfs# apt install -y avahi-daemon
```

#### Install haveged for Linux Kernel 4.19

```console
ubuntu22.04-rootfs# apt install -y haveged
```

#### Install network-manager for Ubuntu22.04

```console
ubuntu22.04-rootfs# apt install -y network-manager
```

#### Make eth0 managed by network-manager

```console
ubuntu22.04-rootfs# cat <<EOT >/etc/NetworkManager/conf.d/10-globally-managed-devices.conf
[keyfile]
unmanaged-devices=none
EOT
```

#### Move Debian Package to /home/fpga/debian

```console
ubuntu22.04-rootfs# mkdir              home/fpga/debian
ubuntu22.04-rootfs# mv *.deb           home/fpga/debian
ubuntu22.04-rootfs# chown fpga.fpga -R home/fpga/debian
```

#### Install Linux Image Debian Packages

```console
ubuntu22.04-rootfs# dpkg -i home/fpga/debian/linux-image-6.6.51-mpfs-fpga-first_6.6.51-mpfs-fpga-1_riscv64.deb
ubuntu22.04-rootfs# dpkg -i home/fpga/debian/linux-headers-6.6.51-mpfs-fpga-first_6.6.51-mpfs-fpga-1_riscv64.deb
```

#### Clean Cache

```console
ubuntu22.04-rootfs# apt-get clean
```

#### Create Debian Package List

```console
ubuntu22.04-rootfs# dpkg -l > dpkg-console-list.txt
```

#### Finish

```console
ubuntu22.04-rootfs# exit
shell$ sudo rm -f  $PWD/$targetdir/usr/bin/qemu-riscv64-static
shell$ sudo rm -f  $PWD/$targetdir/build-ubuntu22.04-rootfs.sh
shell$ sudo mv     $PWD/$targetdir/dpkg-console-list.txt files/ubuntu22.04-dpkg-list.txt
shell$ sudo umount $PWD/$targetdir/proc
shell$ sudo umount $PWD/$targetdir/dev/pts
```

### Build ubuntu22.04-rootfs.tgz

```console
shell$ cd $PWD/$targetdir
shell$ sudo tar cfz ../ubuntu22.04-rootfs.tgz *
shell$ cd ..
```

### Build ubuntu22.04-rootfs.tgz.files

```console
shell$ mkdir ubuntu22.04-rootfs.tgz.files
shell$ cd    ubuntu22.04-rootfs.tgz.files
shell$ split -d --bytes=40M ../ubuntu22.04-rootfs.tgz
shell$ cd ..
```