MPFS-FPGA-Ubuntu22.04
====================================================================================

Overview
------------------------------------------------------------------------------------

### Introduction

This Repository provides a Linux Boot Image(U-boot, Kernel, Ubuntu22.04-Root-Fs) for MPFS-FPGA(Microchip PolarFire SoC FPGA).

### Note

**The Linux Kernel Image and Ubuntu22.04 RootFS provided in this repository is not official.**

**I modified it to my liking. Please handle with care.**

### Features

* Hardware
  + MPFS-DISCO-KIT : Microchip PolarFire SoC FPGA Discovery Kit
* U-Boot v2024.09
  + Build U-Boot v2024.09 for MPFS-DISCO-KIT
  + Customized boot by uEnv.txt
  + Customized boot by boot.scr
  + Enable bootmenu
* Linux Kernel Version v6.6.xx
  + [linux-stable v6.6.51](https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git//tag/?h=v6.6.51)
  + Patched equivalent to linux-stable v6.6.51
  + Enable Device Tree Overlay
* Ubuntu22.04.x(jammy) Root File System
  + Installed build-essential
  + Installed ruby python3
  + Installed u-boot-tools
  + Installed other package list -> [files/ubuntu22.04-dpkg-list.txt](files/ubuntu22.04-dpkg-list.txt)
* FPGA Device Drivers and Services
  + [u-dma-buf (User space mappable DMA Buffer)](https://github.com/ikwzm/udmabuf)

Release
------------------------------------------------------------------------------------

| Release | Released   | Debian Version | Linux Kernel Version     | Release Tag |
|:--------|:-----------|:---------------|:-------------------------|:------------|
| v5.0.0  | 2024-12-12 | Ubuntu 22.04.5 | 6.6.51-mpfs-fpga-first-1 | [v5.0.0](https://github.com/ikwzm/MPFS-FPGA-Ubuntu22.04/tree/v5.0.0)

Install (v5.0.0)
------------------------------------------------------------------------------------

* Install U-Boot and Linux to SD-Card
  + [MPFS-DISCO-KIT](doc/install/mpfs-disco-kit.md)

Build
------------------------------------------------------------------------------------

* [Build U-Boot for MPFS-DISCO-KIT](doc/build/u-boot-mpfs-disco-kit.md)
* [Build Linux Kernel for MPFS-FPGA](doc/build/linux-kernel-6.6.51-mpfs-fpga-first.md)
* [Build Ubuntu22.04 RootFS](doc/build/ubuntu22.04.md)

