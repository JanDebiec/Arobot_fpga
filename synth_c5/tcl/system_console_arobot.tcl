# -----------------------------------------------------------------
# system_console_arobot.tcl
#
# 24.01.2017 JD based on:
# 2/20/2012 D. W. Hawkins (dwh@ovro.caltech.edu)
#
# JTAG-to-Avalon-MM tutorial SystemConsole commands for the
# BeMicro-SDK.
#
# adapted to design: arobot-fpga
#
#  Address       Device
# ---------      --------
#  0x0001_0040   8-bit LEDs (7-bits to the on-board LEDs)
set addr_led 0x10040
#  0x0001_0080   [1:0] switch state, 
set addr_sw 0x10080
#  0x0001_00C0   [2] push-button state
set addr_pb 0x100C0
#  0x0000_5000   light weight bridge
set addr_lw 0x5000
#
set period_offset 	0x04
set ramp_offset 	0x08
set velocity_offset 0x0C

# -----------------------------------------------------------------

# =================================================================
# Master access
# =================================================================
#
# -----------------------------------------------------------------
# Open the JTAG master service
# -----------------------------------------------------------------

# Open the first Avalon-MM master service
proc jtag_open {} {
	global jtag
	
	# Close any open service
	if {[info exists jtag(master)]} {
		jtag_close
	}
	
	set master_paths [get_service_paths master]
	if {[llength $master_paths] == 0} {
		puts "Sorry, no master nodes found"
		return
	}

	# Select the first master service
	set jtag(master) [lindex $master_paths 0]

	open_service master $jtag(master)
	return
}

# -----------------------------------------------------------------
# Close the JTAG master service
# -----------------------------------------------------------------
#
proc jtag_close {} {
	global jtag

	if {[info exists jtag(master)]} {
		close_service master $jtag(master)
		unset jtag(master)
	}
	return
}

# =================================================================
# Master commands
# =================================================================
#
# LED read
proc led_read {} {
	global jtag
	global addr_led
	if {![info exists jtag(master)]} {
		jtag_open
	}
	return [master_read_8 $jtag(master) $addr_led 1]
#	return [master_read_8 $jtag(master) 0x10040 1]
addr_led
}

# LED write
proc led_write {val} {
	global jtag
	global addr_led
	if {![info exists jtag(master)]} {
		jtag_open
	}
	master_write_8 $jtag(master) $addr_led $val
	return
}

# Switch read
proc sw {} {
	global jtag
	global addr_sw
	if {![info exists jtag(master)]} {
		jtag_open
	}
	set data [master_read_8 $jtag(master) $addr_sw 1]
	return [expr {$data & 0x3}]
}

# Push-button read
proc pb {} {
	global jtag
	global addr_pb
	if {![info exists jtag(master)]} {
		jtag_open
	}
	set data [master_read_8 $jtag(master) $addr_pb 1]
	return [expr {($data >> 2) & 1}]
}



# ligth weight bridge read (32-bit)
# * offset in bytes
proc lw_read {offset} {
	global jtag
	global addr_lw
	if {![info exists jtag(master)]} {
		jtag_open
	}
	set addr [expr {$addr_lw + ($offset & ~3)}]
	return [master_read_32 $jtag(master) $addr 1]
}

# ligth weight bridge write (32-bit)
# * offset in bytes,
proc lw_write {offset data} {
	global jtag
	global addr_lw
	if {![info exists jtag(master)]} {
		jtag_open
	}
#	set addr [expr {$addr_lw + ($offset & ~3)}]
    set addr [expr {$addr_lw + $offset}]
	master_write_32 $jtag(master) $addr $data
	return
}

# setting period
proc period {data} {
    global jtag
    global addr_lw
    global period_offset
    if {![info exists jtag(master)]} {
        jtag_open
    }
    set addr [expr {$addr_lw + $period_offset}]
    master_write_32 $jtag(master) $addr $data
    return
}

# setting ramp
proc ramp {data} {
    global jtag
    global addr_lw
    global ramp_offset
    if {![info exists jtag(master)]} {
        jtag_open
    }
    set addr [expr {$addr_lw + $ramp_offset}]
    master_write_32 $jtag(master) $addr $data
    return
}

# setting velocity
proc velocity {data} {
    global jtag
    global addr_lw
    global velocity_offset
    if {![info exists jtag(master)]} {
        jtag_open
    }
    set addr [expr {$addr_lw + $velocity_offset}]
    master_write_32 $jtag(master) $addr $data
    return
}



led_write 0x7

