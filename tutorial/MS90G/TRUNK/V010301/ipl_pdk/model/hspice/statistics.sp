* Create Stimulus File.

*.param mcm_NENHT33_vth0 = agauss(0,10.6666666666667e-9,1)
*.param mcm_NENHT33_u0 = agauss(0,1.43333333333333e-8,1)
*.param mcm_PENHT33_vth0 = agauss(0,7.33333333333333e-9,1)
*.param mcm_PENHT33_u0 = agauss(0,1.2e-8,1)            
*.param mcm_NPNV050_is = agauss(0,7.64e-8,1)
*.param mcm_CM123_c = agauss(0,0.133333333333333e-2,1)
*.param mcm_RPOLYP_r = agauss(0,0.933333333333333e-8,1)
*.param mcm_RSPOLYP_r = agauss(0,1.56666666666667e-8,1)

.param RPOLYP_r = 1
.param RSPOLYP_r = 1
.param CM123_c = 1

.variation 
.local_variation
 subckt RSPOLYP_S mcm_RSPOLYP_r = 1.56666666666667e-8
 subckt RPOLYP_S mcm_RPOLYP_r = 0.933333333333333e-8
 subckt CM123_S mcm_CM123_c = 0.133333333333333e-2
 subckt NPNV050_S mcm_NPNV050_is = 7.64e-8
 subckt PNPV050_S mcm_PNPV050_is = 0.436666666666667e-8
 subckt NENHT33_S mcm_NENHT33_vth0 = 10.6666666666667e-9
 subckt NENHT33_S mcm_NENHT33_u0 = 1.43333333333333e-8
 subckt PENHT33_S mcm_PENHT33_vth0 = 7.33333333333333e-9
 subckt PENHT33_S mcm_PENHT33_u0 = 1.2e-8
 subckt NENHHP_S mcm_NENHHP_vth0 = 4e-9
 subckt NENHHP_S mcm_NENHHP_u0 = 3.24333333333333e-8
 subckt PENHHP_S mcm_PENHHP_vth0 = 4.3e-9
 subckt PENHHP_S mcm_PENHHP_u0 = 3.06e-8
.end_local_variation
.end_variation
