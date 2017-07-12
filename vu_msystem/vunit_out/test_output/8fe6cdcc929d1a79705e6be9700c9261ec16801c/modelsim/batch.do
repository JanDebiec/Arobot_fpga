do e:/project/msystem/msystem/soft_fpga/vu/vunit_out/test_output/8fe6cdcc929d1a79705e6be9700c9261ec16801c/modelsim/common.do
quietly set failed [vunit_load]
if {$failed} {quit -f -code 1}
quietly set failed [vunit_run]
if {$failed} {quit -f -code 1}
quit -f -code 0
