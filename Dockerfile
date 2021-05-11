# use a recent ARM compiler
FROM stronglytyped/arm-none-eabi-gcc:latest

# install necessary build tools:
RUN apt-get update && apt-get install -y gawk unzip curl
RUN curl https://getmic.ro | bash
RUN cp /work/micro /usr/local/bin/

# clone develop from sd2snes firmware repo:
RUN git clone --depth 1 https://github.com/mrehkopf/sd2snes.git

WORKDIR /work/sd2snes

# apply patch to resolve compiler errors. patch is based on this exact commit:
# commit 23898e3d3844d700bb8d86755dfc75f48589777f (HEAD -> develop, origin/develop, origin/HEAD)
# Author: ikari <otakon@gmx.net>
# Date:   Mon Feb 22 17:29:17 2021 +0100
COPY patch .
RUN patch -p1 < patch

# copy in necessary fpga_mini.bi3 which should be built by Quartus
COPY fpga_mini.bi3 ./verilog/sd2snes_mini/

RUN cd ./utils && make
RUN cd ./src/utils && make

# build the firmware image
RUN cd ./src && make CONFIG=config-mk3

# output is /work/sd2snes/src/obj-mk3/firmware.bi3
