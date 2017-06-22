# At first we call the makeVHDL to compile all VHDL files
# Later release will call a external make file tool

source vhdl_files_c4.tcl

# Next we define to functions for easier modelsim simulation
# At this time we need the name of the toplevel vhdl simulation entity

global TopEntity; set TopEntity [regsub {\.vhd$} $TopFileName {}]

proc m  {} { exec make; eval {restart -f} }

proc r  {} { global TopFileName; uplevel #0 source vhdl_simulate.tcl }

proc rr {} { global TopFileName; global last_compile_time; set last_compile_time 0; r }

proc q  {} { quit -force }

# Compile out of date files

set time_now [clock seconds]

if [catch {set last_compile_time}] {
    set last_compile_time 0
}

#
#----------------------------------------------------------------------------------------
#
foreach {section file_list} $ProjectFileList {
    # if we work with more than one library
    # then this is the point to change
    vlib work
    vmap work work
    #
    foreach file $file_list {
	if { $last_compile_time < [file mtime $file] } {
	    puts -nonewline "LastCompiletime: $last_compile_time"
	    puts "    FileTime: [file mtime $file]"
	    set last_compile_time 0
	    vcom -2008 $file	    
	}
    }
}

#if { [catch {exec vmake > makefile} RetVal] } {
#    return -code error $RetVal
#}

set last_compile_time $time_now


if {[info exists simReso]} {
    eval vsim {$TopEntity -t $simReso}
} else {
    eval vsim {$TopEntity -t ps}
}

#lw

puts "TopEntity: $TopEntity"

#puts [file normalize [info script]]

if {[file exists $TopEntity.do]} {
    puts "Call old Do-file"
    eval do $TopEntity.do
}

puts {
		  Script commands are:

	          m   = Recompile changed and dempenent files with MAKE and restart
		  r   = Recompile changed and dependent files
		  rr  = Recompile everything
		  q   = Quit without confirmation


	  }

#--------------------------------------------------------------------------------------------------
# Name  :
# Input :
# Output:
# Info  :
#--------------------------------------------------------------------------------------------------

