proc  ansCdlCompPrim  { nl inst master instNamePrefix params {parent {}}} {
    if { $parent == "" } {
	set parent [db::getAttr currentContext -of $nl]
        }

    set comp_name [nl::internal::findSimInfoParamValue "componentName" $nl $master]
    if { $comp_name != "" } {
	switch $comp_name {
	    "nmos" {
		nlPrintauCdlMOSFET  $nl $inst $master $instNamePrefix $params $parent 
	    }

	    "pmos" {
		nlPrintauCdlMOSFET  $nl $inst $master $instNamePrefix $params $parent 
	    }
	    "res" {
		 nlPrintauCdlPrimDevice  $nl $inst $master $instNamePrefix $params $parent 
	    }

	    "cap" {
		 nlPrintauCdlPrimDevice  $nl $inst $master $instNamePrefix $params $parent 
	    }
	    "npn" {
		starcMS90G_PrintauCdlBJT  $nl $inst $master $instNamePrefix $params $parent 
	    }
	    "pnp" {
		starcMS90G_PrintauCdlBJT  $nl $inst $master $instNamePrefix $params $parent 
	    }
	}
    }
}

proc starcMS90G_PrintauCdlBJT { nl inst master instNamePrefix params {parent {}}} {
        if { $parent == "" } {
                set parent [db::getAttr currentContext -of $nl]
        }
        nl::HSPICE::utils::printSpiceInstName $nl $master $inst $instNamePrefix $parent
        nl::internal::printauCdlNInstTerms $nl $master $inst $parent 3
        nl::internal::printCDLModelName $nl $master $inst $parent $instNamePrefix
        printBJTSpiceParams $nl $master $inst $parent $params "" 1
        nl::internal::printauCdlOtherParams $nl $master $inst $parent 
        nl::internal::printauCdlSubstrat $nl $parent $inst $master 4 
        nl::append "\n" -netlister $nl -wrap false
}
proc printBJTSpiceParams {nl master inst parent \
                {params {}} {subParams {}}  {writedefaults 0} } {
        set ni [db::getAttr netlistInfo -of $nl]
        set pmap [nl::findParamMap -netlistInfo $ni -master $master]
        if { $params == "" } {
                set params [nl::getParamNames -netlister $nl \
                                        -master $master]
        }
        if { $parent == "" } {
                set parent [db::getAttr currentContext -of $nl]
        }
        foreach param $params {
                set use [nl::HSPICE::utils::checkSpiceUseFlag $param $inst $pmap $master $nl $parent]
                if { $use && ![nl::internal::spiceIsSpecialParam $param $subParams]} {
                        nl::internal::printCommentParam $param $nl $master $pmap $inst $parent \
                                $writedefaults 1 1
                }
        }
}
