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
proc starcMS90G_MOS_CB { instID paramName } {

    # get current instance and parameter	
#    set inst [db::getCurrentRef]
    set inst $instID
    set param [starcMS90G_getCurrentParam]

	
    # get standard key values
    starcMS90G_getMosDRValues [starcMS90G_getAttrDesign $inst] tech layer keys mod

    set spice_model [starcMS90G_symGetParam model $inst]

    set threshold 0.001 
    # checking for space and replace with "none"
    set paramList [list l w wpf fingers]
    foreach param1 $paramList {
        if {[starcMS90G_symIsVariable [starcMS90G_symGetParam $param1 $inst]]==3} {
            if {[regsub -all {[ \r\t\n]+} [starcMS90G_symGetParam $param1 $inst] "" outline]} {
		starcMS90G_setParamValue $param1  $outline $inst 1
            } 
        }
    }    

#    # add extra "u" if missing 
#
#    set paramList [list l w wpf]
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
#
#    # Check for invalid inputs, variables.
#    set checkparamlist { l w wpf}
#    foreach i $checkparamlist {
#        starcMS90G_symCheckParam [starcMS90G_symGetParam $i $inst] $spice_model $inst $i
#    }   

    # Get data base unit, grid precision
    set dbu   $tech(dataBaseUnitValue)
#    set grid  $tech(minimumGridValue)
    set grid  0.005

    # Fetch common Parameters from CDF data / keys
    set w             [starcMS90G_symGetParam w $inst]
    set l             [starcMS90G_symGetParam l $inst]
    set wpf           [starcMS90G_symGetParam wpf $inst]
    set dhd           [starcMS90G_symGetParam dhd $inst]
    set dsd           [starcMS90G_symGetParam dsd $inst]
    set shd           [starcMS90G_symGetParam shd $inst]
    set ssd           [starcMS90G_symGetParam ssd $inst]
    set sc          [starcMS90G_symGetParam sc $inst]
    set scref           [starcMS90G_symGetParam scref $inst]
    set dummy_symbol    [starcMS90G_symGetParam dummy_symbol $inst]


    set ad_orig [starcMS90G_getOrigValue ad $inst]
    set as_orig [starcMS90G_getOrigValue as $inst]
    set dummy_l_orig [starcMS90G_getOrigValue dummy_l $inst]
    set dummy_label_orig [starcMS90G_getOrigValue dummy_label $inst]
    set dummy_symbol_orig [starcMS90G_getOrigValue dummy_symbol $inst]
    set dummy_r_orig [starcMS90G_getOrigValue dummy_r $inst]
    set fingers_orig [starcMS90G_getOrigValue fingers $inst]
    set ignore_orig [starcMS90G_getOrigValue ignore $inst]
    set l_orig [starcMS90G_getOrigValue l $inst]
    set m_orig [starcMS90G_getOrigValue m $inst]
    set nlIgnore_orig [starcMS90G_getOrigValue nlIgnore $inst]
    set nrd_orig [starcMS90G_getOrigValue nrd $inst]
    set nrs_orig [starcMS90G_getOrigValue nrs $inst]
    set pd_orig [starcMS90G_getOrigValue pd $inst]
    set ps_orig [starcMS90G_getOrigValue ps $inst]
    set sa_orig [starcMS90G_getOrigValue sa $inst]
    set sb_orig [starcMS90G_getOrigValue sb $inst]
    set sca_orig [starcMS90G_getOrigValue sca $inst]
    set scb_orig [starcMS90G_getOrigValue scb $inst]
    set scc_orig [starcMS90G_getOrigValue scc $inst]
    set simM_orig [starcMS90G_getOrigValue simM $inst]
    set w_orig [starcMS90G_getOrigValue w $inst]
    set wpf_orig [starcMS90G_getOrigValue wpf $inst]
#    puts "DEBUG: $fingers_orig $w_orig $wpf_orig $dummy_label_orig"


    set fingers       [starcMS90G_symGetParam fingers $inst]
    set m             [starcMS90G_symGetParam m $inst]
    set shared_sd     [starcMS90G_symGetParam shared_sd $inst]    
    set dummy_l     [starcMS90G_symGetParam dummy_l $inst]
    set dummy_r     [starcMS90G_symGetParam dummy_r $inst]
    set minWidth     [starcMS90G_symU2M $keys(minWidth_$spice_model)]
    set maxWidth     [starcMS90G_symU2M $keys(maxWidth_$spice_model)]
    set minFWidth     [starcMS90G_symU2M $keys(minFWidth_$spice_model)]
    set maxFWidth     [starcMS90G_symU2M $keys(maxFWidth_$spice_model)]
    set minLength    [starcMS90G_symU2M $keys(minLength_$spice_model)]
    set maxLength    [starcMS90G_symU2M $keys(maxLength_$spice_model)]
    set minM    $keys(mMin_$spice_model)
    set maxM    $keys(mMax_$spice_model)
    set minFingers    $keys(minFingers_$spice_model)
    set maxFingers    $keys(maxFingers_$spice_model)
    set minDummyR  $keys(minDummyR_$spice_model)
    set maxDummyR  $keys(maxDummyR_$spice_model)
    set minDummyL  $keys(minDummyL_$spice_model)
    set maxDummyL  $keys(maxDummyL_$spice_model)








    set dhd            [starcMS90G_engToSci  $dhd ]
    set dsd             [starcMS90G_engToSci  $dsd ]
    set shd            [starcMS90G_engToSci  $shd ]
    set ssd             [starcMS90G_engToSci  $ssd ]
    set sc             [starcMS90G_engToSci  $sc ]
    set scref             [starcMS90G_engToSci  $scref ]


#    puts "TEST"
    switch $paramName {

	"w" {
            # l & w are NOT variables
	    set param_check [starcMS90G_symCheckParam [starcMS90G_symGetParam w $inst] $spice_model $inst w]
	    if {[lindex $param_check 0 ] == -1 } {
			starcMS90G_symSetParam ad $ad_orig $inst
			starcMS90G_symSetParam as $as_orig $inst
			starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
			starcMS90G_symSetParam dummy_label $dummy_label_orig $inst
			starcMS90G_symSetParam dummy_symbol $dummy_symbol_orig $inst
			starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
			starcMS90G_symSetParam fingers $fingers_orig $inst
			starcMS90G_symSetParam ignore $ignore_orig $inst
			starcMS90G_symSetParam l $l_orig $inst
			starcMS90G_symSetParam m $m_orig $inst
			starcMS90G_symSetParam nlIgnore $nlIgnore_orig $inst
			starcMS90G_symSetParam nrd $nrd_orig $inst
			starcMS90G_symSetParam nrs $nrs_orig $inst
			starcMS90G_symSetParam pd $pd_orig $inst
			starcMS90G_symSetParam ps $ps_orig $inst
			starcMS90G_symSetParam sa $sa_orig $inst
			starcMS90G_symSetParam sb $sb_orig $inst
			starcMS90G_symSetParam sca $sca_orig $inst
			starcMS90G_symSetParam scb $scb_orig $inst
			starcMS90G_symSetParam scc $scc_orig $inst
			starcMS90G_symSetParam simM $simM_orig $inst
			starcMS90G_symSetParam w $w_orig $inst
			starcMS90G_symSetParam wpf $wpf_orig $inst
			ics_rollbackCdfgData $instID
			return
	    }


            if { ![starcMS90G_symIsVariable [starcMS90G_symGetParam w $inst]] } {
		if { ! [starcMS90G_symIsVariable [starcMS90G_symGetParam fingers $inst]] } {
		    set w             [starcMS90G_engToSciMaxRes  $w ]
		    set wgrid [starcMS90G_symGridCheck $w $grid $dbu]
		    set width [starcMS90G_symCheckNoModParamValue w $wgrid \
				    $minWidth $maxWidth $w_orig 0 1  $spice_model $inst $param]
#		    puts "RETURN: width $width"
		    if {[lindex $width 0 ] == 0 } {
			set width [lindex $width 1]
#			puts "$w $wgrid"
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
#			puts "orig"

			starcMS90G_symSetParam ad $ad_orig $inst
			starcMS90G_symSetParam as $as_orig $inst
			starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
			starcMS90G_symSetParam dummy_label $dummy_label_orig $inst
			starcMS90G_symSetParam dummy_symbol $dummy_symbol_orig $inst
			starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
			starcMS90G_symSetParam fingers $fingers_orig $inst
			starcMS90G_symSetParam ignore $ignore_orig $inst
			starcMS90G_symSetParam l $l_orig $inst
			starcMS90G_symSetParam m $m_orig $inst
			starcMS90G_symSetParam nlIgnore $nlIgnore_orig $inst
			starcMS90G_symSetParam nrd $nrd_orig $inst
			starcMS90G_symSetParam nrs $nrs_orig $inst
			starcMS90G_symSetParam pd $pd_orig $inst
			starcMS90G_symSetParam ps $ps_orig $inst
			starcMS90G_symSetParam sa $sa_orig $inst
			starcMS90G_symSetParam sb $sb_orig $inst
			starcMS90G_symSetParam sca $sca_orig $inst
			starcMS90G_symSetParam scb $scb_orig $inst
			starcMS90G_symSetParam scc $scc_orig $inst
			starcMS90G_symSetParam simM $simM_orig $inst
			starcMS90G_symSetParam w $w_orig $inst
			starcMS90G_symSetParam wpf $wpf_orig $inst
			ics_rollbackCdfgData $instID
			return
		    }
			
#		    starcMS90G_symSetParam w [starcMS90G_sciToEng $width] $inst
#		    set w $width

		    set wpf [expr $w / $fingers ]
		    set wpf_grid [starcMS90G_symGridCheck $wpf $grid $dbu]
		    set width_wpf [starcMS90G_symCheckNoModParamValue wpf $wpf_grid \
				    $minFWidth $maxFWidth $wpf_orig 0 1  $spice_model $inst $param]		    

		    if {[lindex $width_wpf 0 ] == 0 } {
			set width_wpf [lindex $width_wpf 1]
			starcMS90G_symSetParam wpf [starcMS90G_sciToEng $width_wpf] $inst
			set wpf $width_wpf
		    } else {

			starcMS90G_symSetParam ad $ad_orig $inst
			starcMS90G_symSetParam as $as_orig $inst
			starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
			starcMS90G_symSetParam dummy_label $dummy_label_orig $inst
			starcMS90G_symSetParam dummy_symbol $dummy_symbol_orig $inst
			starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
			starcMS90G_symSetParam fingers $fingers_orig $inst
			starcMS90G_symSetParam ignore $ignore_orig $inst
			starcMS90G_symSetParam l $l_orig $inst
			starcMS90G_symSetParam m $m_orig $inst
			starcMS90G_symSetParam nlIgnore $nlIgnore_orig $inst
			starcMS90G_symSetParam nrd $nrd_orig $inst
			starcMS90G_symSetParam nrs $nrs_orig $inst
			starcMS90G_symSetParam pd $pd_orig $inst
			starcMS90G_symSetParam ps $ps_orig $inst
			starcMS90G_symSetParam sa $sa_orig $inst
			starcMS90G_symSetParam sb $sb_orig $inst
			starcMS90G_symSetParam sca $sca_orig $inst
			starcMS90G_symSetParam scb $scb_orig $inst
			starcMS90G_symSetParam scc $scc_orig $inst
			starcMS90G_symSetParam simM $simM_orig $inst
			starcMS90G_symSetParam w $w_orig $inst
			starcMS90G_symSetParam wpf $wpf_orig $inst
			ics_rollbackCdfgData $instID
			return
		    }
#		    starcMS90G_symSetParam wpf [starcMS90G_sciToEng $width_wpf] $inst

		    set w [expr $width_wpf * $fingers]
 		    set wgrid [starcMS90G_symGridCheck $w $grid $dbu]
		    starcMS90G_symSetParam w [starcMS90G_sciToEng $wgrid] $inst

		} 
	    } else {
		#		set wpf "(iPar(\"w\")) / float((iPar(\"fingers\")))"
		set wpf "(iPar(\"w\")) / (iPar(\"fingers\"))"
		starcMS90G_symSetParam wpf $wpf $inst
	    }
	}
	"wpf" {
	    set param_check [starcMS90G_symCheckParam [starcMS90G_symGetParam wpf $inst] $spice_model $inst wpf]
#	    puts "wpf"
	    if {[lindex $param_check 0 ] == -1 } {
			starcMS90G_symSetParam ad $ad_orig $inst
			starcMS90G_symSetParam as $as_orig $inst
			starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
			starcMS90G_symSetParam dummy_label $dummy_label_orig $inst
			starcMS90G_symSetParam dummy_symbol $dummy_symbol_orig $inst
			starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
			starcMS90G_symSetParam fingers $fingers_orig $inst
			starcMS90G_symSetParam ignore $ignore_orig $inst
			starcMS90G_symSetParam l $l_orig $inst
			starcMS90G_symSetParam m $m_orig $inst
			starcMS90G_symSetParam nlIgnore $nlIgnore_orig $inst
			starcMS90G_symSetParam nrd $nrd_orig $inst
			starcMS90G_symSetParam nrs $nrs_orig $inst
			starcMS90G_symSetParam pd $pd_orig $inst
			starcMS90G_symSetParam ps $ps_orig $inst
			starcMS90G_symSetParam sa $sa_orig $inst
			starcMS90G_symSetParam sb $sb_orig $inst
			starcMS90G_symSetParam sca $sca_orig $inst
			starcMS90G_symSetParam scb $scb_orig $inst
			starcMS90G_symSetParam scc $scc_orig $inst
			starcMS90G_symSetParam simM $simM_orig $inst
			starcMS90G_symSetParam w $w_orig $inst
			starcMS90G_symSetParam wpf $wpf_orig $inst
			ics_rollbackCdfgData $instID
			return
	    }


            if { ![starcMS90G_symIsVariable [starcMS90G_symGetParam wpf $inst]] } {
		if { ! [starcMS90G_symIsVariable [starcMS90G_symGetParam fingers $inst]] } {
		    set wpf           [starcMS90G_engToSciMaxRes  $wpf ]
		    set wgrid [starcMS90G_symGridCheck $wpf $grid $dbu]
		    set width [starcMS90G_symCheckNoModParamValue wpf $wgrid \
				    $minFWidth $maxFWidth $wpf_orig 0 1  $spice_model $inst $param]		    

		    if {[lindex $width 0 ] == 0 } {
			set width [lindex $width 1]
#			puts "$wpf  $wgrid"
			if {  [expr abs ([expr $wpf] - [expr $wgrid]) * 1e6] > 1e-18 } {
			    append msg  "\n    *Error*  **\n"
			    append msg  "      -> Parameter \"wpf\" Value \"$wpf\" is not on valid step\n"
			    append msg  "      -> Rollback.\n"
			    starcMS90G_prompt $msg 
			    ics_rollbackCdfgData $instID
			    return
			} else {
			    starcMS90G_symSetParam wpf [starcMS90G_sciToEng $width] $inst
			    set wpf $width
			}
		    } else {
#			puts "orig"
			starcMS90G_symSetParam ad $ad_orig $inst
			starcMS90G_symSetParam as $as_orig $inst
			starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
			starcMS90G_symSetParam dummy_label $dummy_label_orig $inst
			starcMS90G_symSetParam dummy_symbol $dummy_symbol_orig $inst
			starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
			starcMS90G_symSetParam fingers $fingers_orig $inst
			starcMS90G_symSetParam ignore $ignore_orig $inst
			starcMS90G_symSetParam l $l_orig $inst
			starcMS90G_symSetParam m $m_orig $inst
			starcMS90G_symSetParam nlIgnore $nlIgnore_orig $inst
			starcMS90G_symSetParam nrd $nrd_orig $inst
			starcMS90G_symSetParam nrs $nrs_orig $inst
			starcMS90G_symSetParam pd $pd_orig $inst
			starcMS90G_symSetParam ps $ps_orig $inst
			starcMS90G_symSetParam sa $sa_orig $inst
			starcMS90G_symSetParam sb $sb_orig $inst
			starcMS90G_symSetParam sca $sca_orig $inst
			starcMS90G_symSetParam scb $scb_orig $inst
			starcMS90G_symSetParam scc $scc_orig $inst
			starcMS90G_symSetParam simM $simM_orig $inst
			starcMS90G_symSetParam w $w_orig $inst
			starcMS90G_symSetParam wpf $wpf_orig $inst
			ics_rollbackCdfgData $instID
			return
		    }

		    starcMS90G_symSetParam wpf [starcMS90G_sciToEng $width] $inst
		    set wpf $width

		    set w [expr $wpf * $fingers]
 		    set wgrid [starcMS90G_symGridCheck $w $grid $dbu]
		    starcMS90G_symSetParam w [starcMS90G_sciToEng $wgrid] $inst

		}
	    } 	    else  {
		set w "(iPar(\"wpf\")) * (iPar(\"fingers\"))"
		starcMS90G_symSetParam w $w  $inst
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
		starcMS90G_symSetParam ad $ad_orig $inst
		starcMS90G_symSetParam as $as_orig $inst
		starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		starcMS90G_symSetParam dummy_label $dummy_label_orig $inst
		starcMS90G_symSetParam dummy_symbol $dummy_symbol_orig $inst
		starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		starcMS90G_symSetParam fingers $fingers_orig $inst
		starcMS90G_symSetParam ignore $ignore_orig $inst
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam m $m_orig $inst
		starcMS90G_symSetParam nlIgnore $nlIgnore_orig $inst
		starcMS90G_symSetParam nrd $nrd_orig $inst
		starcMS90G_symSetParam nrs $nrs_orig $inst
		starcMS90G_symSetParam pd $pd_orig $inst
		starcMS90G_symSetParam ps $ps_orig $inst
		starcMS90G_symSetParam sa $sa_orig $inst
		starcMS90G_symSetParam sb $sb_orig $inst
		starcMS90G_symSetParam sca $sca_orig $inst
		starcMS90G_symSetParam scb $scb_orig $inst
		starcMS90G_symSetParam scc $scc_orig $inst
		starcMS90G_symSetParam simM $simM_orig $inst
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam wpf $wpf_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }
		
		
		
	    set param_check [starcMS90G_symCheckParam [starcMS90G_symGetParam fingers $inst] $spice_model $inst fingers]
	    if {[lindex $param_check 0 ] == -1 } {
		starcMS90G_symSetParam ad $ad_orig $inst
		starcMS90G_symSetParam as $as_orig $inst
		starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		starcMS90G_symSetParam dummy_label $dummy_label_orig $inst
		starcMS90G_symSetParam dummy_symbol $dummy_symbol_orig $inst
		starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		starcMS90G_symSetParam fingers $fingers_orig $inst
		starcMS90G_symSetParam ignore $ignore_orig $inst
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam m $m_orig $inst
		starcMS90G_symSetParam nlIgnore $nlIgnore_orig $inst
		starcMS90G_symSetParam nrd $nrd_orig $inst
		starcMS90G_symSetParam nrs $nrs_orig $inst
		starcMS90G_symSetParam pd $pd_orig $inst
		starcMS90G_symSetParam ps $ps_orig $inst
		starcMS90G_symSetParam sa $sa_orig $inst
		starcMS90G_symSetParam sb $sb_orig $inst
		starcMS90G_symSetParam sca $sca_orig $inst
		starcMS90G_symSetParam scb $scb_orig $inst
		starcMS90G_symSetParam scc $scc_orig $inst
		starcMS90G_symSetParam simM $simM_orig $inst
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam wpf $wpf_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }
	    
	    
	    set param_check [starcMS90G_symCheckInteger fingers $fingers $spice_model $inst]	
	    if {[lindex $param_check 0 ] == -1 } {
		starcMS90G_symSetParam ad $ad_orig $inst
		starcMS90G_symSetParam as $as_orig $inst
		starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		starcMS90G_symSetParam dummy_label $dummy_label_orig $inst
		starcMS90G_symSetParam dummy_symbol $dummy_symbol_orig $inst
		starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		starcMS90G_symSetParam fingers $fingers_orig $inst
		starcMS90G_symSetParam ignore $ignore_orig $inst
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam m $m_orig $inst
		starcMS90G_symSetParam nlIgnore $nlIgnore_orig $inst
		starcMS90G_symSetParam nrd $nrd_orig $inst
		starcMS90G_symSetParam nrs $nrs_orig $inst
		starcMS90G_symSetParam pd $pd_orig $inst
		starcMS90G_symSetParam ps $ps_orig $inst
		starcMS90G_symSetParam sa $sa_orig $inst
		starcMS90G_symSetParam sb $sb_orig $inst
		starcMS90G_symSetParam sca $sca_orig $inst
		starcMS90G_symSetParam scb $scb_orig $inst
		starcMS90G_symSetParam scc $scc_orig $inst
		starcMS90G_symSetParam simM $simM_orig $inst
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam wpf $wpf_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }
	    set fingers  [starcMS90G_symCheckNoModParamValue fingers $fingers $minFingers $maxFingers \
			      $fingers_orig 0 1 $spice_model $inst $param]
	    if {[lindex $fingers 0 ] == 0 } {
		set fingers [lindex $fingers 1]
		starcMS90G_symSetParam fingers $fingers $inst
		set fingers $fingers
	    } else {
		starcMS90G_symSetParam ad $ad_orig $inst
		starcMS90G_symSetParam as $as_orig $inst
		starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		starcMS90G_symSetParam dummy_label $dummy_label_orig $inst
		starcMS90G_symSetParam dummy_symbol $dummy_symbol_orig $inst
		starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		starcMS90G_symSetParam fingers $fingers_orig $inst
		starcMS90G_symSetParam ignore $ignore_orig $inst
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam m $m_orig $inst
		starcMS90G_symSetParam nlIgnore $nlIgnore_orig $inst
		starcMS90G_symSetParam nrd $nrd_orig $inst
		starcMS90G_symSetParam nrs $nrs_orig $inst
		    starcMS90G_symSetParam pd $pd_orig $inst
		starcMS90G_symSetParam ps $ps_orig $inst
		starcMS90G_symSetParam sa $sa_orig $inst
		starcMS90G_symSetParam sb $sb_orig $inst
		starcMS90G_symSetParam sca $sca_orig $inst
		starcMS90G_symSetParam scb $scb_orig $inst
		starcMS90G_symSetParam scc $scc_orig $inst
		starcMS90G_symSetParam simM $simM_orig $inst
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam wpf $wpf_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }
	    
	    if { ![starcMS90G_symIsVariable [starcMS90G_symGetParam wpf $inst]] } {
		if { ! [starcMS90G_symIsVariable [starcMS90G_symGetParam fingers $inst]] } {
		    set wpf           [starcMS90G_engToSci  $wpf ]
		    set wgrid [starcMS90G_symGridCheck $wpf $grid $dbu]
		    set width [starcMS90G_symCheckNoModParamValue wpf $wgrid \
				   $minFWidth $maxFWidth $wpf_orig 0 1  $spice_model $inst $param]  
		    
		    if {[lindex $width 0 ] == 0 } {
			set width [lindex $width 1]
			starcMS90G_symSetParam wpf [starcMS90G_sciToEng $width] $inst
			set wpf $width
		    } else {
			starcMS90G_symSetParam ad $ad_orig $inst
			starcMS90G_symSetParam as $as_orig $inst
			starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
			starcMS90G_symSetParam dummy_label $dummy_label_orig $inst
			starcMS90G_symSetParam dummy_symbol $dummy_symbol_orig $inst
			starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
			starcMS90G_symSetParam fingers $fingers_orig $inst
			starcMS90G_symSetParam ignore $ignore_orig $inst
			starcMS90G_symSetParam l $l_orig $inst
			starcMS90G_symSetParam m $m_orig $inst
			starcMS90G_symSetParam nlIgnore $nlIgnore_orig $inst
			starcMS90G_symSetParam nrd $nrd_orig $inst
			starcMS90G_symSetParam nrs $nrs_orig $inst
			starcMS90G_symSetParam pd $pd_orig $inst
			starcMS90G_symSetParam ps $ps_orig $inst
			starcMS90G_symSetParam sa $sa_orig $inst
			starcMS90G_symSetParam sb $sb_orig $inst
			starcMS90G_symSetParam sca $sca_orig $inst
			starcMS90G_symSetParam scb $scb_orig $inst
			starcMS90G_symSetParam scc $scc_orig $inst
			starcMS90G_symSetParam simM $simM_orig $inst
			starcMS90G_symSetParam w $w_orig $inst
			starcMS90G_symSetParam wpf $wpf_orig $inst
			ics_rollbackCdfgData $instID
			return
		    }
		    
		    set w [expr $wpf * $fingers]
		    set wgrid [starcMS90G_symGridCheck $w $grid $dbu]
		    starcMS90G_symSetParam w [starcMS90G_sciToEng $wgrid] $inst
		    
		}   else  {
		    set w "(iPar(\"wpf\")) * (iPar(\"fingers\"))"
		    starcMS90G_symSetParam w $w  $inst
		} 
	    } else {
		set w "(iPar(\"wpf\")) * (iPar(\"fingers\"))"
		starcMS90G_symSetParam w $w  $inst
	    }
	}
        
	"l" {
            if { [starcMS90G_symIsVariable [starcMS90G_symGetParam l  $inst]] } {
		set msg ""
		append msg  "\n    *Error* ** $spice_model **\n"
		append msg  "      -> Parameter \"l\" Value \"$l\" is not a valid number\n"
		append msg  "      -> Parameter \"l\" cannot be a variable.\n"
		append msg  "      -> Rollback.\n"
		starcMS90G_prompt $msg 
		starcMS90G_symSetParam ad $ad_orig $inst
		starcMS90G_symSetParam as $as_orig $inst
		starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		starcMS90G_symSetParam dummy_label $dummy_label_orig $inst
		starcMS90G_symSetParam dummy_symbol $dummy_symbol_orig $inst
		starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		starcMS90G_symSetParam fingers $fingers_orig $inst
		starcMS90G_symSetParam ignore $ignore_orig $inst
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam m $m_orig $inst
		starcMS90G_symSetParam nlIgnore $nlIgnore_orig $inst
		starcMS90G_symSetParam nrd $nrd_orig $inst
		starcMS90G_symSetParam nrs $nrs_orig $inst
		starcMS90G_symSetParam pd $pd_orig $inst
		starcMS90G_symSetParam ps $ps_orig $inst
		starcMS90G_symSetParam sa $sa_orig $inst
		starcMS90G_symSetParam sb $sb_orig $inst
		starcMS90G_symSetParam sca $sca_orig $inst
		starcMS90G_symSetParam scb $scb_orig $inst
		starcMS90G_symSetParam scc $scc_orig $inst
		starcMS90G_symSetParam simM $simM_orig $inst
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam wpf $wpf_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }
		

	    set param_check [starcMS90G_symCheckParam [starcMS90G_symGetParam l $inst] $spice_model $inst l]
	    if {[lindex $param_check 0 ] == -1 } {
			starcMS90G_symSetParam ad $ad_orig $inst
			starcMS90G_symSetParam as $as_orig $inst
			starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
			starcMS90G_symSetParam dummy_label $dummy_label_orig $inst
			starcMS90G_symSetParam dummy_symbol $dummy_symbol_orig $inst
			starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
			starcMS90G_symSetParam fingers $fingers_orig $inst
			starcMS90G_symSetParam ignore $ignore_orig $inst
			starcMS90G_symSetParam l $l_orig $inst
			starcMS90G_symSetParam m $m_orig $inst
			starcMS90G_symSetParam nlIgnore $nlIgnore_orig $inst
			starcMS90G_symSetParam nrd $nrd_orig $inst
			starcMS90G_symSetParam nrs $nrs_orig $inst
			starcMS90G_symSetParam pd $pd_orig $inst
			starcMS90G_symSetParam ps $ps_orig $inst
			starcMS90G_symSetParam sa $sa_orig $inst
			starcMS90G_symSetParam sb $sb_orig $inst
			starcMS90G_symSetParam sca $sca_orig $inst
			starcMS90G_symSetParam scb $scb_orig $inst
			starcMS90G_symSetParam scc $scc_orig $inst
			starcMS90G_symSetParam simM $simM_orig $inst
			starcMS90G_symSetParam w $w_orig $inst
			starcMS90G_symSetParam wpf $wpf_orig $inst
			ics_rollbackCdfgData $instID
			return
	    }
	    

            if { ![starcMS90G_symIsVariable [starcMS90G_symGetParam l $inst]] } {
		set l             [starcMS90G_engToSciMaxRes  $l ]
		set lgrid [starcMS90G_symGridCheck $l $grid $dbu]

		set len [starcMS90G_symCheckNoModParamValue l $lgrid \
				    $minLength $maxLength $l_orig 0 1  $spice_model $inst $param]		    

		if {[lindex $len 0 ] == 0 } {
		    set length [lindex $len 1]
		    if {  [expr abs ([expr $l] - [expr $lgrid]) * 1e6] > 1e-18 } {
			append msg  "\n    *Error*  **\n"
			append msg  "      -> Parameter \"l\" Value \"$l\" is not on valid step\n"
			append msg  "      -> Rollback.\n"
			starcMS90G_prompt $msg 
			ics_rollbackCdfgData $instID
			return
		    } else {
			starcMS90G_symSetParam l [starcMS90G_sciToEng $length] $inst
			set l $length
		    }
		} else {
		    starcMS90G_symSetParam ad $ad_orig $inst
		    starcMS90G_symSetParam as $as_orig $inst
		    starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		    starcMS90G_symSetParam dummy_label $dummy_label_orig $inst
		    starcMS90G_symSetParam dummy_symbol $dummy_symbol_orig $inst
		    starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		    starcMS90G_symSetParam fingers $fingers_orig $inst
		    starcMS90G_symSetParam ignore $ignore_orig $inst
		    starcMS90G_symSetParam l $l_orig $inst
		    starcMS90G_symSetParam m $m_orig $inst
		    starcMS90G_symSetParam nlIgnore $nlIgnore_orig $inst
		    starcMS90G_symSetParam nrd $nrd_orig $inst
		    starcMS90G_symSetParam nrs $nrs_orig $inst
		    starcMS90G_symSetParam pd $pd_orig $inst
		    starcMS90G_symSetParam ps $ps_orig $inst
		    starcMS90G_symSetParam sa $sa_orig $inst
		    starcMS90G_symSetParam sb $sb_orig $inst
		    starcMS90G_symSetParam sca $sca_orig $inst
		    starcMS90G_symSetParam scb $scb_orig $inst
		    starcMS90G_symSetParam scc $scc_orig $inst
		    starcMS90G_symSetParam simM $simM_orig $inst
		    starcMS90G_symSetParam w $w_orig $inst
		    starcMS90G_symSetParam wpf $wpf_orig $inst
		    ics_rollbackCdfgData $instID
		    return
		}

	    }
	}
	"dummy_l" {
	    set param_check [starcMS90G_symCheckParam [starcMS90G_symGetParam dummy_l $inst] $spice_model $inst dummy_l]
	    if {[lindex $param_check 0 ] == -1 } {
		starcMS90G_symSetParam ad $ad_orig $inst
		starcMS90G_symSetParam as $as_orig $inst
		starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		starcMS90G_symSetParam dummy_label $dummy_label_orig $inst
		starcMS90G_symSetParam dummy_symbol $dummy_symbol_orig $inst
		starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		starcMS90G_symSetParam fingers $fingers_orig $inst
		starcMS90G_symSetParam ignore $ignore_orig $inst
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam m $m_orig $inst
		starcMS90G_symSetParam nlIgnore $nlIgnore_orig $inst
		starcMS90G_symSetParam nrd $nrd_orig $inst
		starcMS90G_symSetParam nrs $nrs_orig $inst
		starcMS90G_symSetParam pd $pd_orig $inst
		starcMS90G_symSetParam ps $ps_orig $inst
		starcMS90G_symSetParam sa $sa_orig $inst
		starcMS90G_symSetParam sb $sb_orig $inst
		starcMS90G_symSetParam sca $sca_orig $inst
		starcMS90G_symSetParam scb $scb_orig $inst
		starcMS90G_symSetParam scc $scc_orig $inst
		starcMS90G_symSetParam simM $simM_orig $inst
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam wpf $wpf_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }
            if { [starcMS90G_symIsVariable [starcMS90G_symGetParam dummy_l  $inst]] } {
		set msg ""
		append msg  "\n    *Error* ** $spice_model **\n"
		append msg  "      -> Parameter \"dummy_l\" Value \"$dummy_l\" is not a valid number\n"
		append msg  "      -> Parameter \"dummy_l\" cannot be a variable.\n"
		append msg  "      -> Rollback.\n"
		starcMS90G_prompt $msg 
		starcMS90G_symSetParam ad $ad_orig $inst
		starcMS90G_symSetParam as $as_orig $inst
		starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		starcMS90G_symSetParam dummy_label $dummy_label_orig $inst
		starcMS90G_symSetParam dummy_symbol $dummy_symbol_orig $inst
		starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		starcMS90G_symSetParam fingers $fingers_orig $inst
		starcMS90G_symSetParam ignore $ignore_orig $inst
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam m $m_orig $inst
		starcMS90G_symSetParam nlIgnore $nlIgnore_orig $inst
		starcMS90G_symSetParam nrd $nrd_orig $inst
		starcMS90G_symSetParam nrs $nrs_orig $inst
		starcMS90G_symSetParam pd $pd_orig $inst
		starcMS90G_symSetParam ps $ps_orig $inst
		starcMS90G_symSetParam sa $sa_orig $inst
		starcMS90G_symSetParam sb $sb_orig $inst
		starcMS90G_symSetParam sca $sca_orig $inst
		starcMS90G_symSetParam scb $scb_orig $inst
		starcMS90G_symSetParam scc $scc_orig $inst
		starcMS90G_symSetParam simM $simM_orig $inst
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam wpf $wpf_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }
		

            if { ![starcMS90G_symIsVariable [starcMS90G_symGetParam dummy_l $inst]] } {
		set param_check [starcMS90G_symCheckPosInteger dummy_l [starcMS90G_symGetParam dummy_l $inst] $spice_model $inst ]
		if {[lindex $param_check 0 ] == -1 } {
		    starcMS90G_symSetParam ad $ad_orig $inst
		    starcMS90G_symSetParam as $as_orig $inst
		    starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		    starcMS90G_symSetParam dummy_label $dummy_label_orig $inst
		    starcMS90G_symSetParam dummy_symbol $dummy_symbol_orig $inst
		    starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		    starcMS90G_symSetParam fingers $fingers_orig $inst
		    starcMS90G_symSetParam ignore $ignore_orig $inst
		    starcMS90G_symSetParam l $l_orig $inst
		    starcMS90G_symSetParam m $m_orig $inst
		    starcMS90G_symSetParam nlIgnore $nlIgnore_orig $inst
		    starcMS90G_symSetParam nrd $nrd_orig $inst
		    starcMS90G_symSetParam nrs $nrs_orig $inst
		    starcMS90G_symSetParam pd $pd_orig $inst
		    starcMS90G_symSetParam ps $ps_orig $inst
		    starcMS90G_symSetParam sa $sa_orig $inst
		    starcMS90G_symSetParam sb $sb_orig $inst
		    starcMS90G_symSetParam sca $sca_orig $inst
		    starcMS90G_symSetParam scb $scb_orig $inst
		    starcMS90G_symSetParam scc $scc_orig $inst
		    starcMS90G_symSetParam simM $simM_orig $inst
		    starcMS90G_symSetParam w $w_orig $inst
		    starcMS90G_symSetParam wpf $wpf_orig $inst
		    ics_rollbackCdfgData $instID
		    return
		}

		set param_check [starcMS90G_symCheckNoModParamValue dummy_l $dummy_l $minDummyL $maxDummyL $dummy_l_orig 0 1 $spice_model $inst $paramName]
		if {[lindex $param_check 0 ] == -1 } {
		    starcMS90G_symSetParam ad $ad_orig $inst
		    starcMS90G_symSetParam as $as_orig $inst
		    starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		    starcMS90G_symSetParam dummy_label $dummy_label_orig $inst
		    starcMS90G_symSetParam dummy_symbol $dummy_symbol_orig $inst
		    starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		    starcMS90G_symSetParam fingers $fingers_orig $inst
		    starcMS90G_symSetParam ignore $ignore_orig $inst
		    starcMS90G_symSetParam l $l_orig $inst
		    starcMS90G_symSetParam m $m_orig $inst
		    starcMS90G_symSetParam nlIgnore $nlIgnore_orig $inst
		    starcMS90G_symSetParam nrd $nrd_orig $inst
		    starcMS90G_symSetParam nrs $nrs_orig $inst
		    starcMS90G_symSetParam pd $pd_orig $inst
		    starcMS90G_symSetParam ps $ps_orig $inst
		    starcMS90G_symSetParam sa $sa_orig $inst
		    starcMS90G_symSetParam sb $sb_orig $inst
		    starcMS90G_symSetParam sca $sca_orig $inst
		    starcMS90G_symSetParam scb $scb_orig $inst
		    starcMS90G_symSetParam scc $scc_orig $inst
		    starcMS90G_symSetParam simM $simM_orig $inst
		    starcMS90G_symSetParam w $w_orig $inst
		    starcMS90G_symSetParam wpf $wpf_orig $inst
		    ics_rollbackCdfgData $instID
		    return
		}
	    }

#	    set dummyL  [starcMS90G_symCheckParamValue dummy_l $dummy_l  $minDummyL $maxDummyL  0 0 $spice_model $inst $param]

#	    starcMS90G_symSetParam dummy_l $dummyL  $inst
#	    set dummy_l $dummyL
	}
	"dummy_r" {
	    set param_check [starcMS90G_symCheckParam [starcMS90G_symGetParam dummy_r $inst] $spice_model $inst dummy_r]
	    if {[lindex $param_check 0 ] == -1 } {
		starcMS90G_symSetParam ad $ad_orig $inst
		starcMS90G_symSetParam as $as_orig $inst
		starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		starcMS90G_symSetParam dummy_label $dummy_label_orig $inst
		starcMS90G_symSetParam dummy_symbol $dummy_symbol_orig $inst
		starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		starcMS90G_symSetParam fingers $fingers_orig $inst
		starcMS90G_symSetParam ignore $ignore_orig $inst
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam m $m_orig $inst
		starcMS90G_symSetParam nlIgnore $nlIgnore_orig $inst
		starcMS90G_symSetParam nrd $nrd_orig $inst
		starcMS90G_symSetParam nrs $nrs_orig $inst
		starcMS90G_symSetParam pd $pd_orig $inst
		starcMS90G_symSetParam ps $ps_orig $inst
		starcMS90G_symSetParam sa $sa_orig $inst
		starcMS90G_symSetParam sb $sb_orig $inst
		starcMS90G_symSetParam sca $sca_orig $inst
		starcMS90G_symSetParam scb $scb_orig $inst
		starcMS90G_symSetParam scc $scc_orig $inst
		starcMS90G_symSetParam simM $simM_orig $inst
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam wpf $wpf_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }

            if { [starcMS90G_symIsVariable [starcMS90G_symGetParam dummy_r  $inst]] } {
		set msg ""
		append msg  "\n    *Error* ** $spice_model **\n"
		append msg  "      -> Parameter \"dummy_r\" Value \"$dummy_r\" is not a valid number\n"
		append msg  "      -> Parameter \"dummy_r\" cannot be a variable.\n"
		append msg  "      -> Rollback.\n"
		starcMS90G_prompt $msg 
		starcMS90G_symSetParam ad $ad_orig $inst
		starcMS90G_symSetParam as $as_orig $inst
		starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		starcMS90G_symSetParam dummy_label $dummy_label_orig $inst
		starcMS90G_symSetParam dummy_symbol $dummy_symbol_orig $inst
		starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		starcMS90G_symSetParam fingers $fingers_orig $inst
		starcMS90G_symSetParam ignore $ignore_orig $inst
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam m $m_orig $inst
		starcMS90G_symSetParam nlIgnore $nlIgnore_orig $inst
		starcMS90G_symSetParam nrd $nrd_orig $inst
		starcMS90G_symSetParam nrs $nrs_orig $inst
		starcMS90G_symSetParam pd $pd_orig $inst
		starcMS90G_symSetParam ps $ps_orig $inst
		starcMS90G_symSetParam sa $sa_orig $inst
		starcMS90G_symSetParam sb $sb_orig $inst
		starcMS90G_symSetParam sca $sca_orig $inst
		starcMS90G_symSetParam scb $scb_orig $inst
		starcMS90G_symSetParam scc $scc_orig $inst
		starcMS90G_symSetParam simM $simM_orig $inst
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam wpf $wpf_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }
		

            if { ![starcMS90G_symIsVariable [starcMS90G_symGetParam dummy_r $inst]] } {
		set param_check [starcMS90G_symCheckPosInteger dummy_r [starcMS90G_symGetParam dummy_r $inst] $spice_model $inst ]
		if {[lindex $param_check 0 ] == -1 } {
		    starcMS90G_symSetParam ad $ad_orig $inst
		    starcMS90G_symSetParam as $as_orig $inst
		    starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		    starcMS90G_symSetParam dummy_label $dummy_label_orig $inst
		    starcMS90G_symSetParam dummy_symbol $dummy_symbol_orig $inst
		    starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		    starcMS90G_symSetParam fingers $fingers_orig $inst
		    starcMS90G_symSetParam ignore $ignore_orig $inst
		    starcMS90G_symSetParam l $l_orig $inst
		    starcMS90G_symSetParam m $m_orig $inst
		    starcMS90G_symSetParam nlIgnore $nlIgnore_orig $inst
		    starcMS90G_symSetParam nrd $nrd_orig $inst
		    starcMS90G_symSetParam nrs $nrs_orig $inst
		    starcMS90G_symSetParam pd $pd_orig $inst
		    starcMS90G_symSetParam ps $ps_orig $inst
		    starcMS90G_symSetParam sa $sa_orig $inst
		    starcMS90G_symSetParam sb $sb_orig $inst
		    starcMS90G_symSetParam sca $sca_orig $inst
		    starcMS90G_symSetParam scb $scb_orig $inst
		    starcMS90G_symSetParam scc $scc_orig $inst
		    starcMS90G_symSetParam simM $simM_orig $inst
		    starcMS90G_symSetParam w $w_orig $inst
		    starcMS90G_symSetParam wpf $wpf_orig $inst
		    ics_rollbackCdfgData $instID
		    return
		}


		set param_check [starcMS90G_symCheckNoModParamValue dummy_r $dummy_r $minDummyR $maxDummyR $dummy_r_orig 0 1 $spice_model $inst $paramName]
		if {[lindex $param_check 0 ] == -1 } {
		    starcMS90G_symSetParam ad $ad_orig $inst
		    starcMS90G_symSetParam as $as_orig $inst
		    starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		    starcMS90G_symSetParam dummy_label $dummy_label_orig $inst
		    starcMS90G_symSetParam dummy_symbol $dummy_symbol_orig $inst
		    starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		    starcMS90G_symSetParam fingers $fingers_orig $inst
		    starcMS90G_symSetParam ignore $ignore_orig $inst
		    starcMS90G_symSetParam l $l_orig $inst
		    starcMS90G_symSetParam m $m_orig $inst
		    starcMS90G_symSetParam nlIgnore $nlIgnore_orig $inst
		    starcMS90G_symSetParam nrd $nrd_orig $inst
		    starcMS90G_symSetParam nrs $nrs_orig $inst
		    starcMS90G_symSetParam pd $pd_orig $inst
		    starcMS90G_symSetParam ps $ps_orig $inst
		    starcMS90G_symSetParam sa $sa_orig $inst
		    starcMS90G_symSetParam sb $sb_orig $inst
		    starcMS90G_symSetParam sca $sca_orig $inst
		    starcMS90G_symSetParam scb $scb_orig $inst
		    starcMS90G_symSetParam scc $scc_orig $inst
		    starcMS90G_symSetParam simM $simM_orig $inst
		    starcMS90G_symSetParam w $w_orig $inst
		    starcMS90G_symSetParam wpf $wpf_orig $inst
		    ics_rollbackCdfgData $instID
		    return
		}
		
	    }
#	    starcMS90G_symSetParam dummy_l $dummyL  $inst
#	    set dummy_l $dummyL


#	    set dummyR  [starcMS90G_symCheckParamValue dummy_r $dummy_r  $minDummyR $maxDummyR  0 0 $spice_model $inst $param]
#	    starcMS90G_symSetParam dummy_r $dummyR  $inst
#	    set dummy_r $dummyR
	}
	"m" {
	    set param_check [starcMS90G_symCheckParam [starcMS90G_symGetParam m $inst] $spice_model $inst m]
	    if {[lindex $param_check 0 ] == -1 } {
		starcMS90G_symSetParam ad $ad_orig $inst
		starcMS90G_symSetParam as $as_orig $inst
		starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		starcMS90G_symSetParam dummy_label $dummy_label_orig $inst
		starcMS90G_symSetParam dummy_symbol $dummy_symbol_orig $inst
		starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		starcMS90G_symSetParam fingers $fingers_orig $inst
		starcMS90G_symSetParam ignore $ignore_orig $inst
		starcMS90G_symSetParam l $l_orig $inst
		starcMS90G_symSetParam m $m_orig $inst
		starcMS90G_symSetParam nlIgnore $nlIgnore_orig $inst
		starcMS90G_symSetParam nrd $nrd_orig $inst
		starcMS90G_symSetParam nrs $nrs_orig $inst
		starcMS90G_symSetParam pd $pd_orig $inst
		starcMS90G_symSetParam ps $ps_orig $inst
		starcMS90G_symSetParam sa $sa_orig $inst
		starcMS90G_symSetParam sb $sb_orig $inst
		starcMS90G_symSetParam sca $sca_orig $inst
		starcMS90G_symSetParam scb $scb_orig $inst
		starcMS90G_symSetParam scc $scc_orig $inst
		starcMS90G_symSetParam simM $simM_orig $inst
		starcMS90G_symSetParam w $w_orig $inst
		starcMS90G_symSetParam wpf $wpf_orig $inst
		ics_rollbackCdfgData $instID
		return
	    }
            if { ![starcMS90G_symIsVariable [starcMS90G_symGetParam m $inst]] } {
		set param_check [starcMS90G_symCheckInteger m [starcMS90G_symGetParam m $inst] $spice_model $inst ]
		if {[lindex $param_check 0 ] == -1 } {
		    starcMS90G_symSetParam ad $ad_orig $inst
		    starcMS90G_symSetParam as $as_orig $inst
		    starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		    starcMS90G_symSetParam dummy_label $dummy_label_orig $inst
		    starcMS90G_symSetParam dummy_symbol $dummy_symbol_orig $inst
		    starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		    starcMS90G_symSetParam fingers $fingers_orig $inst
		    starcMS90G_symSetParam ignore $ignore_orig $inst
		    starcMS90G_symSetParam l $l_orig $inst
		    starcMS90G_symSetParam m $m_orig $inst
		    starcMS90G_symSetParam nlIgnore $nlIgnore_orig $inst
		    starcMS90G_symSetParam nrd $nrd_orig $inst
		    starcMS90G_symSetParam nrs $nrs_orig $inst
		    starcMS90G_symSetParam pd $pd_orig $inst
		    starcMS90G_symSetParam ps $ps_orig $inst
		    starcMS90G_symSetParam sa $sa_orig $inst
		    starcMS90G_symSetParam sb $sb_orig $inst
		    starcMS90G_symSetParam sca $sca_orig $inst
		    starcMS90G_symSetParam scb $scb_orig $inst
		    starcMS90G_symSetParam scc $scc_orig $inst
		    starcMS90G_symSetParam simM $simM_orig $inst
		    starcMS90G_symSetParam w $w_orig $inst
		    starcMS90G_symSetParam wpf $wpf_orig $inst
		    ics_rollbackCdfgData $instID
		    return
		}


		set param_check [starcMS90G_symCheckNoModParamValue m $m $minM $maxM $m_orig 0 1 $spice_model $inst $paramName]
		if {[lindex $param_check 0 ] == -1 } {
		    starcMS90G_symSetParam ad $ad_orig $inst
		    starcMS90G_symSetParam as $as_orig $inst
		    starcMS90G_symSetParam dummy_l $dummy_l_orig $inst
		    starcMS90G_symSetParam dummy_label $dummy_label_orig $inst
		    starcMS90G_symSetParam dummy_symbol $dummy_symbol_orig $inst
		    starcMS90G_symSetParam dummy_r $dummy_r_orig $inst
		    starcMS90G_symSetParam fingers $fingers_orig $inst
		    starcMS90G_symSetParam ignore $ignore_orig $inst
		    starcMS90G_symSetParam l $l_orig $inst
		    starcMS90G_symSetParam m $m_orig $inst
		    starcMS90G_symSetParam nlIgnore $nlIgnore_orig $inst
		    starcMS90G_symSetParam nrd $nrd_orig $inst
		    starcMS90G_symSetParam nrs $nrs_orig $inst
		    starcMS90G_symSetParam pd $pd_orig $inst
		    starcMS90G_symSetParam ps $ps_orig $inst
		    starcMS90G_symSetParam sa $sa_orig $inst
		    starcMS90G_symSetParam sb $sb_orig $inst
		    starcMS90G_symSetParam sca $sca_orig $inst
		    starcMS90G_symSetParam scb $scb_orig $inst
		    starcMS90G_symSetParam scc $scc_orig $inst
		    starcMS90G_symSetParam simM $simM_orig $inst
		    starcMS90G_symSetParam w $w_orig $inst
		    starcMS90G_symSetParam wpf $wpf_orig $inst
		    ics_rollbackCdfgData $instID
		    return
		}
		
	    }

#	    set m [starcMS90G_symCheckInteger m $m $spice_model $inst]
#	    set m  [starcMS90G_symCheckParamValue m $m  $minM $maxM  0 0 $spice_model $inst $param]
#	    starcMS90G_symSetParam m $m  $inst
#	    set m $m
	}
	"dummy_symbol" {
	    if { $dummy_symbol } {
		starcMS90G_symSetParam ignore 1  $inst
		starcMS90G_symSetParam dummy_label "Dummy"  $inst
		starcMS90G_symSetParam nlIgnore "spectre hspice"  $inst
	    } else {
		starcMS90G_symSetParam ignore 0  $inst
		starcMS90G_symSetParam dummy_label ""  $inst
		starcMS90G_symSetParam nlIgnore ""  $inst
	    }
	}


    }




    if { $paramName == "w" || $paramName == "l" || $paramName == "fingers"  || $paramName == "m" || $paramName == "shared_sd"  \
	     || $paramName == "wpf" || $paramName == "dummy_r"  || $paramName == "dummy_l" } {
	if { ![starcMS90G_symIsVariable [starcMS90G_symGetParam wpf $inst]] } {
	    if { ! [starcMS90G_symIsVariable [starcMS90G_symGetParam fingers $inst]] } {
		set wpf             [starcMS90G_engToSci  $wpf ]
		
		# AD
		if { [expr $fingers % 2  ] != 0 } {
		    if { $shared_sd == "Drain" } {
			
			set ad [ expr ((1-ceil($dummy_r/($dummy_r+1.0)))*($wpf*($dhd+$dsd))+(floor($fingers/2.0)+ceil($dummy_r/($dummy_r+1.0)))*($wpf*(2*$dhd)))/$fingers ]
		    } else {
			set ad [ expr ((1-ceil($dummy_l/($dummy_l+1.0)))*($wpf*($dhd+$dsd))+(floor($fingers/2.0)+ceil($dummy_l/($dummy_l+1.0)))*($wpf*(2*$dhd)))/$fingers ]
		    }
		} else {
		    if { $shared_sd == "Drain" } {
			set ad [ expr (($fingers/2)*($wpf*(2*$dhd)))/$fingers ]
		    } else {
			set ad [expr  ((2-ceil($dummy_l/($dummy_l+1.0))-ceil($dummy_r/($dummy_r+1.0)))*($wpf*($dhd+$dsd))+((($fingers/2-1)+ceil($dummy_l/($dummy_l+1.0))+ceil($dummy_r/($dummy_r+1.0)))*($wpf*(2*$dhd))))/$fingers ]
		    }
		    
		}
		
		
		
		#	    puts "AD $ad"
		starcMS90G_symSetParam ad [starcMS90G_sciToEng $ad] $inst
		
		# AS
		if { [expr $fingers % 2  ] != 0 } {
		    if { $shared_sd == "Drain" } {
			set as [expr  ((1-ceil($dummy_l/($dummy_l+1.0)))*($wpf*($shd+$ssd))+(floor($fingers/2.0)+ceil($dummy_l/($dummy_l+1.0)))*($wpf*(2*$shd)))/$fingers ]
		    } else {
			set as [expr  ((1-ceil($dummy_r/($dummy_r+1.0)))*($wpf*($shd+$ssd))+(floor($fingers/2.0)+ceil($dummy_r/($dummy_r+1.0)))*($wpf*(2*$shd)))/$fingers ]
		    }
		} else {
		    if { $shared_sd == "Drain" } {
			set as [expr  ((2-ceil($dummy_l/($dummy_l+1.0))-ceil($dummy_r/($dummy_r+1.0)))*($wpf*($shd+$ssd))+((($fingers/2-1)+ceil($dummy_l/($dummy_l+1.0))+ceil($dummy_r/($dummy_r+1.0)))*($wpf*(2*$shd))))/$fingers ]
		    } else {
			set as [expr (($fingers/2)*($wpf*(2*$shd)))/$fingers ]
		    }
		}
		
		#	    puts "AS $as"
		starcMS90G_symSetParam as [starcMS90G_sciToEng $as] $inst
		
		# PD
		if { [expr $fingers % 2  ] != 0 } {
		    if { $shared_sd == "Drain" } {
			set pd [expr ((1-ceil($dummy_r/($dummy_r+1.0)))*(2*($wpf+$dhd+$dsd))+(floor($fingers/2.0)+ceil($dummy_r/($dummy_r+1.0)))*(2*($wpf+(2*$dhd))))/$fingers ] 
		    } else {
			set pd [expr ((1-ceil($dummy_l/($dummy_l+1.0)))*(2*($wpf+$dhd+$dsd))+(floor($fingers/2.0)+ceil($dummy_l/($dummy_l+1.0)))*(2*($wpf+(2*$dhd))))/$fingers ]
		    }
		} else {
		    if { $shared_sd == "Drain" } {
			set pd [expr (($fingers/2)*(2*($wpf+(2*$dhd))))/$fingers ]
		    } else {
			set pd [expr ((2-ceil($dummy_l/($dummy_l+1.0))-ceil($dummy_r/($dummy_r+1.0)))*(2*($wpf+$dhd+$dsd))+((($fingers/2-1)+ceil($dummy_l/($dummy_l+1.0))+ceil($dummy_r/($dummy_r+1.0)))*(2*($wpf+(2*$dhd)))))/$fingers ]
		    }
		}
		#	    puts "PD $pd"
		starcMS90G_symSetParam pd [starcMS90G_sciToEng $pd] $inst
		
		
		# PS
		if { [expr $fingers % 2  ] != 0 } {
		    if { $shared_sd == "Drain" } {
			set ps [expr ((1-ceil($dummy_l/($dummy_l+1.0)))*(2*($wpf+$shd+$ssd))+(floor($fingers/2.0)+ceil($dummy_l/($dummy_l+1.0)))*(2*($wpf+(2*$shd))))/$fingers ]
		    } else {
			set ps [expr ((1-ceil($dummy_r/($dummy_r+1.0)))*(2*($wpf+$shd+$ssd))+(floor($fingers/2.0)+ceil($dummy_r/($dummy_r+1.0)))*(2*($wpf+(2*$shd))))/$fingers ]
		    }
		} else {
		    if { $shared_sd == "Drain" } {
			set ps [expr ((2-ceil($dummy_l/($dummy_l+1.0))-ceil($dummy_r/($dummy_r+1.0)))*(2*($wpf+$shd+$ssd))+((($fingers/2-1)+ceil($dummy_l/($dummy_l+1.0))+ceil($dummy_r/($dummy_r+1.0)))*(2*($wpf+(2*$shd)))))/$fingers ]
		    } else {
			set ps [expr (($fingers/2)*(2*($wpf+(2*$shd))))/$fingers ]
		    }
		}
		#	    puts "PS $ps"
		starcMS90G_symSetParam ps [starcMS90G_sciToEng $ps] $inst
		
		
		# NRD
		set nrd [expr $dhd / $wpf ]
		starcMS90G_symSetParam nrd [starcMS90G_sciToEng $nrd] $inst
		#	    puts "NRD $nrd"
		# NRS
		set nrs [expr $shd / $wpf ]
		#	    puts "NRS $nrs"
		starcMS90G_symSetParam nrs [starcMS90G_sciToEng $nrs] $inst
		# SA
		
		
		if { ![starcMS90G_symIsVariable [starcMS90G_symGetParam l $inst]] } {
		    set l             [starcMS90G_engToSci  $l ]
		    if { $shared_sd == "Drain" } {
#			puts "DEBUG $shd $fingers $dhd $dummy_l $ssd $l"
			
			set sa [expr ((2*$shd)*(ceil($dummy_l/2.0)*$fingers + (floor(($fingers-1)/2.0) * ceil($fingers/2.0)+(floor($fingers/2.0)-1)*floor($fingers/2.0))/2.0)+(2*$dhd)*(floor($dummy_l/2.0)*$fingers+((1+floor($fingers/2.0))*floor($fingers/2.0)+(ceil($fingers/2.0)-1)*ceil($fingers/2.0))/2.0)+$l*$fingers*($dummy_l+($fingers-1)/2.0)+($shd+$ssd)*$fingers*(1-ceil($dummy_l/2.0-floor($dummy_l/2.0)))+($dhd+$dsd)*$fingers*ceil($dummy_l/2.0-floor($dummy_l/2.0)))/$fingers]
			
			
		    } else {
			set sa [expr ((2*$dhd)*(ceil($dummy_l/2.0)*$fingers+(floor(($fingers-1)/2.0)*ceil($fingers/2.0)+(floor($fingers/2.0)-1)*floor($fingers/2.0))/2.0)+(2*$shd)*(floor($dummy_l/2.0)*$fingers+((1+floor($fingers/2.0))*floor($fingers/2.0)+(ceil($fingers/2.0)-1)*ceil($fingers/2.0))/2.0)+$l*$fingers*($dummy_l+($fingers-1)/2.0)+($dhd+$dsd)*$fingers*(1-ceil($dummy_l/2.0-floor($dummy_l/2.0)))+($shd+$ssd)*$fingers*ceil($dummy_l/2.0-floor($dummy_l/2.0)))/$fingers ]
		    }
		    
		    #		puts "SA $sa"
		    starcMS90G_symSetParam sa [starcMS90G_sciToEng $sa] $inst
		    #SB
		    if { [expr $fingers % 2  ] != 0 } {
			if { $shared_sd == "Drain" } {
			    set sb [expr ($l*($fingers-1+2*$dummy_r)*$fingers/2+(2*$shd)*(ceil($dummy_r/2.0)*$fingers+floor(($fingers-1)/2.0)*ceil($fingers/2.0))+(2*$dhd)*(floor($dummy_r/2.0)*$fingers+floor($fingers/2.0)*floor($fingers/2.0))+($shd+$ssd)*$fingers*(1-ceil($dummy_r/2.0-floor($dummy_r/2.0)))+($dhd+$dsd)*$fingers*ceil($dummy_r/2.0-floor($dummy_r/2.0)))/$fingers ]
			} else {
			    set sb [expr ($l*($fingers-1+2*$dummy_r)*$fingers/2+(2*$shd)*(floor($dummy_r/2.0)*$fingers+floor($fingers/2.0)*floor($fingers/2.0))+(2*$dhd)*(ceil($dummy_r/2.0)*$fingers+floor(($fingers-1)/2.0)*ceil($fingers/2.0))+($dhd+$dsd)*$fingers*(1-ceil($dummy_r/2.0-floor($dummy_r/2.0)))+($shd+$ssd)*$fingers*ceil($dummy_r/2.0-floor($dummy_r/2.0)))/$fingers ]
			}
		    } else {
			if { $shared_sd == "Drain" } {
			    set sb [expr ($l*($fingers-1+2*$dummy_r)*$fingers/2+(2*$shd)*(floor($dummy_r/2.0)*$fingers+floor(($fingers-1)/2.0)*ceil($fingers/2.0))+(2*$dhd)*(ceil($dummy_r/2.0)*$fingers+floor($fingers/2.0)*floor($fingers/2.0))+($shd+$ssd)*$fingers*ceil($dummy_r/2.0-floor($dummy_r/2.0))+($dhd+$dsd)*$fingers*(1-ceil($dummy_r/2.0-floor($dummy_r/2.0))))/$fingers ]
			} else {
			    set sb [expr ($l*($fingers-1+2*$dummy_r)*$fingers/2+(2*$shd)*(ceil($dummy_r/2.0)*$fingers+floor($fingers/2.0)*floor($fingers/2.0))+(2*$dhd)*(floor($dummy_r/2.0)*$fingers+floor(($fingers-1)/2.0)*ceil($fingers/2.0))+($dhd+$dsd)*$fingers*ceil($dummy_r/2.0-floor($dummy_r/2.0))+($shd+$ssd)*$fingers*(1-ceil($dummy_r/2.0-floor($dummy_r/2.0))))/$fingers ]
			}
			
		    }
		    #		puts "SB $sb"
		    starcMS90G_symSetParam sb [starcMS90G_sciToEng $sb] $inst
		} else {
		    
		    
		    if { $shared_sd == "Drain" } {
			set sa "((2*(iPar(\"shd\")))*(ceil((iPar(\"dummy_l\"))/2.0)*(iPar(\"fingers\"))+(floor(((iPar(\"fingers\"))-1)/2.0)*ceil((iPar(\"fingers\"))/2.0)+(floor((iPar(\"fingers\"))/2.0)-1)*floor((iPar(\"fingers\"))/2.0))/2.0)+(2*(iPar(\"dhd\")))*(floor((iPar(\"dummy_l\"))/2.0)*(iPar(\"fingers\"))+((1+floor((iPar(\"fingers\"))/2.0))*floor((iPar(\"fingers\"))/2.0)+(ceil((iPar(\"fingers\"))/2.0)-1)*ceil((iPar(\"fingers\"))/2.0))/2.0)+(iPar(\"l\"))*(iPar(\"fingers\"))*((iPar(\"dummy_l\"))+((iPar(\"fingers\"))-1)/2.0)+((iPar(\"shd\"))+(iPar(\"ssd\")))*(iPar(\"fingers\"))*(1-ceil((iPar(\"dummy_l\"))/2.0-floor((iPar(\"dummy_l\"))/2.0)))+((iPar(\"dhd\"))+(iPar(\"dsd\")))*(iPar(\"fingers\"))*ceil((iPar(\"dummy_l\"))/2.0-floor((iPar(\"dummy_l\"))/2.0)))/(iPar(\"fingers\"))"
			
		    } else {
			set sa "((2*(iPar(\"dhd\")))*(ceil((iPar(\"dummy_l\"))/2.0)*(iPar(\"fingers\"))+(floor(((iPar(\"fingers\"))-1)/2.0)*ceil((iPar(\"fingers\"))/2.0)+(floor((iPar(\"fingers\"))/2.0)-1)*floor((iPar(\"fingers\"))/2.0))/2.0)+(2*(iPar(\"shd\")))*(floor((iPar(\"dummy_l\"))/2.0)*(iPar(\"fingers\"))+((1+floor((iPar(\"fingers\"))/2.0))*floor((iPar(\"fingers\"))/2.0)+(ceil((iPar(\"fingers\"))/2.0)-1)*ceil((iPar(\"fingers\"))/2.0))/2.0)+(iPar(\"l\"))*(iPar(\"fingers\"))*((iPar(\"dummy_l\"))+((iPar(\"fingers\"))-1)/2.0)+((iPar(\"dhd\"))+(iPar(\"dsd\")))*(iPar(\"fingers\"))*(1-ceil((iPar(\"dummy_l\"))/2.0-floor((iPar(\"dummy_l\"))/2.0)))+((iPar(\"shd\"))+(iPar(\"ssd\")))*(iPar(\"fingers\"))*ceil((iPar(\"dummy_l\"))/2.0-floor((iPar(\"dummy_l\"))/2.0)))/(iPar(\"fingers\"))"
		    }
		    #		puts "SA $sa"
		    
		    starcMS90G_symSetParam sa $sa $inst
		    #SB
		    if { [expr $fingers % 2  ] != 0 } {
			if { $shared_sd == "Drain" } {
			    set sb "((iPar(\"l\"))*((iPar(\"fingers\"))-1+2*(iPar(\"dummy_r\")))*(iPar(\"fingers\"))/2+(2*(iPar(\"shd\")))*(floor((iPar(\"dummy_r\"))/2.0)*(iPar(\"fingers\"))+floor(((iPar(\"fingers\"))-1)/2.0)*ceil((iPar(\"fingers\"))/2.0))+(2*(iPar(\"dhd\")))*(ceil((iPar(\"dummy_r\"))/2.0)*(iPar(\"fingers\"))+floor((iPar(\"fingers\"))/2.0)*floor((iPar(\"fingers\"))/2.0))+((iPar(\"shd\"))+(iPar(\"ssd\")))*(iPar(\"fingers\"))*ceil((iPar(\"dummy_r\"))/2.0-floor((iPar(\"dummy_r\"))/2.0))+((iPar(\"dhd\"))+(iPar(\"dsd\")))*(iPar(\"fingers\"))*(1-ceil((iPar(\"dummy_r\"))/2.0-floor((iPar(\"dummy_r\"))/2.0))))/(iPar(\"fingers\"))"
			} else {
			    
			    set sb "((iPar(\"l\"))*((iPar(\"fingers\"))-1+2*(iPar(\"dummy_r\")))*(iPar(\"fingers\"))/2+(2*(iPar(\"shd\")))*(floor((iPar(\"dummy_r\"))/2.0)*(iPar(\"fingers\"))+floor((iPar(\"fingers\"))/2.0)*floor((iPar(\"fingers\"))/2.0))+(2*(iPar(\"dhd\")))*(ceil((iPar(\"dummy_r\"))/2.0)*(iPar(\"fingers\"))+floor(((iPar(\"fingers\"))-1)/2.0)*ceil((iPar(\"fingers\"))/2.0))+((iPar(\"dhd\"))+(iPar(\"dsd\")))*(iPar(\"fingers\"))*(1-ceil((iPar(\"dummy_r\"))/2.0-floor((iPar(\"dummy_r\"))/2.0)))+((iPar(\"shd\"))+(iPar(\"ssd\")))*(iPar(\"fingers\"))*ceil((iPar(\"dummy_r\"))/2.0-floor((iPar(\"dummy_r\"))/2.0)))/(iPar(\"fingers\"))"
			}
		    } else {
			if { $shared_sd == "Drain" } {
			    set sb "((iPar(\"l\"))*((iPar(\"fingers\"))-1+2*(iPar(\"dummy_r\")))*(iPar(\"fingers\"))/2+(2*(iPar(\"shd\")))*(floor((iPar(\"dummy_r\"))/2.0)*(iPar(\"fingers\"))+floor(((iPar(\"fingers\"))-1)/2.0)*ceil((iPar(\"fingers\"))/2.0))+(2*(iPar(\"dhd\")))*(ceil((iPar(\"dummy_r\"))/2.0)*(iPar(\"fingers\"))+floor((iPar(\"fingers\"))/2.0)*floor((iPar(\"fingers\"))/2.0))+((iPar(\"shd\"))+(iPar(\"ssd\")))*(iPar(\"fingers\"))*ceil((iPar(\"dummy_r\"))/2.0-floor((iPar(\"dummy_r\"))/2.0))+((iPar(\"dhd\"))+(iPar(\"dsd\")))*(iPar(\"fingers\"))*(1-ceil((iPar(\"dummy_r\"))/2.0-floor((iPar(\"dummy_r\"))/2.0))))/(iPar(\"fingers\"))"
			} else {
			    set sb "((iPar(\"l\"))*((iPar(\"fingers\"))-1+2*(iPar(\"dummy_r\")))*(iPar(\"fingers\"))/2+(2*(iPar(\"shd\")))*(ceil((iPar(\"dummy_r\"))/2.0)*(iPar(\"fingers\"))+floor((iPar(\"fingers\"))/2.0)*floor((iPar(\"fingers\"))/2.0))+(2*(iPar(\"dhd\")))*(floor((iPar(\"dummy_r\"))/2.0)*(iPar(\"fingers\"))+floor(((iPar(\"fingers\"))-1)/2.0)*ceil((iPar(\"fingers\"))/2.0))+((iPar(\"dhd\"))+(iPar(\"dsd\")))*(iPar(\"fingers\"))*ceil((iPar(\"dummy_r\"))/2.0-floor((iPar(\"dummy_r\"))/2.0))+((iPar(\"shd\"))+(iPar(\"ssd\")))*(iPar(\"fingers\"))*(1-ceil((iPar(\"dummy_r\"))/2.0-floor((iPar(\"dummy_r\"))/2.0))))/(iPar(\"fingers\"))"
			}
			
		    }
		    #		puts "SB $sb"
		    starcMS90G_symSetParam sb  $sb $inst
		}
		# SCA
		set sca [expr ( pow($scref,2) /$wpf ) * ((1/$sc)-(1/($sc+$wpf))) ]
		#	    puts "SCA $sca"
		starcMS90G_symSetParam sca [starcMS90G_sciToEng $sca] $inst
		# SCB
		#	    puts "SC $sc SCREF $scref wpf $wpf"
		
		if {  [catch {expr exp(-10*($sc/$scref))} ] } {
		    set exp1 0.0
		} else {
		    set exp1 [expr exp(-10*($sc/$scref)) ]
		}
		if {  [catch {expr  exp(-10*(($sc+$wpf)/$scref))} ] } { 
		    set exp2 0.0
		} else {
		    set exp2 [expr 	    exp(-10*(($sc+$wpf)/$scref)) ]
		}
		
		if {  [catch {expr exp(-20*($sc/$scref)) } ] } {
		    set exp3 0.0
		} else {
		    set exp3 [expr exp(-20*($sc/$scref)) ]
		}
		if {  [catch {expr  exp(-20*(($sc+$wpf)/$scref)) } ] } {
		    set exp4 0.0
		} else {
		    set exp4 [expr 	    exp(-20*(($sc+$wpf)/$scref)) ]
		}
		
		set scb [expr (1/($wpf*$scref))*((($scref/10)*$sc* $exp1  )+((pow($scref,2)/100)* $exp1  )-(($scref/10)*($sc+$wpf)* $exp2  )-((pow($scref,2)/100)* $exp2 )) ]
		#	    puts "SCB $scb"
		starcMS90G_symSetParam scb [starcMS90G_sciToEng $scb] $inst
		# SCC
		set scc [expr (1/($wpf*$scref))*((($scref/20)*$sc* $exp3 )+((pow($scref,2)/400)* $exp3 ) -(($scref/20)*($sc+$wpf)* $exp4  )-((pow($scref,2)/400)* $exp4 ) ) ]
		#	    puts "SCC $scc"
		starcMS90G_symSetParam scc [starcMS90G_sciToEng $scc] $inst
		# simM
#		set simM [expr floor($m * $fingers) ]
#		set simM "iPar(\"m\")* iPar(\"fingers\")"
		set simM [expr $m * $fingers ]
		starcMS90G_symSetParam simM  $simM  $inst
		#	    puts "simM $simM"
#		starcMS90G_symSetParam simM [starcMS90G_sciToEng $simM ] $inst
	    }
	} else {
	    
	    # AD
	    if { [expr $fingers % 2  ] != 0 } {
		if { $shared_sd == "Drain" } {
		    set ad "(((1-ceil((iPar(\"dummy_r\"))/((iPar(\"dummy_r\"))+1.0)))*((iPar(\"wpf\"))*((iPar(\"dhd\"))+(iPar(\"dsd\"))))+(floor((iPar(\"fingers\"))/2.0)+ceil((iPar(\"dummy_r\"))/((iPar(\"dummy_r\"))+1.0)))*((iPar(\"wpf\"))*(2*(iPar(\"dhd\")))))/(iPar(\"fingers\")))"
		    
		} else {
		    set ad "(((1-ceil((iPar(\"dummy_l\"))/((iPar(\"dummy_l\"))+1.0)))*((iPar(\"wpf\"))*((iPar(\"dhd\"))+(iPar(\"dsd\"))))+(floor((iPar(\"fingers\"))/2.0)+ceil((iPar(\"dummy_l\"))/((iPar(\"dummy_l\"))+1.0)))*((iPar(\"wpf\"))*(2*(iPar(\"dhd\")))))/(iPar(\"fingers\")))"
		}
	    } else {
		if { $shared_sd == "Drain" } {
		    set ad "(((iPar(\"fingers\"))/2)*((iPar(\"wpf\"))*(2*(iPar(\"dhd\")))))/(iPar(\"fingers\"))"
		} else  {
		    set ad "((2-ceil((iPar(\"dummy_l\"))/((iPar(\"dummy_l\"))+1.0))-ceil((iPar(\"dummy_r\"))/((iPar(\"dummy_r\"))+1.0)))*((iPar(\"wpf\"))*((iPar(\"dhd\"))+(iPar(\"dsd\"))))+((((iPar(\"fingers\"))/2-1)+ceil((iPar(\"dummy_l\"))/((iPar(\"dummy_l\"))+1.0))+ceil((iPar(\"dummy_r\"))/((iPar(\"dummy_r\"))+1.0)))*((iPar(\"wpf\"))*(2*(iPar(\"dhd\"))))))/(iPar(\"fingers\"))"
		}
		
	    }
	    
	    #	    puts "AD $ad"
	    starcMS90G_symSetParam ad  $ad $inst
	    # AS
	    if { [expr $fingers % 2  ] != 0 } {
		if { $shared_sd == "Drain" } {
		    set as "((1-ceil((iPar(\"dummy_l\"))/((iPar(\"dummy_l\"))+1.0)))*((iPar(\"wpf\"))*((iPar(\"shd\"))+(iPar(\"ssd\"))))+(floor((iPar(\"fingers\"))/2.0)+ceil((iPar(\"dummy_l\"))/((iPar(\"dummy_l\"))+1.0)))*((iPar(\"wpf\"))*(2*(iPar(\"shd\")))))/(iPar(\"fingers\"))"
		} else {
		    set as "((1-ceil((iPar(\"dummy_r\"))/((iPar(\"dummy_r\"))+1.0)))*((iPar(\"wpf\"))*((iPar(\"shd\"))+(iPar(\"ssd\"))))+(floor((iPar(\"fingers\"))/2.0)+ceil((iPar(\"dummy_r\"))/((iPar(\"dummy_r\"))+1.0)))*((iPar(\"wpf\"))*(2*(iPar(\"shd\")))))/(iPar(\"fingers\"))"
		}
	    } else {
		if { $shared_sd == "Drain" } {
		    set as "((2-ceil((iPar(\"dummy_l\"))/((iPar(\"dummy_l\"))+1.0))-ceil((iPar(\"dummy_r\"))/((iPar(\"dummy_r\"))+1.0)))*((iPar(\"wpf\"))*((iPar(\"shd\"))+(iPar(\"ssd\"))))+((((iPar(\"fingers\"))/2-1)+ceil((iPar(\"dummy_l\"))/((iPar(\"dummy_l\"))+1.0))+ceil((iPar(\"dummy_r\"))/((iPar(\"dummy_r\"))+1.0)))*((iPar(\"wpf\"))*(2*(iPar(\"shd\"))))))/(iPar(\"fingers\"))"
		} else {
		    set as "(((iPar(\"fingers\"))/2)*((iPar(\"wpf\"))*(2*(iPar(\"shd\")))))/(iPar(\"fingers\"))"
		    
		}
	    }
	    
	    #	    puts "AS $as"
	    starcMS90G_symSetParam as  $as $inst
	    # PD
	    if { [expr $fingers % 2  ] != 0 } {
		if { $shared_sd == "Drain" } {
		    set pd "((1-ceil((iPar(\"dummy_r\"))/((iPar(\"dummy_r\"))+1.0)))*(2*((iPar(\"wpf\"))+(iPar(\"dhd\"))+(iPar(\"dsd\"))))+(floor((iPar(\"fingers\"))/2.0)+ceil((iPar(\"dummy_r\"))/((iPar(\"dummy_r\"))+1.0)))*(2*((iPar(\"wpf\"))+(2*(iPar(\"dhd\"))))))/(iPar(\"fingers\"))"
		    
		} else {
		    set pd "((1-ceil((iPar(\"dummy_l\"))/((iPar(\"dummy_l\"))+1.0)))*(2*((iPar(\"wpf\"))+(iPar(\"dhd\"))+(iPar(\"dsd\"))))+(floor((iPar(\"fingers\"))/2.0)+ceil((iPar(\"dummy_l\"))/((iPar(\"dummy_l\"))+1.0)))*(2*((iPar(\"wpf\"))+(2*(iPar(\"dhd\"))))))/(iPar(\"fingers\"))"
		}
	    } else {
		if { $shared_sd == "Drain" } {
		    set pd "(((iPar(\"fingers\"))/2)*(2*((iPar(\"wpf\"))+(2*(iPar(\"dhd\"))))))/(iPar(\"fingers\"))"
		} else {
		    set pd "((2-ceil((iPar(\"dummy_l\"))/((iPar(\"dummy_l\"))+1.0))-ceil((iPar(\"dummy_r\"))/((iPar(\"dummy_r\"))+1.0)))*(2*((iPar(\"wpf\"))+(iPar(\"dhd\"))+(iPar(\"dsd\"))))+((((iPar(\"fingers\"))/2-1)+ceil((iPar(\"dummy_l\"))/((iPar(\"dummy_l\"))+1.0))+ceil((iPar(\"dummy_r\"))/((iPar(\"dummy_r\"))+1.0)))*(2*((iPar(\"wpf\"))+(2*(iPar(\"dhd\")))))))/(iPar(\"fingers\"))"
		}
	    }
	    
	    #	    puts "PD $pd"
	    starcMS90G_symSetParam pd $pd $inst
	    # PS
	    if { [expr $fingers % 2  ] != 0 } {
		if { $shared_sd == "Drain" } {
		    set ps "((1-ceil((iPar(\"dummy_l\"))/((iPar(\"dummy_l\"))+1.0)))*(2*((iPar(\"wpf\"))+(iPar(\"shd\"))+(iPar(\"ssd\"))))+(floor((iPar(\"fingers\"))/2.0)+ceil((iPar(\"dummy_l\"))/((iPar(\"dummy_l\"))+1.0)))*(2*((iPar(\"wpf\"))+(2*(iPar(\"shd\"))))))/(iPar(\"fingers\"))"
		} else {
		    set ps "((1-ceil((iPar(\"dummy_r\"))/((iPar(\"dummy_r\"))+1.0)))*(2*((iPar(\"wpf\"))+(iPar(\"shd\"))+(iPar(\"ssd\"))))+(floor((iPar(\"fingers\"))/2.0)+ceil((iPar(\"dummy_r\"))/((iPar(\"dummy_r\"))+1.0)))*(2*((iPar(\"wpf\"))+(2*(iPar(\"shd\"))))))/(iPar(\"fingers\"))"
		}
	    } else {
		if { $shared_sd == "Drain" } {
		    set ps "((2-ceil((iPar(\"dummy_l\"))/((iPar(\"dummy_l\"))+1.0))-ceil((iPar(\"dummy_r\"))/((iPar(\"dummy_r\"))+1.0)))*(2*((iPar(\"wpf\"))+(iPar(\"shd\"))+(iPar(\"ssd\"))))+((((iPar(\"fingers\"))/2-1)+ceil((iPar(\"dummy_l\"))/((iPar(\"dummy_l\"))+1.0))+ceil((iPar(\"dummy_r\"))/((iPar(\"dummy_r\"))+1.0)))*(2*((iPar(\"wpf\"))+(2*(iPar(\"shd\")))))))/(iPar(\"fingers\"))"
		} else {
		    set ps "(((iPar(\"fingers\"))/2)*(2*((iPar(\"wpf\"))+(2*(iPar(\"shd\"))))))/(iPar(\"fingers\"))"
		}
	    }
	    #	    puts "PS $ps"
	    starcMS90G_symSetParam ps $ps $inst
	    # NRD
	    set nrd "(iPar(\"dhd\")) / (iPar(\"wpf\"))"
	    starcMS90G_symSetParam nrd  $nrd $inst
	    #	    puts "NRD $nrd"
	    # NRS
	    #	    puts "NRS $nrs
	    set nrs "(iPar(\"shd\")) / (iPar(\"wpf\"))"
	    starcMS90G_symSetParam nrs  $nrs $inst
	    # SA
	    
	    
	    
	    if { $shared_sd == "Drain" } {
		set sa "((2*(iPar(\"shd\")))*(ceil((iPar(\"dummy_l\"))/2.0)*(iPar(\"fingers\"))+(floor(((iPar(\"fingers\"))-1)/2.0)*ceil((iPar(\"fingers\"))/2.0)+(floor((iPar(\"fingers\"))/2.0)-1)*floor((iPar(\"fingers\"))/2.0))/2.0)+(2*(iPar(\"dhd\")))*(floor((iPar(\"dummy_l\"))/2.0)*(iPar(\"fingers\"))+((1+floor((iPar(\"fingers\"))/2.0))*floor((iPar(\"fingers\"))/2.0)+(ceil((iPar(\"fingers\"))/2.0)-1)*ceil((iPar(\"fingers\"))/2.0))/2.0)+(iPar(\"l\"))*(iPar(\"fingers\"))*((iPar(\"dummy_l\"))+((iPar(\"fingers\"))-1)/2.0)+((iPar(\"shd\"))+(iPar(\"ssd\")))*(iPar(\"fingers\"))*(1-ceil((iPar(\"dummy_l\"))/2.0-floor((iPar(\"dummy_l\"))/2.0)))+((iPar(\"dhd\"))+(iPar(\"dsd\")))*(iPar(\"fingers\"))*ceil((iPar(\"dummy_l\"))/2.0-floor((iPar(\"dummy_l\"))/2.0)))/(iPar(\"fingers\"))"
		
	    } else {
		set sa "((2*(iPar(\"dhd\")))*(ceil((iPar(\"dummy_l\"))/2.0)*(iPar(\"fingers\"))+(floor(((iPar(\"fingers\"))-1)/2.0)*ceil((iPar(\"fingers\"))/2.0)+(floor((iPar(\"fingers\"))/2.0)-1)*floor((iPar(\"fingers\"))/2.0))/2.0)+(2*(iPar(\"shd\")))*(floor((iPar(\"dummy_l\"))/2.0)*(iPar(\"fingers\"))+((1+floor((iPar(\"fingers\"))/2.0))*floor((iPar(\"fingers\"))/2.0)+(ceil((iPar(\"fingers\"))/2.0)-1)*ceil((iPar(\"fingers\"))/2.0))/2.0)+(iPar(\"l\"))*(iPar(\"fingers\"))*((iPar(\"dummy_l\"))+((iPar(\"fingers\"))-1)/2.0)+((iPar(\"dhd\"))+(iPar(\"dsd\")))*(iPar(\"fingers\"))*(1-ceil((iPar(\"dummy_l\"))/2.0-floor((iPar(\"dummy_l\"))/2.0)))+((iPar(\"shd\"))+(iPar(\"ssd\")))*(iPar(\"fingers\"))*ceil((iPar(\"dummy_l\"))/2.0-floor((iPar(\"dummy_l\"))/2.0)))/(iPar(\"fingers\"))"
	    }
	    #		puts "SA $sa"
	    
	    starcMS90G_symSetParam sa $sa $inst
	    #SB
	    if { [expr $fingers % 2  ] != 0 } {
		if { $shared_sd == "Drain" } {
		    set sb "((iPar(\"l\"))*((iPar(\"fingers\"))-1+2*(iPar(\"dummy_r\")))*(iPar(\"fingers\"))/2+(2*(iPar(\"shd\")))*(floor((iPar(\"dummy_r\"))/2.0)*(iPar(\"fingers\"))+floor(((iPar(\"fingers\"))-1)/2.0)*ceil((iPar(\"fingers\"))/2.0))+(2*(iPar(\"dhd\")))*(ceil((iPar(\"dummy_r\"))/2.0)*(iPar(\"fingers\"))+floor((iPar(\"fingers\"))/2.0)*floor((iPar(\"fingers\"))/2.0))+((iPar(\"shd\"))+(iPar(\"ssd\")))*(iPar(\"fingers\"))*ceil((iPar(\"dummy_r\"))/2.0-floor((iPar(\"dummy_r\"))/2.0))+((iPar(\"dhd\"))+(iPar(\"dsd\")))*(iPar(\"fingers\"))*(1-ceil((iPar(\"dummy_r\"))/2.0-floor((iPar(\"dummy_r\"))/2.0))))/(iPar(\"fingers\"))"
		} else {
		    
		    set sb "((iPar(\"l\"))*((iPar(\"fingers\"))-1+2*(iPar(\"dummy_r\")))*(iPar(\"fingers\"))/2+(2*(iPar(\"shd\")))*(floor((iPar(\"dummy_r\"))/2.0)*(iPar(\"fingers\"))+floor((iPar(\"fingers\"))/2.0)*floor((iPar(\"fingers\"))/2.0))+(2*(iPar(\"dhd\")))*(ceil((iPar(\"dummy_r\"))/2.0)*(iPar(\"fingers\"))+floor(((iPar(\"fingers\"))-1)/2.0)*ceil((iPar(\"fingers\"))/2.0))+((iPar(\"dhd\"))+(iPar(\"dsd\")))*(iPar(\"fingers\"))*(1-ceil((iPar(\"dummy_r\"))/2.0-floor((iPar(\"dummy_r\"))/2.0)))+((iPar(\"shd\"))+(iPar(\"ssd\")))*(iPar(\"fingers\"))*ceil((iPar(\"dummy_r\"))/2.0-floor((iPar(\"dummy_r\"))/2.0)))/(iPar(\"fingers\"))"
		}
	    } else {
		if { $shared_sd == "Drain" } {
		    set sb "((iPar(\"l\"))*((iPar(\"fingers\"))-1+2*(iPar(\"dummy_r\")))*(iPar(\"fingers\"))/2+(2*(iPar(\"shd\")))*(floor((iPar(\"dummy_r\"))/2.0)*(iPar(\"fingers\"))+floor(((iPar(\"fingers\"))-1)/2.0)*ceil((iPar(\"fingers\"))/2.0))+(2*(iPar(\"dhd\")))*(ceil((iPar(\"dummy_r\"))/2.0)*(iPar(\"fingers\"))+floor((iPar(\"fingers\"))/2.0)*floor((iPar(\"fingers\"))/2.0))+((iPar(\"shd\"))+(iPar(\"ssd\")))*(iPar(\"fingers\"))*ceil((iPar(\"dummy_r\"))/2.0-floor((iPar(\"dummy_r\"))/2.0))+((iPar(\"dhd\"))+(iPar(\"dsd\")))*(iPar(\"fingers\"))*(1-ceil((iPar(\"dummy_r\"))/2.0-floor((iPar(\"dummy_r\"))/2.0))))/(iPar(\"fingers\"))"
		} else {
		    set sb "((iPar(\"l\"))*((iPar(\"fingers\"))-1+2*(iPar(\"dummy_r\")))*(iPar(\"fingers\"))/2+(2*(iPar(\"shd\")))*(ceil((iPar(\"dummy_r\"))/2.0)*(iPar(\"fingers\"))+floor((iPar(\"fingers\"))/2.0)*floor((iPar(\"fingers\"))/2.0))+(2*(iPar(\"dhd\")))*(floor((iPar(\"dummy_r\"))/2.0)*(iPar(\"fingers\"))+floor(((iPar(\"fingers\"))-1)/2.0)*ceil((iPar(\"fingers\"))/2.0))+((iPar(\"dhd\"))+(iPar(\"dsd\")))*(iPar(\"fingers\"))*ceil((iPar(\"dummy_r\"))/2.0-floor((iPar(\"dummy_r\"))/2.0))+((iPar(\"shd\"))+(iPar(\"ssd\")))*(iPar(\"fingers\"))*(1-ceil((iPar(\"dummy_r\"))/2.0-floor((iPar(\"dummy_r\"))/2.0))))/(iPar(\"fingers\"))"
		}
		
	    }
	    #		puts "SB $sb"
	    starcMS90G_symSetParam sb  $sb $inst
	    
	    
	    # SCA
	    set sca "(((iPar(\"scref\"))**2)/(iPar(\"wpf\")))*((1/(iPar(\"sc\")))-(1/((iPar(\"sc\"))+(iPar(\"wpf\")))))"
	    starcMS90G_symSetParam sca  $sca $inst
	    #	    puts "SCA $sca"
	    # SCB
	    #	    puts "SC $sc SCREF $scref wpf $wpf"
	    #	    puts "SCB $scb"
	    set scb "(1/((iPar(\"wpf\"))*(iPar(\"scref\"))))*((((iPar(\"scref\"))/10)*(iPar(\"sc\"))*exp(-10*((iPar(\"sc\"))/(iPar(\"scref\")))))+((((iPar(\"scref\"))**2)/100)*exp(-10*((iPar(\"sc\"))/(iPar(\"scref\")))))-(((iPar(\"scref\"))/10)*((iPar(\"sc\"))+(iPar(\"wpf\")))*exp(-10*(((iPar(\"sc\"))+(iPar(\"wpf\")))/(iPar(\"scref\")))))-((((iPar(\"scref\"))**2)/100)*exp(-10*((iPar(\"sc\"))+(iPar(\"wpf\")))/(iPar(\"scref\")))))"
	    starcMS90G_symSetParam scb  $scb $inst
	    # SCC
	    #	    puts "SCC $scc"
	    set scc "(1/((iPar(\"wpf\"))*(iPar(\"scref\"))))*((((iPar(\"scref\"))/20)*(iPar(\"sc\"))*exp(-20*((iPar(\"sc\"))/(iPar(\"scref\")))))+((((iPar(\"scref\"))**2)/400)*exp(-20*((iPar(\"sc\"))/(iPar(\"scref\")))))-(((iPar(\"scref\"))/20)*((iPar(\"sc\"))+(iPar(\"wpf\")))*exp(-20*(((iPar(\"sc\"))+(iPar(\"wpf\")))/(iPar(\"scref\")))))-((((iPar(\"scref\"))**2)/400)*exp(-20*((iPar(\"sc\"))+(iPar(\"wpf\")))/(iPar(\"scref\")))))"
	    starcMS90G_symSetParam scc  $scc $inst
	    # simM
#	    set simM [expr floor($m * $fingers) ]
	    #	    puts "simM $simM" 
	    set simM "iPar(\"m\")* iPar(\"fingers\")"
	    
	    starcMS90G_symSetParam simM  $simM  $inst
	}
    }
}















