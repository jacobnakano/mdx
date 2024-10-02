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
#
#  c is not editable
#  unitc is editable
#  nrows is editable
#  ncols is editable
#  l is editable


proc starcMS90G_CM123_CB { instID paramName } {
	
    # get current instance and parameter	
#    set inst [db::getCurrentRef]
    set inst $instID
    set param [starcMS90G_getCurrentParam]
   
    # Fetch tech properties
    set spice_model [starcMS90G_symGetParam model $inst]

    
    set threshold 0.001 
    # checking for space and replace with "none"
    set paramList [list unitc l nrows ncolumns]
    foreach param1 $paramList {
        if {[starcMS90G_symIsVariable [starcMS90G_symGetParam $param1 $inst]]==3} {
            if {[regsub -all {[ \r\t\n]+} [starcMS90G_symGetParam $param1 $inst] "" outline]} {
                #gftk_setParamValue $param1 $outline $inst
		starcMS90G_setParamValue $param1 $outline $inst 1
            } 
        }
    }    

    # add extra "u" if missing 
#    set paramList [list l ]
#    foreach param1 $paramList {
#        if {![starcMS90G_symIsVariable [starcMS90G_symGetParam $param1 $inst]]} {
#            set val [starcMS90G_engToSci [starcMS90G_symGetParam $param1 $inst]]
#            if {$val > $threshold} {
#                set val [expr $val*1e-6] 
#                starcMS90G_symSetParam $param1 [starcMS90G_sciToEng $val] $inst
#            }
#        } 	  
#    }
#
#    # Check for invalid inputs, variables.
#    set checkparamlist {unitc l nrows ncolumns}
#    foreach i $checkparamlist {
#        starcMS90G_symCheckParam [starcMS90G_symGetParam $i $inst] $spice_model $inst $i
#    }   

    # Fetch Design rules  
    starcMS90G_getCapDRValues [starcMS90G_getAttrDesign $inst] tech layer keys mod

    # Get data base unit, grid precision
    set dbu   $tech(dataBaseUnitValue)
    set grid  $tech(minimumGridValue)

    # Fetch common Parameters from CDF data
    set unitc         [starcMS90G_symGetParam unitc $inst]
    set len         [starcMS90G_symGetParam l $inst]
    set nrows         [starcMS90G_symGetParam nrows $inst]
    set ncolumns      [starcMS90G_symGetParam ncolumns $inst]


    set unitc_orig [starcMS90G_getOrigValue unitc $inst]
    set csub_orig  [starcMS90G_getOrigValue csub $inst]
    set c_orig  [starcMS90G_getOrigValue c $inst]
    set l_orig  [starcMS90G_getOrigValue l $inst]
    set nrows_orig  [starcMS90G_getOrigValue nrows $inst]
    set ncolumns_orig  [starcMS90G_getOrigValue ncolumns $inst]


    set minLength   [starcMS90G_symU2M  $keys(minLength_$spice_model)]
    set maxLength   [starcMS90G_symU2M $keys(maxLength_$spice_model)]
    set minRows    $keys(minRows_$spice_model)
    set maxRows    $keys(maxRows_$spice_model)
    set minCols    $keys(minCols_$spice_model)
    set maxCols    $keys(maxCols_$spice_model)

#    puts "DEBUG: ROWS:$rows COLS: $columns GRID: $grid $dbu"
    # Check if parameter value is an non zero and +ve integer.
#    set rows [starcMS90G_symCheckInteger nrows $rows $spice_model $inst]
#    starcMS90G_symSetParam nrows $rows $inst
#    set columns [starcMS90G_symCheckInteger ncolumns $columns $spice_model $inst]
#    starcMS90G_symSetParam ncolumns $columns $inst

    # l cannot be a variable. check and fix it
#    if { [starcMS90G_symIsVariable [starcMS90G_symGetParam l $inst]] } {
#	puts "WARNING 006> Parameter 'l' is a variable or negative. Resetting it to $minLength"
#	starcMS90G_symSetParam l $minLength  $inst
#	set l $minLength
#    }


    # Calculations 
    switch $paramName {
	"unitc" {
	    # check if the entry is valid , it not reject it outright
	    set param_check [starcMS90G_symCheckParam [starcMS90G_symGetParam unitc $inst] $spice_model $inst unitc]
	    if {[lindex $param_check 0 ] == -1 } {
		    starcMS90G_symSetParam l $l_orig $inst
		    starcMS90G_symSetParam unitc $unitc_orig $inst
		    starcMS90G_symSetParam csub $csub_orig $inst
		    starcMS90G_symSetParam c $c_orig $inst
		    starcMS90G_symSetParam nrows $nrows_orig $inst
		    starcMS90G_symSetParam ncolumns $ncolumns_orig $inst
		    ics_rollbackCdfgData $instID
		    return
		}
	    set l_var 0
	    set unitc_var 0
	    if { ![starcMS90G_symIsVariable [starcMS90G_symGetParam unitc $inst]] } {
		set len [expr ( [starcMS90G_engToSci $unitc ] / 548e-15 ) * 40e-6 ]
		#		puts "LEN: $len"
		set len_grid  [starcMS90G_symGridCheck $len $grid $dbu]
		set length [starcMS90G_symCheckNoModParamValue l $len_grid \
				$minLength $maxLength $l_orig 0 1   $spice_model $inst $param]		    
#		puts "length $length"
		if {[lindex $length 0 ] == 0 } {
		    set length [lindex $length 1]
		    starcMS90G_symSetParam l [starcMS90G_sciToEng $length] $inst
		    set l $length
		} else {
		    starcMS90G_symSetParam l $l_orig $inst
		    starcMS90G_symSetParam unitc $unitc_orig $inst
		    starcMS90G_symSetParam csub $csub_orig $inst
		    starcMS90G_symSetParam c $c_orig $inst
		    starcMS90G_symSetParam nrows $nrows_orig $inst
		    starcMS90G_symSetParam ncolumns $ncolumns_orig $inst
		    ics_rollbackCdfgData $instID
		    return
		}
		set unitcval [expr 548.0e-15 / 40.0e-06 * $length ]
		starcMS90G_symSetParam unitc [starcMS90G_sciToEng $unitcval] $inst
		if { ![starcMS90G_symIsVariable [starcMS90G_symGetParam unitc $inst]] &&
		     ![starcMS90G_symIsVariable [starcMS90G_symGetParam unitc $inst]] } { 
		    set cval [ expr $unitcval * $nrows * $ncolumns ]
		    starcMS90G_symSetParam c [starcMS90G_sciToEng $cval]  $inst
		    set csub [ expr ((140e-15*((60+2*$length  *1e6))/140)*$nrows*$ncolumns) ]
		    starcMS90G_symSetParam csub [starcMS90G_sciToEng $csub] $inst

		} else {
		    set c "(iPar(\"unitc\")*iPar(\"nrows\")*iPar(\"ncolumns\"))"
		    starcMS90G_symSetParam c $c $inst
		    set csub "(140f*((60+2*( iPar(\"l\")  *1e6))/140)*iPar(\"nrows\")*iPar(\"ncolumns\"))"
		    starcMS90G_symSetParam csub $csub $inst
		}
		
		
	    } else {
		set unitc_var 1
	    }

	    if { $unitc_var || $l_var } {
		set len "( (iPar(\"unitc\")/548f)*40*1e-6)"
		starcMS90G_symSetParam l $len $inst
		set c "(iPar(\"unitc\")*iPar(\"nrows\")*iPar(\"ncolumns\"))"
		starcMS90G_symSetParam c $c $inst
		set csub "(140f*((60+2*( iPar(\"l\")  *1e6))/140)*iPar(\"nrows\")*iPar(\"ncolumns\"))"
		starcMS90G_symSetParam csub $csub $inst
	    }
	}
	"l" {
	    set l  [starcMS90G_symGetParam l $inst]
	    if { [starcMS90G_symIsVariable [starcMS90G_symGetParam l  $inst]] } {	
		set msg ""
		append msg  "\n    *Error* ** $spice_model **\n"
		append msg  "      -> Parameter \"l\" Value \"$l\" is not a valid number\n"
		append msg  "      -> Parameter \"l\" cannot be a variable.\n"
		append msg  "      -> Rollback.\n"
		starcMS90G_prompt $msg 
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam unitc $unitc_orig $inst
		starcMS90G_symSetParam csub $csub_orig $inst
		starcMS90G_symSetParam c $c_orig $inst
		starcMS90G_symSetParam nrows $nrows_orig $inst
		starcMS90G_symSetParam ncolumns $ncolumns_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }



	    set param_check [starcMS90G_symCheckParam [starcMS90G_symGetParam l $inst] $spice_model $inst l]
	    if {[lindex $param_check 0 ] == -1 } {
		    starcMS90G_symSetParam l $l_orig $inst
		    starcMS90G_symSetParam unitc $unitc_orig $inst
		    starcMS90G_symSetParam csub $csub_orig $inst
		    starcMS90G_symSetParam c $c_orig $inst
		    starcMS90G_symSetParam nrows $nrows_orig $inst
		    starcMS90G_symSetParam ncolumns $ncolumns_orig $inst
		    ics_rollbackCdfgData $instID
		    return
		}

	    if { ![starcMS90G_symIsVariable [starcMS90G_symGetParam l $inst]] } {
		set len  [starcMS90G_symGetParam l $inst]
		set len  [starcMS90G_engToSciMaxRes $len ]
#		puts "LEN $len $grid $dbu"
                set len_grid  [starcMS90G_symGridCheck $len $grid $dbu]
		set length [starcMS90G_symCheckNoModParamValue l $len_grid \
				$minLength $maxLength $l_orig 0 1   $spice_model $inst $param]		    
#		puts "length $length"
		if {[lindex $length 0 ] == 0 } {
		    set length [lindex $length 1]
		    if {  [expr abs ([expr $len] - [expr $len_grid]) * 1e6] > 1e-18 } {
			append msg  "\n    *Error*  **\n"
			append msg  "      -> Parameter \"l\" Value \"$len\" is not on valid step\n"
			append msg  "      -> Rollback.\n"
			starcMS90G_prompt $msg 
			ics_rollbackCdfgData $instID
			return
		    } else {
			starcMS90G_symSetParam l [starcMS90G_sciToEng $length] $inst
			set l $length
		    }
		} else {
		    starcMS90G_symSetParam l $l_orig $inst
		    starcMS90G_symSetParam unitc $unitc_orig $inst
		    starcMS90G_symSetParam c $c_orig $inst
		    starcMS90G_symSetParam csub $csub_orig $inst
		    starcMS90G_symSetParam nrows $nrows_orig $inst
		    starcMS90G_symSetParam ncolumns $ncolumns_orig $inst
		    ics_rollbackCdfgData $instID
		    return
		}
		starcMS90G_symSetParam l [starcMS90G_sciToEng $length] $inst
		set unitcval [expr 548.0e-15 / 40.0e-06 * $length ]
		starcMS90G_symSetParam unitc [starcMS90G_sciToEng $unitcval] $inst

		if { ![starcMS90G_symIsVariable [starcMS90G_symGetParam nrows $inst]] && \
		     ![starcMS90G_symIsVariable [starcMS90G_symGetParam ncolumns $inst]] } { 
		    set cval [ expr $unitcval * $nrows * $ncolumns ]
		    starcMS90G_symSetParam c [starcMS90G_sciToEng $cval]  $inst
		    set csub [ expr ((140e-15*((60+2*$length  *1e6))/140)*$nrows*$ncolumns) ]
		    starcMS90G_symSetParam csub [starcMS90G_sciToEng $csub] $inst

		} else {
		    set c "(iPar(\"unitc\")*iPar(\"nrows\")*iPar(\"ncolumns\"))"
		    starcMS90G_symSetParam c $c $inst
		    set csub "(140f*((60+2*( iPar(\"l\")  *1e6))/140)*iPar(\"nrows\")*iPar(\"ncolumns\"))"
		    starcMS90G_symSetParam csub $csub $inst
		}
	    } else {
		set unitc "548f*((iPar(\"l\"))*1e6/40)"
		starcMS90G_symSetParam unitc $unitc $inst
		set c "(iPar(\"unitc\")*iPar(\"nrows\")*iPar(\"ncolumns\"))"
		starcMS90G_symSetParam c $c $inst
		set csub "(140f*((60+2*( iPar(\"l\")  *1e6))/140)*iPar(\"nrows\")*iPar(\"ncolumns\"))"
		starcMS90G_symSetParam csub $csub $inst
	    }
	}

	"nrows" {
	    set nrows  [starcMS90G_symGetParam nrows $inst]
	    if { [starcMS90G_symIsVariable [starcMS90G_symGetParam nrows  $inst]] } {	
		set msg ""
		append msg  "\n    *Error* ** $spice_model **\n"
		append msg  "      -> Parameter \"nrows\" Value \"$nrows\" is not a valid number\n"
		append msg  "      -> Parameter \"nrows\" cannot be a variable.\n"
		append msg  "      -> Rollback.\n"
		starcMS90G_prompt $msg 
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam unitc $unitc_orig $inst
		starcMS90G_symSetParam csub $csub_orig $inst
		starcMS90G_symSetParam c $c_orig $inst
		starcMS90G_symSetParam nrows $nrows_orig $inst
		starcMS90G_symSetParam ncolumns $ncolumns_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }
	    set param_check [starcMS90G_symCheckParam [starcMS90G_symGetParam nrows $inst] $spice_model $inst nrows]
	    if {[lindex $param_check 0 ] == -1 } {
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam unitc $unitc_orig $inst
		starcMS90G_symSetParam c $c_orig $inst
		starcMS90G_symSetParam csub $csub_orig $inst
		starcMS90G_symSetParam nrows $nrows_orig $inst
		starcMS90G_symSetParam ncolumns $ncolumns_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }
	    set param_check [starcMS90G_symCheckInteger nrows [starcMS90G_symGetParam nrows $inst] $spice_model $inst ]
	    if {[lindex $param_check 0 ] == -1 } {
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam unitc $unitc_orig $inst
		starcMS90G_symSetParam c $c_orig $inst
		starcMS90G_symSetParam csub $csub_orig $inst
		starcMS90G_symSetParam nrows $nrows_orig $inst
		starcMS90G_symSetParam ncolumns $ncolumns_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }
	    if { ![starcMS90G_symIsVariable [starcMS90G_symGetParam nrows $inst]] } {
		set param_check [starcMS90G_symCheckNoModParamValue nrows $nrows $minRows $maxRows $nrows_orig 0 1 $spice_model $inst $param]
		if {[lindex $param_check 0 ] == -1 } {
		    starcMS90G_symSetParam l $l_orig $inst
		    starcMS90G_symSetParam unitc $unitc_orig $inst
		    starcMS90G_symSetParam c $c_orig $inst
		    starcMS90G_symSetParam csub $csub_orig $inst
		    starcMS90G_symSetParam nrows $nrows_orig $inst
		    starcMS90G_symSetParam ncolumns $ncolumns_orig $inst
		    ics_rollbackCdfgData $instID
		    return
		}
		starcMS90G_symSetParam nrows $nrows $inst


		if { ![starcMS90G_symIsVariable [starcMS90G_symGetParam unitc $inst]] && \
			 ![starcMS90G_symIsVariable [starcMS90G_symGetParam nrows $inst]] && \
			 ![starcMS90G_symIsVariable [starcMS90G_symGetParam l $inst]] && \
			 ![starcMS90G_symIsVariable [starcMS90G_symGetParam ncolumns $inst]] } {
		    set unitc [starcMS90G_engToSci $unitc ]
		    set cval [ expr $unitc * $nrows * $ncolumns ]
		    starcMS90G_symSetParam c $cval $inst
		    set length  [starcMS90G_symGetParam l $inst]
		    set length  [starcMS90G_engToSci $length ]
		    set csub [ expr ((140e-15*((60+2*$length  *1e6))/140)*$nrows*$ncolumns) ]
		    starcMS90G_symSetParam csub [starcMS90G_sciToEng $csub] $inst
		} else {
		    set c "(iPar(\"unitc\")*iPar(\"nrows\")*iPar(\"ncolumns\"))"
		    starcMS90G_symSetParam c $c $inst
		    set csub "(140f*((60+2*( iPar(\"l\")  *1e6))/140)*iPar(\"nrows\")*iPar(\"ncolumns\"))"
		    starcMS90G_symSetParam csub $csub $inst
		}
	    }
	}
	"ncolumns" {
	    set ncolumns  [starcMS90G_symGetParam ncolumns $inst]
	    if { [starcMS90G_symIsVariable [starcMS90G_symGetParam ncolumns  $inst]] } {	
		set msg ""
		append msg  "\n    *Error* ** $spice_model **\n"
		append msg  "      -> Parameter \"ncolumns\" Value \"$ncolumns\" is not a valid number\n"
		append msg  "      -> Parameter \"ncolumns\" cannot be a variable.\n"
		append msg  "      -> Rollback.\n"
		starcMS90G_prompt $msg 
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam unitc $unitc_orig $inst
		starcMS90G_symSetParam csub $csub_orig $inst
		starcMS90G_symSetParam c $c_orig $inst
		starcMS90G_symSetParam nrows $nrows_orig $inst
		starcMS90G_symSetParam ncolumns $ncolumns_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }

	    set param_check [starcMS90G_symCheckParam [starcMS90G_symGetParam ncolumns $inst] $spice_model $inst ncolumns]
	    if {[lindex $param_check 0 ] == -1 } {
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam unitc $unitc_orig $inst
		starcMS90G_symSetParam c $c_orig $inst
		starcMS90G_symSetParam csub $csub_orig $inst
		starcMS90G_symSetParam nrows $nrows_orig $inst
		starcMS90G_symSetParam ncolumns $ncolumns_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }
	    set param_check [starcMS90G_symCheckInteger ncolumns [starcMS90G_symGetParam ncolumns $inst] $spice_model $inst ]
	    if {[lindex $param_check 0 ] == -1 } {
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam unitc $unitc_orig $inst
		starcMS90G_symSetParam c $c_orig $inst
		starcMS90G_symSetParam csub $csub_orig $inst
		starcMS90G_symSetParam nrows $nrows_orig $inst
		starcMS90G_symSetParam ncolumns $ncolumns_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }

	    if { ![starcMS90G_symIsVariable [starcMS90G_symGetParam ncolumns $inst]] } {
		set param_check [starcMS90G_symCheckNoModParamValue ncolumns $ncolumns $minCols $maxCols $ncolumns_orig 0 1 $spice_model $inst $param]
		if {[lindex $param_check 0 ] == -1 } {
		    starcMS90G_symSetParam l $l_orig $inst
		    starcMS90G_symSetParam unitc $unitc_orig $inst
		    starcMS90G_symSetParam c $c_orig $inst
		    starcMS90G_symSetParam csub $csub_orig $inst
		    starcMS90G_symSetParam nrows $nrows_orig $inst
		    starcMS90G_symSetParam ncolumns $ncolumns_orig $inst
   		    ics_rollbackCdfgData $instID
		    return
		}
		starcMS90G_symSetParam ncolumns $ncolumns $inst


		if { ![starcMS90G_symIsVariable [starcMS90G_symGetParam unitc $inst]] && \
			 ![starcMS90G_symIsVariable [starcMS90G_symGetParam nrows $inst]] && \
			 ![starcMS90G_symIsVariable [starcMS90G_symGetParam l $inst]] && \
			 ![starcMS90G_symIsVariable [starcMS90G_symGetParam ncolumns $inst]] } {
		    set unitc [starcMS90G_engToSci $unitc ]
		    set length  [starcMS90G_symGetParam l $inst]
		    set length  [starcMS90G_engToSci $length ]
		    set cval [ expr $unitc * $nrows * $ncolumns ]
		    starcMS90G_symSetParam c $cval $inst
		    set csub [ expr ((140e-15*((60+2*$length  *1e6))/140)*$nrows*$ncolumns) ]
		    starcMS90G_symSetParam csub [starcMS90G_sciToEng $csub] $inst
		} else {
		    set c "(iPar(\"unitc\")*iPar(\"nrows\")*iPar(\"ncolumns\"))"
		    starcMS90G_symSetParam c $c $inst
		    set csub "(140f*((60+2*( iPar(\"l\")  *1e6))/140)*iPar(\"nrows\")*iPar(\"ncolumns\"))"
		    starcMS90G_symSetParam csub $csub $inst
		}
	    }
	}
    }
}





		

