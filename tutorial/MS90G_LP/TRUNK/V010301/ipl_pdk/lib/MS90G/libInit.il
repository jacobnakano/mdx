let((libPath)

	libName = "MS90G"
	libPath = ddGetObjReadPath(ddGetObj("MS90G"))

	load(strcat(libPath "/.pdkinfo/nucleus.ile"))
	load(strcat(libPath "/.pdkinfo/pcell/index.il"))
	load(strcat(libPath "/.pdkinfo/callback/index.il"))


    ; when(  fboundp(`drLoadDrf)
        when( ddObj = ddGetObj(libName nil nil "display.drf")
            printf("\tLoading %s/%s ... " libName ddObj~>name)
            if( errset(drLoadDrf(ddGetObjReadPath(ddObj) nil))
            then printf("done!\n")
            else printf("failed!\n")
            ); if errset
        ) ; ** when ddObj **
    ; ) ; ** when fboundp **


;; for Circuit Prospector
	when(isCallable('ciRegisterDevice)
		ciRegisterDevice("fet"
			append(ciGetDeviceNames("fet")
				'('("MS90G" "NENHT33" nil)
					'("MS90G" "NENHHP" nil)
					'("MS90G" "PENHT33" nil)
					'("MS90G" "PENHHP" nil))))
		ciRegisterDevice("nfet"
			append(ciGetDeviceNames("nfet")
				'('("MS90G" "NENHT33" nil)
					'("MS90G" "NENHHP" nil))))
		ciRegisterDevice("pfet"
			append(ciGetDeviceNames("pfet")
				'('("MS90G" "PENHT33" nil)
					'("MS90G" "PENHHP" nil))))
		ciRegisterDevice("bjt"
			append(ciGetDeviceNames("bjt")
				'('("MS90G" "NPNV050" nil)
					'("MS90G" "PNPV050" nil))))
		ciRegisterDevice("passive"
			append(ciGetDeviceNames("passive")
				'('("MS90G" "CM123" nil)
					'("MS90G" "RPOLYP" nil)
					'("MS90G" "RSPOLYP" nil))))
	) ; when
	when(isCallable('ciMapParam)
		ciMapParam("width" append(ciGetParamMapping("width") '("w")))
		ciMapParam("length" append(ciGetParamMapping("length") '("l")))
		ciMapParam("fingerCount" append(ciGetParamMapping("fingerCount") '("fingers")))
		ciMapParam("fingerWidth" append(ciGetParamMapping("fingerWidth") '("wpf")))
		ciMapParam("mFactor" append(ciGetParamMapping("mFactor") '("m")))
	) ; when
	when(isCallable('ciMapTerm)
		ciMapTerm("gate" append(ciGetTermNames("gate") '("G")))
		ciMapTerm("source" append(ciGetTermNames("source") '("S")))
		ciMapTerm("drain" append(ciGetTermNames("drain") '("D")))
		ciMapTerm("bulk" append(ciGetTermNames("bulk") '("B")))
	) ; when

) ; let

