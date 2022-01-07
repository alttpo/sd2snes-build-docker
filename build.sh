#!/bin/bash

# stop on first error:
set -e

# clone sd2snes repo into sd2snes/ if that directory does not already exist:
if [ ! -d "sd2snes" ]; then
  echo Cloning sd2snes repository into sd2snes/
  git clone https://github.com/mrehkopf/sd2snes.git
else
  echo Existing working copy of sd2snes/ found.
fi

# build the docker image which compiles the sd2snes firmware:
echo Building docker image which compiles the sd2snes firmware and FPGA
docker build . -t sd2snes-fpga

# create the container from the image to extract the im3 build results:
echo Creating docker container from the built image to extract im3 files
container_id=$(docker create sd2snes-fpga)
echo Extracting im3 files
docker cp ${container_id}:/work/sd2snes/src/obj-mk3/firmware.im3 .
docker cp ${container_id}:/work/sd2snes/verilog/sd2snes_base/fpga_base.bi3 .
docker cp ${container_id}:/work/sd2snes/verilog/sd2snes_mini/fpga_mini.bi3 .
echo Removing temporary container
docker rm ${container_id}

echo Successfully built firmware and FPGA images for MK3
