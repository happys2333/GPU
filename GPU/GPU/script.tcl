############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2020 Xilinx, Inc. All Rights Reserved.
############################################################
open_project GPU
add_files GPU/GPUmain.v
add_files -tb GPU/GPU.v
open_solution "GPU"
set_part {xc7a100tfgg484-1}
create_clock -period 60 -name default
#source "./GPU/GPU/directives.tcl"
csim_design
csynth_design
cosim_design
export_design -format ip_catalog
