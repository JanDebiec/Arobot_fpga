do e:/project/msystem/msystem/soft_fpga/vu/vunit_out/test_output/8fe6cdcc929d1a79705e6be9700c9261ec16801c/modelsim/common.do
# Do not exclude variables from log
if {![vunit_load -vhdlvariablelogging]} {
  quietly set WildcardFilter [lsearch -not -all -inline $WildcardFilter Process]
  quietly set WildcardFilter [lsearch -not -all -inline $WildcardFilter Variable]
  quietly set WildcardFilter [lsearch -not -all -inline $WildcardFilter Constant]
  quietly set WildcardFilter [lsearch -not -all -inline $WildcardFilter Generic]
  log -recursive /*"
  quietly set WildcardFilter default
  vunit_run
}
