let((libPath)

	libPath = ddGetObjReadPath(ddGetObj("MS90G"))

	load(strcat(libPath "/.pdkinfo/callback/CM123.ile"))
	load(strcat(libPath "/.pdkinfo/callback/MS90G.ile"))
	load(strcat(libPath "/.pdkinfo/callback/NENHT33.ile"))
	load(strcat(libPath "/.pdkinfo/callback/NENHHP.ile"))
	load(strcat(libPath "/.pdkinfo/callback/NPNV050.ile"))
	load(strcat(libPath "/.pdkinfo/callback/PENHT33.ile"))
	load(strcat(libPath "/.pdkinfo/callback/PENHHP.ile"))
	load(strcat(libPath "/.pdkinfo/callback/PNPV050.ile"))
	load(strcat(libPath "/.pdkinfo/callback/RPOLYP.ile"))
	load(strcat(libPath "/.pdkinfo/callback/RSPOLYP.ile"))

) ; let

