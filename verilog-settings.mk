HOST = LINUX
#XILINX_HOME = /opt/Xilinx/14.7/ISE_DS
#XILINX_BIN = $(XILINX_HOME)/ISE/bin/lin64
#XILINX_PATHS = ISE/bin/lin64 ISE/lib/lin64 PlanAhead/bin EDK/bin/lib64 EDK/lib/lin64
INTEL_BIN = LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libtcmalloc_minimal.so.4 LD_LIBRARY_PATH=/opt/intelFPGA_lite/20.1/quartus/linux64 /opt/intelFPGA_lite/20.1/quartus/linux64

# specify number of concurrent SmartXPlorer runs
XPLORER_CPUS = 8
XPLORER_PARAMS  = -sf currentProps.stratfile -host_list hostlistfile.txt
XPLORER_PARAMS += -max_runs 99 -best_n_runs 1
