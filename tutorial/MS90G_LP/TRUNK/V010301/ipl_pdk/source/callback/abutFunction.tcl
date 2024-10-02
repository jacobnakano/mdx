proc MS90G_abutFunction {iA iB pA pB side connection event {group "" }} {
  #puts "ABUT CALLED event:$event conn: $connection"
    set mfg_grid 0.005
    set PO_ss 0.25
    set CT_wh 0.12
    set CT_cw 0.11
    
    switch $event {
	1 {
	    return 0
	}
	2 {
	    if { $pA != "" && $pB != "" } {
		set iAW [starcMS90G_symGetParam wpf $iA]
		set iBW [starcMS90G_symGetParam wpf $iB]
		set iAW [starcMS90G_engToSci $iAW]
		set iBW [starcMS90G_engToSci $iBW]
		set diff [expr $iAW - $iBW ]
		if { [expr  abs($diff) > 1.0E-12  ] } {
		    return
		}
		set iAf [starcMS90G_symGetParam fingers $iA]
		set iBf [starcMS90G_symGetParam fingers $iB]
		if {  ( $iAf > 1 || $iBf > 1 ) } {
		    set connection  1
		}
	    }
	    #puts "W AND CONN:  $iAW $iBW $connection"
	    switch $connection {
		0 {
		    
		    set pA_name [oa::getValue [oa::PropFind $pA "name"]]
		    if { $pA_name == "left" } {
			starcMS90G_symSetParam abut_l 1  $iA
			starcMS90G_symSetParam stretch_l [expr -1 * $mfg_grid] $iA
			starcMS90G_symSetParam contact_l 0 $iA
		    } else {
			starcMS90G_symSetParam abut_r 1  $iA
			starcMS90G_symSetParam stretch_r [expr -1 * $mfg_grid] $iA
			starcMS90G_symSetParam contact_r 0 $iA
		    }
		    set pB_name [oa::getValue [oa::PropFind $pB "name"]]
		    if { $pB_name == "left" } {
			starcMS90G_symSetParam abut_l 1  $iB
			starcMS90G_symSetParam stretch_l $PO_ss $iB
			starcMS90G_symSetParam contact_l 0 $iB
		    }  else {
			starcMS90G_symSetParam abut_r 1  $iB
			starcMS90G_symSetParam stretch_r $PO_ss $iB
			starcMS90G_symSetParam contact_r 0 $iB
		    }
		}
		1 {
		    set pA_name [oa::getValue [oa::PropFind $pA "name"]]
		    if { $pA_name == "left" } {
			starcMS90G_symSetParam abut_l 1  $iA
			starcMS90G_symSetParam stretch_l [expr -1 * $mfg_grid] $iA
			starcMS90G_symSetParam contact_l 0 $iA
		    } else {
			starcMS90G_symSetParam abut_r 1  $iA
			starcMS90G_symSetParam stretch_r [expr -1 * $mfg_grid] $iA
			starcMS90G_symSetParam contact_r 0 $iA
		    }
		    set pB_name [oa::getValue [oa::PropFind $pB "name"]]

		    if { $pB_name == "left" } {
			starcMS90G_symSetParam abut_l 1  $iB
			starcMS90G_symSetParam stretch_l [expr $CT_wh + $CT_cw * 2 ] $iB
			starcMS90G_symSetParam contact_l 1 $iB
		    }  else {
			starcMS90G_symSetParam abut_r 1  $iB
			starcMS90G_symSetParam stretch_r [expr $CT_wh + $CT_cw * 2 ] $iB
			starcMS90G_symSetParam contact_r 1 $iB
		    }
		}
	    }
	    return 1
	}
	default {
	    return
	}
	
    }

}






	     

	     
		 

		 
