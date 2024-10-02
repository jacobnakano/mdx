
proc ics_getLCSVersion {} {
 return "2.0"
}
proc ics_callback {paramName} {

    set cdfInstID [db::getCurrentRef]
    if { $cdfInstID != "" }   {
	ics_callbackMain $cdfInstID $paramName
        ics_copyCdfgData $cdfInstID
    } else {
      puts "ERROR: Call to fetch Instance CDF data returned NIL"
      return
    }

}

proc ics_callbackMain {instID paramName } {


    set cellName [db::getAttr cellName -of $instID]
    switch $cellName {
	"CM123" {
	    starcMS90G_CM123_CB $instID $paramName
	}
	"NENHT33" {
	    starcMS90G_MOS_CB $instID $paramName
	}
	"NPNV050" {
	    starcMS90G_NPNV050_CB $instID $paramName
	}
	"PENHT33" {
	    starcMS90G_MOS_CB $instID $paramName
	}
	"RPOLYP" {
	    starcMS90G_POLYRES_CB $instID $paramName
	}
	"RSPOLYP" {
	    starcMS90G_POLYRES_CB $instID $paramName
	}
	"NENHHP" {
	    starcMS90G_MOS_CB $instID $paramName
	}
	"PENHHP" {
	    starcMS90G_MOS_CB $instID $paramName
	}
	"PNPV050" {
	    starcMS90G_PNPV050_CB $instID $paramName
	}
    }
}



