# use a recent ARM compiler
FROM stronglytyped/arm-none-eabi-gcc:latest

# install necessary build tools:
RUN apt-get update && apt-get install -y gawk unzip curl
RUN curl https://getmic.ro | bash
RUN cp /work/micro /usr/local/bin/

# clone develop from sd2snes firmware repo:
#RUN git clone --depth 1 https://github.com/mrehkopf/sd2snes.git
ADD ./sd2snes /work/sd2snes

WORKDIR /work/sd2snes

# apply patch to resolve compiler errors. patch is based on this exact commit:
# commit fe15b2f3a2aba6312eb56a31f853434ddd7c7771 (HEAD -> develop, origin/develop, origin/HEAD)
# Author: redacted173 <67377137+redacted173@users.noreply.github.com>
# Date:   Mon Aug 2 09:18:48 2021 -0700
COPY patch .
RUN patch -p1 < patch

# copy in necessary fpga_mini.bi3 which should be built by Quartus
COPY fpga_mini.bi3 ./verilog/sd2snes_mini/

RUN cd ./utils && make
RUN cd ./src/utils && make

# build the firmware image
RUN cd ./src && make CONFIG=config-mk3

# output is /work/sd2snes/src/obj-mk3/firmware.bi3
