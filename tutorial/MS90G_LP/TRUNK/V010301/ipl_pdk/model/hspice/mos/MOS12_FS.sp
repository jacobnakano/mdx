*simulator lang=spice

*** .LIB FS ***
*** .LIB 'UX6HPlib' COMMON ***

.param
+dvth0shiftn_hp = dvth000n_hp
+dvth0shiftp_hp = dvth000p_hp
+dvth0sigman_hp = -2
+dvth0sigmap_hp = -2
+dvth0intrn_hp = 'dvth000intrn_hp*dvth0sigman_hp'
+dvth0intrp_hp = 'dvth000intrp_hp*dvth0sigmap_hp'
+dxln_hp = 0
+dxlp_hp = 0
+dxwn_hp = 0
+dxwp_hp = 0
+dlintn_hp = 0.83n
+dlintp_hp = -0.67n
+dwintn_hp = -10n
+dwintp_hp = 10n
+dlminn_hp = '2*dlintn_hp'
+dlminp_hp = '2*dlintp_hp'
+dlmaxn_hp = '2*dlintn_hp'
+dlmaxp_hp = '2*dlintp_hp'
+dwminn_hp = '2*dwintn_hp'
+dwminp_hp = '2*dwintp_hp'
+dwmaxn_hp = '2*dwintn_hp'
+dwmaxp_hp = '2*dwintp_hp'
+lminoffsetn_hp = dxln_hp
+lminoffsetp_hp = dxlp_hp
+lmaxoffsetn_hp = 'dxln_hp+0.1n'
+lmaxoffsetp_hp = 'dxlp_hp+0.1n'
+wminoffsetn_hp = dxwn_hp
+wminoffsetp_hp = dxwp_hp
+wmaxoffsetn_hp = 'dxwn_hp+0.1n'
+wmaxoffsetp_hp = 'dxwp_hp+0.1n'
+dtoxn_hp = 0
+dtoxp_hp = 0
+dk1factorn_hp = dk100factorn_hp
+dk1factorp_hp = dk100factorp_hp
+dk2factorn_hp = 1
+dk2factorp_hp = 1
+du0factorn_hp = du000factorn_hp
+du0factorp_hp = du000factorp_hp
+dvsatfactorn_hp = 1.08
+dvsatfactorp_hp = 0.80
+dcgdofactorn_hp = 1.30
+dcgdofactorp_hp = 0.84
+dcgsofactorn_hp = dcgdofactorn_hp
+dcgsofactorp_hp = dcgdofactorp_hp
+dcgdlfactorn_hp = dcgdofactorn_hp
+dcgdlfactorp_hp = dcgdofactorp_hp
+dcgslfactorn_hp = dcgsofactorn_hp
+dcgslfactorp_hp = dcgsofactorp_hp
+dcgdon_hp = 0
+dcgson_hp = dcgdon_hp
+dcgdop_hp = 0
+dcgsop_hp = dcgdop_hp
+dcffactorn_hp = 1
+dcffactorp_hp = 1
+ddlc00n_hp = 2.08n
+ddlc00p_hp = -2.24n
+ddlcn_hp = 'ddlc00n_hp+dlintn_hp'
+ddlcp_hp = 'ddlc00p_hp+dlintp_hp'
+ddwcn_hp = dwintn_hp
+ddwcp_hp = dwintp_hp
+ddwjn_hp = dwintn_hp
+ddwjp_hp = dwintp_hp
+dcjfactorn_hp = 0.93
+dcjfactorp_hp = 1.07
+dcjn_hp = 0
+dcjp_hp = 0
+dwminn0_hp = -2e-08
+dwmaxn0_hp = -2e-08
+dwminn1_hp = -2.0004e-08
+dwmaxn1_hp = -2e-08
+dwminn2_hp = -2.0044e-08
+dwmaxn2_hp = -2.0004e-08
+dwminn3_hp = -2.0204e-08
+dwmaxn3_hp = -2.0044e-08
+dwminn4_hp = -2.1103e-08
+dwmaxn4_hp = -2.0204e-08
+dwminn5_hp = -2.3746e-08
+dwmaxn5_hp = -2.1103e-08
+dwminn6_hp = -2.7882e-08
+dwmaxn6_hp = -2.3746e-08
+dwminp0_hp = 2e-08
+dwmaxp0_hp = 2e-08
+dwminp1_hp = 2.0004e-08
+dwmaxp1_hp = 2e-08
+dwminp2_hp = 2.0042e-08
+dwmaxp2_hp = 2.0004e-08
+dwminp3_hp = 2.0187e-08
+dwmaxp3_hp = 2.0042e-08
+dwminp4_hp = 2.0903e-08
+dwmaxp4_hp = 2.0187e-08
+dwminp5_hp = 2.2535e-08
+dwmaxp5_hp = 2.0903e-08
+dwminp6_hp = 2.4211e-08
+dwmaxp6_hp = 2.2535e-08
+dwminp7_hp = 2.5158e-08
+dwmaxp7_hp = 2.4211e-08

*** .LIB 'UX6HPlib' COMMON_DVTH ***
*** .LIB 'UX6HPlib' MOS ***
*** .ENDL FS ***
