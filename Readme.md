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
* Linux Kernel Version v6.6.x
  + linux-stable v6.6.x
  + Patched equivalent to linux-stable v6.6.x
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

The main branch contains only Readme.md.     
For Linux Kernel and Ubuntu22.04 RootFS, please refer to the respective release tag listed below.

| Release | Released   | Ubuntu Version | Linux Kernel Version     | Release Tag |
|:--------|:-----------|:---------------|:-------------------------|:------------|
| v5.0.2  | 2024-12-14 | Ubuntu 22.04.5 | 6.6.51-mpfs-fpga-first-1 | [v5.0.2](https://github.com/ikwzm/MPFS-FPGA-Ubuntu22.04/tree/v5.0.2)

Install (v5.0.2)
------------------------------------------------------------------------------------

* Install U-Boot and Linux to SD-Card
  + [MPFS-DISCO-KIT](doc/install/mpfs-disco-kit.md)

Build
------------------------------------------------------------------------------------

* [Build U-Boot for MPFS-DISCO-KIT](doc/build/u-boot-mpfs-disco-kit.md)
* [Build Linux Kernel for MPFS-FPGA](doc/build/linux-kernel-6.6.51-mpfs-fpga-first.md)
* [Build Ubuntu22.04 RootFS](doc/build/ubuntu22.04.md)

