#########################################################################
# This file and the associated documentation are confidential 
# and proprietary to Synopsys, Inc. 
#
# Copyright (c), 2009 Synopsys, Inc. All rights reserved.
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
# Procedure used for setting the resistor properties depending on various 
# Entry modes.
# DEVICE TYPE    Resistor
# SUPPORTFILE    CallbackSupport.tcl
# DESCRIPTION    "2/3-Terminal Resistor"
##########################################################################
#
#  w and r can be variables.... l cannot be a variable
#  w and r are editable l is not editable
#  fingers cannot be a variable

proc starcMS90G_POLYRES_CB { instID paramName } {

    # get current instance and parameter	
#    set inst [db::getCurrentRef]
    set inst $instID
    set param [starcMS90G_getCurrentParam]

    set r            [starcMS90G_symGetParam r $inst]
#    puts "RVAL=$r"
	
    # get standard key values
    starcMS90G_getResDRValues [starcMS90G_getAttrDesign $inst] tech layer keys mod

    set spice_model [starcMS90G_symGetParam model $inst]

    set threshold 0.001 
    # checking for space and replace with "none"
    set paramList [list w r dummy_l dummy_r fingers]
    foreach param1 $paramList {
        if {[starcMS90G_symIsVariable [starcMS90G_symGetParam $param1 $inst]]==3} {
            if {[regsub -all {[ \r\t\n]+} [starcMS90G_symGetParam $param1 $inst] "" outline]} {
		starcMS90G_setParamValue $param1  $outline $inst 1
            } 
        }
    }    

    # add extra "u" if missing 

#    set paramList [list l w ]
#    foreach param1 $paramList {
#        if {![starcMS90G_symIsVariable [starcMS90G_symGetParam $param1 $inst]]} {
#            set val [starcMS90G_engToSci [starcMS90G_symGetParam $param1 $inst]]
#            if {$val > $threshold} {
#                set val [expr $val*1e-6] 
#                starcMS90G_symSetParam $param1 [starcMS90G_sciToEng $val] $inst
#            }
#        } 	  
#    }


#    # Check for invalid inputs, variables.
#    set checkparamlist {r l w fingers}
#    foreach i $checkparamlist {
#        starcMS90G_symCheckParam [starcMS90G_symGetParam $i $inst] $spice_model $inst $i
#    }   

    # Get data base unit, grid precision
    set dbu   $tech(dataBaseUnitValue)
#    set grid  $tech(minimumGridValue)
    set grid  0.005

    # Fetch common Parameters from CDF data / keys
    set fingers       [starcMS90G_symGetParam fingers $inst]
    set r            [starcMS90G_symGetParam r $inst]
    set w            [starcMS90G_symGetParam w $inst]
    set rcont            [starcMS90G_symGetParam rcont $inst]


    set fingers_orig [starcMS90G_getOrigValue fingers $inst]
    set r_orig [starcMS90G_getOrigValue r $inst]
    set w_orig [starcMS90G_getOrigValue w $inst]
    set l_orig [starcMS90G_getOrigValue l $inst]
    set dummy_l_orig [starcMS90G_getOrigValue dummy_l $inst]
    set dummy_r_orig [starcMS90G_getOrigValue dummy_r $inst]
    set rcont_orig [starcMS90G_getOrigValue rcont $inst]
    set simR_orig [starcMS90G_getOrigValue simR $inst]
    set simL_orig [starcMS90G_getOrigValue simL $inst]
    set csub_orig [starcMS90G_getOrigValue csub $inst]


    set minWidth     [starcMS90G_symU2M $keys(minWidth_$spice_model)]
    set maxWidth     [starcMS90G_symU2M $keys(maxWidth_$spice_model)]
    set minLength    [starcMS90G_symU2M $keys(minLength_$spice_model)]
    set maxLength    [starcMS90G_symU2M $keys(maxLength_$spice_model)]
    set dW           [starcMS90G_symU2M $keys(dW_$spice_model)]
    set dL           [starcMS90G_symU2M $keys(dL_$spice_model)]
    set sh_res       [starcMS90G_symGetParam sh_res $inst]
    set minFingers    $keys(minFingers_$spice_model)
    set maxFingers    $keys(maxFingers_$spice_model)
    set minDummy_L 0
    set maxDummy_L 1
    set minDummy_R 0
    set maxDummy_R 1



#    set prl [starcMS90G_symCheckInteger fingers $fingers $spice_model $inst]
#    starcMS90G_symSetParam fingers $prl $inst


#    puts "SHEET RES  $sh_res RCONT $rcont"
#    puts "R=$r"
    switch $paramName {

	"w" {
	    # check if the entry is valid , it not reject it outright
	    set param_check [starcMS90G_symCheckParam [starcMS90G_symGetParam w $inst] $spice_model $inst w]
	    if {[lindex $param_check 0 ] == -1 } {
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam r $r_orig $inst
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam simR $simR_orig $inst
		starcMS90G_symSetParam simL $simL_orig $inst
		starcMS90G_symSetParam csub $csub_orig $inst
		starcMS90G_symSetParam rcont $rcont_orig $inst
		starcMS90G_symSetParam fingers $fingers_orig $inst
		starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }


            # l & w are NOT variables
	    set fing_var 0
	    set w_var 0
	    set r_var 0
            if { ![starcMS90G_symIsVariable [starcMS90G_symGetParam w $inst]] } {
		if { ! [starcMS90G_symIsVariable [starcMS90G_symGetParam r $inst]] } {
		    if { ! [starcMS90G_symIsVariable [starcMS90G_symGetParam fingers $inst]] } {
			#		    puts "R=$r"
			set r [starcMS90G_engToSci $r ]
#			puts "R2=$r"
			set w [starcMS90G_engToSciMaxRes $w ]
			
			set wgrid [starcMS90G_symGridCheck $w $grid $dbu]
			set width [starcMS90G_symCheckNoModParamValue w $wgrid \
				       $minWidth $maxWidth $w_orig 0 1  $spice_model $inst $paramName]
#			puts "RETURN: width $width"
			if {[lindex $width 0 ] == 0 } {
			    set width [lindex $width 1]
#			    puts "Width: $width"
			    if {  [expr abs ([expr $w] - [expr $wgrid]) * 1e6] > 1e-18 } {
				append msg  "\n    *Error*  **\n"
				append msg  "      -> Parameter \"w\" Value \"$w\" is not on valid step\n"
				append msg  "      -> Rollback.\n"
				starcMS90G_prompt $msg 
				ics_rollbackCdfgData $instID
				return
			    } else {
				starcMS90G_symSetParam w [starcMS90G_sciToEng $width] $inst
				set w $width
			    }
			} else {
#			    puts "orig"
			    starcMS90G_symSetParam w $w_orig $inst
			    starcMS90G_symSetParam l $l_orig $inst
			    starcMS90G_symSetParam r $r_orig $inst
			    starcMS90G_symSetParam w $w_orig $inst
			    starcMS90G_symSetParam simR $simR_orig $inst
			    starcMS90G_symSetParam simL $simL_orig $inst
			    starcMS90G_symSetParam csub $csub_orig $inst
			    starcMS90G_symSetParam rcont $rcont_orig $inst
			    starcMS90G_symSetParam fingers $fingers_orig $inst
			    starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
			    starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
			    ics_rollbackCdfgData $instID
			    return
			}
#			puts "W: $w"
			set rcont [expr 2.0/ int(($w-2*0.2e-6+0.14e-6)/(0.12e-6+0.14e-6))* 13]
			starcMS90G_symSetParam rcont [starcMS90G_sciToEng $rcont] $inst
#			puts "rcont $rcont"
			
			
			
			set length  [expr 	 ( $r * $fingers - $rcont )/$sh_res  *($w - 2*$dW) +2*$dL ]
#			puts "LENGTH $length R=$r fingers=$fingers sh_res = $sh_res rcont=$rcont w=$w Dw=$dW Dl=$dL"
			set lgrid [starcMS90G_symGridCheck $length $grid $dbu]
			#		    puts "Checking againt $length $minLength $maxLength $lgrid 1 $spice_model"
			set length [starcMS90G_symCheckNoModParamValue l $lgrid \
					$minLength $maxLength $l_orig 0 1   $spice_model $inst $paramName]		    
#			puts "length $length"
			if {[lindex $length 0 ] == 0 } {
			    set length [lindex $length 1]
			    starcMS90G_symSetParam l [starcMS90G_sciToEng $length] $inst
			    set l $length
			} else {
#			    puts "Set w"
			    starcMS90G_symSetParam w $w_orig $inst
			    starcMS90G_symSetParam l $l_orig $inst
			    starcMS90G_symSetParam l $l_orig $inst
			    starcMS90G_symSetParam r $r_orig $inst
			    starcMS90G_symSetParam w $w_orig $inst
			    starcMS90G_symSetParam simR $simR_orig $inst
			    starcMS90G_symSetParam simL $simL_orig $inst
			    starcMS90G_symSetParam csub $csub_orig $inst
			    starcMS90G_symSetParam rcont $rcont_orig $inst
			    starcMS90G_symSetParam fingers $fingers_orig $inst
			    starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
			    starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
			    ics_rollbackCdfgData $instID
			    return
			}
			
			set rval [ expr ($sh_res*(($length-2*$dL)/($w-2*$dW))+$rcont)/$fingers ]
			starcMS90G_symSetParam r [starcMS90G_sciToEng $rval] $inst
			set r $rval
			
			set simR [expr $r - $rcont]
			starcMS90G_symSetParam simR [starcMS90G_sciToEng $simR] $inst
			
			set simL [expr ($simR)/($sh_res)*(($w)-2*($dW))+2*($dL) ]
			starcMS90G_symSetParam simL [starcMS90G_sciToEng $simL] $inst
			
			set csub [expr 4.48e-15 / 1e-12 *($simL-2*$dL)*($w-2*$dW)]
			starcMS90G_symSetParam csub [starcMS90G_sciToEng $csub] $inst
		    } else {
			set fing_var 1
		    }
		} else {
		    set r_var 1
		    starcMS90G_symSetParam fingers "1" $inst		    
		}
	    } else {
		set w_var 1
		starcMS90G_symSetParam fingers "1" $inst		    
	    }
	    if { $fing_var || $w_var || $r_var } {
		set rcont "2.0/floor((iPar(\"w\")-2*0.2u+0.14u)/(0.12u+0.14u))*13"
		starcMS90G_symSetParam rcont  $rcont $inst
		
		#		set length "((iPar(\"r\"))*(iPar(\"fingers\")))-(iPar(\"rcont\"))/(iPar(\"sh_res\"))*((iPar(\"w\"))-2*(iPar(\"dW\")))+2*(iPar(\"dL\"))"	
	        set length "(((iPar(\"r\"))*(iPar(\"fingers\")))-(iPar(\"rcont\")))/(iPar(\"sh_res\"))*((iPar(\"w\"))-2*(iPar(\"dW\")))+2*(iPar(\"dL\"))"

		starcMS90G_symSetParam l $length $inst
		
		set simR  "(iPar(\"r\") - iPar(\"rcont\"))"
		starcMS90G_symSetParam simR $simR $inst
		set simL "(iPar(\"simR\"))/(iPar(\"sh_res\"))*((iPar(\"w\"))-2*(iPar(\"dW\")))+2*(iPar(\"dL\"))"
		starcMS90G_symSetParam simL $simL $inst
		
		set csub "4.48f/(1e-6**2)*((iPar(\"simL\"))-2*(iPar(\"dL\")))*((iPar(\"w\"))-2*(iPar(\"dW\")))"
		starcMS90G_symSetParam csub  $csub $inst
	    }

	}
	"r" {

	    set param_check [starcMS90G_symCheckParam [starcMS90G_symGetParam r $inst] $spice_model $inst r]
	    if {[lindex $param_check 0 ] == -1 } {
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam r $r_orig $inst
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam simR $simR_orig $inst
		starcMS90G_symSetParam simL $simL_orig $inst
		starcMS90G_symSetParam csub $csub_orig $inst
		starcMS90G_symSetParam rcont $rcont_orig $inst
		starcMS90G_symSetParam fingers $fingers_orig $inst
		starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }


	    set fing_var 0
	    set w_var 0
	    set r_var 0

            if { ![starcMS90G_symIsVariable [starcMS90G_symGetParam r $inst]] } {	    
		if { ! [starcMS90G_symIsVariable [starcMS90G_symGetParam w $inst]] } {
		    if { ! [starcMS90G_symIsVariable [starcMS90G_symGetParam fingers $inst]] } {
			set w [starcMS90G_engToSci $w ]
			set r [starcMS90G_engToSci $r ]
			set wgrid [starcMS90G_symGridCheck $w $grid $dbu]
			
			set wgrid [starcMS90G_symGridCheck $w $grid $dbu]
			set width [starcMS90G_symCheckNoModParamValue l $wgrid \
				       $minWidth $maxWidth $w_orig  0 1  $spice_model $inst $paramName]
			if {[lindex $width 0 ] == 0 } {
			    set width [lindex $width 1]
			    starcMS90G_symSetParam w [starcMS90G_sciToEng $width] $inst
			    set w $width
			} else {
			    starcMS90G_symSetParam w $w_orig $inst
			    starcMS90G_symSetParam l $l_orig $inst
			    starcMS90G_symSetParam r $r_orig $inst
			    starcMS90G_symSetParam w $w_orig $inst
			    starcMS90G_symSetParam simR $simR_orig $inst
			    starcMS90G_symSetParam simL $simL_orig $inst
			    starcMS90G_symSetParam csub $csub_orig $inst
			    starcMS90G_symSetParam rcont $rcont_orig $inst
			    starcMS90G_symSetParam fingers $fingers_orig $inst
			    starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
			    starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
			    ics_rollbackCdfgData $instID
			    return
			}
			set rcont [expr 2.0/ int(($w-2*0.2e-6+0.14e-6)/(0.12e-6+0.14e-6))* 13]
			starcMS90G_symSetParam rcont [starcMS90G_sciToEng $rcont] $inst
			
			
			set length  [expr 	 (( $r * $fingers -$rcont )/$sh_res ) *($w - 2*$dW) +2*$dL ]
			set lgrid [starcMS90G_symGridCheck $length $grid $dbu]
			
			set length [starcMS90G_symCheckNoModParamValue l $lgrid \
					$minLength $maxLength $l_orig  0 1  $spice_model $inst $paramName]
			if {[lindex $length 0 ] == 0 } {
			    set length [lindex $length 1]
			    starcMS90G_symSetParam l [starcMS90G_sciToEng $length] $inst
			    set l $length
			} else {
			    starcMS90G_symSetParam l $l_orig $inst
			    starcMS90G_symSetParam r $r_orig $inst
			    starcMS90G_symSetParam w $w_orig $inst
			    starcMS90G_symSetParam simR $simR_orig $inst
			    starcMS90G_symSetParam simL $simL_orig $inst
			    starcMS90G_symSetParam csub $csub_orig $inst
			    starcMS90G_symSetParam rcont $rcont_orig $inst
			    starcMS90G_symSetParam fingers $fingers_orig $inst
			    starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
			    starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
			    ics_rollbackCdfgData $instID
			    return
			}

			starcMS90G_symSetParam l [starcMS90G_sciToEng $length] $inst
			set rval [ expr ($sh_res*(($length-2*$dL)/($w-2*$dW))+$rcont)/$fingers ]
			starcMS90G_symSetParam r [starcMS90G_sciToEng $rval] $inst
			set r $rval

			set simR [expr $r - $rcont]
			starcMS90G_symSetParam simR [starcMS90G_sciToEng $simR] $inst
			
			set simL [expr ($simR)/($sh_res)*(($w)-2*($dW))+2*($dL) ]
			starcMS90G_symSetParam simL [starcMS90G_sciToEng $simL] $inst
			
			set csub [expr 4.48e-15 / 1e-12 *($simL-2*$dL)*($w-2*$dW)]
			starcMS90G_symSetParam csub [starcMS90G_sciToEng $csub] $inst
		    } else {
			set fing_var 1
		    }
		} else {
		    set w_var 1
		    starcMS90G_symSetParam fingers "1" $inst
		    set fingers "1"
		}
	    } else {
		set r_var 1
		starcMS90G_symSetParam fingers "1" $inst
		set fingers "1"
	    }
	    if { $fing_var || $w_var || $r_var } {
		set rcont "2.0/floor((iPar(\"w\")-2*0.2u+0.14u)/(0.12u+0.14u))*13"
		starcMS90G_symSetParam rcont  $rcont $inst
		
		#		set length "((iPar(\"r\"))*(iPar(\"fingers\")))-(iPar(\"rcont\"))/(iPar(\"sh_res\"))*((iPar(\"w\"))-2*(iPar(\"dW\")))+2*(iPar(\"dL\"))"		
		set length "(((iPar(\"r\"))*(iPar(\"fingers\")))-(iPar(\"rcont\")))/(iPar(\"sh_res\"))*((iPar(\"w\"))-2*(iPar(\"dW\")))+2*(iPar(\"dL\"))"
		starcMS90G_symSetParam l $length $inst
		
		set simR  "(iPar(\"r\") - iPar(\"rcont\"))"
		starcMS90G_symSetParam simR $simR $inst
		set simL "(iPar(\"simR\"))/(iPar(\"sh_res\"))*((iPar(\"w\"))-2*(iPar(\"dW\")))+2*(iPar(\"dL\"))"
		starcMS90G_symSetParam simL $simL $inst
		
		set csub "4.48f/(1e-6**2)*((iPar(\"simL\"))-2*(iPar(\"dL\")))*((iPar(\"w\"))-2*(iPar(\"dW\")))"
		starcMS90G_symSetParam csub  $csub $inst
	    }
	}
	"fingers" {

	    if { [starcMS90G_symIsVariable [starcMS90G_symGetParam fingers  $inst]] } {		
		set msg ""
		append msg  "\n    *Error* ** $spice_model **\n"
		append msg  "      -> Parameter \"fingers\" Value \"$fingers\" is not a valid number\n"
		append msg  "      -> Parameter \"fingers\" cannot be a variable.\n"
		append msg  "      -> Rollback.\n"
		starcMS90G_prompt $msg 
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam r $r_orig $inst
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam simR $simR_orig $inst
		starcMS90G_symSetParam simL $simL_orig $inst
		starcMS90G_symSetParam csub $csub_orig $inst
		starcMS90G_symSetParam rcont $rcont_orig $inst
		starcMS90G_symSetParam fingers $fingers_orig $inst
		starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }

	    set param_check [starcMS90G_symCheckParam [starcMS90G_symGetParam fingers $inst] $spice_model $inst fingers]
	    if {[lindex $param_check 0 ] == -1 } {
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam r $r_orig $inst
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam simR $simR_orig $inst
		starcMS90G_symSetParam simL $simL_orig $inst
		starcMS90G_symSetParam csub $csub_orig $inst
		starcMS90G_symSetParam rcont $rcont_orig $inst
		starcMS90G_symSetParam fingers $fingers_orig $inst
		starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }
			     
	    set param_check [starcMS90G_symCheckInteger fingers [starcMS90G_symGetParam fingers $inst] $spice_model $inst ]
	    if {[lindex $param_check 0 ] == -1 } {
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam r $r_orig $inst
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam simR $simR_orig $inst
		starcMS90G_symSetParam simL $simL_orig $inst
		starcMS90G_symSetParam csub $csub_orig $inst
		starcMS90G_symSetParam rcont $rcont_orig $inst
		starcMS90G_symSetParam fingers $fingers_orig $inst
		starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }


	    set fing_var 0
	    set w_var 0
	    set r_var 0
            if { ![starcMS90G_symIsVariable [starcMS90G_symGetParam fingers $inst]] } {
		set fingers         [starcMS90G_symGetParam fingers $inst]
		set fingers  [starcMS90G_symCheckNoModParamValue fingers $fingers $minFingers $maxFingers $fingers_orig 0 1 $spice_model $inst $paramName]
		if {[lindex $fingers 0 ] == 0 } {
		    set fingers [lindex $fingers 1]
		    starcMS90G_symSetParam fingers $fingers $inst
		    set fingers $fingers
		} else {
		    starcMS90G_symSetParam fingers $fingers_orig $inst
		    starcMS90G_symSetParam l $l_orig $inst
		    starcMS90G_symSetParam r $r_orig $inst
		    starcMS90G_symSetParam w $w_orig $inst
		    starcMS90G_symSetParam simR $simR_orig $inst
		    starcMS90G_symSetParam simL $simL_orig $inst
		    starcMS90G_symSetParam csub $csub_orig $inst
		    starcMS90G_symSetParam rcont $rcont_orig $inst
		    starcMS90G_symSetParam fingers $fingers_orig $inst
		    starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		    starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		    ics_rollbackCdfgData $instID
		    return
		}
		if { ![starcMS90G_symIsVariable [starcMS90G_symGetParam w $inst]] } {
		    if { ! [starcMS90G_symIsVariable [starcMS90G_symGetParam r $inst]] } {
			set r [starcMS90G_engToSci $r ]
			set w [starcMS90G_engToSci $w ]
			
			set rcont [expr (2.0/ int(($w-2*0.2e-6+0.14e-6)/(0.12e-6+0.14e-6)))* 13]
			
			starcMS90G_symSetParam rcont [starcMS90G_sciToEng $rcont] $inst
			
			set length  [expr 	 (( $r * $fingers -$rcont )/$sh_res ) *($w - 2*$dW) +2*$dL ]
			set lgrid [starcMS90G_symGridCheck $length $grid $dbu]
			set length [starcMS90G_symCheckNoModParamValue l $lgrid \
					$minLength $maxLength $l_orig  0 1  $spice_model $inst $paramName]
			if {[lindex $length 0 ] == 0 } {
			    set length [lindex $length 1]
			    starcMS90G_symSetParam l [starcMS90G_sciToEng $length] $inst
			    set l $length
			} else {
			    starcMS90G_symSetParam l $l_orig $inst
			    starcMS90G_symSetParam r $r_orig $inst
			    starcMS90G_symSetParam w $w_orig $inst
			    starcMS90G_symSetParam simR $simR_orig $inst
			    starcMS90G_symSetParam simL $simL_orig $inst
			    starcMS90G_symSetParam csub $csub_orig $inst
			    starcMS90G_symSetParam rcont $rcont_orig $inst
			    starcMS90G_symSetParam fingers $fingers_orig $inst
			    starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
			    starcMS90G_symSetParam dummy_r $dummy_r_orig $inst

			    starcMS90G_symSetParam l $l_orig $inst
			    starcMS90G_symSetParam r $r_orig $inst
			    starcMS90G_symSetParam w $w_orig $inst
			    starcMS90G_symSetParam fingers $fingers_orig $inst
			    ics_rollbackCdfgData $instID
			    return
			}


#			set length [starcMS90G_symCheckParamValue l $lgrid \
#					$minLength $maxLength $lgrid 1 $spice_model $inst $paramName]
#			starcMS90G_symSetParam l [starcMS90G_sciToEng $length] $inst
			
			set simR [expr $r - $rcont]
			starcMS90G_symSetParam simR [starcMS90G_sciToEng $simR] $inst
			
			set simL [expr ($simR)/($sh_res)*(($w)-2*($dW))+2*($dL) ]
			starcMS90G_symSetParam simL [starcMS90G_sciToEng $simL] $inst
			
			set csub [expr ( 4.48e-15 / 1e-12 )*($simL - 2*$dL)*($w-2*$dW)]
			starcMS90G_symSetParam csub [starcMS90G_sciToEng $csub] $inst
		    } else {
			set r_var 1
			starcMS90G_symSetParam fingers "1" $inst
			set fingers "1"
		    }
		} else {
		    set w_var 1
		    starcMS90G_symSetParam fingers "1" $inst
		    set fingers "1"
		}
	    } else {
		set fing_var 1
	    }
	    if { $fing_var || $w_var || $r_var } {
		set rcont "2.0/floor((iPar(\"w\")-2*0.2u+0.14u)/(0.12u+0.14u))*13"
		starcMS90G_symSetParam rcont  $rcont $inst
		

#		set length "((iPar(\"r\"))*(iPar(\"fingers\")))-(iPar(\"rcont\"))/(iPar(\"sh_res\"))*((iPar(\"w\"))-2*(iPar(\"dW\")))+2*(iPar(\"dL\"))"		
	        set length "(((iPar(\"r\"))*(iPar(\"fingers\")))-(iPar(\"rcont\")))/(iPar(\"sh_res\"))*((iPar(\"w\"))-2*(iPar(\"dW\")))+2*(iPar(\"dL\"))"
		starcMS90G_symSetParam l $length $inst
		
		set simR  "(iPar(\"r\") - iPar(\"rcont\"))"
		starcMS90G_symSetParam simR $simR $inst
		set simL "(iPar(\"simR\"))/(iPar(\"sh_res\"))*((iPar(\"w\"))-2*(iPar(\"dW\")))+2*(iPar(\"dL\"))"
		starcMS90G_symSetParam simL $simL $inst
		
		set csub "4.48f/(1e-6**2)*((iPar(\"simL\"))-2*(iPar(\"dL\")))*((iPar(\"w\"))-2*(iPar(\"dW\")))"
		starcMS90G_symSetParam csub  $csub $inst
	    }
	}
	"dummy_l" {
	    set msg ""
	    set dummy_l         [starcMS90G_symGetParam dummy_l $inst]

	    if { [starcMS90G_symIsVariable [starcMS90G_symGetParam dummy_l  $inst]] } {		
		set msg ""
		append msg  "\n    *Error* ** $spice_model **\n"
		append msg  "      -> Parameter \"dummy_l\" Value \"$dummy_l\" is not a valid number\n"
		append msg  "      -> Parameter \"dummy_l\" cannot be a variable.\n"
		append msg  "      -> Rollback.\n"
		starcMS90G_prompt $msg 
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam r $r_orig $inst
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam simR $simR_orig $inst
		starcMS90G_symSetParam simL $simL_orig $inst
		starcMS90G_symSetParam csub $csub_orig $inst
		starcMS90G_symSetParam rcont $rcont_orig $inst
		starcMS90G_symSetParam fingers $fingers_orig $inst
		starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }

	    set param_check [starcMS90G_symCheckParam [starcMS90G_symGetParam dummy_l $inst] $spice_model $inst dummy_l]
	    if {[lindex $param_check 0 ] == -1 } {
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam r $r_orig $inst
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam simR $simR_orig $inst
		starcMS90G_symSetParam simL $simL_orig $inst
		starcMS90G_symSetParam csub $csub_orig $inst
		starcMS90G_symSetParam rcont $rcont_orig $inst
		starcMS90G_symSetParam fingers $fingers_orig $inst
		starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }
	    set param_check [starcMS90G_symCheckPosInteger dummy_l [starcMS90G_symGetParam dummy_l $inst] $spice_model $inst ]
	    if {[lindex $param_check 0 ] == -1 } {
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam r $r_orig $inst
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam simR $simR_orig $inst
		starcMS90G_symSetParam simL $simL_orig $inst
		starcMS90G_symSetParam csub $csub_orig $inst
		starcMS90G_symSetParam rcont $rcont_orig $inst
		starcMS90G_symSetParam fingers $fingers_orig $inst
		starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }

	    if { ![starcMS90G_symIsVariable [starcMS90G_symGetParam dummy_l $inst]] } {
		set param_check [starcMS90G_symCheckNoModParamValue dummy_l $dummy_l $minDummy_L $maxDummy_L $dummy_l_orig 0 1 $spice_model $inst $paramName]
		if {[lindex $param_check 0 ] == -1 } {
		    starcMS90G_symSetParam l $l_orig $inst
		    starcMS90G_symSetParam r $r_orig $inst
		    starcMS90G_symSetParam w $w_orig $inst
		    starcMS90G_symSetParam simR $simR_orig $inst
		    starcMS90G_symSetParam simL $simL_orig $inst
		    starcMS90G_symSetParam csub $csub_orig $inst
		    starcMS90G_symSetParam rcont $rcont_orig $inst
		    starcMS90G_symSetParam fingers $fingers_orig $inst
		    starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		    starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		    ics_rollbackCdfgData $instID
		    return
		}
		starcMS90G_symSetParam dummy_l $dummy_l $inst
	    }
	}
	"dummy_r" {
	    set dummy_r         [starcMS90G_symGetParam dummy_r $inst]

	    if { [starcMS90G_symIsVariable [starcMS90G_symGetParam dummy_r  $inst]] } {		
		set msg ""
		append msg  "\n    *Error* ** $spice_model **\n"
		append msg  "      -> Parameter \"dummy_r\" Value \"$dummy_r\" is not a valid number\n"
		append msg  "      -> Parameter \"dummy_r\" cannot be a variable.\n"
		append msg  "      -> Rollback.\n"
		starcMS90G_prompt $msg 
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam r $r_orig $inst
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam simR $simR_orig $inst
		starcMS90G_symSetParam simL $simL_orig $inst
		starcMS90G_symSetParam csub $csub_orig $inst
		starcMS90G_symSetParam rcont $rcont_orig $inst
		starcMS90G_symSetParam fingers $fingers_orig $inst
		starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }

	    set param_check [starcMS90G_symCheckParam [starcMS90G_symGetParam dummy_r $inst] $spice_model $inst dummy_r]
	    if {[lindex $param_check 0 ] == -1 } {
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam r $r_orig $inst
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam simR $simR_orig $inst
		starcMS90G_symSetParam simL $simL_orig $inst
		starcMS90G_symSetParam csub $csub_orig $inst
		starcMS90G_symSetParam rcont $rcont_orig $inst
		starcMS90G_symSetParam fingers $fingers_orig $inst
		starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }
	    set param_check [starcMS90G_symCheckPosInteger dummy_r [starcMS90G_symGetParam dummy_r $inst] $spice_model $inst ]
	    if {[lindex $param_check 0 ] == -1 } {
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam r $r_orig $inst
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam simR $simR_orig $inst
		starcMS90G_symSetParam simL $simL_orig $inst
		starcMS90G_symSetParam csub $csub_orig $inst
		starcMS90G_symSetParam rcont $rcont_orig $inst
		starcMS90G_symSetParam fingers $fingers_orig $inst
		starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }


	    if { ![starcMS90G_symIsVariable [starcMS90G_symGetParam dummy_r $inst]] } {
		set param_check [starcMS90G_symCheckNoModParamValue dummy_r $dummy_r $minDummy_R $maxDummy_R $dummy_r_orig 0 1 $spice_model $inst $paramName]
		if {[lindex $param_check 0 ] == -1 } {
		    starcMS90G_symSetParam l $l_orig $inst
		    starcMS90G_symSetParam r $r_orig $inst
		    starcMS90G_symSetParam w $w_orig $inst
		    starcMS90G_symSetParam simR $simR_orig $inst
		    starcMS90G_symSetParam simL $simL_orig $inst
		    starcMS90G_symSetParam csub $csub_orig $inst
		    starcMS90G_symSetParam rcont $rcont_orig $inst
		    starcMS90G_symSetParam fingers $fingers_orig $inst
		    starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		    starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		    ics_rollbackCdfgData $instID
		    return
		}
		starcMS90G_symSetParam dummy_r $dummy_r $inst
	    }
	}

    }
}



	


