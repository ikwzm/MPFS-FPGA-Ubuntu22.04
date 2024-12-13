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
  + MPFS-DISCO-KIT :
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

