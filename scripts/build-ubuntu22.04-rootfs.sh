
### Build Ubuntu 22.04(Console) RootFS

#### Setup APT

distro=jammy
export LANG=C

/debootstrap/debootstrap --second-stage

cat <<EOT > /etc/apt/sources.list
deb http://ports.ubuntu.com/ubuntu-ports jammy main restricted universe multiverse
deb-src http://ports.ubuntu.com/ubuntu-ports jammy main restricted universe multiverse
deb http://ports.ubuntu.com/ubuntu-ports jammy-updates main restricted universe multiverse
deb-src http://ports.ubuntu.com/ubuntu-ports jammy-updates main restricted universe multiverse
deb http://ports.ubuntu.com/ubuntu-ports jammy-security main restricted universe multiverse
deb-src http://ports.ubuntu.com/ubuntu-ports jammy-security main restricted universe multiverse
EOT

cat <<EOT > /etc/apt/apt.conf.d/71-no-recommends
APT::Install-Recommends "0";
APT::Install-Suggests   "0";
EOT

apt update  -y
apt upgrade -y

#### Install Core applications

apt install -y locales dialog
dpkg-reconfigure locales
apt install -y net-tools openssh-server ntpdate resolvconf sudo less hwinfo ntp tcsh zsh file

#### Setup hostname

echo "ubuntu-fpga" > /etc/hostname

#### Set root password

echo Set root password
passwd

cat <<EOT >> /etc/securetty
# Seral Port for Xilinx Zynq
ttyPS0
ttyPS1
EOT

#### Add fpga user

echo Add fpga user
adduser fpga
echo "fpga ALL=(ALL:ALL) ALL" > /etc/sudoers.d/fpga

#### Setup sshd config

sed -i -e 's/#PasswordAuthentication/PasswordAuthentication/g' /etc/ssh/sshd_config

#### Setup Time Zone

dpkg-reconfigure tzdata

#### Setup fstab

cat <<EOT > /etc/fstab
none            /config         configfs        defaults        0       0
EOT

#### Setup /lib/firmware

mkdir /lib/firmware

#### Install Development applications

apt-get install -y build-essential
apt-get install -y pkg-config
apt-get install -y curl
apt-get install -y git git-lfs
apt-get install -y kmod
apt-get install -y flex bison
apt-get install -y u-boot-tools device-tree-compiler
apt-get install -y libssl-dev
apt-get install -y socat
apt-get install -y ruby rake ruby-msgpack ruby-serialport
apt-get install -y python3 python3-dev python3-setuptools python3-wheel python3-pip python3-numpy
pip3 install msgpack-rpc-python

#### Install Other applications

apt install -y samba
apt install -y avahi-daemon

#### Install haveged for Linux Kernel 4.19

apt install -y haveged

#### Install network-manager for Ubuntu18.04

apt install -y network-manager

#### Make eth0 managed by network-manager

cat <<EOT >/etc/NetworkManager/conf.d/10-globally-managed-devices.conf
[keyfile]
unmanaged-devices=none
EOT

#### Move Debian Package to /home/fpga/debian

mkdir /home/fpga/debian
mv *.deb     /home/fpga/debian
chown fpga.fpga -R /home/fpga/debian

#### Install Linux Image and Header Debian Packages

dpkg -i home/fpga/debian/linux-image-6.6.51-mpfs-fpga-first_6.6.51-mpfs-fpga-1_riscv64.deb
dpkg -i home/fpga/debian/linux-headers-6.6.51-mpfs-fpga-first_6.6.51-mpfs-fpga-1_riscv64.deb

#### Clean Cache

apt-get clean

##### Create Debian Package List

dpkg -l > dpkg-console-list.txt
