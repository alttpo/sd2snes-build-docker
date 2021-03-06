# What is it?
This repository contains a `Dockerfile` which can be used to successfully compile the
[sd2snes](https://github.com/mrehkopf/sd2snes) firmware and FPGA code and produce a `firmware.im3` binary
and a `fpga_base.im3` binary ready to copy to the sd2snes folder on your SD card.

# Prerequisites
1. Have Docker installed.
1. Have a usable Bash-compatible shell to run `./build.sh` with.
1. If you don't have Bash, you can manually replicate the steps found in the `./build.sh` script.

# How to build
Run the `./build.sh` script.

It will build the docker image which compiles the firmware image.

The build script will then copy out the resulting `firmware.im3` and `fpga_base.im3` into the current directory.

# How to run
1. This guide assumes that you have an existing installation of an SD2SNES firmware (likely v1.10.3) installed
on your SD Card, complete with all its `*.bi3` files in the `/sd2snes/` folder in your SD card.
1. **MAKE A BACKUP OF YOUR EXISTING FIRMWARE.IM3 FILE FROM YOUR SD2SNES SD CARD!!!**
1. Copy `firmware.im3` and `fpga_base.im3` into your SD2SNES SD card's `/sd2snes/` folder.

![Demo](demo.jpg)

# Caveats
1. Only the `fpga_base.im3` FPGA image is currently compiled to save time. Extending the Dockerfile to build the
other FPGA images is a simple matter but will cost a lot of build time.
1. The `firmware.im3` and `fpga_base.im3` must be built and deployed together since they are somewhat tightly
coupled together.
