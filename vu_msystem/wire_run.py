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
"globals/msystem_typedef_pkg.vhd",
"globals/msystem_constant_pkg.vhd",
"basics/flipflop_sre.vhd",
"basics/flipflop_d1.vhd",
"basics/flipflop_dn.vhd",
"basics/monoshot.vhd",
"basics/delay2.vhd",
"basics/mono_on_border.vhd",
"wire_transmitter.vhd",
"clock_divider.vhd",
"dac_controllerer.vhd",
]

pathTB = "../testbench/"

testbenchList = [
"msystem_stim_tcc_pkg.vhd",
"msystem_stim_fp_pkg.vhd",
"wire_transmitter_tb.vhd",
"clock_divider_tb.vhd",
"mono_on_border_tb.vhd",
"dac_controller_tb.vhd",
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
