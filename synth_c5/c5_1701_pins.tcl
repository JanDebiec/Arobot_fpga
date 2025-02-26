#TODO define pins as in orcad schema
#============================================================
# ARDUINO
#============================================================
set_location_assignment PIN_AG13 -to isl_SerialRx
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to isl_SerialRx
set_location_assignment PIN_AF13 -to osl_SerialTx
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to osl_SerialTx
#set_location_assignment PIN_AG13 -to ARDUINO_IO[0]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ARDUINO_IO[0]
#set_location_assignment PIN_AF13 -to ARDUINO_IO[1]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ARDUINO_IO[1]
set_location_assignment PIN_AG10 -to ARDUINO_IO[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ARDUINO_IO[2]
set_location_assignment PIN_AG9 -to ARDUINO_IO[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ARDUINO_IO[3]
set_location_assignment PIN_U14 -to ARDUINO_IO[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ARDUINO_IO[4]
set_location_assignment PIN_U13 -to ARDUINO_IO[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ARDUINO_IO[5]
set_location_assignment PIN_AG8 -to ARDUINO_IO[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ARDUINO_IO[6]
set_location_assignment PIN_AH8 -to ARDUINO_IO[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ARDUINO_IO[7]
set_location_assignment PIN_AF17 -to ARDUINO_IO[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ARDUINO_IO[8]
set_location_assignment PIN_AE15 -to ARDUINO_IO[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ARDUINO_IO[9]
set_location_assignment PIN_AF15 -to ARDUINO_IO[10]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ARDUINO_IO[10]
set_location_assignment PIN_AG16 -to ARDUINO_IO[11]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ARDUINO_IO[11]
set_location_assignment PIN_AH11 -to ARDUINO_IO[12]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ARDUINO_IO[12]
set_location_assignment PIN_AH12 -to ARDUINO_IO[13]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ARDUINO_IO[13]
set_location_assignment PIN_AH9 -to ARDUINO_IO[14]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ARDUINO_IO[14]
set_location_assignment PIN_AG11 -to ARDUINO_IO[15]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ARDUINO_IO[15]
set_location_assignment PIN_AH7 -to ARDUINO_RESET_N
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ARDUINO_RESET_N

#============================================================
# CLOCK
#============================================================
set_location_assignment PIN_V11 -to FPGA_CLK1_50
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to FPGA_CLK1_50
set_location_assignment PIN_Y13 -to FPGA_CLK2_50
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to FPGA_CLK2_50
set_location_assignment PIN_E11 -to FPGA_CLK3_50
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to FPGA_CLK3_50

#============================================================
# HPS
# in orig qsf file
#============================================================
#============================================================
# KEY
#============================================================
set_location_assignment PIN_AH17 -to KEY[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to KEY[0]
set_location_assignment PIN_AH16 -to KEY[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to KEY[1]

#============================================================
# LED
#============================================================
set_location_assignment PIN_W15 -to LED[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LED[0]
set_location_assignment PIN_AA24 -to LED[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LED[1]
set_location_assignment PIN_V16 -to LED[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LED[2]
set_location_assignment PIN_V15 -to LED[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LED[3]
set_location_assignment PIN_AF26 -to LED[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LED[4]
set_location_assignment PIN_AE26 -to LED[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LED[5]
set_location_assignment PIN_Y16 -to LED[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LED[6]
set_location_assignment PIN_AA23 -to LED[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LED[7]

#============================================================
# SW
#============================================================
set_location_assignment PIN_L10 -to SW[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[0]
set_location_assignment PIN_L9 -to SW[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[1]
set_location_assignment PIN_H6 -to SW[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[2]
set_location_assignment PIN_H5 -to SW[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[3]

#============================================================
# GPIO_0, GPIO connect to GPIO Default
#============================================================
set_location_assignment PIN_V12 -to osl_slice_tick
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to osl_slice_tick
#set_location_assignment PIN_V12 -to GPIO_0[0]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[0]

set_location_assignment PIN_AF7 -to osl_outX1B
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to osl_outX1B
#set_location_assignment PIN_AF7 -to GPIO_0[1]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[1]

set_location_assignment PIN_W12 -to osl_outX2A
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to osl_outX2A
#set_location_assignment PIN_W12 -to GPIO_0[2]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[2]

set_location_assignment PIN_AF8 -to osl_outX2B
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to osl_outX2B
#set_location_assignment PIN_AF8 -to GPIO_0[3]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[3]

set_location_assignment PIN_Y8 -to osl_outX1A
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to osl_outX1A
#set_location_assignment PIN_Y8 -to GPIO_0[4]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[4]

set_location_assignment PIN_AB4 -to GPIO_0[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[5]
set_location_assignment PIN_W8 -to GPIO_0[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[6]
set_location_assignment PIN_Y4 -to GPIO_0[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[7]
set_location_assignment PIN_Y5 -to GPIO_0[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[8]
set_location_assignment PIN_U11 -to GPIO_0[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[9]
set_location_assignment PIN_T8 -to GPIO_0[10]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[10]
set_location_assignment PIN_T12 -to GPIO_0[11]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[11]
set_location_assignment PIN_AH5 -to GPIO_0[12]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[12]
set_location_assignment PIN_AH6 -to GPIO_0[13]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[13]
set_location_assignment PIN_AH4 -to GPIO_0[14]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[14]
set_location_assignment PIN_AG5 -to GPIO_0[15]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[15]
set_location_assignment PIN_AH3 -to GPIO_0[16]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[16]
set_location_assignment PIN_AH2 -to GPIO_0[17]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[17]
set_location_assignment PIN_AF4 -to GPIO_0[18]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[18]
set_location_assignment PIN_AG6 -to GPIO_0[19]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[19]
set_location_assignment PIN_AF5 -to GPIO_0[20]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[20]
set_location_assignment PIN_AE4 -to GPIO_0[21]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[21]
set_location_assignment PIN_T13 -to GPIO_0[22]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[22]
set_location_assignment PIN_T11 -to GPIO_0[23]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[23]
set_location_assignment PIN_AE7 -to GPIO_0[24]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[24]
set_location_assignment PIN_AF6 -to GPIO_0[25]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[25]
set_location_assignment PIN_AF9 -to GPIO_0[26]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[26]
set_location_assignment PIN_AE8 -to GPIO_0[27]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[27]
set_location_assignment PIN_AD10 -to GPIO_0[28]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[28]
set_location_assignment PIN_AE9 -to GPIO_0[29]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[29]
set_location_assignment PIN_AD11 -to GPIO_0[30]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[30]
set_location_assignment PIN_AF10 -to GPIO_0[31]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[31]
set_location_assignment PIN_AD12 -to GPIO_0[32]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[32]
set_location_assignment PIN_AE11 -to GPIO_0[33]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[33]
set_location_assignment PIN_AF11 -to GPIO_0[34]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[34]
set_location_assignment PIN_AE12 -to GPIO_0[35]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[35]

#============================================================
# GPIO_1, GPIO connect to GPIO Default
#============================================================

set_location_assignment PIN_Y15 -to GPIO_1[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[0]
#test
set_location_assignment PIN_AG28 -to osl_PerfTest
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to osl_PerfTest
#set_location_assignment PIN_AG28 -to GPIO_1[1]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[1]
set_location_assignment PIN_AA15 -to GPIO_1[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[2]
set_location_assignment PIN_AH27 -to GPIO_1[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[3]
set_location_assignment PIN_AG26 -to GPIO_1[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[4]

#osl_DacDin
set_location_assignment PIN_AH24 -to osl_DacDin
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to osl_DacDin
#set_location_assignment PIN_AH24 -to GPIO_1[5]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[5]

set_location_assignment PIN_AF23 -to GPIO_1[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[6]

#osl_DacSn
set_location_assignment PIN_AE22 -to osl_DacSn
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to osl_DacSn
#set_location_assignment PIN_AE22 -to GPIO_1[7]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[7]

set_location_assignment PIN_AF21 -to GPIO_1[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[8]

#osl_DacClk
set_location_assignment PIN_AG20 -to osl_DacClk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to osl_DacClk
#set_location_assignment PIN_AG20 -to GPIO_1[9]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[9]

set_location_assignment PIN_AG19 -to GPIO_1[10]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[10]

#osl_IlxRog
set_location_assignment PIN_AF20 -to osl_IlxRog
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to osl_IlxRog
#set_location_assignment PIN_AF20 -to GPIO_1[11]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[11]

#osl_IlxShSw
set_location_assignment PIN_AC23 -to osl_IlxShSw
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to osl_IlxShSw
#set_location_assignment PIN_AC23 -to GPIO_1[12]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[12]

# not used
set_location_assignment PIN_AG18 -to GPIO_1[13]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[13]

#osl_IlxClk
set_location_assignment PIN_AH26 -to osl_IlxClk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to osl_IlxClk
#set_location_assignment PIN_AH26 -to GPIO_1[14]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[14]

# ADC-clk
set_location_assignment PIN_AA19 -to osl_AdcClk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to osl_AdcClk
#set_location_assignment PIN_AA19 -to GPIO_1[15]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[15]

set_location_assignment PIN_AG24 -to islv12_AdcData[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to islv12_AdcData[0]
#set_location_assignment PIN_AG24 -to GPIO_1[16]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[16]
set_location_assignment PIN_AF25 -to islv12_AdcData[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to islv12_AdcData[1]
#set_location_assignment PIN_AF25 -to GPIO_1[17]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[17]
set_location_assignment PIN_AH23 -to islv12_AdcData[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to islv12_AdcData[2]
#set_location_assignment PIN_AH23 -to GPIO_1[18]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[18]
set_location_assignment PIN_AG23 -to islv12_AdcData[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to islv12_AdcData[3]
#set_location_assignment PIN_AG23 -to GPIO_1[19]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[19]
set_location_assignment PIN_AE19 -to islv12_AdcData[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to islv12_AdcData[4]
#set_location_assignment PIN_AE19 -to GPIO_1[20]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[20]
set_location_assignment PIN_AF18 -to islv12_AdcData[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to islv12_AdcData[5]
#set_location_assignment PIN_AF18 -to GPIO_1[21]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[21]
set_location_assignment PIN_AD19 -to islv12_AdcData[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to islv12_AdcData[6]
#set_location_assignment PIN_AD19 -to GPIO_1[22]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[22]
set_location_assignment PIN_AE20 -to islv12_AdcData[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to islv12_AdcData[7]
#set_location_assignment PIN_AE20 -to GPIO_1[23]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[23]

set_location_assignment PIN_AE24 -to GPIO_1[24]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[24]
set_location_assignment PIN_AD20 -to GPIO_1[25]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[25]
set_location_assignment PIN_AF22 -to GPIO_1[26]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[26]
set_location_assignment PIN_AH22 -to GPIO_1[27]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[27]

set_location_assignment PIN_AH19 -to islv12_AdcData[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to islv12_AdcData[8]
#set_location_assignment PIN_AH19 -to GPIO_1[28]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[28]
set_location_assignment PIN_AH21 -to islv12_AdcData[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to islv12_AdcData[9]
#set_location_assignment PIN_AH21 -to GPIO_1[29]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[29]
set_location_assignment PIN_AG21 -to islv12_AdcData[10]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to islv12_AdcData[10]
#set_location_assignment PIN_AG21 -to GPIO_1[30]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[30]
set_location_assignment PIN_AH18 -to islv12_AdcData[11]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to islv12_AdcData[11]
#set_location_assignment PIN_AH18 -to GPIO_1[31]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[31]
set_location_assignment PIN_AD23 -to osl_AdcOtr
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to osl_AdcOtr
#set_location_assignment PIN_AD23 -to GPIO_1[32]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[32]
set_location_assignment PIN_AE23 -to isl_AdcMode
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to osl_AdcMode
#set_location_assignment PIN_AE23 -to GPIO_1[33]
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[33]

set_location_assignment PIN_AA18 -to GPIO_1[34]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[34]
set_location_assignment PIN_AC22 -to GPIO_1[35]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[35]

#============================================================
# End of pin assignments by Terasic System Builder
#============================================================

