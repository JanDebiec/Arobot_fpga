#
# We have a problem with the different path separator !!
# Because the vhdl files can only be in source or testbench 
# we check if we find them there and then we start the 
# compile process
#


if [regexp {.vhdl?$} $FullFileName] {

    vlib work
    vmap work work

    if [ catch {vcom -2008 $FullFileName} RetVal ] {
	    return -code error $RetVal	    
    }

} else {
    puts "No valid VHDL File"
    puts "Filename is: $FullFileName"
    puts "quit"
}


