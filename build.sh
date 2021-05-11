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
echo Building docker image which compiles the sd2snes firmware
docker build . -t sd2snes

# create the container from the image to extract the firmware.im3 build result:
echo Creating docker container from the built image to extract firmware.im3
container_id=$(docker create sd2snes)
echo Extracting firmware.im3
docker cp ${container_id}:/work/sd2snes/src/obj-mk3/firmware.im3 .
echo Removing temporary container
docker rm ${container_id}

echo Successfully built firmware.im3
