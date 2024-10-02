#########################################################################
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
#       26 Feb 06 : Removed invalid input check for 0
#	19 Sep 06 : Added procedure to calculate sa sb sd 
#       21 Aug 06 : Renamed the procedure symMicronToMetre to symU2M 
#       19 Aug 06 : Added procedures to control the display/Editable options in CDFs 
#	10 Aug 06 : Adding First version
##########################################################################

########################## Start of General Procedures #############################

# Procedure to control the Display Based on cellViewType "schematic"
proc starcMS90G_symIsSchematic { } {
    set inst  [db::getCurrentRef]
    set viewType [oa::getName [oa::getViewType [oa::getDesign $inst]]]
    if { $viewType == "schematic" } {return 1} else {return 0}
}

proc starcMS90G_symIsSchOrIvPcell { } {
    set inst  [db::getCurrentRef]
    set viewType [oa::getName [oa::getViewType [oa::getDesign $inst]]]
    set viewName [oa::getViewName $inst] 
    if { $viewType == "schematic" || $viewName == "ivpcell" } {return 1} else {return 0}
}

proc starcMS90G_symIsSchOrLay { } {
    set inst  [db::getCurrentRef]
    set viewType [oa::getName [oa::getViewType [oa::getDesign $inst]]]
    set viewName [oa::getViewName $inst] 
    #puts "viewName $viewName $viewType"
    if { $viewType == "schematic" || $viewName == "layout" } {return 1} else {return 0}
}


# Procedure to control the Display Based on cellViewType "layout"
proc starcMS90G_symIsLayout { } {
    set inst  [db::getCurrentRef]
    set viewType [oa::getName [oa::getViewType [oa::getDesign $inst]]]
    set viewName [oa::getViewName $inst] 
    if { $viewName == "layout" } {return 1} else {return 0}
}

# Procedure to control the Display Based on instances of type "ivpcell"
proc starcMS90G_symIsIvpcell { } {
    set inst  [db::getCurrentRef]
    set viewName [oa::getViewName $inst]
    if { $viewName == "ivpcell" } {return 1} else {return 0}
}

# Procedure to make parameters Editable.
proc starcMS90G_symMakeEditable {controlParamName MODE} {
    set inst      [db::getCurrentRef]	
    set value     [db::getParamValue $controlParamName -of $inst]
    set paramType [starcMS90G_symGetParamDef type $inst $controlParamName]
    if {$paramType == "boolean"} {
        if {$value} {
            return 1
        } else {
            return 0 
        }
    } else {
        if { [regexp $MODE $value]} {
            return 1
        } else {
            return 0  
        } 
    }
}

# Procedure to get the parameters from the instance
proc starcMS90G_symGetParam { param inst} {
    set value [db::getParamValue $param -of $inst]
    return $value
}

# Procedure to set the parameters from the instance
proc starcMS90G_symSetParam { param value inst} {
#    puts "param $param value $value"
    set formval [db::getParamValue $param -of $inst]

    # param is a variable
    if { [starcMS90G_symIsVariable $formval] || [starcMS90G_symIsVariable $value] } {
        set old_val $formval
        set new_val $value
        if { [string compare $old_val $new_val] != 0 } {
            db::setParamValue $param -value $value -of $inst -evalCallbacks 0
        }

    # param is NOT a variable
    } else {
	db::setParamValue $param -value $value -of $inst -evalCallbacks 0
    }
    
}

# Procedure to round input to grid
proc starcMS90G_symGridCheck { val grid dbu } {
    set gdu [expr $grid/double($dbu)]
    #    set val1 [expr round(($val/1e-6)/$gdu)]

# Fix for TCL Error: Integer value too large to represent
    if { [catch {expr round($val*1e6/$gdu)}] } {
        set val [expr $val*double(1e6)]
        set val [lindex [split $val "."] 0]
        set val1 [expr double($val) / double($gdu)]
    } else {
        set val1 [expr round($val*1e6/$gdu)]
    }  
# End of fix

    set val2 [expr $val1*$gdu*1e-6]  
    return [db::engToSci $val2]
}  
# Procedure to return the max value inputs
proc starcMS90G_symGetMax {inList} {
   set length [llength $inList]
   set maxValue [lindex $inList 0]
  for {set i 0} {$i < [expr $length-1]} {incr i} {
    if {$maxValue < [lindex $inList [expr $i+1]]} {
	set maxValue [lindex $inList [expr $i+1]]
    } 
  }
  return $maxValue
}       
#######################################################################
# procedure to get default Values from CDF.
#
# attr  :- Attribute of the Copernicus parameter
# param :- Copernicus parameter name
# inst  :- current instance ID
######################################################################

proc starcMS90G_symGetParamDef { attr inst param} {
    set attrVal [db::getAttr $attr -of [db::getParamDefs $param -of $inst]]
    return $attrVal
}

proc starcMS90G_engToSci { value } {
   return [db::engToSci $value]
}


proc starcMS90G_engToSciMaxRes { value } {
   return [db::engToSci $value -precision 18]
}

proc starcMS90G_sciToEng { value } {
   return [db::sciToEng $value -precision 10]
}

proc starcMS90G_getCurrentParam { } {
    return [db::getCurrentParam]
}


proc starcMS90G_getAttrDesign {inst } {
    return [db::getAttr design -of $inst]
}

proc starcMS90G_getPcellParamValue {param} {
  set paramName [oa::getName $param]
  set paramType [oa::getName [oa::getType $param]]
  switch -- $paramType { 
    "booleanParam" {
      set paramValue [oa::getBooleanVal $param]
    }
    "stringParam" {
      set paramValue [oa::getStringVal $param]
    }
    "intParam" {
      set paramValue [oa::getIntVal $param]
    }
    "floatParam" {
      set paramValue [oa::getFloatVal $param]
    }
    "doubleParam" {
      set paramValue [oa::getDoubleVal $param]
    }
  }
  return $paramValue
}


proc starcMS90G_getOrigValue {prop inst} {
#    puts "entry $prop"
    set oaParams    [oa::getParams $inst]
    if { $oaParams != "" } {
	for {set i 0} {$i < [oa::getNumElements $oaParams]} {incr i} {
	    set param     [oa::getElement $oaParams $i]
	    set paramName [oa::getName $param]
	    set paramVal  [starcMS90G_getPcellParamValue $param]
	    if { $prop == $paramName } {
#		puts "FOUND $prop $paramVal"
		return $paramVal
	    }
	}
    } 
#    set inst [db::getAttr object -of $inst]
    if { [oa::PropFind $inst $prop]  != "" } {
	set propType [oa::getName  [oa::getType [oa::PropFind $inst $prop]]]
	set propVal  [oa::getValue [oa::PropFind $inst $prop]]
	#	puts "Proptype $propType"
	if { $propType == "AppProp"} {
#	    puts "AppProp"
	    return [starcMS90G_getAppPropVal [oa::PropFind $inst $prop]]
	} else {
#	    puts "prop $prop value [oa::getValue [oa::PropFind $inst $prop]]"
	    return [oa::getValue [oa::PropFind $inst $prop]]
	}
    } else {
#	puts "CDF prop $prop value [db::getAttr defValue -of [db::getParamDefs $prop -of $inst]]"
	return [db::getAttr defValue -of [db::getParamDefs $prop -of $inst]]
    }
    
}


proc starcMS90G_getAppPropVal { appProp } {
    if { [oa::getName [oa::getType $appProp]] == "AppProp"} {
        set appPropVal [oa::getValue $appProp]
        if { ![catch {set byteArraySize [expr [oa::getSize $appPropVal]]}]} {
            set appPropVal [starcMS90G_getStringFromByteArray $appPropVal $byteArraySize]
        }
    } else {
           set appPropVal [oa::getValue $appProp]
    }
    return $appPropVal
}

proc starcMS90G_getStringFromByteArray { byteArray byteArraySize } {
    set byteArrayVal ""
    for {set i 0} {$i < $byteArraySize} {incr i} {
        append byteArrayVal [format %c [oa::get $byteArray $i]]
    }
    return $byteArrayVal
}

proc starcMS90G_setParamValue { param value inst eval} {
#   puts "param $param value $value"
   return [db::setParamValue $param -value $value -of $inst -evalCallbacks $eval]
}


