#########################################################################
# This file and the associated documentation are confidential 
# and proprietary to Synopsys, Inc. 
#
# Copyright (c), 2008-2009 Synopsys, Inc. All rights reserved.
#
# DISCLAIMER
# The information contained herein is provided by Synopsys, Inc. on 
# an "AS IS" basis without any warranty, and Synopsys has no obligation 
# to support or otherwise maintain the information.
#
# Synopsys, Inc. disclaims any representation that the information 
# does not infringe any intellectual property rights or proprietary
# rights of any third parties. There are no other warranties given by
# Synopsys, whether express, implied or statutory, including, without
# limitation, implied warranties of merchantability and fitness for a
# particular purpose.
#
# Synopsys, Inc. reserves the right to make changes to the information 
# at any time and without notice.
#
#########################################################################

##########################################################################
# Procedure used for setting the MIM Capacitor properties depending on various 
# Entry modes.
# DEVICE TYPE    Capacitor
# SUPPORTFILE    CallbackSupport.tcl
# DESCRIPTION    "2-Terminal MIM Capacitor"
##########################################################################

#callback procedure starts here

proc starcMS90G_NPNV050_CB { instID paramName } {
	
    # get current instance and parameter	
#    set inst [db::getCurrentRef]
    set inst $instID
    set param [db::getCurrentParam]
   
    # Fetch tech properties
    set spice_model [starcMS90G_symGetParam model $inst]

    

    # Fetch Design rules  
    starcMS90G_getNpnvDRValues [db::getAttr design -of $inst] tech layer keys mod

    # Get data base unit, grid precision
    set dbu   $tech(dataBaseUnitValue)
    set grid  $tech(minimumGridValue)

    # Fetch common Parameters from CDF data
    set m         [starcMS90G_symGetParam m $inst]
    set area      [starcMS90G_symGetParam area $inst]

    set m_orig [starcMS90G_getOrigValue m $inst]
    set area_orig [starcMS90G_getOrigValue area $inst]
    set ta_orig [starcMS90G_getOrigValue ta $inst]

    set minM      1
    set maxM      100
    # Check if parameter value is an non zero and +ve integer.



    # Calculations 
#    puts "M0 $m"
    switch $paramName {

	"m" {
	    set param_check [starcMS90G_symCheckParam [starcMS90G_symGetParam m $inst] $spice_model $inst m]
	    if {[lindex $param_check 0 ] == -1 } {
		starcMS90G_symSetParam m $m_orig $inst
		starcMS90G_symSetParam ta $ta_orig $inst
		return
	    }

	    if { ![starcMS90G_symIsVariable [starcMS90G_symGetParam m $inst]] } {
		set m         [starcMS90G_symGetParam m $inst] 
		set param_check [starcMS90G_symCheckParam [starcMS90G_symGetParam m $inst] $spice_model $inst m]
		if {[lindex $param_check 0 ] == -1 } {
		    starcMS90G_symSetParam m $m_orig $inst
		    starcMS90G_symSetParam ta $ta_orig $inst
		    return
		}

		set param_check [starcMS90G_symCheckInteger m [starcMS90G_symGetParam m $inst] $spice_model $inst ]
		if {[lindex $param_check 0 ] == -1 } {
		    starcMS90G_symSetParam m $m_orig $inst
		    starcMS90G_symSetParam ta $ta_orig $inst
		    return
		}
		starcMS90G_symSetParam m $m $inst

#		puts "M $m $minM "	
		set param_check  [starcMS90G_symCheckNoModParamValue m $m $minM $maxM $m_orig 0 1 $spice_model $inst $paramName]
		if {[lindex $param_check 0 ] == -1 } {
		    starcMS90G_symSetParam m $m_orig $inst
		    starcMS90G_symSetParam ta $ta_orig $inst
		    return
		}
#		starcMS90G_symSetParam m $m $inst
		set area [starcMS90G_engToSci $area ]
		set ta [expr $m * $area ]
		starcMS90G_symSetParam ta $ta $inst
	    } else {
		set ta "iPar(\"area\") * iPar(\"m\")"
		starcMS90G_symSetParam ta $ta $inst
	    }
    
	}
    }
}




		

