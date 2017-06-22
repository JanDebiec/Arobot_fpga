# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2014-2015, Lars Asplund lars.anders.asplund@gmail.com

from os.path import join, dirname
from vunit import VUnit

root = dirname(__file__)

pathIP = "../ip/"

ipFiles = [
"mul_equ/mul_equ.vhd",
"sub_cds/sub_cds.vhd",
"sub_dark/sub_dark.vhd"
]

pathSource = "../src_v/"

sourcesList = [
"msystem_typedef_pkg.vhd",
"msystem_constant_pkg.vhd",
"flipflop_sre.vhd",
"flipflop_d1.vhd",
"monoshot.vhd",
"delay2.vhd",
"recalc_with_refs.vhd",
"cds.vhd",
"h2flw_interface.vhd",
"runtime_control_1603.vhd",
"common_calc_1603.vhd",
"common_addr_1603.vhd",
"common_ctrl_1603.vhd",
"buffers_control_1603.vhd"
]

pathTB = "../testbench/"

testbenchList = [
"msystem_stim_tcc_pkg.vhd",
"msystem_stim_fp_pkg.vhd",
#"flipflop_sre_tb.vhd",
#"flipflop_d1_tb.vhd",
#"delay2_tb.vhd",
#"h2f_if_tb.vhd",
#"buffer_control_single_tb.vhd",
#"runtime_control_1603_tb.vhd",
#"common_calc_1603_tb.vhd",
#"common_addr_1603_tb.vhd",
#"common_ctrl_1603_tb.vhd",
"buffer_control_1603_tb.vhd",
]

sourceListWithPath = []
for file in sourcesList:
    fileName = root + pathSource + file
    sourceListWithPath.append(fileName)
    
tbListWithPath = []
for file in testbenchList:
    fileName = root + pathTB + file
    tbListWithPath.append(fileName)

ipListWithPath = []
for file in ipFiles:
    fileName = root + pathIP + file
    ipListWithPath.append(fileName)
        

ui = VUnit.from_argv()
lib = ui.add_library("lib")
lib.add_source_files(ipListWithPath)
lib.add_source_files(sourceListWithPath)
lib.add_source_files(tbListWithPath)
ui.main()
