do e:/project/msystem/msystem/soft_fpga/vu/vunit_out/test_output/dea86e9cdcae3595a81dd8a6effabe1f1014b925/modelsim/common.do
quietly set failed [vunit_load]
if {$failed} {quit -f -code 1}
quietly set failed [vunit_run]
if {$failed} {quit -f -code 1}
quit -f -code 0
