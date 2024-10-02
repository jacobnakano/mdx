#########################################################################
#
# This file and the associated documentation are confidential 
# and proprietary to Synopsys, Inc. 
#
# Copyright (c), 2008 Synopsys, Inc. All rights reserved.
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
#
#	Change Log:
#
#	22 May 07 : Commented obsolete keys. 
#	27 Oct 06 : Changed DNW Diode min L and min W 
#	10 Aug 06 : Adding First version
#
##########################################################################

###################################################################################
# starcMS90G_getLayerNumber is a procedure used fetch the layer number from layer Name
#             
# Inputs:
# ---------
# techId   : Technology file used
# layerName: Layer Name
# 
# Output:
# ---------
# Returns the Layer Number
#
##################################################################################

proc starcMS90G_getLayerNumber { techId layerName } {
    set Layer [oa::LayerFind $techId $layerName]
    set layerNumber [oa::getNumber $Layer]
    return $layerNumber
}

#############################################################################
#          Procedure to read layer constraint
# reads the values from Tech file 
#############################################################################


proc starcMS90G_getLayerConstraint { const Layer tf} {
    set fc [oa::getFoundryRules $tf]
    set layerNo [oa::getNumber [oa::LayerFind $tf $Layer]]
    set c_ref [oa::LayerConstraintFind $fc $layerNo [oa::LayerConstraintDefGet [oa::LayerConstraintType $const]]]
    set c_val [oa::get [oa::getValue $c_ref]]
    set dbu   [oa::TechGetDefaultDBUPerUU [oa::ViewTypeGet maskLayout]]
    if { $const == "minArea" } { 
        set value [expr ($c_val/double($dbu*$dbu))]
    } else {
        set value [expr ($c_val/double($dbu))]
    } 
    return $value
}

#############################################################################
#          Procedure to read layer pari constraints
#############################################################################

proc starcMS90G_getLayerPairConstraint { const layer1 layer2 tf } {
    set fc     [oa::getFoundryRules $tf]
    set c_def  [oa::ConstraintDefFind $const]
    set layer1 [oa::getNumber [oa::LayerFind $tf $layer1]]
    set layer2 [oa::getNumber [oa::LayerFind $tf $layer2]] 
    set c_ref  [oa::LayerPairConstraintFind $fc $layer1 $layer2 $c_def]
    set c_val  [oa::get [oa::getValue $c_ref]]
    set dbu    [oa::TechGetDefaultDBUPerUU [oa::ViewTypeGet maskLayout]]
    if {$const == "minEnclosure" || $const == "endOfLineEnclosure"} {
        set value [expr round($c_val*$dbu)/double($dbu*$dbu)]
    } elseif {$const == "minOverlap"} {
        set value  [expr ($c_val/double($dbu))]
    } else {
        set value  [expr ($c_val/double($dbu))]
    }
    return $value
}


###########################################################################
#                            Define all the keys                          # 
###########################################################################
proc starcMS90G_defineKeys { listProps listValues keysArray} {
    upvar keys $keysArray

    foreach propList $listProps valueList $listValues {
        for {set i 0} {$i < [llength $valueList] } {incr i } { 
            set model [lindex [lindex $valueList $i] 0]
            for {set j 1} {$j < [llength $propList] } {incr j } {   
                set prop [lindex $propList $j]
                set value [lindex [lindex $valueList $i] $j]
                if {$value != "x" } {
                    set keys(${prop}_$model) $value
                }
            }
        } 
    }
}