# Procedure to check for variable inputs
proc starcMS90G_symIsVariable { paramValue } {

    if { [regexp {([i][n][s][t])|([p][a][r][e][n][t])|([l][i][n][e][a][g][e])|([P][a][r])} $paramValue match] } {
        return 1
    } elseif { [regexp {(^\[+)}  $paramValue ] } {
        return 1
    } elseif { [regexp {(^[a-zA-Z]+$)|(^[a-zA-Z]+)} $paramValue ]} {
        if { [regexp {(^[a-zA-Z]+)((\*+)|(\/+)|(\-+)|(\++) \
          |(\%+))(([a-zA-Z]+$)|([0-9]+$))} $paramValue ] && ![regexp {(\@+)|(\^+)|(\&+)|(\(+)|(\)+)|(\|+)|(\{+)|(\}+)|(\<+) \
          |(\>+)|(\?+)|(\:+)|(\;+)|(\"+)|(\'+)|(\=+)|(\`+)|(\~+)|(\,+)} $paramValue ]} {
            return 1

         } elseif { [regexp {(^[a-zA-Z]+$)|(^[a-zA-Z]+)} $paramValue ] && ![regexp {(\@+)|(\^+)|(\&+)|(\(+)|(\)+)|(\|+)|(\{+)|(\}+)| \
             (\<+)|(\>+)|(\?+)|(\:+)|(\;+)|(\"+)|(\'+)|(\=+)|(\`+)|(\~+)|(\,+)} $paramValue ]} {
             return 1

         } else {
            
            # input error
             return 2

         }

    # if input begins with a number
    } elseif { ([regexp {(^[0-9]+$)|(^[0-9]+\.[0-9]+$)|(^\.[0-9]+$)} $paramValue ] \
       || [regexp {((^[0-9]+)|(^[0-9]+\.[0-9]+)|(^\.[0-9]+))([a-zA-Z]+$)} $paramValue ] \
       || [regexp {((^[0-9]+)|(^[0-9]+\.[0-9]+)|(^\.[0-9]+))(([a-zA-Z]+)|(\++)|(\!+)| \
        (\#+)|(\$+)|(\%+)|(\[+)|(\]+)|(\_+)|(\/+)|(\*+)|(\-+))} $paramValue ]) && ![regexp { } $paramValue] } {

        if { [regexp {(^[0-9]+)|(^[0-9]+\.[0-9]+)|(^\.[0-9]+)} $paramValue match] } {
            if { [regexp {(^[0-9]+$)|(^[0-9]+\.[0-9]+$)|(^\.[0-9]+$)} $paramValue ] } {
                return 0
            } else {
                  
                  set sample_value [string trimleft $paramValue $match]
                  if {[regexp {^([y]|[z]|[a]|[f]|[p]|[n]|[u]|[m]|[c]|[k]||[K]|[M]|(^[m][e][g])|[X]|[G]|[T]|[P]|[E]|[Z]|[Y])$} $sample_value] \
                  && ![regexp {[0-9]$} $sample_value ]} {
                      return 0
 
                  } elseif {[regexp {(^[eE][0-9]+$)|(^[eE]([\-]|[\+])[0-9]+$)} $sample_value check ] || [regexp {(^[0-9]+$)|(^[0-9]+\.[0-9]+$)} \
                    $sample_value check ]} {
                      return 0
              
                  } elseif { [regexp {((\*+)|(\/+)|(\-+)|(\++)|(\%+))(([a-zA-Z]+)|([0-9]+))} $sample_value ] \
                    || [regexp {([a-zA-Z]+)((\*+)|(\/+)|(\-+)|(\++)|(\%+))(([a-zA-Z]+$)|([0-9]+$))} $sample_value ] \
                    && ![regexp {(\@+)|(\^+)|(\&+)|(\(+)|(\)+)|(\|+)|(\{+)|(\}+)|(\<+)|(\>+)|(\?+)|(\:+)|(\;+)| \
                    (\"+)|(\'+)|(\=+)|(\`+)|(\~+)|(\,+)} $sample_value ] } {
                      return 1

                  } elseif { [regexp {(\@+)|(\^+)|(\&+)|(\(+)|(\)+)|(\|+)|(\{+)|(\}+)|(\<+)|(\>+)|(\?+)|(\:+) \
                    |(\;+)|(\"+)|(\'+)|(\=+)|(\`+)|(\~+)|(\,+)} $sample_value ]} {   
                     # input error
                      return 2

                  } else {
                      # input error
                      return 2

                  }
              }
        }
        
    } else {
        return 3

    }

}

# Procedure to check for the invalid inputs
#____________________________________________________________________________________
# param  :- Name of the Copernicus parameter to be checked against invalid inputs
# paramValue :- Value of the parameter.
# model  :- Hspice model name of the device.
#____________________________________________________________________________________

proc starcMS90G_symCheckParamXX {paramValue model inst param} {
    set defVal [starcMS90G_symGetParamDef defValue $inst $param]
    set paramDisplay [starcMS90G_symGetParamDef prompt $inst $param]

    if {[starcMS90G_symIsVariable $paramValue] == 1} {
        if {[starcMS90G_symIsLayout]} {
            puts "\n*************************** $model ************************"
            puts "WARNING 0002> Parameter \"$paramDisplay\" Value \"$paramValue\" is invalid, Resetting to Default value.\n"
	    set paramValue $defVal
	    db::setParamValue $param -value $defVal -of $inst -evalCallbacks 1
            #starcMS90G_symSetParam $param $defVal $inst
        }
	return

    } elseif { [starcMS90G_symIsVariable $paramValue] == 2 } {
        puts "\n*************************** $model ************************"
        puts "WARNING 0002> Parameter \"$paramDisplay\" Value \"$paramValue\" is invalid, Resetting to Default value.\n"
	set paramValue $defVal
	db::setParamValue $param -value $defVal -of $inst -evalCallbacks 1
        #starcMS90G_symSetParam $param $defVal $inst

    } elseif { ([regexp {(^[0-9]+$)|(^[0-9]+\.[0-9]+$)|(^\.[0-9]+$)} $paramValue ] \
       || [regexp {((^[0-9]+)|(^[0-9]+\.[0-9]+)|(^\.[0-9]+))([a-zA-Z]+$)} $paramValue ] \
       || [regexp {((^[0-9]+)|(^[0-9]+\.[0-9]+)|(^\.[0-9]+))(([a-zA-Z]+)|(\++)|(\!+)| \
        (\#+)|(\$+)|(\%+)|(\[+)|(\]+)|(\_+)|(\/+)|(\*+)|(\-+))} $paramValue ]) && ![regexp { } $paramValue] } {

        if { [regexp {(^[0-9]+)|(^[0-9]+\.[0-9]+)|(^\.[0-9]+)} $paramValue match] } {
            if { [regexp {(^[0-9]+$)|(^[0-9]+\.[0-9]+$)|(^\.[0-9]+$)} $paramValue ] } {

            } else {
                  
                  set sample_value [string trimleft $paramValue $match]

                  if {[regexp {^([y]|[z]|[a]|[f]|[p]|[n]|[u]|[m]|[c]|[k]|[M]|(^[m][e][g])|[X]|[G]|[T]|[P]|[E]|[Z]|[Y])$} $sample_value] \
                  && ![regexp {[0-9]$} $sample_value ]} {
 
                  } elseif {[regexp {(^[eE][0-9]+$)|(^[eE]([\-]|[\+])[0-9]+$)} $sample_value check ] || [regexp {(^[0-9]+$)|(^[0-9]+\.[0-9]+$)} \
                    $sample_value check ]} {
              
                  } elseif { [regexp {((\*+)|(\/+)|(\-+)|(\++)|(\%+))(([a-zA-Z]+)|([0-9]+$))} $sample_value ] \
                    || [regexp {([a-zA-Z]+)((\*+)|(\/+)|(\-+)|(\++)|(\%+))(([a-zA-Z]+$)|([0-9]+$))} $sample_value ] \
                    && ![regexp {(\@+)|(\^+)|(\&+)|(\(+)|(\)+)|(\|+)|(\{+)|(\}+)|(\<+)|(\>+)|(\?+)|(\:+)|(\;+)| \
                    (\"+)|(\'+)|(\=+)|(\`+)|(\~+)|(\,+)} $sample_value ] } {

                  } elseif { [regexp {(\@+)|(\^+)|(\&+)|(\(+)|(\)+)|(\|+)|(\{+)|(\}+)|(\<+)|(\>+)|(\?+)|(\:+) \
                    |(\;+)|(\"+)|(\'+)|(\=+)|(\`+)|(\~+)|(\,+)} $sample_value ]} {   
    
                        puts "\n*************************** $model ************************"
                        puts "WARNING 0002> Parameter \"$paramDisplay\" value \"$paramValue\" is invalid, Resetting to default value \n"
			set paramValue $defVal
			db::setParamValue $param -value $defVal -of $inst -evalCallbacks 1
                        #starcMS90G_symSetParam $param $defVal $inst 

                  } else {

                        puts "\n*************************** $model ************************"
                        puts "WARNING 0002> Parameter \"$paramDisplay\" Value \"$paramValue\" is invalid, Resetting to default value.\n"
			set paramValue $defVal
			db::setParamValue $param -value $defVal -of $inst -evalCallbacks 1
                        #starcMS90G_symSetParam $param $defVal $inst
                  }
              }
        }
        
    } else {

        puts "\n*************************** $model ************************"
        puts "WARNING 0002> Parameter \"$paramDisplay\" value \"$paramValue\" is invalid, Resetting to default value.\n"
	set paramValue $defVal
	db::setParamValue $param -value $defVal -of $inst -evalCallbacks 1
        #starcMS90G_symSetParam $param $defVal $inst
    }
}





# Procedure to check for the invalid inputs
#____________________________________________________________________________________
# param  :- Name of the Copernicus parameter to be checked against invalid inputs
# paramValue :- Value of the parameter.
# model  :- Hspice model name of the device.
#____________________________________________________________________________________

proc starcMS90G_symCheckParam {paramValue model inst param} {
    set defVal [starcMS90G_symGetParamDef defValue $inst $param]
    set paramDisplay [starcMS90G_symGetParamDef prompt $inst $param]
    set msg ""
    if {[starcMS90G_symIsVariable $paramValue] == 1} {
        if {[starcMS90G_symIsLayout]} {
            append msg  "\n    *Error* ** $model **\n"
            append msg  "    -> Parameter \"$paramDisplay\" Value \"$paramValue\" is invalid\n"
            append msg  "    -> Rollback.\n"
	    starcMS90G_prompt $msg 
            return [list -1 $paramValue]
        }
	return [list 0 $paramValue]

    } elseif { [starcMS90G_symIsVariable $paramValue] == 2 } {
	append msg  "\n    *Error* ** $model **\n"
	append msg  "    -> Parameter \"$paramDisplay\" Value \"$paramValue\" is invalid\n"
	append msg  "    -> Rollback.\n"
	starcMS90G_prompt $msg 
	return [list -1 $paramValue]

    } elseif { ([regexp {(^[0-9]+$)|(^[0-9]+\.[0-9]+$)|(^\.[0-9]+$)} $paramValue ] \
       || [regexp {((^[0-9]+)|(^[0-9]+\.[0-9]+)|(^\.[0-9]+))([a-zA-Z]+$)} $paramValue ] \
       || [regexp {((^[0-9]+)|(^[0-9]+\.[0-9]+)|(^\.[0-9]+))(([a-zA-Z]+)|(\++)|(\!+)| \
        (\#+)|(\$+)|(\%+)|(\[+)|(\]+)|(\_+)|(\/+)|(\*+)|(\-+))} $paramValue ]) && ![regexp { } $paramValue] } {

        if { [regexp {(^[0-9]+)|(^[0-9]+\.[0-9]+)|(^\.[0-9]+)} $paramValue match] } {
            if { [regexp {(^[0-9]+$)|(^[0-9]+\.[0-9]+$)|(^\.[0-9]+$)} $paramValue ] } {

            } else {
                  
                  set sample_value [string trimleft $paramValue $match]

                  if {[regexp {^([y]|[z]|[a]|[f]|[p]|[n]|[u]|[m]|[c]|[k]|[K]|[M]|(^[m][e][g])|[X]|[G]|[T]|[P]|[E]|[Z]|[Y])$} $sample_value] \
                  && ![regexp {[0-9]$} $sample_value ]} {
 
                  } elseif {[regexp {(^[eE][0-9]+$)|(^[eE]([\-]|[\+])[0-9]+$)} $sample_value check ] || [regexp {(^[0-9]+$)|(^[0-9]+\.[0-9]+$)} \
                    $sample_value check ]} {
              
                  } elseif { [regexp {((\*+)|(\/+)|(\-+)|(\++)|(\%+))(([a-zA-Z]+)|([0-9]+$))} $sample_value ] \
                    || [regexp {([a-zA-Z]+)((\*+)|(\/+)|(\-+)|(\++)|(\%+))(([a-zA-Z]+$)|([0-9]+$))} $sample_value ] \
                    && ![regexp {(\@+)|(\^+)|(\&+)|(\(+)|(\)+)|(\|+)|(\{+)|(\}+)|(\<+)|(\>+)|(\?+)|(\:+)|(\;+)| \
                    (\"+)|(\'+)|(\=+)|(\`+)|(\~+)|(\,+)} $sample_value ] } {

                  } elseif { [regexp {(\@+)|(\^+)|(\&+)|(\(+)|(\)+)|(\|+)|(\{+)|(\}+)|(\<+)|(\>+)|(\?+)|(\:+) \
                    |(\;+)|(\"+)|(\'+)|(\=+)|(\`+)|(\~+)|(\,+)} $sample_value ]} {   
		      append msg  "\n    *Error* ** $model **\n"
		      append msg  "    -> Parameter \"$paramDisplay\" Value \"$paramValue\" is invalid\n"
		      append msg  "    -> Rollback.\n"
		      starcMS90G_prompt $msg 
		      return [list -1 $paramValue]
		    } else {
			append msg  "\n    *Error* ** $model **\n"
			append msg  "    -> Parameter \"$paramDisplay\" Value \"$paramValue\" is invalid\n"
			append msg  "    -> Rollback.\n"
			starcMS90G_prompt $msg 
			return [list -1 $paramValue]
                  }
              }
        }
        
    } else {
	append msg  "\n    *Error* ** $model **\n"
	append msg  "    -> Parameter \"$paramDisplay\" Value \"$paramValue\" is invalid\n"
	append msg  "    -> Rollback.\n"
	starcMS90G_prompt $msg 
	return [list -1 $paramValue]
    }
    return [list 0 $paramValue]
}

#######################################################################
# procedure to check min/max and offgrid Values.
#
# pNam    :- Prompt name of the parameter to be checked.
# pval    :- Value of parameter to be checked.
# minVal  :- minimum allowable value against which the parameter has to be checked.Set to 0 to avoid minCheck
# maxVal  :- maximum allowable value against which the parameter has to be checked.Set to 0 to avoid maxCheck
# p_grid  :- parameter value rounded to grid if checked otherwise set to 0
# reset   :- set to 1 if the parameter has to be reset after comparing.
# spice_model :- Model Name used for displaying the error msg's
# param :- the Param for which the check to be made 
# inst     :- Name of the parameter from which the parameter to be checked is derived/calculated.
#            for e.g. if entryMode is "c" then l & w are just checked and not reset, so to give
#            warning to change the c value.
########################################################################
proc starcMS90G_symCheckParamValue { pNam pVal minVal maxVal p_grid reset spice_model inst param } {

    set rval   [db::sciToEng [expr $pVal]] 
    set mxval  [db::sciToEng [expr $maxVal]]
    set mnval  [db::sciToEng [expr $minVal]]
    set gval   [db::sciToEng [expr $p_grid]]
    set inp    [starcMS90G_symGetParamDef prompt $inst $param]
    set inpVal [starcMS90G_symGetParam $param $inst]
    set pNam   [starcMS90G_symGetParamDef prompt $inst $pNam]

    if { ([expr $pVal] < [expr $minVal]) && $minVal >= 0} {
        puts "\n************************ $spice_model **************************"
        if {$reset} {
            puts "WARNING 0007> \"$pNam\" $rval < Min value $mnval"
            puts "              Resetting \"$pNam\" to Min value\n"
            set pVal [expr $minVal]
            return $pVal
        } else {
            puts "WARNING 0005> For given \"$inp\" $inpVal, Calculated \"$pNam\" $rval < Min value $mnval"
            puts "              Resetting \"$inp\" to limit \"$pNam\" to Min Value $mnval\n"
            set pVal [expr $minVal]
            return $pVal
        }
        
    } elseif { ([expr $pVal] > [expr $maxVal]) && $maxVal != 0} {
        puts "\n************************ $spice_model **************************"
        if {$reset} { 
            puts "WARNING 0008> \"$pNam\" $rval > Max value $mxval"
            puts "              Resetting \"$pNam\" to Max value\n"
            set pVal [expr $maxVal]
            return $pVal
        } else {
            puts "WARNING 0006> For given \"$inp\" $inpVal, Calculated \"$pNam\" $rval > Max value $mxval"
            puts "              Resetting \"$inp\" to limit \"$pNam\" to Max Value $mxval\n"
            set pVal [expr $maxVal]
            return $pVal
        }
        
    } elseif { [expr $p_grid] != 0 && ([expr $p_grid] != [expr $pVal]) } {
        puts "\n************************ $spice_model **************************"
        puts "WARNING 0004> Resetting parameter \"$pNam\" $rval to $gval to be on grid.\n"
        set pVal [expr $p_grid]
        return $pVal

    } else {
        return [expr $pVal]
    }
}

proc starcMS90G_prompt { msg } {
    gi::prompt $msg  -icon warning -title "WARNING" -buttons "OK" -default "OK"
}


proc starcMS90G_symCheckNoModParamValue { pNam pVal minVal maxVal pOrigVal p_grid reset spice_model inst param } {


#    puts "PVAL $pVal param $param SPICE_MODEL $spice_model"
    set rval   [db::sciToEng [expr $pVal]] 
    set mxval  [db::sciToEng [expr $maxVal]]
    set mnval  [db::sciToEng [expr $minVal]]
    set gval   [db::sciToEng [expr $p_grid]]
    set inp    [starcMS90G_symGetParamDef prompt $inst $param]
    set inpVal [starcMS90G_symGetParam $param $inst]
    set pNam   [starcMS90G_symGetParamDef prompt $inst $pNam]
    set msg ""

    if { ([expr $pVal] < [expr $minVal]) && $minVal >= 0} {
        append msg "\n************************ $spice_model **************************\n"
        if {$reset} {
	    append msg  "\n    *Error*   ** $spice_model **\n"
	    append msg  "    -> Error in Min checking.\n"
	    append msg  "    -> \"$pNam\" $rval < Min value $mnval\n"
	    append msg  "    -> Rollback.\n"
	    starcMS90G_prompt $msg 
            return [list -1 $mnval]
        } else {
            append msg "WARNING 0005> For given \"$inp\" $inpVal, Calculated \"$pNam\" $rval < Min value $mnval\n"
            append msg "              Resetting \"$inp\" to limit \"$pNam\" to previous Value  \"$pOrigVal\"\n"
            append msg "              Resetting all other parameters to their previous value\n"
	    starcMS90G_prompt $msg 
            return [list -1 $mnval]
        }
        
    } elseif { ([expr $pVal] > [expr $maxVal]) && $maxVal != 0} {
        append msg "\n************************ $spice_model **************************\n"
        if {$reset} { 
	    append msg  "\n    *Error*   ** $spice_model **\n"
	    append msg  "    -> Error in Max checking.\n"
	    append msg  "    -> \"$pNam\" $rval > Max value $mxval\n"
	    append msg  "    -> Rollback.\n"
	    starcMS90G_prompt $msg 
            return [list -1 $mxval]
        } else {
            append msg "WARNING 0006> For given \"$inp\" $inpVal, Calculated \"$pNam\" $rval > Max value $mxval\n"
            append msg "              Resetting \"$inp\" to limit \"$pNam\" to previous value  \"$pOrigVal\"\n"
            append msg "              Resetting all other parameters to their previous value\n"
	    starcMS90G_prompt $msg 
            return [list -1 $mxval]
        }
        
    } elseif { [expr $p_grid] != 0 && ([expr $p_grid] != [expr $pVal]) } {
        append msg "\n************************ $spice_model **************************\n"
        append msg "WARNING 0004> Resetting parameter \"$pNam\" $rval to $gval to be on grid.\n"
        set pVal [expr $p_grid]
        return [list 0 $pVal]

    } else {
        return [list 0 $pVal]
    }
}


###############################################################################
# procedure to check the parameter for integer/zeroValue
#
# cdf     :- Copernicus parameter name used for resetting the values.
# pNam    :- Prompt name of the parameter to be checked.
# pval    :- Value of parameter to be checked.
###############################################################################
proc starcMS90G_symCheckIntegerXX { pName pVal spice_model inst} {

    set pName [starcMS90G_symGetParamDef prompt $inst $pName]
    # Return without checking in case of variable inputs
    if { [starcMS90G_symIsVariable $pVal] } {
        return $pVal
    } elseif {[regexp {([a-zA-Z]+$)} $pVal]} {
        puts "\n************** $spice_model ***************************"  
        set PVal 1
        puts "WARNING 0003> Parameter \"$pName\" $pVal not an integer. Resetting to integer value $PVal\n"
	set pVal $PVal
    } elseif { $pVal < 1 } {
        puts "\n************** $spice_model ***************************"  
        set PVal 1
        puts "WARNING 0003> Parameter \"$pName\" $pVal not an integer. Resetting to integer value $PVal\n"
	set pVal $PVal
        return $pVal
    } elseif { $pVal != [expr int($pVal)]} {
        puts "\n************** $spice_model ***************************"
        set PVal [expr int($pVal)]
        puts "WARNING 0003> Parameter \"$pName\" $pVal not an integer. Resetting to integer value $PVal\n"
	set pVal $PVal
        return $pVal
    } else {
        return $pVal
    }

}



###############################################################################
# procedure to check the parameter for integer/zeroValue
#
# cdf     :- Copernicus parameter name used for resetting the values.
# pNam    :- Prompt name of the parameter to be checked.
# pval    :- Value of parameter to be checked.
###############################################################################
proc starcMS90G_symCheckInteger { pName pVal spice_model inst} {

    set pName [starcMS90G_symGetParamDef prompt $inst $pName]
    set msg ""
    # Return without checking in case of variable inputs
    if { [starcMS90G_symIsVariable $pVal] } {
        return $pVal
    } elseif {[regexp {([a-zA-Z]+$)} $pVal]} {
	append msg  "\n    *Error* ** $spice_model **\n"
	append msg  "      -> Parameter \"$pName\" Value \"$pVal\" is not a valid integer\n"
	append msg  "      -> Rollback.\n"
	starcMS90G_prompt $msg 
	return [list -1 $pVal]
    } elseif { $pVal < 1 } {
	append msg  "\n    *Error* ** $spice_model **\n"
	append msg  "      -> Parameter \"$pName\" Value \"$pVal\" is not a valid integer\n"
	append msg  "      -> Rollback.\n"
	starcMS90G_prompt $msg 
	return [list -1 $pVal]
    } elseif { $pVal != [expr int($pVal)]} {
	append msg  "\n    *Error* ** $spice_model **\n"
	append msg  "      -> Parameter \"$pName\" Value \"$pVal\" is not a valid integer\n"
	append msg  "      -> Rollback.\n"
	starcMS90G_prompt $msg 
	return [list -1 $pVal]
    } else {
        return [list 0 $pVal]
    }

}




proc starcMS90G_symCheckPosInteger { pName pVal spice_model inst} {

    set pName [starcMS90G_symGetParamDef prompt $inst $pName]
    set msg ""
    # Return without checking in case of variable inputs
    if { [starcMS90G_symIsVariable $pVal] } {
        return $pVal
    } elseif {[regexp {([a-zA-Z]+$)} $pVal]} {
	append msg  "\n    *Error* ** $spice_model **\n"
	append msg  "      -> Parameter \"$pName\" Value \"$pVal\" is not a valid integer\n"
	append msg  "      -> Rollback.\n"
	starcMS90G_prompt $msg 
	return [list -1 $pVal]
    } elseif { $pVal < 0 } {
	append msg  "\n    *Error* ** $spice_model **\n"
	append msg  "      -> Parameter \"$pName\" Value \"$pVal\" is not a valid integer\n"
	append msg  "      -> Rollback.\n"
	starcMS90G_prompt $msg 
	return [list -1 $pVal]
    } elseif { $pVal != [expr int($pVal)]} {
	append msg  "\n    *Error* ** $spice_model **\n"
	append msg  "      -> Parameter \"$pName\" Value \"$pVal\" is not a valid integer\n"
	append msg  "      -> Rollback.\n"
	starcMS90G_prompt $msg 
	return [list -1 $pVal]
    } else {
        return [list 0 $pVal]
    }

}


proc starcMS90G_symCheckPosInteger2 { pName pVal spice_model inst} {

    set pName [starcMS90G_symGetParamDef prompt $inst $pName]
    # Return without checking in case of variable inputs
    if { [starcMS90G_symIsVariable $pVal] } {
        return $pVal
    } elseif {[regexp {([a-zA-Z]+$)} $pVal]} {
        puts "\n************** $spice_model ***************************"  
        set PVal 1
        puts "WARNING 0003> Parameter \"$pName\" $pVal not an integer. Resetting to integer value $PVal\n"
	set pVal $PVal
    } elseif { $pVal < 0 } {
        puts "\n************** $spice_model ***************************"  
        set PVal 1
        puts "WARNING 0003> Parameter \"$pName\" $pVal not an integer. Resetting to integer value $PVal\n"
	set pVal $PVal
        return $pVal
    } elseif { $pVal != [expr int($pVal)]} {
        puts "\n************** $spice_model ***************************"
        set PVal [expr int($pVal)]
        puts "WARNING 0003> Parameter \"$pName\" $pVal not an integer. Resetting to integer value $PVal\n"
	set pVal $PVal
        return $pVal
    } else {
        return $pVal
    }

}



# Procedure to load the tech and key values
proc starcMS90G_symGetTechKeys {inst} {
    set viewName [oa::getViewName $inst]
    set cellName [oa::getCellName $inst]
    set libName [oa::getLibName $inst]
    set oaDesign [oa::DesignFind $libName $cellName $viewName]	
    starcMS90G_getCommDRValues $oaDesign tech keys layer mod
}

###############################################################################
# Procedure to convert value in microns to metres
#
# val    :- Value to be converted
###############################################################################
proc starcMS90G_symU2M { val } {

    return [expr $val*1e-6]
}


# Procedure to control visibility of Ties based on Guard Ring
proc starcMS90G_symGuardRingCtrl {controlParamName} {
    set inst [db::getCurrentRef]	
    set value [db::getParamValue $controlParamName -of $inst]
    if {$value == "none" } {
        starcMS90G_symSetParam tapTop "none" $inst
        starcMS90G_symSetParam tapBottom "none" $inst
        starcMS90G_symSetParam tapLeft "none" $inst
        starcMS90G_symSetParam tapRight "none" $inst
	return 0
    } else {
    	return 1
    }
}


#Procedure to deal with DFM/Recommended Rules
proc starcMS90G_symCalcDFMRules { DFM_rule rule rulNam minVal maxVal recVal grid dbu spice_model inst tech1 keys1} {
    
#    global keys tech
    upvar $tech1 tech
    upvar $keys1 keys
    if { $rule == 0} {
        foreach i $rulNam j $minVal {
            set val [db::sciToEng [expr $j*1e-6]] 
            starcMS90G_symSetParam $i $val $inst
        }
    } elseif { $rule == 1} {
        foreach i $rulNam j $recVal {
            set val [db::sciToEng [expr $j*1e-6]] 
            starcMS90G_symSetParam $i $val $inst
        }
    } elseif { $rule == 2} {
        foreach i $rulNam j $minVal k $maxVal {
            starcMS90G_symCheckParam [starcMS90G_symGetParam $i $inst] $spice_model $inst $i
            set inp      [db::engToSci [starcMS90G_symGetParam $i $inst]]
            set min      [expr $j*1e-6]
            set max      [expr $k*1e-6]
            set inp_grid [starcMS90G_symGridCheck $inp $grid $dbu]
            set vale [starcMS90G_symCheckParamValue $i $inp $min $max $inp_grid 1 $spice_model $inst $i]
            set valu [db::sciToEng $vale]
            starcMS90G_symSetParam $i $valu $inst
        }
     
    }
}

########################### Procedures for Resistors ################################

# Procedure to control the visibility of stripe spacing based on series/parallel/dummyLegs
proc starcMS90G_symResCntrlSpa {srs prl legs} {
    set inst [db::getCurrentRef]	
    set s  [db::getParamValue $srs  -of $inst]
    set p  [db::getParamValue $prl  -of $inst]
    set lg [db::getParamValue $legs -of $inst]
    if {[starcMS90G_symIsSchematic]} {return 0}
    if {[starcMS90G_symIsLayout]} {
        if { $s > 1 || $p > 1 || ($lg !="none") } {return 1} else {return 0}
    }
}

# Resistor Parameter Calculation
proc starcMS90G_symResCalcVal {res wid stripeLength dW dL Rsh Rend stripes s_p grid dbu} {

    if {$res == "NA"} {
        set calc "r"
    } elseif {$wid == "NA" } {
       set calc "w"
    } elseif {$stripeLength == "NA"} {
        set calc "l"
    }

    switch $calc {

        "r" {
            set resBody [expr ($stripeLength-$dL)*$Rsh/($wid-$dW)]
            set resTerm [expr $Rend * 1e-6 / ($wid - $dW)]
            set resStripe [expr $resBody + 2*$resTerm]

            if {$s_p == "1"} {
                set reff [expr $resStripe * double($stripes)]
            } else {
                set reff [expr $resStripe / double($stripes)]
            }

            ##Fix added for avoiding Tcl round error:Integer value too large ######
            if { [catch {expr round($reff*double(1000)) / double(1000)}] } {
                set reff [expr $reff*double(1000)]
                set reff [lindex [split $reff "."] 0]
                set reff [expr double($reff) / double(1000)]
            } else {
                set reff [expr round($reff*double(1000)) / double(1000)]
            }
            return $reff
        }

        "w" {
            if {$s_p == 1} {
                set width [expr $stripes * (($stripeLength - $dL) * $Rsh + 2 * $Rend* 1e-6) / $res + $dW]
            } else {
                set width [expr (($stripeLength - $dL) * $Rsh + 2 * $Rend* 1e-6) / ($stripes * $res) + $dW]
            }

            set wid [starcMS90G_symGridCheck $width $grid $dbu]
            return $wid
        }

        "l" {
            if {$s_p == 1} {
                set resStripe [expr $res / double($stripes)]
            } else {
                set resStripe [expr $res *  double($stripes)]
            }
            # Normalizing with terminal resistance value
            set resBody [expr $resStripe-2*$Rend* 1e-6/($wid-$dW)]

            # Calculating the resistor body length per stripe
            set calcStripeLength [expr double($resBody*($wid-$dW)/$Rsh)]
            set stripeLength [expr $calcStripeLength+$dL]
            set stripeLength [starcMS90G_symGridCheck $stripeLength $grid $dbu]
            return $stripeLength
        }

    }

}

proc starcMS90G_symResGetNumConts { width enclose tech1} {
    #global tech
    upvar $tech1 tech
    
    if { $width <= [expr 2.0*$enclose + $tech(contMinSpacing)] } {
	return 1
    } else {
        return [expr floor(($width - 2.0*$enclose + $tech(contMinSpacing)) \
		    / ($tech(contMinWidth) + $tech(contMinSpacing)))]
    }
}

proc starcMS90G_symResRtMetalExtent { width overhangX metalContEndcap tech1} {
    #global tech
    upvar $tech1 tech
    # Convert back to microns
    set overhangX	[expr $overhangX*1e6]
    set width           [expr $width*1e6]
    set metalContEndcap [expr $metalContEndcap*1e6]

    set numConts	[starcMS90G_symResGetNumConts $width $overhangX tech]
    set xContOffset	[expr $numConts*($tech(contMinWidth)+$tech(contMinSpacing))-$tech(contMinSpacing)]
    set backboneExcess	[expr ($width - $xContOffset)/2.0]
    set backboneExcess  [expr double(floor($backboneExcess*double(1000)/5)*5/double(1000))]
    set xContOffset	[expr $width - $backboneExcess*2.0]
    set rtExtent        [expr $width-$xContOffset-$overhangX]
    
    set diff1           [expr $metalContEndcap-$rtExtent]
    set diff2           [expr $metalContEndcap-$overhangX]
    set correction      [expr $diff1+$diff2+$tech(metal1Spacing)]
    
    # Change back to Metres
    return [expr $correction*1e-6]
}

# StripeSpacing Procedure
proc starcMS90G_symResSpacingCheck { resType width inst tech1 keys1} {
#    global tech keys
    upvar $tech1 tech
    upvar $keys1 keys
    set tech(polyContBox) [expr $tech(contMinWidth)+2*$tech(polyContEnclose)]
    set polyMinSpacing   [starcMS90G_symU2M $tech(polyMinSpacing)]
    set diffMinSpacing   [starcMS90G_symU2M $tech(diffMinSpacing)]
    set nwellSpacing     [starcMS90G_symU2M $tech(nwellSpacing)]
    set diffNwellEnclose [starcMS90G_symU2M $keys(diffNwellEnclose)]
    set sabDiffEnclose   [starcMS90G_symU2M $tech(sabDiffEnclose)]
    set sabMinSpacing    [starcMS90G_symU2M $tech(sabMinSpacing)]
    set polyContBox      [starcMS90G_symU2M $tech(polyContBox)]
    set metal1Spacing    [starcMS90G_symU2M $tech(metal1Spacing)]
    set polyContEnclose  [starcMS90G_symU2M $tech(polyContEnclose)]
    
    # Get DFM Rules
    if { ![regexp {metal} $resType] } {
        set metalContEndcap  [db::engToSci [starcMS90G_symGetParam m1ContactEndcap $inst]]
        set diffContEnclose  [db::engToSci [starcMS90G_symGetParam diffContactEnclose $inst]]
        set diffContBox      [expr ($tech(contMinWidth)*1e-6+(2* $diffContEnclose))]
    }
    
    if { [regexp {poly} $resType] } {
        if { $polyContBox > $width } {
            set resSpacing [expr $polyMinSpacing+$polyContBox-$width]
        } else {
            set resSpacing $polyMinSpacing
        }
        set m1Spacingfix [starcMS90G_symResRtMetalExtent $width $polyContEnclose $metalContEndcap tech]
        set resSpacing   [starcMS90G_symGetMax [list $resSpacing $m1Spacingfix]]
       
    } elseif { [regexp {diff} $resType] } {

        if { $diffContBox > $width } {
            set resSpacing [expr $diffMinSpacing+$diffContBox-$width]
        } else {
            set resSpacing $diffMinSpacing
        }
        set m1Spacingfix [starcMS90G_symResRtMetalExtent $width $diffContEnclose $metalContEndcap tech]
        set resSpacing   [starcMS90G_symGetMax [list $resSpacing $m1Spacingfix]]

    } elseif { [regexp {nwod} $resType] } {
        set resSpacing [expr 2*($diffNwellEnclose+$sabDiffEnclose)+$sabMinSpacing]
    } elseif { [regexp {nwell} $resType] } {
        if {$keys(resNwellTermDiff) > 0} {
	    set resSpacing [expr 2.0*$diffNwellEnclose+$diffMinSpacing]
	} else {
            set resSpacing $nwellSpacing
	}
    } elseif { [regexp {metal} $resType] } {
        set mtype [string trim $resType "metal"]
        set Spacingrule "${mtype}Spacing"
        set resSpacing [starcMS90G_symU2M $tech(metal$Spacingrule)]
    }

    return $resSpacing
}


################################### Procedures for Capacitors ######################################
# Procedure to control visibility of Finger Width based on TopPlate Connection type
proc starcMS90G_symCapFingerWidth {row col top} {
    set inst [db::getCurrentRef]	
    set Row  [db::getParamValue $row -of $inst]
    set Col  [db::getParamValue $col -of $inst]
    set Top  [db::getParamValue $top -of $inst]
    
    if {[starcMS90G_symIsSchematic]} {return 0}
    
    if {($Row == 1 && $Col == 1) && $Top == "array" } {
	return 0
    } else {
    	return 1
    }
}

# MIM Capacitor parameter Calculations

proc starcMS90G_symCapCalcVal {len wid cval Cf Ca dw dl constant grid dbu} {
    set mode [expr {($len == "NA" && $wid == "NA") ? "modeC" : [expr {($cval != "NA" && $wid != "NA") ? "modeCW": [expr {($cval == "NA" && $wid != "NA")? "modeLW" : "modeW"}]}]}]
    switch $mode {
	modeC {
	       set varC [expr $dw*$dl*$Ca+$constant-$cval-2*($dw+$dl)*$Cf]
               set varB [expr 4*$Cf-$Ca*($dl+$dw)]
               set temp [expr (sqrt($varB*$varB-4*$Ca*$varC)-$varB)/(2*$Ca)]
	       return [starcMS90G_symGridCheck $temp $grid $dbu]
	
	}
        modeLW {
              set C_temp [expr ($Ca*($len-$dl)*($wid-$dw) + 2*(($len-$dl) + ($wid-$dw))*$Cf + $constant)]
              return  $C_temp
	
	}
	modeCW {
	        set l_temp1 [expr $cval-2*$Cf*$wid-$constant]
                set l_temp2 [expr ($Ca*$wid)+(2*$Cf)]
                return [starcMS90G_symGridCheck [expr ($l_temp1/$l_temp2)+$dl] $grid $dbu]
	
	} 
	modeW {
	      set w_temp1 [expr $cval-2*$Cf*$len-$constant]
              set w_temp2 [expr ($Ca*$len)+(2*$Cf)]
              return [starcMS90G_symGridCheck [expr ($w_temp1/$w_temp2)+$dl] $grid $dbu]
	
	}

    }

}

# Capacitance calculation for MOM capacitor
proc starcMS90G_symCapMomCalcVal { nv nh w s stm spm } {

    set layno [expr $spm - $stm +1]

    if {$stm == 1} {
	set laym1 1
    } else {
	set laym1 0
    }

    if {($stm % 2) == 0} {
	set layodd [expr int(($spm - $stm + 1)/2.0)]
    } elseif {($stm == 3 || $stm == 5)} {
	set layodd [expr int(($spm - $stm + 2)/2.0)]
    } else {
        set layodd [expr int(($spm + (5.0/3.0))/2.0) - 1]
    }

    if {($stm % 2) == 0} {
	set layeven [expr int(($spm - $stm + 2)/2.0)]
    } else {
   	set layeven [expr int(($spm - $stm + 1)/2.0)]
    }

    set Edg [expr ($layodd + (0.56*$laym1)) * ($nv - 1) * ($nh*($w + $s) - $s) \
	         + ($layeven * ($nh - 1) * ($nv*($w + $s) - $s)) ]
    set AREA [expr ($nv * $nh / 2.0) * $w * ($layno - 1)]
    set FRI1 [expr (2 * $nh * $nv * $w) / ($layno - 1) ]
    set FRI2 [expr (($layodd + $laym1)*$nv*$w + $layeven*$nh*$w) + \
		     $layeven*($nv*($w + $s) - $s + 0.5e-6)*2 + \
		     $layno*0.14e-6*2 + \
		   (($layodd + (0.56*$laym1)) * ($nh*($w + $s) - $s))*2 ]
    set Cc1 [expr (0.01 / ($s * 1e6)) + (0.00003 / ($w * 1e6)) + \
                  (0.000018 * $w / $s) + 0.011]
    set Cc2 0.0486
    set Cf  [expr (0.023 * $s * 1e6) + (0.0051 * $w * 1e6) - 0.0034 * $s * $w * 1e12 + \
                   0.00124 ]
    set Ca  [expr (0.0156 * $s * 1e6) + (0.0835 * $w * 1e6) - 0.0543 * $s * $w * 1e12 - \
		   0.00018 ]

    set Cmom [expr (($Cc1 * $Edg) + ($Cf * $FRI1) + ($Ca * $AREA) + ($Cc2 * $FRI2)) * 1e-9 ]
    set Cpa  1e-16
    set Cpb  1e-16

    return [list $Cmom $Cpa $Cpb]

}


################################### Procedures for Inductors ######################################
# To control visibility of Spacing in Inductor, visible only when turns > 1
proc starcMS90G_symIndCntrlSpa {turns} {
    set inst [db::getCurrentRef]	
    set t  [db::getParamValue $turns  -of $inst]
    if {[starcMS90G_symIsLayout]} {
        if { $t > 1 } {
	   return 1
	} else {
	   return 0
	}
    }
}



# r	  : spiral radius
# w	  : spiral width
# ms      : spacing between the spiral turns
# sides   : No. of spiral sides, validated for 4 and 8
# p	  : value of tan(pi/8)
# s	  : value of tan(pi/sides)


################### Symmetrical Inductor Calculations #########################
# Calculates Inner side of Cross-connection required to avoid bad geometries
# required  when keys(connWidth4vias) = 0
proc starcMS90G_symIndSCalInside {r w ms sides p s grid dbu} {
    set r       [expr $r*1e6]	
    set w       [expr $w*1e6]	
    set ms      [expr $ms*1e6]
    set sp      [expr $ms*$p]
    set sp      [expr double(ceil($sp*$dbu/$grid)*$grid/$dbu)]
    set sp1     [expr 0.5*$w*$p]
    set sp1     [expr double(ceil($sp1*$dbu/$grid)*$grid/$dbu)]
    set spacing [expr $sp+$sp1+(($w+$ms)/2)]
    set spacing [expr double(ceil($spacing*$dbu/$grid)*$grid/$dbu)]
    set sideIn  [expr ($r*$s)-$spacing]
    set sideIn  [expr double(ceil($sideIn*$dbu/$grid)*$grid/$dbu)]
    return      [expr $sideIn*1e-6]
}

# Calculates possible width of spiral for a given Radius and desired Inner side
# of Cross-connection to avoid bad geometries when keys(connWidth4vias) = 0
proc starcMS90G_symIndSCalWidI {sideCon ms r sides p s grid dbu} {
    set r       [expr $r*1e6]	
    set sideCon [expr $sideCon*1e6]	
    set ms      [expr $ms*1e6]
    set sp1     [expr $ms*$p]
    set sp      [expr double(ceil($sp1*$dbu/$grid)*$grid/$dbu)]
    set sideBy2 [expr ($r*$s)]
    set spacing [expr $sideBy2-$sideCon-$sp-$ms/2]
    set w       [expr floor((2*$spacing)/(1+$p))]
    return      [expr $w*1e-6]
}

# Calculates possible Radius of spiral for a given width and desired Inner side
# of Cross-connection to avoid bad geometries when keys(connWidth4vias) = 0
proc starcMS90G_symIndCalRadI {sideCon ms w sides p s grid dbu} {
    set w       [expr $w*1e6]	
    set sideCon [expr $sideCon*1e6]	
    set ms      [expr $ms*1e6]
    set sp      [expr $ms*$p]
    set sp      [expr double(ceil($sp*$dbu/$grid)*$grid/$dbu)]
    set sp1     [expr 0.5*$w*$p]
    set sp1     [expr double(ceil($sp1*$dbu/$grid)*$grid/$dbu)]
    set spacing [expr $sp+$sp1+(($w+$ms)/2)]
    set spacing [expr double(ceil($spacing*$dbu/$grid)*$grid/$dbu)]
    set sideBy2 [expr $spacing+$sideCon]
    set r       [expr ceil($sideBy2/$s)]
    return      [expr $r*1e-6]
}

# Calculates possible width of spiral for a given radius such that 
# Cross-connection width is equal to spiral width when keys(connWidth4vias) = 1
proc starcMS90G_symIndSCalWidO {r ms sides p s grid dbu } {
   set ms       [expr $ms*1e6]
   set r        [expr $r*1e6]
   set a        [expr (2*$r*$s)-(2*$ms*$p)-$s]
   set b        [expr 3+$p-(2*$s)]
   set w        [expr $a/$b]
   set w        [expr double(floor($w*$dbu/$grid)*$grid/$dbu)]
   return 	[expr $w*1e-6]
}

# Calculates possible Radius of spiral for a given Width such that 
# Cross-connection width is equal to spiral width when keys(connWidth4vias) = 1
proc starcMS90G_symIndSCalRadO {w ms sides p s grid dbu} {
    set ms       [expr $ms*1e6]
    set w        [expr $w*1e6]
    set sp       [expr $ms*$p]
    set sp1      [expr $w*$p]
    set spacing  [expr (2*$sp+$sp1+($w+$ms))/2]
    set r [expr  (($w*(1-$s))+$spacing)/$s]
    set r        [expr double(ceil($r*$dbu/$grid)*$grid/$dbu)]
    return       [expr $r*1e-6]
}

################### Asymmetrical Inductor Calculations ########################
# Calculates possible Width of spiral for a given Radius to avoid merging of
# spiral turns in the center, when keys(needSeperation) = 0
proc starcMS90G_symIndAScalWidI {r ms sides p s grid dbu} {
    set ms       [expr $ms*1e6]
    set r        [expr $r*1e6]
    set a        [expr (3*$r*$s)-(3*$ms*$p)-$ms+(2.5*$ms*$s)]
    set b        [expr 2.5-(2.5*$s)]
    set w        [expr $a/$b]
    set w        [expr double(floor($w*$dbu/$grid)*$grid/$dbu)]
    return       [expr $w*1e-6]
}

# Calculates possible Radius of spiral for a given Width to avoid merging of
# spiral turns in the center, when keys(needSeperation) = 0
proc starcMS90G_symIndASCalRadI {w ms sides p s grid dbu} {
    set ms       [expr $ms*1e6]
    set w        [expr $w*1e6]
    set sh       [expr (($w+$ms)/3.0)]
    set r	 [expr ((($w/2.0)+$ms*$p+$sh)/$s)-(2.5*$sh)] 
    set r        [expr double(ceil($r*$dbu/$grid)*$grid/$dbu)]
    return       [expr $r*1e-6]
}

# Calculates possible Width of spiral for a given Radius to draw outer side
# region equal to spiral width, when keys(needSeperation) = 1
proc starcMS90G_symIndASCalWidO {r ms sides p s grid dbu} {
    set ms       [expr $ms*1e6]
    set r        [expr $r*1e6]
    set w        [expr ((($r-($ms/6.0))*$s)-($ms/2.0))/((1-(5/6.0)*$s))]
    set w        [expr double(floor($w*$dbu/$grid)*$grid/$dbu)]
    return       [expr $w*1e-6]
}

# Calculates possible Radius of spiral for a given Width to draw outer side
# region equal to spiral width, when keys(needSeperation) = 1
proc starcMS90G_symIndASCalRadO {w ms sides p s grid dbu} {
    set ms       [expr $ms*1e6]
    set w        [expr $w*1e6]
    set r        [expr ($w*(1-(5*$s/6.0))+($ms*$s/6.0)+($ms/2.0))/$s]
    set r        [expr double(ceil($r*$dbu/$grid)*$grid/$dbu)]
    return       [expr $r*1e-6]
}

################################### Procedures for Varactor ######################################
proc starcMS90G_symVarCalcVal {len wid cval Ca Cf Cl Cw dl dw grid dbu} {
set mode [expr {($len == "NA" && $wid == "NA") ? "modeC" : [expr {($cval != "NA" && $wid != "NA") ? "modeCW": [expr {($cval == "NA" && $wid != "NA")? "modeLW" : "modeW"}]}]}]
    switch $mode {
	modeC {
	        set varC [expr $Ca*$dl*$dw-2*$Cl*$dl-2*$Cw*$dw-2*$Cf*$dw-2*$Cf*$dl-$cval]
                set varB [expr 2*$Cl+2*$Cw+4*$Cf-$Ca*$dl-$Ca*$dw]
		set temp3 [expr (sqrt($varB*$varB-4*$Ca*$varC)-$varB)/(2*$Ca)]
		return [starcMS90G_symGridCheck $temp3 $grid $dbu]
	}
        modeLW {
	        set len [expr $len - $dl]
                set wid [expr $wid - $dw]
	        set C_temp [expr ($Ca*$len*$wid)+(2*$Cl*$len)+(2*$Cw*$wid)+(2*$Cf*($len+$wid))]
		return $C_temp
        }
	modeCW {
	       set l_temp1 [expr $cval-(2*$Cf*($wid-$dw)+2*$Cw*($wid-$dw))]
               set l_temp2 [expr ($Ca*($wid-$dw)+2*($Cl+$Cf))]
	       set l_temp3 [expr $l_temp1/$l_temp2]
               return [starcMS90G_symGridCheck [expr ($l_temp3+$dl)] $grid $dbu]
	} 
	modeW {
	      set w_temp1 [expr $cval-(2*$Cf*($len-$dl)+2*$Cw*($len-$dl))]
              set w_temp2 [expr ($Ca*($len-$dl)+2*($Cl+$Cf))]
	      set w_temp3 [expr $w_temp1/$w_temp2]
              set w_temp4 [expr ($w_temp3+$dw)]
              return [starcMS90G_symGridCheck $w_temp4 $grid $dbu]
	}

    }
}

# The following Procedeure calculates pitch of gate.
# The Pitch depends on internalStrapping. If strapping 
# is off pitch decreases as contacts are not required
# Returns : PolyPitch - float
#           Dogbone   - boolean
#           numContacts- Int

proc starcMS90G_symMosPitch { grid dbu Width Length p2cs p2cd internalStrapping inst model tech1 keys1} {

    #global tech keys
    upvar $tech1 tech
    upvar $keys1 keys
    set tech(polyDiffSpacing) [expr [db::engToSci [starcMS90G_symGetParam diffPolySpacing $inst]] *1e6]
    set tech(diffContEnclose) [expr [db::engToSci [starcMS90G_symGetParam diffContactEnclose $inst]] *1e6]
    set tech(polyContBox)     [expr $tech(contMinWidth)+2*$tech(polyContEnclose)]
    set strapOffset [expr {
	    $Length < $tech(polyContBox) ? 
	    [expr ($tech(contMinWidth)/2.0) + $tech(polyContEnclose) - ($Length/2.0)]
	    : 0
	    }]
    set strapOffset [starcMS90G_symCheckGridUpper $grid $dbu $strapOffset]
    if { $Width < (2 * $tech(diffContEnclose)) + $tech(contMinWidth) } {
	set NumConts 1
	set Dogbone 1
	if { $internalStrapping} {
	    set PolyPitch [expr $Length + (2 * $tech(diffContEnclose)) + \
			    $tech(contMinWidth) + (2 * $tech(polyDiffSpacing))]
	} else {
	    set PolyPitch [expr $Length +$tech(gateMinSpacing)]
	}

    } else {
    	set Dogbone 0
	set NumConts [expr floor(($Width + (-2 * $tech(diffContEnclose)) + \
		            $tech(contMinSpacing)) / ($tech(contMinWidth) + \
			    $tech(contMinSpacing)))]
	if { $internalStrapping} {
	    set PolyPitch [expr $Length + (2 * $keys(polyContSpacing_$model)) + \
			    $tech(contMinWidth)]
 	} else {
	    set PolyPitch [expr $Length +$tech(gateMinSpacing)]
	}
    }
    if { !$internalStrapping} {
        set PolyPitchD $PolyPitch
        set PolyPitchS $PolyPitch
    } else {
        set PolyPitchD [expr { $PolyPitch > $Length + 2.0*$p2cd + $tech(contMinWidth) ?
                               $PolyPitch
                               : $Length + 2.0*$p2cd + $tech(contMinWidth)
                        }]
        set PolyPitchS [expr { $PolyPitch > $Length + 2.0*$p2cs + $tech(contMinWidth) ?
                               $PolyPitch
                               : $Length + 2.0*$p2cs + $tech(contMinWidth)
                        }]


        set PolyPitchS [expr { 
	                $tech(polyMinSpacing) + 2*$strapOffset + $Length > $PolyPitchS ? 
		            $tech(polyMinSpacing) + 2*$strapOffset + $Length 
		            : $PolyPitchS
	                }]
        set PolyPitchD [expr { 
	                $tech(polyMinSpacing) + 2*$strapOffset + $Length > $PolyPitchD ? 
		            $tech(polyMinSpacing) + 2*$strapOffset + $Length 
		            : $PolyPitchD
	                }]
    }
    return [list $PolyPitch $PolyPitchS $PolyPitchD $Dogbone $NumConts]
}


#
#  Procedure to calculate SA SB SD 
#
proc starcMS90G_symMosCalcSASBSD { Length Width nf p2cs p2cd internalStrapping drainTerm sourceTerm grid dbu inst model tech1 keys1} {

    #global tech keys
    upvar $tech1 tech
    upvar $keys1 keys
    
    set tech(diffPolyEnclose) [expr [db::engToSci [starcMS90G_symGetParam diffPolyEndcap $inst]] *1e6]
    set tech(diffContEnclose) [expr [db::engToSci [starcMS90G_symGetParam diffContactEnclose $inst]] *1e6]
    
    set p2cd   [expr $p2cd *1e6] 
    set p2cs   [expr $p2cs *1e6]
    set Length [expr $Length *1e6]
    set Width  [expr $Width *1e6] 
    
    set tech(gateMinSpacing) [expr $keys(gateMinSpacing)]
    set params [starcMS90G_symMosPitch $grid $dbu $Width $Length $p2cs $p2cd $internalStrapping $inst $model tech keys]
    set PolyPitchS [lindex $params 1]
    set PolyPitchD [lindex $params 2]
    set Dogbone    [lindex $params 3]

    # Calculating SA 
    if { $sourceTerm } { 
        set sa [expr $p2cs + $tech(contMinWidth) + $tech(diffContEnclose)]
    } else {
        set sa $tech(diffPolyEnclose)
    }

    # Calculating SB
    if [expr fmod ($nf,2) != 0] {
        if { $drainTerm } { 
            set sb [expr $p2cd + $tech(contMinWidth) + $tech(diffContEnclose)]
        } else {
            set sb $tech(diffPolyEnclose)
        }
    } else {
        if { $drainTerm } { 
            set sb [expr $p2cs + $tech(contMinWidth) + $tech(diffContEnclose)]
        } else {
            set sb $tech(diffPolyEnclose)
        }
    }
    # Calculating SD
    set sd 0

    # Calculating SD when nf = 2 
    if {$nf == 2 } { 
        set sd [expr $PolyPitchD - $Length]
    }

    # Calculating SD when nf = odd 
    if { $nf > 2 } { 
        if { [expr fmod($nf,2)] != 0 } {
            set sd [expr ($PolyPitchD + $PolyPitchS - $Length - $Length )/2]
        } else { 
            set sd_1 [expr ($nf/2) * $PolyPitchD]
            set sd_2 [expr (($nf/2)-1) * $PolyPitchS]
            set sd_3 [expr ($nf-1) * $Length]
            set sd [expr ($sd_1 + $sd_2 - $sd_3)/($nf - 1)]
        }
    }
    set sa [db::sciToEng [expr $sa * 1e-6]]
    set sb [db::sciToEng [expr $sb * 1e-6]]
    set sd [db::sciToEng [expr $sd * 1e-6]]
    set polyS [expr $PolyPitchS*1e-6]
    set polyD [expr $PolyPitchD*1e-6]
    return [list $sa $sb $sd $polyS $polyD]
}

#####################################################################################
# mosParasitics : set as/ad/ps/pd/nrs/nrd values for the mosfets device instance.
# By setting a value for the instance and not an equation, it introduces an inaccuracy
# in case the designer is running a sweep simulation on the mosfet width.
######################################################################################
proc starcMS90G_symMosParasitics { len wid NF spice_model grid dbu inst tech1 keys1} {
    #global tech keys
    upvar $tech1 tech
    upvar $keys1 keys

    # Take inputs from the PE form
    set tech(polyContBox) [expr $tech(contMinWidth)+2*$tech(polyContEnclose)]
    set diffContactEnclose [db::engToSci [starcMS90G_symGetParam diffContactEnclose $inst]]
    set polyDiffSpacing [db::engToSci [starcMS90G_symGetParam diffPolySpacing $inst]]

    set dgb_box [expr ($tech(contMinWidth)*1e-6+(2* $diffContactEnclose))]
    
    if { $wid < $dgb_box} {
        set minG2cs [expr $polyDiffSpacing+$diffContactEnclose]
	set p2cs $minG2cs
	set p2cd $minG2cs
    } else {
        set minG2cs [expr $keys(polyContSpacing_$spice_model)*1e-6]
	set p2cs $minG2cs
	set p2cd $minG2cs
    }
    

    set intStrap [starcMS90G_symGetParam internalStrapping $inst]
    set drnTerm  [starcMS90G_symGetParam drainTerm $inst]
    set srcTerm  [starcMS90G_symGetParam sourceTerm $inst]
    if {$intStrap} {set intStrap 1} else {set intStrap 0}
    if {$drnTerm} {set drnTerm 1} else {set drnTerm 0}
    if {$srcTerm} {set srcTerm 1} else {set srcTerm 0}
    
    # get values of lod parameters
    set sasbsd   [starcMS90G_symMosCalcSASBSD $len $wid $NF $p2cs $p2cd $intStrap $drnTerm $srcTerm $grid $dbu $inst $spice_model tech keys]
    set sa [lindex $sasbsd 0]
    set sb [lindex $sasbsd 1]
    set sd [lindex $sasbsd 2]
    set PolyPitchS [lindex $sasbsd 3]
    set PolyPitchD [lindex $sasbsd 4]
    set sa [db::engToSci $sa]
    set sb [db::engToSci $sb]
    set sd [db::engToSci $sd]    

    # Calculate as/ad/ps/pd/nrs/nrd for non-dogbone mosfet
    if {$wid >= $dgb_box } {
        if {$NF==1} {
            set as [ expr ($sa*$wid)]
            set ad [ expr $sb*$wid]
            set ps [ expr (2*$sa)+$wid]
            set pd [ expr (2*$sb)+$wid]
        } elseif {[expr $NF%2]} {
            set as [expr (($sa*$wid)+(($NF-1)/2*$wid)*($PolyPitchS - $len ))]
            set ad [expr (($sb*$wid)+((($NF-1)/2)*(($PolyPitchD - $len) * $wid)))]
	    set ps [expr ((2*$sa)+($wid)+((($NF-1)/2)*2*($PolyPitchS - $len )))]
            set pd [expr ((2*$sb)+($wid)+((($NF-1)/2)*2*($PolyPitchD - $len)))]
        } elseif {![expr $NF%2]} {
            set as [expr ($sa+$sb)*$wid +(($NF-2)/2)*($PolyPitchS-$len)*$wid ]
            set ad [expr ($NF/2)*($PolyPitchD-$len)*$wid]
            set ps [expr ((2*$sa)+(2*$sb)+(2*$wid)+((($NF-2)/2)*2*($PolyPitchS-$len)))]
            set pd [expr (($NF/2)*2*($PolyPitchD-$len))]
        }
    } 

    # Calculate as/ad/ps/pd/nrs/nrd for dogbone mosfet
    if {$wid < $dgb_box } {
        set extSrcArea  [expr $srcTerm*$dgb_box*($dgb_box-$wid)]
        set extDrnArea  [expr $drnTerm*$dgb_box*($dgb_box-$wid)]
        set extSrcPerim [expr $srcTerm*2*($dgb_box-$wid)]
        set extDrnPerim [expr $drnTerm*2*($dgb_box-$wid)]
        if {$NF==1} {
            set as [expr $sa*$wid+$extSrcArea]
            set ad [expr $sb*$wid+$extDrnArea]
            set ps [expr (2*$sa)+$wid+$extSrcPerim]
            set pd [ expr (2*$sb)+$wid+$extDrnPerim]
        } elseif {[expr $NF%2]} {
            set extBoxArea [expr $intStrap*$dgb_box*($dgb_box-$wid)]
	    set extBoxPerim [expr $intStrap*2*($dgb_box-$wid)]
            set as [expr (($sa*$wid)+(($NF-1)/2*$wid)*($PolyPitchS-$len ))+$extSrcArea+(($NF-1)/2)*$extBoxArea]
            set ad [expr (($sb*$wid)+((($NF-1)/2)*(($PolyPitchD-$len)*$wid)))+$extDrnArea+(($NF-1)/2)*$extBoxArea]
	    set ps [expr ((2*$sa)+($wid)+((($NF-1)/2)*2*($PolyPitchS-$len )))+$extSrcPerim+(($NF-1)/2)*$extBoxPerim]
            set pd [expr ((2*$sb)+($wid)+((($NF-1)/2)*2*($PolyPitchD-$len)))+$extDrnPerim+(($NF-1)/2)*$extBoxPerim]
        } elseif {![expr $NF%2]} {
            set extBoxArea [expr $intStrap*$dgb_box*($dgb_box-$wid)]
	    set extBoxPerim [expr $intStrap*2*($dgb_box-$wid)]
            set as [expr ($sa+$sb)*$wid +(($NF-2)/2)*($PolyPitchS-$len)*$wid+$extSrcArea+$extDrnArea+(($NF-2)/2)*$extBoxArea]
	    set ad [expr ($NF/2)*($PolyPitchD-$len)*$wid+($NF/2)*$extBoxArea]
	    set ps [expr ((2*$sa)+(2*$sb)+(2*$wid)+((($NF-2)/2)*2*($PolyPitchS-$len)))+$extSrcPerim+$extDrnPerim+(($NF-2)/2)*$extBoxPerim]
            set pd [expr (($NF/2)*2*($PolyPitchD-$len))+($NF/2)*$extBoxPerim]
        }	
   } 

   set nrs [expr $as/($wid*$wid)]
   set nrd [expr $ad/($wid*$wid)]

   # return the calculated values of parasitics to the callback
   return [list $p2cs $p2cd $nrs $nrd $as $ad $ps $pd $sa $sb $sd]

}


# Procedure used to calculate the pwell area
proc starcMS90G_symMosDrawImplant { layer lstDiffExtent lstGateExtent polyLowHi diffEnclose gateEnclose \
    buttedJunctionLt buttedJunctionRt needSharp drawImplant keys1} {

    upvar $keys1 keys

    set polyLowerY [lindex $polyLowHi 0]
    set polyUpperY [lindex $polyLowHi 1]
    set encloseY [ expr { \
		    $needSharp ? \
			$diffEnclose > $gateEnclose ? $diffEnclose : $gateEnclose \
			: $gateEnclose \
		}]
	    
    set lstImpCoord [starcMS90G_symResizeRectUnsymmetric $lstDiffExtent $buttedJunctionLt*$diffEnclose \
        $encloseY $buttedJunctionRt*$diffEnclose $encloseY]

    if { $keys(mosImpConcern) } {
        set impLY [starcMS90G_symBreakRect $lstImpCoord ly]
        set impUY [starcMS90G_symBreakRect $lstImpCoord uy]
        if { $polyLowerY < [starcMS90G_symBreakRect $lstImpCoord ly]} {
            set impLY $polyLowerY
        }
        if { $polyUpperY > [starcMS90G_symBreakRect $lstImpCoord uy]} {
            set impUY $polyUpperY
        }
        set lstImpCoord [starcMS90G_symMakeRectList [starcMS90G_symBreakRect $lstImpCoord lx] $impLY\
            [starcMS90G_symBreakRect $lstImpCoord ux] $impUY]
    }
    if { $needSharp } {
        for { set i 0 } { $i <= [llength $lstGateExtent]/2 } { incr i 1 } {
	    set lstNewGateExtent [starcMS90G_symResizeRect [list [lindex $lstGateExtent $i] \
		[lindex $lstGateExtent [expr $i+1]]] $encloseY $encloseY]
         }
    }
    return $lstImpCoord

}

# Procedure used to calculate the pwell area
proc starcMS90G_symMosMetalStrap { dbu grid Length folds PolyPitchS PolyPitchD \
    gateStrapPosition ptGatePolyLowerX ptGatePolyUpperY ptGatePolyLowerY cornered tech1} {

    global  ptOriginX ptOriginY 
    upvar  $tech1 tech 

    set ptLower $ptGatePolyLowerY
    set ptUpper $ptGatePolyUpperY

    set PolyPitch $PolyPitchD
    set polyBox [expr $tech(contMinWidth) +2*$tech(polyContEnclose)]
    set tech(polyContBox) [expr $tech(contMinWidth)+2*$tech(polyContEnclose)]
    set strapOffset [expr { 
	    $Length < $polyBox ? 
	    [expr - ($tech(contMinWidth)/2.0) - $tech(polyContEnclose) + ($Length/2.0)]
	    : 0
	    }]
    set strapOffset [starcMS90G_symCheckGrid $grid $dbu $strapOffset]
    set polyVertexX [expr {  
	    $Length <= $polyBox ? $polyBox : $Length 
		 	}]
    set polyVertexY $polyBox
    
    set xnumPolyCont [ starcMS90G_symGetNumPolyConts $polyVertexX tech]
    set numPolyCont [expr floor($xnumPolyCont) ]

    set polyExcess [expr {  
	    $Length > $polyBox ? 
		    [expr ($polyVertexX - ($numPolyCont-1) * ($tech(contMinWidth)\
		    + $tech(contMinSpacing)) - $polyBox)/($numPolyCont)]
		    : 0
		}]
    set polyExcess [starcMS90G_symCheckGrid $grid $dbu $polyExcess ]
    set xContOffset [expr ($numPolyCont-1)*($polyExcess+$tech(contMinSpacing)+$tech(contMinWidth))+$tech(contMinWidth)]
    set strapPolyBoxLowerX [expr $ptGatePolyLowerX + $strapOffset]
    set strapPolyBoxLowerY $ptGatePolyLowerY
    set strapPolyBoxUpperY $ptGatePolyUpperY
    
    set polyContLowerX [expr { $cornered ? \
			[expr $strapPolyBoxLowerX + $tech(polyContEnclose) ]\
			: [expr $strapPolyBoxLowerX + $tech(polyContEnclose) + $polyExcess]\
			}]
    set polyContLowerBoxY [expr $strapPolyBoxLowerY - $tech(polyContEnclose) ]
    set polyContUpperBoxY [expr $strapPolyBoxUpperY + $tech(polyContEnclose) ]
    set strapMetalLowerX  [expr $polyContLowerX - $tech(metal1ContEndCapEnclose) ]
    set strapMetalTopY    [expr $polyContUpperBoxY - $tech(metal1ContEnclose)]
    set strapMetalBottomY [expr $polyContLowerBoxY + $tech(metal1ContEnclose)]
    for { set g 0 } { $g <= $folds } \
	    { incr g 1; set strapPolyBoxLowerX [expr $strapPolyBoxLowerX + $PolyPitch];\
			    set polyContLowerX [expr $polyContLowerX + $PolyPitch] } {

	if { $g % 2 == 0 } {
            set PolyPitch $PolyPitchD
        } else {
            set PolyPitch $PolyPitchS
        }
	if { $gateStrapPosition == "bottom" || $gateStrapPosition == "both" } {

            # set the lower-most point of poly, when bottom is strapped
            set ptLower [expr $strapPolyBoxLowerY -$tech(polyContBox)]
        }


	if { $gateStrapPosition == "top" || $gateStrapPosition == "both" } {
            set ptUpper [expr $strapPolyBoxUpperY + $tech(polyContBox)]
	}
	set strapMetalUpperX [expr $polyContLowerX + $xContOffset + $tech(metal1ContEndCapEnclose)]

    }
    return [list $ptLower $ptUpper]
}

# Procedure used to calculate the pwell area
proc starcMS90G_symCreateMosContColumn { x y offset spacing direction numConts drawControl tech1 } {

    upvar $tech1 tech

    set m1Width [expr $tech(contMinWidth) + (2.0*$tech(metal1ContEnclose))]
    if { $m1Width < $tech(metal1MinWidth) } {
	set m1Width $tech(metal1MinWidth)
    }
    set m1Overhang [expr ($m1Width-$tech(contMinWidth))/2.0]
    set m1Length   [expr (($numConts - 1) * \
	                  ($tech(contMinWidth) + $spacing)) + \
			  ($tech(contMinWidth) + $tech(metal1ContEndCapEnclose))]
    set contColLength [expr $m1Length - $tech(metal1ContEndCapEnclose)]
    set lowerX [expr $x+$offset]
    set lowerY [expr $y + $tech(diffContEnclose)]
    set dir [expr {
	    $direction > 0 ? 1
			    :$direction < 0 ? 2
					    : 0
		    }]
    switch $dir {
	    "2" {
	        set metalLowerY [expr $y + $tech(diffContEnclose) - \
				    $tech(metal1ContEndCapEnclose) - $tech(metal1Spacing)]
	        set metalUpperY [expr $lowerY + $m1Length]
	    }
	    "1" {
	        set metalLowerY [expr $y + $tech(diffContEnclose) - \
				    $tech(metal1ContEndCapEnclose)]
	        set metalUpperY [expr $lowerY + $m1Length + $tech(metal1Spacing)]
	    }
	    "0" {
	        set metalLowerY [expr $y + $tech(diffContEnclose) - \
					$tech(metal1ContEndCapEnclose)]
	        set metalUpperY [expr $lowerY + $m1Length]
	    }
    }
    set upperX    [expr $lowerX+$tech(contMinWidth)]
    set metalX    [expr $lowerX-$m1Overhang]
    set metalRect [starcMS90G_symMakeRectList $metalX $metalLowerY [expr $metalX + $m1Width] $metalUpperY]
    for { set c 0 } { $c < $numConts } { incr c 1 } {
	set lowerY [expr $lowerY + $tech(contMinWidth) + $spacing]
    }
    if { $drawControl == 0 } {
        return $metalRect
    } elseif { $direction ==1 } {
        return [list $metalX $metalUpperY]
    } else {
        return [list $metalX $metalLowerY]
    }
}

# Procedure used to calculate the pwell area
proc starcMS90G_symMosPolyStrap { Length keepOut strapSource strapDrain Width folds gateStrapPosition ptStrapPolyLowerX \
    ptStrapPolyUpperX ptStrapPolyBottomUpperY ptStrapPolyBottomLowerY ptStrapPolyTopLowerY ptStrapPolyTopUpperY tech1} {

    global  ptOriginX ptOriginY 
    upvar  $tech1 tech

    # set Default lower and upper Y-coords of poly and reload with required values.
    # Used for drawing implant layer later.
    set ptLower $ptStrapPolyBottomUpperY
    set ptUpper $ptStrapPolyTopLowerY

    if { $gateStrapPosition == "bottom" || $gateStrapPosition == "both" } {
	
        set ptLower $ptStrapPolyBottomLowerY
    }
    if { $gateStrapPosition == "top" || $gateStrapPosition == "both" } {
	     
        set ptUpper $ptStrapPolyTopUpperY
    }
    return [list $ptLower $ptUpper]
}

# Procedure used to calculate the pwell area
proc starcMS90G_symMosCreateGateSrcDrn { Length Width folds PolyPitch PolyPitchS PolyPitchD  p2cs p2cd \
    Dogbone dbu grid keepOut strapSource strapDrain leftTerm rightTerm internalStrapping \
    ptGatePolyLowerX ptGatePolyUpperX ptGatePolyLowerY ptGatePolyUpperY spacing tech1 keys1} {

    global  ptOriginX ptOriginY
    upvar $tech1 tech 
    upvar $keys1 keys
    set tech(diffContBox) [expr $tech(contMinWidth)+2*$tech(diffContEnclose)]
    set ptGateDiffLowerX $ptOriginX
    set numDiffCont      [starcMS90G_symGetNumDiffConts $Width tech]
    set PolyPitch        $PolyPitchD
    set direction        [expr {
                             $keepOut ? -1 :int(-1*$strapSource)
                         }]

    # contGateOffset, contGateOffsetSrc, contGateOffsetDrn :
    # The three variables will store the difference :
    # (user specified gate to Diffustion contact) - (DRC rules that affect a dogbone)
    # This is will be used according to keys(mosDiffConcern) which specifies
    # how p2cs and p2cd should be distributed into the dogbone.
    set contGateOffsetSrc     [expr {
                              $tech(diffContEnclose) + $tech(polyDiffSpacing) > $p2cs ?
                                  0
                                  : $p2cs - ($tech(diffContEnclose) + $tech(polyDiffSpacing))
                              }]
    set contGateOffsetDrn     [expr {
                              $tech(diffContEnclose) + $tech(polyDiffSpacing) > $p2cd ?
                                  0
                                  : $p2cd - ($tech(diffContEnclose) + $tech(polyDiffSpacing))
                              }]
    if { $Dogbone } {
        set termOffset        [expr -($tech(diffContBox)/2.0)+($Width/2.0)]
        set termOffset        [starcMS90G_symCheckGrid $grid $dbu $termOffset]
        set ptDiffLowerX      [expr {
                              $leftTerm ?
                                  $ptOriginX - ($tech(diffContBox)+$tech(polyDiffSpacing)+$contGateOffsetSrc)
                                  :$ptOriginX - $tech(diffPolyEnclose)
                              }]
        
        set ptDiffLowerY      [expr $ptOriginY + $termOffset]
        set ptDboneDiffLowerX [expr {
                              $leftTerm ?
                                  $keys(mosDiffConcern) ?
                                      $ptOriginX - $tech(polyDiffSpacing)
                                      : $ptOriginX - $tech(polyDiffSpacing) - $contGateOffsetSrc
                                  : $ptOriginX - $tech(diffPolyEnclose)
                              }]
        set ptDboneDiffLowerY $ptOriginY
        set lstTermPolygon    [starcMS90G_symMakePolygonListFromRect [list $ptDiffLowerX \
        		      $ptDiffLowerY] [list [expr $ptDiffLowerX + $tech(diffContBox)\
                              + $keys(mosDiffConcern) * $contGateOffsetSrc]\
        		      [expr $ptDiffLowerY + $tech(diffContBox)]]]

        if { !$leftTerm } {
            set lstTermPolygon {{0 0} {0 0}}
        }
	set lstExtraDbonePolygon [starcMS90G_symMakePolygonListFromRect [list $ptDboneDiffLowerX\
			      $ptDboneDiffLowerY] [list $ptOriginX \
			      [expr $ptOriginY + $Width]]]
	set offset            $tech(diffContEnclose)
	set spacing           $tech(contMinSpacing)
       } else {
	set termOffset        0.0
	set diffVertexY       $Width
	set diffVertexX       [expr { $leftTerm ? $tech(diffContBox)-$tech(diffContEnclose)+$p2cs
				:$tech(diffPolyEnclose) }]
	set ptDiffLowerY      $ptOriginY
	set ptDiffLowerX      [expr $ptOriginX - $diffVertexX]
	set lstSrcDrn         [list [starcMS90G_symMakePolygonListFromRect [list $ptDiffLowerX \
                              $ptDiffLowerY] [list $ptOriginX [expr $ptDiffLowerY + $Width]]]]
	set offset            $tech(diffContEnclose)
	set spacing           $spacing
    }	
	set lstReturnDiffLower [list $ptDiffLowerX $ptDiffLowerY]
	set lstStrapLower {0 0}
	set lstSrcStrapLower {0 0}

	if { $leftTerm } {
	    set lstSrcStrapLower [starcMS90G_symCreateMosContColumn $ptDiffLowerX $ptDiffLowerY \
		$offset $spacing $direction $numDiffCont 3 tech]
	    set lstStrapLower $lstSrcStrapLower
}
    for { set g 0 } { $g <= $folds } \
	{ incr g 1; set ptGatePolyLowerX [expr $ptGatePolyLowerX + $PolyPitch];\
	    set ptGateDiffLowerX [expr $ptGateDiffLowerX + $PolyPitch] } {
		
	if { $g % 2 == 0 } {
            set PolyPitch $PolyPitchD
            set PolyPitchOld $PolyPitchS
            set gateToContact $p2cd
            set contGateOffset $contGateOffsetDrn
	    set direction [expr {
			$keepOut ? 1 : $strapDrain
			}]
	    set lstSrcStrapUpper $lstStrapLower
	} else {
            set PolyPitch $PolyPitchS
            set PolyPitchOld $PolyPitchD
            set gateToContact $p2cs
            set contGateOffset $contGateOffsetSrc
	    set direction [expr {
			$keepOut ? -1 : int(-1*$strapSource)
			}]
	    set lstDrnStrapUpper $lstStrapLower
    	}

	# when dogbone is true And 0< g < folds
	if { $Dogbone } {
	    set ptDiffLowerX      [expr {
                                  $keys(mosDiffConcern) ?
                                      $ptGatePolyLowerX + $Length + $tech(polyDiffSpacing)
                                      : $ptGatePolyLowerX + $Length + $tech(polyDiffSpacing) + $contGateOffset
                                  }]

	    set ptDboneDiffLowerX [expr $ptGatePolyLowerX + $Length ]
	    set ptDboneDiffLowerY $ptOriginY
	    set ptDiffUpperX      [expr {
                                  $rightTerm ? 
                                      $ptDiffLowerX + $tech(diffContBox) + $keys(mosDiffConcern) * $contGateOffset
                                      : $ptDboneDiffLowerX +$tech(diffPolyEnclose)
                                  }]
	    set offset            [expr $tech(diffContEnclose) + $keys(mosDiffConcern) * $contGateOffset]
	    set lstTermPolygon    [starcMS90G_symMakePolygonListFromRect [list $ptDiffLowerX \
                                  $ptDiffLowerY] [list [expr $ptDiffLowerX + $tech(diffContBox) \
                                  + 2 * $keys(mosDiffConcern) * $contGateOffset] \
                                  [expr $ptDiffLowerY + $tech(diffContBox)]]]

	    # when dogbone is true And g = folds
	    if { $g !=$folds } {
		if {!$internalStrapping} {
		    set lstTermPolygon [list [list $ptDboneDiffLowerX $ptDboneDiffLowerX]\
				    [list $ptDboneDiffLowerY $ptDboneDiffLowerY]]
		}
		set lstExtraDbonePolygon [starcMS90G_symMakePolygonListFromRect [list $ptDboneDiffLowerX\
		    $ptDboneDiffLowerY] [list [expr $ptGateDiffLowerX+$PolyPitch] \
			[expr $ptOriginY + $Width]]]
	    } elseif { $rightTerm && $g==$folds } {
		set lstTermPolygon [list [list $ptDboneDiffLowerX $ptDboneDiffLowerX]\
				    [list $ptDboneDiffLowerY $ptDboneDiffLowerY]]
		set lstExtraDbonePolygon [starcMS90G_symMakePolygonListFromRect [list $ptDboneDiffLowerX\
		    $ptDboneDiffLowerY] [list [expr $ptDboneDiffLowerX+$tech(diffPolyEnclose)] \
			[expr $ptOriginY + $Width]]]
	    } else {
	        set lstTermPolygon    [starcMS90G_symMakePolygonListFromRect [list $ptDiffLowerX \
		    $ptDiffLowerY] [list [expr $ptDiffLowerX + $tech(diffContBox) \
                        + $keys(mosDiffConcern) * $contGateOffset] \
		            [expr $ptDiffLowerY + $tech(diffContBox)]]]
		set lstExtraDbonePolygon [starcMS90G_symMakePolygonListFromRect [list $ptDboneDiffLowerX\
		    $ptDboneDiffLowerY] [list [expr $ptDboneDiffLowerX+$tech(diffContBox)+$tech(polyDiffSpacing)] \
			[expr $ptOriginY + $Width]]]
	    }
	} else {
	    set diffRightVertexX   [expr {
				    $rightTerm ? 
					$tech(diffContBox)-$tech(diffContEnclose)+$gateToContact
					:$tech(diffPolyEnclose)
				    }]	
	    set ptDiffLowerX      [expr $ptGateDiffLowerX + $Length]
	    set ptDiffUpperX      [expr {
				  $g<$folds ?
				    $ptGateDiffLowerX+$PolyPitch
				    : $ptGateDiffLowerX + $Length + $diffRightVertexX
				  }]	
	    set offset            $gateToContact
	    set lstSrcDrn         [list [starcMS90G_symMakePolygonListFromRect [list $ptDiffLowerX \
				  $ptOriginY] [list $ptDiffUpperX \
			          [expr $ptOriginY + $Width]]]]
	}	
	if { ($g!=$folds && $internalStrapping) || ( $g==$folds && $rightTerm)  } {
	    set lstStrapLower [starcMS90G_symCreateMosContColumn $ptDiffLowerX $ptDiffLowerY \
		    $offset $spacing $direction $numDiffCont 3 tech]
	}    
    }
    if { $rightTerm } {
        if { $folds%2 ==0 } {
	    set lstDrnStrapUpper $lstStrapLower
        } else {
	    set lstSrcStrapUpper $lstStrapLower
        }    
    }
    set ptFinalDiffUpperY  [expr {
			    $Dogbone ?
				$ptDiffLowerY + $tech(diffContBox)
				: $ptDiffLowerY + $Width
			    }]
    set lstReturnDiffUpper [list $ptDiffUpperX $ptFinalDiffUpperY]
    set ptGatePolyLowerX [expr $ptGatePolyLowerX - $PolyPitch]
    return [list [list $lstReturnDiffLower $lstReturnDiffUpper] $spacing $ptGatePolyLowerX]
}

#Procedure to calculate the Pwell Area
proc starcMS90G_symMosCalcPwellArea { model grid dbu inst Length Width mosTapTop mosTapBottom mosTapRight mosTapLeft mosTapContacts \
                           p2cs p2cd tapSettings internalStrapping gateStrapPosition keepOut gateStrapLayer strapDrain \
			   strapSource folds sourceTerm drainTerm drawImplant tapIncrSpacing inst tech1 keys1 layer1} {

    upvar $tech1 tech
    upvar $keys1 keys
    upvar $layer1 layer
   
    global  ptOriginX ptOriginY buttedJunctionRt buttedJunctionLt
    
    
    # Convert to microns to deal with tech and keys values
    set Length                   [expr $Length*1e6]
    set Width                    [expr  $Width*1e6]
    set p2cs                     [expr  $p2cs*1e6]
    set p2cd                     [expr  $p2cd*1e6]
    set tapIncrSpacing           [expr  $tapIncrSpacing*1e6]
    set tech(diffContEnclose)    [expr [db::engToSci [starcMS90G_symGetParam diffContactEnclose $inst]]*1e6]
    set keys(polyDiffEndcap_std) [expr [db::engToSci [starcMS90G_symGetParam polyDiffEndcap $inst]]*1e6]
    set tech(polyContSpacing)    $keys(polyContSpacing_$model) 
    set tech(impGateEnclose)     $keys(impGateEnclose)
    set tech(gateMinSpacing)     $keys(gateMinSpacing)
    set tech(diffContBox)        [expr $tech(contMinWidth)+2*$tech(diffContEnclose)]
    set ptOriginX        0
    set ptOriginY        0
    set PolyPitch        0
    set PolyPitchS       0
    set PolyPitchD       0
    set NumConts         1
    set Dogbone          0
    set PtGatePolyLowerY 0
    set pushPolyUp       0
    set pushPolyDown     0
    set diffExcess       0
    set widthOffset      0
    set buttedJunctionRt 1
    set buttedJunctionLt 1
    set pushPoly         0

    # Convert booleans to integers
    if { $strapSource } {
        set strapSource 1
    } else {
        set strapSource 0
    }
    if { $strapDrain } {
        set strapDrain 1
    } else {
        set strapDrain 0
    }
   if { $sourceTerm } {
        set sourceTerm 1
    } else {
        set sourceTerm 0
    }
    if { $drainTerm } {
        set drainTerm 1
    } else {
        set drainTerm 0
    }

    for {set c 0} {$c < 4} {incr c} {
        set tapSettings [expr {
            [lindex $tapSettings $c] != "none" ? 
            [lindex $tapSettings $c] == "all" ? 
            [lreplace $tapSettings $c $c 2]
                : [lreplace $tapSettings $c $c 1]
                : [lreplace $tapSettings $c $c 0]
        }]
    }
    set params [starcMS90G_symMosPitch $grid $dbu $Width $Length $p2cs $p2cd $internalStrapping $inst $model tech keys]
    set PolyPitch  [lindex $params 0]
    set PolyPitchS [lindex $params 1]
    set PolyPitchD [lindex $params 2]
    set Dogbone    [lindex $params 3]
    set NumConts   [lindex $params 4]
    if { $Dogbone } {
        set widthOffset [expr double(($tech(diffContBox) - $Width)/2.0)]
   
        set widthOffset [starcMS90G_symCheckGridUpper $grid $dbu $widthOffset]
    }
    set polyExcess [expr $tech(polyContEnclose) - $tech(metal1ContEnclose)]
    if { ($gateStrapPosition == "top" || $gateStrapPosition == "both") \
           && $keepOut && $gateStrapLayer == "metal1" } {
	set strapDrain 1
	set drainTerm 1
	set sourceTerm 1
    }
    if { ($gateStrapPosition == "bottom" || $gateStrapPosition == "both") \
           && $keepOut && $gateStrapLayer == "metal1" } {
	set strapSource 1
	set sourceTerm 1
	set drainTerm 1
    }

    if { $gateStrapLayer == "metal1" } {
       if { ($gateStrapPosition =="top" || $gateStrapPosition =="both") && \
             ($internalStrapping == "ON" || ($folds%2 ==0 && $drainTerm == 1)) } {
	    set pushPolyUp 1
	} 
        if { ($gateStrapPosition =="bottom" || $gateStrapPosition =="both") || \
             ($internalStrapping == "OFF" && ($folds%2 !=0 && $sourceTerm == 1)) } {
	    set pushPolyDown 1
	} 
    }

    if { $NumConts!=1 } {
        set diffExcess    [expr ($Width - ($NumConts-1.0) * ($tech(contMinWidth)\
			      + $tech(contMinSpacing)) - $tech(diffContBox))/($NumConts-1.0)]
        set diffExcess    [expr {
                              $diffExcess < 0 ? 0.0 : $diffExcess
                           }]
    }
    set diffExcess        [starcMS90G_symCheckGrid $grid $dbu $diffExcess]
    set spacing           [expr $tech(contMinSpacing) + $diffExcess]
    set diffMetal1Extent [ starcMS90G_symCreateMosContColumn $ptOriginX [expr -1.0*$widthOffset]\
        $tech(diffContEnclose) $spacing 0 $NumConts 0 tech]
    set diffMetal1LowerY [lindex [lindex $diffMetal1Extent 0] 1]
    set diffMetal1UpperY [lindex [lindex $diffMetal1Extent 1] 1]

    set verticalPoly [ expr {
            $keys(polyDiffEndcap_std) > $Dogbone*$widthOffset +\
            $tech(polyDiffSpacing) + $tech(polyMinWidth) ?
                $keys(polyDiffEndcap_std)
                : $Dogbone*$widthOffset + $tech(polyDiffSpacing)
            }]
    set pushValUpper [expr {
	    $verticalPoly + $Width > $pushPolyUp * \
	    ($strapDrain*($diffMetal1UpperY+2*$tech(metal1Spacing) + $tech(metal1MinWidth) - $polyExcess)) ?
		$verticalPoly + $Width
		:$pushPolyUp * ($strapDrain * ($diffMetal1UpperY + 2*$tech(metal1Spacing) + $tech(metal1MinWidth) - $polyExcess))
		}]

    if { $gateStrapLayer == "none"  || $gateStrapPosition == "bottom" || ($gateStrapPosition == "none" && $gateStrapLayer != "none") ||\
         ($gateStrapLayer == "poly" && $folds == 0) } {
        set pushValUpper [expr $keys(polyDiffEndcap_std) + $Width]
    }
 
    set pushValLower [expr {
        -$verticalPoly < $pushPolyDown * \
	    ($strapSource*($diffMetal1LowerY-2*$tech(metal1Spacing) - $tech(metal1MinWidth) + $polyExcess)) ?
	-$verticalPoly
	:$pushPolyDown * ($strapSource * ($diffMetal1LowerY-2*$tech(metal1Spacing) - $tech(metal1MinWidth) + $polyExcess))
    }]
    if { $gateStrapLayer == "none"  || $gateStrapPosition == "top" || ($gateStrapPosition == "none" && $gateStrapLayer != "none") ||\
        ($gateStrapLayer == "poly" && $folds == 0) } {
        set pushValLower [expr -1.0*$keys(polyDiffEndcap_std)]
    }

    if { $gateStrapLayer == "poly" && $gateStrapPosition == "both" } { 
        set pushPoly [starcMS90G_symMosPolyHoleAreaAdj $pushValLower $pushValUpper $Length $PolyPitchS $PolyPitchD $grid $dbu keys]

    } 

    set ptGatePolyLowerX $ptOriginX
    set ptGatePolyUpperX [expr $ptGatePolyLowerX + $Length ]   
    set ptGatePolyLowerY [expr $ptOriginY + $pushValLower - $pushPoly]
    set ptGatePolyUpperY [expr $ptOriginY + $pushValUpper + $pushPoly]
    set lstProcReturn [starcMS90G_symMosCreateGateSrcDrn $Length $Width\
        $folds $PolyPitch $PolyPitchS $PolyPitchD $p2cs $p2cd $Dogbone $dbu $grid $keepOut \
        $strapSource $strapDrain $sourceTerm $drainTerm $internalStrapping $ptGatePolyLowerX \
        $ptGatePolyUpperX $ptGatePolyLowerY $ptGatePolyUpperY $spacing tech keys] 
    set lstDiffExtent [lindex $lstProcReturn 0]
    set lstDiffExtentOrig $lstDiffExtent
	
    # contSpacing : this value is contact spacing taking into account excess diff.
    set contSpacing [lindex $lstProcReturn 1]
    set ptFinalFingerLowerX [lindex $lstProcReturn 2]
    set ptStrapPolyLowerX $ptGatePolyLowerX
    set ptStrapPolyUpperX [expr $ptFinalFingerLowerX + $Length]
    set ptStrapPolyBottomUpperY $ptGatePolyLowerY
    set ptStrapPolyBottomLowerY [expr $ptStrapPolyBottomUpperY - $tech(polyMinWidth)]
    set ptStrapPolyTopLowerY $ptGatePolyUpperY
    set ptStrapPolyTopUpperY [expr $ptStrapPolyTopLowerY + $tech(polyMinWidth)]
    set polyLowHi [list $ptGatePolyLowerY $ptGatePolyUpperY]

    if { $gateStrapLayer == "poly" && $folds != 0 } {
        set polyLowHi [starcMS90G_symMosPolyStrap $Length $keepOut $strapSource $strapDrain \
            $Width $folds $gateStrapPosition $ptStrapPolyLowerX $ptStrapPolyUpperX $ptStrapPolyBottomUpperY\
	        $ptStrapPolyBottomLowerY $ptStrapPolyTopLowerY $ptStrapPolyTopUpperY tech]
    } elseif { $gateStrapLayer == "metal1" } {
        set polyLowHi [starcMS90G_symMosMetalStrap $dbu $grid $Length $folds $PolyPitchS $PolyPitchD \
	    $gateStrapPosition $ptGatePolyLowerX $ptGatePolyUpperY $ptGatePolyLowerY 0 tech]
    }

    # lstGateExtent: Rectangle whose coordinate is the Lower-left of leftmost gate and 
    # Upper-right of the rightmost gate.
    set lstGateExtent [list [list $ptOriginX $ptOriginY]\
        [list [expr $ptOriginX + $folds*$PolyPitch + $Length]\
	[expr $ptOriginY + $Width ]]]

    set layer(implant) $layer(nplus)
    set layer(tapImplant) $layer(pplus)    
    set impEnclose $tech(nplusDiffEnclose)
    set tapImpType "P"

    # lstImpExtent: coordinate array of the Implant Rectangle around MOS diffusion.
    set lstImpExtent $lstDiffExtent
    set lstImpExtent [starcMS90G_symMosDrawImplant $layer(implant) $lstDiffExtent $lstGateExtent \
        $polyLowHi $impEnclose $tech(impGateEnclose) $buttedJunctionLt $buttedJunctionRt 0 $drawImplant keys]

    set lstImpExtentOrig $lstImpExtent

    # extraSpacing      : this variable will account for drc spacing due to any Native 
    #                     or higher voltage diffusions and butted junctions contacts etc.
    # activeTermSpacing : this variable is to account for any implant based diffusion 
    #                     spacing (boolean AND)
    # mosCreateTap      : Procedure to create TAPs . For detail see Support file.
    set extraSpacing $tapIncrSpacing
    set increment [expr $impEnclose + $tapIncrSpacing]
    set lstImpExtent [starcMS90G_symResizeRect $lstImpExtent $increment $increment]

    # This is to calculate the min nwell hole inner edge distance from imp.
    if { $mosTapContacts > 1 } {
        set tech(contMinSpacing) $keys(contArrayMinSpacing)
    }	
    set diffNwellRingSpacing [expr { $model == "NDN25" ? $keys(HVDiffEnclose) : $tech(nwellDiffSpacing) }] 
    set lstNWinner [starcMS90G_symMosCalcNwellHoleImpDist $lstImpExtentOrig $lstDiffExtentOrig $tapSettings \
        $tapIncrSpacing $mosTapContacts $diffNwellRingSpacing $dbu $grid tech keys]
    set lengthDiode [expr  [lindex [lindex $lstNWinner 1] 0] - [lindex [lindex $lstNWinner 0] 0] ]
    set widthDiode [expr [lindex [lindex $lstNWinner 1] 1] - [lindex [lindex $lstNWinner 0] 1] ]
    set area [expr $lengthDiode * $widthDiode]
    return $area

}

################################ Procedures for MOSFETs ###############################################

# Procedure to control the tapSpacing based on tapOptions.
proc starcMS90G_symMosTapSpaCntrl { top bot lt rt} {
    set inst [db::getCurrentRef]
    if {[starcMS90G_symIsSchematic] || [starcMS90G_symIsIvpcell]} {return 0} 
    if {[starcMS90G_symIsLayout]} {
        set vTop [db::getParamValue $top -of $inst]
        set vBot [db::getParamValue $bot -of $inst]
        set vLt  [db::getParamValue $lt -of  $inst]
        set vRt  [db::getParamValue $rt -of  $inst]
        if { $vTop == "none" && $vBot == "none" && $vLt == "none" && $vRt == "none" } {return 0} else {return 1}
    }
}

# Procedure to control the tapContacts based on tapOptions.
proc starcMS90G_symMosTapContCntrl { top bot lt rt} {
    set inst [db::getCurrentRef]	
    if { [starcMS90G_symIsSchematic] || [starcMS90G_symIsIvpcell] } {return 0}
    if { [starcMS90G_symIsLayout] } {
        set vTop [db::getParamValue $top -of $inst]
        set vBot [db::getParamValue $bot -of $inst]
        set vLt  [db::getParamValue $lt -of  $inst]
        set vRt  [db::getParamValue $rt -of  $inst]
	if { ($vTop == "all" || $vBot == "all" || $vLt == "all" || $vRt == "all" ) } {return 1} else {return 0}
    }
}

# Procedure to control the buttedTap display based on tap options
proc starcMS90G_symMosButtedCntrl { tapStruct lt rt} {
    set inst [db::getCurrentRef]	
    if { [starcMS90G_symIsSchematic] ||  [starcMS90G_symIsIvpcell] } {return 0}
    if { [starcMS90G_symIsLayout] } {
        set tap [db::getParamValue $tapStruct -of $inst]
        if { $tap == "ring" } {
            starcMS90G_symSetParam buttedTap 0 $inst
	    return 0
	} else {
            set r [db::getParamValue $rt  -of $inst] 
            set l [db::getParamValue $lt  -of $inst] 
            if {$l == "none" && $r == "none"} {return 0} else {return 1}
        }
    }
}

# Procedure to control the src/drn Strapping options based on internal strapping
proc starcMS90G_symMosOptDFM { opt} {
    set inst [db::getCurrentRef]	
    set option   [db::getParamValue $opt -of $inst]
    if { $option == "Custom" } {return 1} else {return 0}
}

# Procedure to control the src/drn Strapping options based on internal strapping
proc starcMS90G_symMosStrapCntrl { strap fing} {
    set inst [db::getCurrentRef]	
    set intStrap [db::getParamValue $strap -of $inst]
    set NF [db::getParamValue $fing -of $inst]
    if { [starcMS90G_symIsSchematic] || [starcMS90G_symIsIvpcell] } {return 0}
    if { [starcMS90G_symIsLayout] } {
        if {$NF == 1 } { return 0 }
        if {$NF > 1} {
            if {$intStrap} {return 1} else { return 0}
        }    
    }
} 

# Procedure to control gateStrapLayer option based on gateStrapPosition
proc starcMS90G_symMosStrapGate { post} {
    set inst [db::getCurrentRef]	
    set position [db::getParamValue $post -of $inst]
    if { [starcMS90G_symIsSchematic]} {return 0}
    if { [starcMS90G_symIsLayout] } {
        if {$position == "none" } { return 0 } else { return 1}
    }
}
# Procedure to control the internal Strapping options based on # fingers
proc starcMS90G_symMosIntStrap { fing} {
    set inst [db::getCurrentRef]	
    set NF [db::getParamValue $fing -of $inst]
    if { [starcMS90G_symIsSchematic] || [starcMS90G_symIsIvpcell]} {return 0}
    if { [starcMS90G_symIsLayout] } {
        if {$NF == 1} { return 0 } else { return 1}
    }
}

# Procedure to control the Source/Drain terminal options based on keep out
proc starcMS90G_symMostermCntrl { KEEPOUT} {
    set inst [db::getCurrentRef]	
    set KO [db::getParamValue $KEEPOUT -of $inst]
    if {$KO} {
        starcMS90G_symSetParam sourceTerm 1 $inst 
        starcMS90G_symSetParam drainTerm 1 $inst 
	return 0
    } else { return 1}	
}
# Procedure to control the buttedTapMetal display based on tap options
proc starcMS90G_symMosButtedMetalCntrl { buttedT} {
    set inst [db::getCurrentRef]
    if { [starcMS90G_symIsSchematic] ||  [starcMS90G_symIsIvpcell] } {return 0}
    if { [starcMS90G_symIsLayout] } {
        set bt [db::getParamValue $buttedT -of $inst]
        if { $bt == 0 } {return 0} else {return 1}
    }
}


################################ Procedures for DNWELL MOSFETs ###############################################
# Procedure to control the src/drn Strapping options based on internal strapping
proc starcMS90G_symDnwStrapCntrl { strap fing} {
    set inst [db::getCurrentRef]	
    set intStrap [db::getParamValue $strap -of $inst]
    set NF [db::getParamValue $fing -of $inst]
    if {$NF == 1 } { return 0 }
    if {$NF > 1} {
        if {$intStrap} {return 1} else { return 0}
    }    
}

# Procedure to control the internal Strapping options based on # fingers
proc starcMS90G_symDnwIntStrap { fing} {
    set inst [db::getCurrentRef]	
    set NF [db::getParamValue $fing -of $inst]
    if {$NF == 1} { return 0 } else { return 1}
}

# Procedure to control gateStrapLayer option based on gateStrapPosition
proc starcMS90G_symDnwStrapGate { post} {
    set inst [db::getCurrentRef]	
    set position [db::getParamValue $post -of $inst]
    if {$position == "none" } { return 0 } else { return 1}
}

# Procedure to control the tapSpacing based on tapOptions.
proc starcMS90G_symDnwTapSpaCntrl { top bot lt rt} {
    if {[starcMS90G_symIsSchematic]} {return 0}
    set inst [db::getCurrentRef]	
    set vTop [db::getParamValue $top -of $inst]
    set vBot [db::getParamValue $bot -of $inst]
    set vLt  [db::getParamValue $lt -of  $inst]
    set vRt  [db::getParamValue $rt -of  $inst]
    if { $vTop == "none" && $vBot == "none" && $vLt == "none" && $vRt == "none" } {return 0} else {return 1}
}

# Procedure to control the tapContacts based on tapOptions.
proc starcMS90G_symDnwTapContCntrl {controlParam top bot lt rt} {
    if {[starcMS90G_symIsSchematic]} {return 0}
    set inst [db::getCurrentRef]	
    set vTop [db::getParamValue $top -of $inst]
    set vBot [db::getParamValue $bot -of $inst]
    set vLt  [db::getParamValue $lt -of  $inst]
    set vRt  [db::getParamValue $rt -of  $inst]
    if { ($vTop != "all" && $vBot != "all" && $vLt != "all" && $vRt != "all" ) } {
	db::setParamValue $controlParam -value 1 -of $inst
    }
    if { ($vTop == "all" || $vBot == "all" || $vLt == "all" || $vRt == "all" ) } {return 1} else {return 0}
}

################################ Procedures for INVERTER ###############################################
# Procedure to control the buttedTap based on tapOptions.
proc starcMS90G_symInvBut { lt rt } {
    set inst [db::getCurrentRef]	
    if { [starcMS90G_symIsSchematic]} {return 0}
    if { [starcMS90G_symIsLayout] } {
        set vLt  [db::getParamValue $lt -of  $inst]
        set vRt  [db::getParamValue $rt -of  $inst]
	if { $vLt==1 || $vRt==1 } {return 1} else {return 0}
    }
}

############################### Procedures from MosSupport.tcl #######################################

proc starcMS90G_symMosCalcNwellHoleImpDist {lstImpExtentOrig lstDiffExtentOrig tapSettings tapIncrSpacing tapContacts diffNwellRingSpacing dbu grid tech1 keys1 }  {

    #global tech layer keys 
    upvar $tech1 tech
    upvar $keys1 keys
    
    set botx [lindex [lindex $lstImpExtentOrig 0] 0]
    set boty [lindex [lindex $lstImpExtentOrig 0] 1]
    set topx [lindex [lindex $lstImpExtentOrig 1] 0]
    set topy [lindex [lindex $lstImpExtentOrig 1] 1]
    if { [expr $topx - $botx + 2*$keys(nwellInnerImpSpacing)] < $keys(nwellHoleMinWidth) }  {
        set nwInnerBotx [expr $botx - ($keys(nwellHoleMinWidth) - $topx + $botx - \
            2*$keys(nwellInnerImpSpacing))/2 - $keys(nwellInnerImpSpacing)] 
	set nwInnerTopx [expr $topx + ($keys(nwellHoleMinWidth) - $topx + $botx - \
            2*$keys(nwellInnerImpSpacing))/2 + $keys(nwellInnerImpSpacing)]
	} else {
	set nwInnerBotx [expr $botx - $keys(nwellInnerImpSpacing)] 
        set nwInnerTopx [expr $topx + $keys(nwellInnerImpSpacing)] 
	}

        set nwInnerTopx [starcMS90G_symCheckGridUpper $grid $dbu $nwInnerTopx]
        set nwInnerBotx [starcMS90G_symCheckGrid      $grid $dbu $nwInnerBotx]


    if  { [expr [lindex [lindex $lstDiffExtentOrig 0] 0] - $nwInnerBotx ] <  $diffNwellRingSpacing }  {
        set nwInnerBotx [expr $nwInnerBotx - [expr $diffNwellRingSpacing - [expr [lindex \
        [lindex $lstDiffExtentOrig 0] 0] - $nwInnerBotx ]]]          
        } 

    if  { [expr $nwInnerTopx - [lindex [lindex $lstDiffExtentOrig 1] 0] ] <  $diffNwellRingSpacing }  {
        set nwInnerTopx [expr $nwInnerTopx + [expr $diffNwellRingSpacing - [expr $nwInnerTopx - [lindex \
        [lindex $lstDiffExtentOrig 1] 0]]]]          
        } 


    if { [expr $topy - $boty + 2*$keys(nwellInnerImpSpacing)] < $keys(nwellHoleMinWidth) }  {
        set nwInnerBoty [expr $boty - ($keys(nwellHoleMinWidth) - $topy + $boty - \
           2*$keys(nwellInnerImpSpacing))/2 - $keys(nwellInnerImpSpacing)] 
	set nwInnerTopy [expr $topy + ($keys(nwellHoleMinWidth) - $topy + $boty - \
           2*$keys(nwellInnerImpSpacing))/2 + $keys(nwellInnerImpSpacing)]
	} else {
	set nwInnerBoty [expr $boty - $keys(nwellInnerImpSpacing)] 
        set nwInnerTopy [expr $topy + $keys(nwellInnerImpSpacing)] 
	}
	
	
	set nwInnerTopy [starcMS90G_symCheckGridUpper $grid $dbu $nwInnerTopy]
        set nwInnerTopy [starcMS90G_symCheckGrid      $grid $dbu $nwInnerTopy]
	
    if  { [expr [lindex [lindex $lstDiffExtentOrig 0] 1] - $nwInnerBoty ] <  $diffNwellRingSpacing }  {
        set nwInnerBoty [expr $nwInnerBoty - [expr $diffNwellRingSpacing - [expr [lindex \
        [lindex $lstDiffExtentOrig 0] 1] - $nwInnerBoty ]]]          
        } 

    if  { [expr $nwInnerTopy - [lindex [lindex $lstDiffExtentOrig 1] 1] ] <  $diffNwellRingSpacing }  {
        set nwInnerTopy [expr $nwInnerTopy + [expr $diffNwellRingSpacing - [expr $nwInnerTopy - [lindex \
        [lindex $lstDiffExtentOrig 1] 1]]]]          
        } 
	
    set lstNWinner [starcMS90G_symMakeRectList $nwInnerBotx $nwInnerBoty $nwInnerTopx $nwInnerTopy]
    
    if { $tapSettings != "0 0 0 0" } { 
    set pushOutNWinner [expr $tech(pplusDiffEnclose) + [expr $tapContacts * $tech(contMinWidth)] + \
              2*$tech(diffContEnclose) + $diffNwellRingSpacing + $tapIncrSpacing + \
              [expr ($tapContacts - 1) * $tech(contMinSpacing)]]
    set lstNWinner [starcMS90G_symResizeRect $lstImpExtentOrig $pushOutNWinner $pushOutNWinner  ]
    }	 
	
    return $lstNWinner

}

proc starcMS90G_symMosPolyHoleAreaAdj {pushValLower pushValUpper Length PolyPitchS PolyPitchD grid dbu keys1} {
    upvar $keys1 keys

    set holeAreaS [expr ($PolyPitchS - $Length) * (-$pushValLower + $pushValUpper)] 	
    set holeAreaD [expr ($PolyPitchD - $Length) * (-$pushValLower + $pushValUpper)]
    set halfPushNeeded 0 

    if {$holeAreaS < $keys(minPolyHoleArea) } { 
    	set areaDiff [expr $keys(minPolyHoleArea) - $holeAreaS]  	
	set pushNeeded [expr $areaDiff/($PolyPitchS - $Length)]
        set halfPushNeeded [expr $pushNeeded / 2]
        set halfPushNeeded [expr round(double($halfPushNeeded)*($dbu/$grid)) * ($grid/$dbu) ]
    } elseif {$holeAreaD < $keys(minPolyHoleArea) } {      
        set areaDiff [expr $keys(minPolyHoleArea) - $holeAreaD]  	
        set pushNeeded [expr $areaDiff/($PolyPitchD - $Length)]
        set halfPushNeeded [expr $pushNeeded / 2]
        set halfPushNeeded [expr round(double($halfPushNeeded)*($dbu/$grid)) * ($grid/$dbu) ]
    }
    return $halfPushNeeded
}


############################### Procedures from PcellSupport.tcl #######################################

###################################################################################
# celCheckGridUpper is a procedure used to round to the nearest higher on Grid Value
#             
# Inputs:
# ---------
# grid    : grod size.
# dbu     : DataBase unit
# value   : value which is to be made as a grid value
# 
# Output:
# ---------
# Returns the value on grid 
#
##################################################################################

proc starcMS90G_symCheckGridUpper { grid dbu value } {
    return [expr double(ceil($value*$dbu/$grid)*$grid/$dbu)]
}

###################################################################################
# celCheckGrid is a procedure used to round to the nearest on Grid Value
#             
# Inputs:
# ---------
# grid    : grod size.
# dbu     : DataBase unit
# value   : value which is to be made as a grid value
# 
# Output:
# ---------
# Returns the value on grid 
#
##################################################################################

proc starcMS90G_symCheckGrid { grid dbu value } {
    return [expr double(floor($value*double($dbu)/$grid)*$grid/double($dbu))]
}

###################################################################################
# celResizeRectUnsymmetric is a procedure used to re-size the Rectangle Unsymmetrically
#             
# Inputs:
# ---------
# coord : Rectangle co-ordinates.
# resizeX1 : resizing factor on X-coordinate of lower left point
# resizeX2 : resizing factor on X-coordinate of upper right point
# resizeY1 : resizing factor on Y-coordinate of lower left point
# resizeY2 : resizing factor on Y-coordinate of upper right point
#
# Output:
# ---------
# Returns resized rectangle 
#
##################################################################################


proc starcMS90G_symResizeRectUnsymmetric { coord resizeX1 resizeY1 resizeX2 resizeY2 } {

    set lowerX [expr [lindex [lindex $coord 0] 0] - $resizeX1]
    set lowerY [expr [lindex [lindex $coord 0] 1] - $resizeY1]
    set UpperX [expr [lindex [lindex $coord 1] 0] + $resizeX2]
    set UpperY [expr [lindex [lindex $coord 1] 1] + $resizeY2]

    return [list [list $lowerX $lowerY] [list $UpperX $UpperY]]
}

###################################################################################
# celBreakRect is a procedure used to return a point from Rectangle co-ordinates
#             
# Inputs:
# ---------
# point : specifies point required: lx - lower X-Coordinate
#                                   ly - lower Y-Coordinate
#                                   ux - upper X-Coordinate
#                                   uy - upper Y-Coordinate
# coord : Rectangle co-ordinates.
# 
# Output:
# ---------
# Returns Point specified by point variable 
#
###################################################################################

proc starcMS90G_symBreakRect { coord point } {

    set lowerX [lindex [lindex $coord 0] 0]
    set lowerY [lindex [lindex $coord 0] 1]
    set UpperX [lindex [lindex $coord 1] 0]
    set UpperY [lindex [lindex $coord 1] 1]
    switch $point {
        "lx" {
                 return $lowerX
             }
        "ly" {
                 return $lowerY
             }
        "ux" {
                 return $UpperX
             }
        "uy" {
                 return $UpperY
             }
    }
}


###################################################################################
# starcMS90G_symMakeRectList is a procedure used to make list of list of four points given
#             
# Inputs:
# ---------
# x1 y1 x2 y2 : Four co-ordinates of Two points
#
# Output:
# ---------
# Returns the List of list of points 
#
###################################################################################


proc starcMS90G_symMakeRectList { x1 y1 x2 y2 } {
  return [list [list $x1 $y1] [list $x2 $y2]]
}

###################################################################################
# celResizeRect is a procedure used to re-size the Rectangle by a factor
#             
# Inputs:
# ---------
# coord : Rectangle co-ordinates.
# resizeX : resizing factor on X-coordinate
# resizeY : resizing factor on Y-coordinate
# 
# Output:
# ---------
# Returns resized rectangle 
#
###################################################################################

proc starcMS90G_symResizeRect { coord resizeX resizeY } {

    set lowerX [expr [lindex [lindex $coord 0] 0] - $resizeX]
    set lowerY [expr [lindex [lindex $coord 0] 1] - $resizeY]
    set UpperX [expr [lindex [lindex $coord 1] 0] + $resizeX]
    set UpperY [expr [lindex [lindex $coord 1] 1] + $resizeY]

    return [list [list $lowerX $lowerY] [list $UpperX $UpperY]]
}


proc starcMS90G_symGetNumPolyConts { width tech1 } {
    
    upvar $tech1 tech
    if { $width < [expr 2.0*$tech(polyContEnclose) + $tech(contMinWidth)] } {
	return 1
    } else {
        return [expr double($width - 2.0*$tech(polyContEnclose) + \
		$tech(contMinSpacing)) / ($tech(contMinWidth) + \
		$tech(contMinSpacing))]
    }
}

###################################################################################
# starcMS90G_symMakeRectList is a procedure used to make list of list of four points given
#             
# Inputs:
# ---------
# x1 y1 x2 y2 : Four co-ordinates of Two points
#
# Output:
# ---------
# Returns the List of list of points 
#
###################################################################################


proc starcMS90G_symMakeRectList { x1 y1 x2 y2 } {
  return [list [list $x1 $y1] [list $x2 $y2]]
}


proc starcMS90G_symGetNumDiffConts { width tech1} {
    upvar $tech1 tech
    if { $width < [expr 2.0*$tech(diffContEnclose) + $tech(contMinWidth)] } {
	return 1
    } else {
    return [expr floor(($width + (-2.0*$tech(diffContEnclose)) + \
	    $tech(contMinSpacing)) / ($tech(contMinWidth) + \
	    $tech(contMinSpacing)))]
    }
}

###################################################################################
# makePloygonList is a procedure used to make list containing polygon co-ordinates
#             
# Inputs:
# ---------
# addClose : If value is "1" , the polygon list contains the first co-ordinate repea
#
# Output:
# ---------
# Returns the polygon list 
#
###################################################################################

proc starcMS90G_symMakePolygonList { addClose args } {

    foreach point $args {
	lappend polygon $point
    }
    if { $addClose } {
	lappend polygon [lindex $polygon 0]
    }
    return $polygon
}

###################################################################################
# makePloygonListFromRect is a procedure used to make a polygon list from Rectangle co-ordinates
#             
# Inputs:
# ---------
# lowerLeft : Lower left co-ordinate of Rectangle
# upperRight: Upper Right co-ordinate of Rectangle
#
# Output:
# ---------
# Returns the polygon list 
#
###################################################################################


proc starcMS90G_symMakePolygonListFromRect { lowerLeft upperRight } {
    set x1 [lindex $lowerLeft 0]
    set y1 [lindex $lowerLeft 1]
    set x2 [lindex $upperRight 0]
    set y2 [lindex $upperRight 1]

    return [starcMS90G_symMakePolygonList true [list $x1 $y1] [list $x2 $y1] \
	                         [list $x2 $y2] [list $x1 $y2]]
}


###################################################################################
# celRoundGridCheckup is a procedure used to round to the nearest on Grid Value
#             
# Inputs:
# ---------
# grid    : grod size.
# dbu     : DataBase unit
# value   : value which is to be made as a grid value
# 
# Output:
# ---------
# Returns the value on grid 
#
##################################################################################

proc starcMS90G_symRoundGridCheckup { grid dbu value } {
    set adjustedValue [expr double($value)*double($dbu)/$grid]
    if { [expr fmod($adjustedValue,1)] != 0} {
        set onGridValue [expr round(double($value)*(double($dbu)/$grid)) * $grid/double($dbu) ]
    } else {
        set onGridValue $value
    }
    return $onGridValue
}



#########################################################################
# lvsSPICEnetlister.tcl
# This file creates the LVSSpice netlist of the schematic. 
# usage  : 
# starcMS90G_netlist [starcMS90G_lcv <libName> <cellname> <viewName>] lvsSPICE

proc starcMS90G_get_netlister {name} {
    set nl [nl::getNetlisters $name]
    return [db::getNext $nl]
}

proc starcMS90G_netlist {cv nlName {vsl "schematic symbol"} {outDir ./}} {
    set nl [starcMS90G_get_netlister $nlName]
    nl::runNetlister $nl -cellView $cv -viewSearchList $vsl \
        -filePath "$outDir/lvsSPICE.output"
}

proc starcMS90G_lcv {lib cell view} {
    append lib ""
    append cell ""
    append view ""
    return [dm::findCellView $view -cellName $cell -libName $lib]
}
################## End Custom Netlister################ 


############## nettran unit metric defined###############
proc starcMS90G_begin {nl} {
    nl::spiceNetlistBegin $nl
    nl::append "\n*.LENGTH_UNIT R S\n" -netlister $nl
    #nl::append "\n*.AREA_UNIT A\n" -netlister $nl
    #nl::append "\n*.NON_UNIT nr m\n" -netlister $nl
}

proc starcMS90G_createNameMap {nl} {
    return [nl::createNameMap]
}

set nl [db::getNext [nl::getNetlisters lvsSPICE]]

db::setAttr netlistBeginProc -of $nl -value starcMS90G_begin
db::setAttr nameMapProc -of $nl -value starcMS90G_createNameMap

############ End Nettran corrections ##################
