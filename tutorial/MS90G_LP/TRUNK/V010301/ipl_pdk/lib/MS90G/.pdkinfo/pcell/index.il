let((libPath)

	libPath = ddGetObjReadPath(ddGetObj("MS90G"))

	load(strcat(libPath "/.pdkinfo/pcell/CIL33.ile"))
	load(strcat(libPath "/.pdkinfo/pcell/CM123.ile"))
	load(strcat(libPath "/.pdkinfo/pcell/NENHHP.ile"))
	load(strcat(libPath "/.pdkinfo/pcell/NENHT33.ile"))
	load(strcat(libPath "/.pdkinfo/pcell/PENHHP.ile"))
	load(strcat(libPath "/.pdkinfo/pcell/PENHT33.ile"))
	load(strcat(libPath "/.pdkinfo/pcell/RPOLYP.ile"))
	load(strcat(libPath "/.pdkinfo/pcell/RSPOLYP.ile"))
	load(strcat(libPath "/.pdkinfo/pcell/abutFunction.ile"))

) ; let

