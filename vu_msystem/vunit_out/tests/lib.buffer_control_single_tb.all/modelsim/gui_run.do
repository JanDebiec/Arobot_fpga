do e:/project/msystem/msystem/soft_fpga/vu/vunit_out/tests/lib.buffer_control_single_tb.all/modelsim/common.do
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