###################################################################################
# getCommDRValues is a procedure used for setting Layer Constraint and Layer Pair Constraint
#             also for storing the Design Rule Values.
# Inputs:
# ---------
# libId : Current Library ID
#
###################################################################################
proc starcMS90G_getCommDRValues { oaDesign techArray layerArray keysArray } {
    
    upvar tech $techArray
    upvar layer $layerArray
    upvar keys $keysArray

    variable layerSpec


    set oaTech [oa::getTech $oaDesign]
    set group [oa::getNext [oa::getGroupsByName $oaTech techParams]]
#    set cadGrid [oa::PropFind $group cadGrid]
    


#######################################################################################
########  <>  <>  <>          Layer Definition Section            <>  <>  <>   ########
#######################################################################################

########  <>  <>  <>   Design Rule Section (Fetch Values from Technology File)    <>  <>  <>   ########
#######################################################################################################

#######################################################################################################
########  <>  <>  <>   Common Keys Section (Values used by multiple devices)    <>  <>  <>   ##########
#######################################################################################################    

#    set tech(minimumGridValue) 		[oa::getValue $cadGrid] ;# see beginning of procedure for cadGrid derivation
     set tech(minimumGridValue)  	[oa::getDefaultManufacturingGrid $oaTech]
    set tech(dataBaseUnitValue) 	1 ;#[oa::TechGetDefaultDBUPerUU [oa::ViewTypeGet maskLayout]]
					  ;# set to 1 as default manf.grid is in user units (OA 2.2.6 p49 & later)

}
#####################################################
#####		MOSFET SECTION 		        #####
#####################################################
proc starcMS90G_getMosDRValues { oaDesign techArray layerArray keysArray modArray } {

    upvar tech $techArray
    upvar layer $layerArray
    upvar keys $keysArray
    upvar mod $modArray
    
    starcMS90G_getCommDRValues $oaDesign tech layer keys

#################################################################################################
########  	<>  <>  <>	   	Pcell tag Section	   <>  <>  <>  		 ########
#################################################################################################
    set keys(ftkVersion)   "FTK Version:1.0"
    set keys(spiceVersion) "SPICE Version:Unknown"
    set keys(drmVersion)   "DRM Version:1.0"

    # Classify models 


    set mos_props {model minLength maxLength  minWidth  maxWidth minFWidth maxFWidth mMin mMax minFingers maxFingers minDummyL maxDummyL minDummyR maxDummyR polyDiffEndcap polyContSpacing polyDiffSpacing}
              #model	minL	maxL	minW	maxW	PDEC	PCS	PDS
    set mos_values [list \
	  [list NENHT33_S	0.4	10	.4	10000	.4 100   1 100 1  100 0 10 0 10 N/A N/A N/A ] \
	  [list PENHT33_S	0.4	10	.4	10000	.4 100   1 100 1  100 0 10 0 10 N/A N/A N/A] \
	  [list NENHHP_S	0.1	10	.22	10000	.22 100   1 100 1  100 0 10 0 10 N/A N/A N/A ] \
	  [list PENHHP_S	0.1	10	.22	10000	.22 100   1 100 1  100 0 10 0 10 N/A N/A N/A ] \
    ]
    set listProps  [list $mos_props]
    set listValues [list $mos_values]
    starcMS90G_defineKeys $listProps $listValues keys

}
#####################################################
#####		RESISTOR SECTION 		#####
#####################################################

proc starcMS90G_getResDRValues { oaDesign techArray layerArray keysArray modArray } {

    upvar tech $techArray
    upvar layer $layerArray
    upvar keys $keysArray
    upvar mod $modArray
    
    starcMS90G_getCommDRValues $oaDesign tech layer keys

   set res_props {model minLength minWidth minW_rec maxLength maxWidth minFingers maxFingers sheetResistance rend dW dL maxDummyL maxDummyR numSquares}
              #model		minL	minW	minW_R  maxL	maxW	minFingers maxFingers Rsh	Rend	dW	dL	maxDummyL maxDummyR Squares
    set res_values [list \
        [list RSPOLYP_S		4	2	2	100	100	1 100 205	0	.045	-0.110	1 1 0] \
        [list RPOLYP_S		4	2	2	100	100	1 100 205	0	.020	-0.050	1 1 0] \
    ]
    set listProps  [list $res_props]
    set listValues [list $res_values]
    starcMS90G_defineKeys $listProps $listValues keys
}


#####################################################
#####		BJT SECTION 		        #####
#####################################################
proc starcMS90G_getNpnvDRValues { oaDesign techArray layerArray keysArray modArray } {

    upvar tech $techArray
    upvar layer $layerArray
    upvar keys $keysArray
    upvar mod $modArray
    starcMS90G_getCommDRValues $oaDesign tech layer keys


}
proc starcMS90G_getPnpvDRValues { oaDesign techArray layerArray keysArray modArray } {

    upvar tech $techArray
    upvar layer $layerArray
    upvar keys $keysArray
    upvar mod $modArray
    starcMS90G_getCommDRValues $oaDesign tech layer keys


}

#####################################################
#####		CAPACITOR SECTION 		#####
#####################################################
    # MIM capacitor related keys
proc starcMS90G_getCapDRValues { oaDesign techArray layerArray keysArray modArray } {

    upvar tech $techArray
    upvar layer $layerArray
    upvar keys $keysArray
    upvar mod $modArray
    starcMS90G_getCommDRValues $oaDesign tech layer keys

    set cap_props {model minLength maxLength minWidth maxWidth areaCap fringeCap dL dW const step minRows maxRows minCols maxCols}
    	      #model		minL	maxL	minW	maxW	ArCap	   FrCap  	dL 	dW 	const  step	   
    set cap_values [list \
	[list CM123_S		40	100	40      100     N/A  N/A	 0	0	 0  50.00e-09 1 100 1 100] 
    ]
    set listProps  [list $cap_props]
    set listValues [list $cap_values]
    starcMS90G_defineKeys $listProps $listValues keys

}
    
