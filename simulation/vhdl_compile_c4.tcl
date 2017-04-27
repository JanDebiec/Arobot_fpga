# First we import the files listed in our one and only FileList file :)
#
source vhdl_files_c4.tcl
#
# We work only with the modelsim standard lib
#
# At first we clean the working lib

if {[file exists work]} {
    vdel -lib work -all
}

foreach {section file_list} $ProjectFileList {
    # if we work with more than one library
    # then this is the point to change
    vlib work
    vmap work work
    #
    foreach file $file_list {
	if [regexp {.vhdl?$} $file] {
	    if [ catch {vcom -2008 $file} RetVal ] {
		return -code error $RetVal
	    }
    }
}

    if { [catch {exec vmake > makefile} RetVal] } {
	return -code error $RetVal
    }

    puts "***********"
    puts "All files compiled - makefile generated"
    puts "***********"
}

