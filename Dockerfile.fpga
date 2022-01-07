# use a recent ARM compiler
FROM stronglytyped/arm-none-eabi-gcc:latest AS install

WORKDIR /work/quartus
RUN wget https://download.altera.com/akdlm/software/acdsinst/20.1std.1/720/ib_tar/Quartus-lite-20.1.1.720-linux.tar
RUN tar xf Quartus-lite-20.1.1.720-linux.tar && \
	./setup.sh --mode unattended --accept_eula 1 --installdir /opt/intelFPGA_lite/20.1 --disable-components quartus_help,modelsim_ase,modelsim_ae,cyclone10lp,cyclonev,max,max10,arria_lite && \
	rm -fr *

######################################################

FROM stronglytyped/arm-none-eabi-gcc:latest

COPY --from=install /opt /opt

# available components: discover with `./setup.sh --help`
# quartus quartus_help devinfo arria_lite cyclone cyclone10lp cyclonev max max10 quartus_update modelsim_ase modelsim_ae

# install necessary build tools:
WORKDIR /work
RUN apt update && apt install -y gawk unzip curl libglib2.0-0 libtcmalloc-minimal4
RUN curl https://getmic.ro | bash ; cp micro /usr/local/bin/

# LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libtcmalloc_minimal.so.4 LD_LIBRARY_PATH=/opt/intelFPGA_lite/20.1/quartus/linux64
RUN mv /opt/intelFPGA_lite/20.1/quartus/linux64/libboost_system.so /opt/intelFPGA_lite/20.1/quartus/linux64/libboost_system.so.disabled ; \
	mv /opt/intelFPGA_lite/20.1/quartus/linux64/libccl_curl_drl.so /opt/intelFPGA_lite/20.1/quartus/linux64/libccl_curl_drl.so.disabled ; \
	mv /opt/intelFPGA_lite/20.1/quartus/linux64/libstdc++.so.6 /opt/intelFPGA_lite/20.1/quartus/linux64/libstdc++.so.6.disabled ; \
	mv /opt/intelFPGA_lite/20.1/quartus/linux64/libstdc++.so /opt/intelFPGA_lite/20.1/quartus/linux64/libstdc++.so.disabled

# clone develop from sd2snes firmware repo:
#RUN git clone --depth 1 https://github.com/mrehkopf/sd2snes.git
ADD ./sd2snes /work/sd2snes

WORKDIR /work/sd2snes

# override verilog/settings.mk with linux-specific Quartus 20.1 paths and env var overrides:
ADD ./verilog-settings.mk verilog/settings.mk

# these are required build steps for utilities:
RUN cd ./utils && make
RUN cd ./src/utils && make

# build the fpga_base.bi3 file:
RUN cd ./verilog/sd2snes_base && make mk3
# output is /work/sd2snes/verilog/sd2snes_base/fpga_base.bi3
RUN cd ./verilog/sd2snes_mini && make mk3
# output is /work/sd2snes/verilog/sd2snes_mini/fpga_mini.bi3

# PATCH to add a missing #include which otherwise breaks compilation
RUN sed -i '27 i #include <ctype.h>' ./src/sgb.c
RUN cd ./src && make CONFIG=config-mk3
# output is /work/sd2snes/src/firmware.im3
