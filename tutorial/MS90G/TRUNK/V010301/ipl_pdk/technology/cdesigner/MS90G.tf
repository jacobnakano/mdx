; Technology File MS90G
; Generated on Jun 29 18:15:35 2009
;     with @(#)$CDS: virtuoso version 6.1.3 02/21/2009 06:23 (cic612lnx) $


;********************************
; CONTROLS
;********************************
controls(
 techParams(
 ;( parameter           value             )
 ;( ----------          -----             )
 ) ;techParams

 viewTypeUnits(
 ;( viewType            userUnit       dbuperuu           )
 ;( --------            --------       --------           )
 ) ;viewTypeUnits

 mfgGridResolution(
      ( 0.005000 )
 ) ;mfgGridResolution

 refTechLibs(
; techLibName            
; -----------            
 ) ;refTechLibs

 processFamily(
 ) ;processFamily

 distanceMeasure(
 ) ;distanceMeasure

) ;controls


;********************************
; LAYER DEFINITION
;********************************
layerDefinitions(

 techPurposes(
 ;( PurposeName               Purpose#   Abbreviation )
 ;( -----------               --------   ------------ )
 ;User-Defined Purposes:
 ;System-Reserved Purposes:
 ) ;techPurposes

 techLayers(
 ;( LayerName                 Layer#     Abbreviation )
 ;( ---------                 ------     ------------ )
 ;User-Defined Layers:
  ( NW                        1          NW           )
  ( PWLVS                     2          PWLVS        )
  ( ND                        3          ND           )
  ( PD                        4          PD           )
  ( PO                        5          PO           )
  ( CT                        6          CT           )
 ;( -                         7          -            )
  ( GC                        8          GC           )
  ( NWR                       9          NWR          )
  ( DNW                       10         DNW          )
  ( M1                        11         M1           )
  ( M2                        12         M2           )
  ( M3                        13         M3           )
  ( M4                        14         M4           )
  ( M5                        15         M5           )
 ;( -                         16         -            )
 ;( -                         17         -            )
 ;( -                         18         -            )
 ;( -                         19         -            )
  ( PM                        20         PM           )
  ( V1                        21         V1           )
  ( V2                        22         V2           )
  ( V3                        23         V3           )
  ( V4                        24         V4           )
 ;( -                         25         -            )
 ;( -                         26         -            )
 ;( -                         27         -            )
 ;( -                         28         -            )
 ;( -                         29         -            )
  ( PV                        30         PV           )
  ( SB                        31         SB           )
  ( PCHTACC                   32         PCHTACC      )
  ( NCHTACC                   33         NCHTACC      )
 ;( -                         34         -            )
  ( NPPO                      35         NPPO         )
  ( NIESD                     36         NIESD        )
  ( PIACC                     37         PIACC        )
  ( NIACC                     38         NIACC        )
  ( PEXTACC                   39         PEXTACC      )
  ( NEXTACC                   40         NEXTACC      )
  ( PLDDACC                   41         PLDDACC      )
  ( NLDDACC                   42         NLDDACC      )
 ;( -                         43         -            )
 ;( -                         44         -            )
  ( HVACC                     45         HVACC        )
  ( NPREACC                   46         NPREACC      )
  ( PPREACC                   47         PPREACC      )
  ( HVNWACC                   48         HVNWACC      )
  ( HVPWACC                   49         HVPWACC      )
 ;( -                         50         -            )
 ;( -                         51         -            )
  ( PCACC                     52         PCACC        )
  ( NCACC                     53         NCACC        )
  ( PSACC                     54         PSACC        )
  ( NSMACC                    55         NSMACC       )
 ;( -                         56         -            )
  ( FUSE                      57         FUSE         )
  ( PICOVER                   58         PICOVER      )
  ( UBM                       59         UBM          )
  ( UBMV                      60         UBMV         )
  ( COVER                     61         COVER        )
 ;( -                         62         -            )
 ;( -                         63         -            )
 ;( -                         64         -            )
  ( V5M                       65         V5M          )
  ( M6M                       66         M6M          )
 ;( -                         67         -            )
  ( SIONCOVER                 68         SIONCOVER    )
 ;( -                         69         -            )
 ;( -                         70         -            )
 ;( -                         71         -            )
 ;( -                         72         -            )
 ;( -                         73         -            )
 ;( -                         74         -            )
 ;( -                         75         -            )
 ;( -                         76         -            )
  ( CI                        77         CI           )
 ;( -                         78         -            )
 ;( -                         79         -            )
 ;( -                         80         -            )
 ;( -                         81         -            )
  ( SCTVER                    82         SCTVER       )
  ( FCV                       83         FCV          )
 ;( -                         84         -            )
 ;( -                         85         -            )
 ;( -                         86         -            )
 ;( -                         87         -            )
 ;( -                         88         -            )
 ;( -                         89         -            )
 ;( -                         90         -            )
 ;( -                         91         -            )
 ;( -                         92         -            )
  ( CUPDRC                    93         CUPDRC       )	; #195
  ( PADDRC                    94         PADDRC       )	; #196
  ( NOPGDRC2                  95         NOPGDRC2     )	; #197
  ( NOWELL                    96         NOWELL       )	; #198
  ( OMLVS2                    97         OMLVS2       )	; #199
  ( NOPGDRC3                  98         NOPGDRC3     )	; #200
  ( NI                        99         NI           )	; #203
  ( PI                        100        PI           )	; #204
  ( NWACC                     101        NWACC        )
  ( PWACC                     102        PWACC        )
  ( DIFACC                    103        DIFACC       )
  ( PCHT                      104        PCHT         )
  ( NCHT                      105        NCHT         )
  ( CTACC                     106        CTACC        )
  ( HVNW                      107        HVNW         )
  ( HVPW                      108        HVPW         )
  ( PCDC                      109        PCDC         )	; #207
  ( NCDC                      110        NCDC         )	; #208
  ( M1OBS                     111        M1OBS        )
  ( M2OBS                     112        M2OBS        )
  ( M3OBS                     113        M3OBS        )
  ( M4OBS                     114        M4OBS        )
  ( M5OBS                     115        M5OBS        )
  ( M6OBS                     116        M6OBS        )
 ;( -                         117        -            )
 ;( -                         118        -            )
 ;( -                         119        -            )
  ( FRAME                     120        FRAME        )	; #209
  ( SCRIBE                    121        SCRIBE       )	; #210
  ( RFLVS                     122        RFLVS        )
  ( SPOVER                    123        SPOVER       )
  ( SPODLP                    124        SPODLP       )
  ( CTVER                     125        CTVER        )
  ( M1VER                     126        M1VER        )
  ( M2VER                     127        M2VER        )
  ( NOM1D                     128        NOM1D        )	; #211
  ( NOM2D                     129        NOM2D        )	; #212
  ( NOM3D                     130        NOM3D        )	; #213
  ( NNA                       131        NNA          )
  ( NCU                       132        NCU          )
  ( NCH                       133        NCH          )
  ( NCM                       134        NCM          )
  ( NOM4D                     135        NOM4D        )	; #214
  ( NOM5D                     136        NOM5D        )	; #215
  ( NOM6D                     137        NOM6D        )	; #216
  ( PNPIOLVS                  138        PNPIOLVS     )
  ( PGPR                      139        PGPR         )
  ( EFUSEDRC                  140        EFUSEDRC     )
  ( NOM1OPC                   141        NOM1OPC      )	; #220
  ( HV33                      142        HV33         )
  ( HV25                      143        HV25         )
  ( HV18                      144        HV18         )
  ( DIFD                      145        DIFD         )	; #221
  ( NOIODRC                   146        NOIODRC      )	; #222
  ( NODIFD                    147        NODIFD       )	; #223
  ( PIODRC                    148        PIODRC       )
  ( NIODRC                    149        NIODRC       )
  ( POD                       150        POD          )	; #224
  ( NOPOD                     151        NOPOD        )	; #225
  ( NOMD                      152        NOMD         )	; #226
  ( POOPCPLUS                 153        POOPCPLUS    )	; #227
  ( POOPCMINUS                154        POOPCMINUS   )	; #228
  ( NOPOOPC                   155        NOPOOPC      )	; #229
  ( CAPLVS                    156        CAPLVS       )	; #230
  ( NOHT                      157        NOHT         )
  ( DACHKPAT                  158        DACHKPAT     )
  ( HT                        159        HT           )
  ( NOMOPC                    160        NOMOPC       )	; #231
  ( NODIFOPC                  161        NODIFOPC     )
  ( PPPO                      162        PPPO         )
  ( SPO                       163        SPO          )
  ( SDIF                      164        SDIF         )
  ( NPNLVS                    165        NPNLVS       )	; #232
  ( PCU                       166        PCU          )
  ( PCH                       167        PCH          )
  ( PCM                       168        PCM          )
  ( NOCTOPC                   169        NOCTOPC      )	; #233
  ( NOVOPC                    170        NOVOPC       )	; #234
  ( FR6B                      171        FR6B         )	; #237
  ( SDIFVER                   172        SDIFVER      )
  ( PODLP                     173        PODLP        )
  ( GFR6B                     174        GFR6B        )	; #238
  ( FR7K                      175        FR7K         )	; #239
  ( GFR7K                     176        GFR7K        )	; #240
  ( RESLVS                    177        RESLVS       )	; #241
  ( NOM2OPC                   178        NOM2OPC      )
  ( PNPLVS                    179        PNPLVS       )	; #242
  ( NOPGDRC                   180        NOPGDRC      )	; #243
  ( OMDRC                     181        OMDRC        )	; #244
  ( SRAMLVS                   182        SRAMLVS      )	; #245
  ( OMLVS                     183        OMLVS        )	; #246
  ( DILVS                     184        DILVS        )	; #247
  ( DIODRC                    185        DIODRC       )	; #248
  ( RIODRC                    186        RIODRC       )	; #249
  ( SRAMCELL                  187        SRAMCELL     )	; #250
  ( SRAMPR                    188        SRAMPR       )	; #251
  ( USRAM                     189        USRAM        )	; #252
  ( SRAMDRC                   190        SRAMDRC      )	; #253
  ( NOPOSGDRC                 191        NOPOSGDRC    )
  ( PS                        192        PS           )	; #254
  ( NSM                       193        NSM          )	; #255
  ( RESLVS2                   194        RESLVS2      )
 ;System-Reserved Layers:
 ) ;techLayers

 techLayerPurposePriorities(
 ;layers are ordered from lowest to highest priority
 ;( LayerName                 Purpose    )
 ;( ---------                 -------    )
 ;User-Defined Layers:
  ( NW                        drawing    )
  ( PWLVS                     drawing    )
  ( ND                        drawing    )
  ( PD                        drawing    )
  ( PO                        drawing    )
  ( CT                        drawing    )
  ( GC                        drawing    )
  ( NWR                       drawing    )
  ( DNW                       drawing    )
  ( M1                        drawing    )
  ( M2                        drawing    )
  ( M3                        drawing    )
  ( M4                        drawing    )
  ( M5                        drawing    )
  ( M6M                       drawing    )
  ( PM                        drawing    )
  ( V1                        drawing    )
  ( V2                        drawing    )
  ( V3                        drawing    )
  ( V4                        drawing    )
  ( V5M                       drawing    )
  ( PV                        drawing    )
  ( SB                        drawing    )
  ( PCHTACC                   drawing    )
  ( NCHTACC                   drawing    )
  ( NPPO                      drawing    )
  ( NIESD                     drawing    )
  ( PIACC                     drawing    )
  ( NIACC                     drawing    )
  ( PEXTACC                   drawing    )
  ( NEXTACC                   drawing    )
  ( PLDDACC                   drawing    )
  ( NLDDACC                   drawing    )
  ( HVACC                     drawing    )
  ( NPREACC                   drawing    )
  ( PPREACC                   drawing    )
  ( HVNWACC                   drawing    )
  ( HVPWACC                   drawing    )
  ( PCACC                     drawing    )
  ( NCACC                     drawing    )
  ( PSACC                     drawing    )
  ( NSMACC                    drawing    )
  ( FUSE                      drawing    )
  ( PICOVER                   drawing    )
  ( UBM                       drawing    )
  ( UBMV                      drawing    )
  ( COVER                     drawing    )
  ( SIONCOVER                 drawing    )
  ( CI                        drawing    )
  ( SCTVER                    drawing    )
  ( FCV                       drawing    )
  ( NWACC                     drawing    )
  ( PWACC                     drawing    )
  ( DIFACC                    drawing    )
  ( PCHT                      drawing    )
  ( NCHT                      drawing    )
  ( CTACC                     drawing    )
  ( HVNW                      drawing    )
  ( HVPW                      drawing    )
  ( M1OBS                     drawing    )
  ( M2OBS                     drawing    )
  ( M3OBS                     drawing    )
  ( M4OBS                     drawing    )
  ( M5OBS                     drawing    )
  ( M6OBS                     drawing    )
  ( RFLVS                     drawing    )
  ( SPOVER                    drawing    )
  ( SPODLP                    drawing    )
  ( CTVER                     drawing    )
  ( M1VER                     drawing    )
  ( M2VER                     drawing    )
  ( NNA                       drawing    )
  ( NCU                       drawing    )
  ( NCH                       drawing    )
  ( NCM                       drawing    )
  ( PNPIOLVS                  drawing    )
  ( PGPR                      drawing    )
  ( EFUSEDRC                  drawing    )
  ( HV33                      drawing    )
  ( HV25                      drawing    )
  ( HV18                      drawing    )
  ( PIODRC                    drawing    )
  ( NIODRC                    drawing    )
  ( NOHT                      drawing    )
  ( DACHKPAT                  drawing    )
  ( HT                        drawing    )
  ( NODIFOPC                  drawing    )
  ( PPPO                      drawing    )
  ( SPO                       drawing    )
  ( SDIF                      drawing    )
  ( PCU                       drawing    )
  ( PCH                       drawing    )
  ( PCM                       drawing    )
  ( SDIFVER                   drawing    )
  ( PODLP                     drawing    )
  ( NOM2OPC                   drawing    )
  ( NOPOSGDRC                 drawing    )
  ( RESLVS2                   drawing    )
  ( CUPDRC                    drawing    )
  ( PADDRC                    drawing    )
  ( NOPGDRC2                  drawing    )
  ( NOWELL                    drawing    )
  ( OMLVS2                    drawing    )
  ( NOPGDRC3                  drawing    )
  ( NI                        drawing    )
  ( PI                        drawing    )
  ( PCDC                      drawing    )
  ( NCDC                      drawing    )
  ( FRAME                     drawing    )
  ( SCRIBE                    drawing    )
  ( NOM1D                     drawing    )
  ( NOM2D                     drawing    )
  ( NOM3D                     drawing    )
  ( NOM4D                     drawing    )
  ( NOM5D                     drawing    )
  ( NOM6D                     drawing    )
  ( NOM1OPC                   drawing    )
  ( DIFD                      drawing    )
  ( NOIODRC                   drawing    )
  ( NODIFD                    drawing    )
  ( POD                       drawing    )
  ( NOPOD                     drawing    )
  ( NOMD                      drawing    )
  ( POOPCPLUS                 drawing    )
  ( POOPCMINUS                drawing    )
  ( NOPOOPC                   drawing    )
  ( CAPLVS                    drawing    )
  ( NOMOPC                    drawing    )
  ( NPNLVS                    drawing    )
  ( NOCTOPC                   drawing    )
  ( NOVOPC                    drawing    )
  ( FR6B                      drawing    )
  ( GFR6B                     drawing    )
  ( FR7K                      drawing    )
  ( GFR7K                     drawing    )
  ( RESLVS                    drawing    )
  ( PNPLVS                    drawing    )
  ( NOPGDRC                   drawing    )
  ( OMDRC                     drawing    )
  ( SRAMLVS                   drawing    )
  ( OMLVS                     drawing    )
  ( DILVS                     drawing    )
  ( DIODRC                    drawing    )
  ( RIODRC                    drawing    )
  ( SRAMCELL                  drawing    )
  ( SRAMPR                    drawing    )
  ( USRAM                     drawing    )
  ( SRAMDRC                   drawing    )
  ( PS                        drawing    )
  ( NSM                       drawing    )
  ( NW                        net        )
  ( PWLVS                     net        )
  ( ND                        net        )
  ( PD                        net        )
  ( PO                        net        )
  ( CT                        net        )
  ( M1                        net        )
  ( M2                        net        )
  ( M3                        net        )
  ( M4                        net        )
  ( M5                        net        )
  ( M6M                       net        )
  ( PM                        net        )
  ( V1                        net        )
  ( V2                        net        )
  ( V3                        net        )
  ( V4                        net        )
  ( V5M                       net        )
  ( PV                        net        )
  ( HVNW                      net        )
  ( HVPW                      net        )
  ( PO                        pin        )
  ( M1                        pin        )
  ( M2                        pin        )
  ( M3                        pin        )
  ( M4                        pin        )
  ( M5                        pin        )
  ( M6M                       pin        )
  ( PM                        pin        )
 ;System-Reserved Layers:
  ( background                drawing    )
  ( grid                      drawing    )
  ( grid                      drawing1   )
  ( annotate                  drawing    )
  ( annotate                  drawing1   )
  ( annotate                  drawing2   )
  ( annotate                  drawing3   )
  ( annotate                  drawing4   )
  ( annotate                  drawing5   )
  ( annotate                  drawing6   )
  ( annotate                  drawing7   )
  ( annotate                  drawing8   )
  ( annotate                  drawing9   )
  ( instance                  drawing    )
  ( instance                  label      )
  ( prBoundary                drawing    )
  ( prBoundary                boundary   )
  ( prBoundary                label      )
  ( align                     drawing    )
  ( hardFence                 drawing    )
  ( softFence                 drawing    )
  ( text                      drawing    )
  ( text                      drawing1   )
  ( text                      drawing2   )
  ( border                    drawing    )
  ( device                    drawing    )
  ( device                    label      )
  ( device                    drawing1   )
  ( device                    drawing2   )
  ( device                    annotate   )
  ( wire                      drawing    )
  ( wire                      label      )
  ( wire                      flight     )
  ( pin                       label      )
  ( pin                       drawing    )
  ( pin                       annotate   )
  ( axis                      drawing    )
  ( edgeLayer                 drawing    )
  ( edgeLayer                 pin        )
  ( snap                      drawing    )
  ( stretch                   drawing    )
  ( y0                        drawing    )
  ( y1                        drawing    )
  ( y2                        drawing    )
  ( y3                        drawing    )
  ( y4                        drawing    )
  ( y5                        drawing    )
  ( y6                        drawing    )
  ( y7                        drawing    )
  ( y8                        drawing    )
  ( y9                        drawing    )
  ( hilite                    drawing    )
  ( hilite                    drawing1   )
  ( hilite                    drawing2   )
  ( hilite                    drawing3   )
  ( hilite                    drawing4   )
  ( hilite                    drawing5   )
  ( hilite                    drawing6   )
  ( hilite                    drawing7   )
  ( hilite                    drawing8   )
  ( hilite                    drawing9   )
  ( select                    drawing    )
  ( drive                     drawing    )
  ( hiz                       drawing    )
  ( resist                    drawing    )
  ( spike                     drawing    )
  ( supply                    drawing    )
  ( unknown                   drawing    )
  ( unset                     drawing    )
  ( designFlow                drawing    )
  ( designFlow                drawing1   )
  ( designFlow                drawing2   )
  ( designFlow                drawing3   )
  ( designFlow                drawing4   )
  ( designFlow                drawing5   )
  ( designFlow                drawing6   )
  ( designFlow                drawing7   )
  ( designFlow                drawing8   )
  ( designFlow                drawing9   )
  ( changedLayer              tool0      )
  ( changedLayer              tool1      )
  ( marker                    warning    )
  ( marker                    error      )
  ( Row                       drawing    )
  ( Row                       label      )
  ( Group                     drawing    )
  ( Group                     label      )
  ( Cannotoccupy              drawing    )
  ( Cannotoccupy              boundary   )
  ( Canplace                  drawing    )
  ( Unrouted                  drawing    )
  ( Unrouted                  drawing1   )
  ( Unrouted                  drawing2   )
  ( Unrouted                  drawing3   )
  ( Unrouted                  drawing4   )
  ( Unrouted                  drawing5   )
  ( Unrouted                  drawing6   )
  ( Unrouted                  drawing7   )
  ( Unrouted                  drawing8   )
  ( Unrouted                  drawing9   )
  ( Row                       boundary   )
  ( Unrouted                  track      )
  ( marker                    annotate   )
  ( marker                    info       )
  ( marker                    ackWarn    )
  ( marker                    soError    )
  ( marker                    soCritical )
  ( marker                    critical   )
  ( marker                    fatal      )
  ( Group                     boundary   )
  ( y0                        flight     )
  ( y1                        flight     )
  ( y2                        flight     )
  ( y3                        flight     )
  ( y4                        flight     )
  ( y5                        flight     )
  ( y6                        flight     )
  ( y7                        flight     )
  ( y8                        flight     )
  ( y9                        flight     )
  ( border                    boundary   )
  ( snap                      grid       )
  ( snap                      boundary   )
 ) ;techLayerPurposePriorities

 techDisplays(
 ;( LayerName    Purpose      Packet          Vis Sel Con2ChgLy DrgEnbl Valid )
 ;( ---------    -------      ------          --- --- --------- ------- ----- )
 ;User-Defined Layers:
  ( NW           drawing      NW              t t t t t )
  ( NW           net          NW_net          t t t t nil )
  ( PWLVS        drawing      PWLVS           t t t t t )
  ( PWLVS        net          PWLVS_net       t t t t nil )
  ( ND           drawing      ND              t t t t t )
  ( ND           net          ND_net          t t t t nil )
  ( PD           drawing      PD              t t t t t )
  ( PD           net          PD_net          t t t t nil )
  ( PO           drawing      PO              t t t t t )
  ( PO           net          PO_net          t t t t nil )
  ( PO           pin          PO_pin          t t t t nil )
  ( CT           drawing      CT              t t t t t )
  ( CT           net          CT_net          t t t t nil )
  ( GC           drawing      GC              t t t t t )
  ( NWR          drawing      NWR             t t t t t )
  ( DNW          drawing      DNW             t t t t t )
  ( M1           drawing      M1              t t t t t )
  ( M1           net          M1_net          t t t t nil )
  ( M1           pin          M1_pin          t t t t nil )
  ( M2           drawing      M2              t t t t t )
  ( M2           net          M2_net          t t t t nil )
  ( M2           pin          M2_pin          t t t t nil )
  ( M3           drawing      M3              t t t t t )
  ( M3           net          M3_net          t t t t nil )
  ( M3           pin          M3_pin          t t t t nil )
  ( M4           drawing      M4              t t t t t )
  ( M4           net          M4_net          t t t t nil )
  ( M4           pin          M4_pin          t t t t nil )
  ( M5           drawing      M5              t t t t t )
  ( M5           net          M5_net          t t t t nil )
  ( M5           pin          M5_pin          t t t t nil )
  ( PM           drawing      PM              t t t t t )
  ( PM           net          PM_net          t t t t nil )
  ( PM           pin          PM_pin          t t t t nil )
  ( V1           drawing      V1              t t t t t )
  ( V1           net          V1_net          t t t t nil )
  ( V2           drawing      V2              t t t t t )
  ( V2           net          V2_net          t t t t nil )
  ( V3           drawing      V3              t t t t t )
  ( V3           net          V3_net          t t t t nil )
  ( V4           drawing      V4              t t t t t )
  ( V4           net          V4_net          t t t t nil )
  ( PV           drawing      PV              t t t t t )
  ( PV           net          PV_net          t t t t nil )
  ( SB           drawing      SB              t t t t t )
  ( PCHTACC      drawing      PCHTACC         t t t t t )
  ( NCHTACC      drawing      NCHTACC         t t t t t )
  ( NPPO         drawing      NPPO            t t t t t )
  ( NIESD        drawing      NIESD           t t t t t )
  ( PIACC        drawing      PIACC           t t t t t )
  ( NIACC        drawing      NIACC           t t t t t )
  ( PEXTACC      drawing      PEXTACC         t t t t t )
  ( NEXTACC      drawing      NEXTACC         t t t t t )
  ( PLDDACC      drawing      PLDDACC         t t t t t )
  ( NLDDACC      drawing      NLDDACC         t t t t t )
  ( HVACC        drawing      HVACC           t t t t t )
  ( NPREACC      drawing      NPREACC         t t t t t )
  ( PPREACC      drawing      PPREACC         t t t t t )
  ( HVNWACC      drawing      HVNWACC         t t t t t )
  ( HVPWACC      drawing      HVPWACC         t t t t t )
  ( PCACC        drawing      PCACC           t t t t t )
  ( NCACC        drawing      NCACC           t t t t t )
  ( PSACC        drawing      PSACC           t t t t t )
  ( NSMACC       drawing      NSMACC          t t t t t )
  ( FUSE         drawing      FUSE            t t t t t )
  ( PICOVER      drawing      PICOVER         t t t t t )
  ( UBM          drawing      UBM             t t t t t )
  ( UBMV         drawing      UBMV            t t t t t )
  ( COVER        drawing      COVER           t t t t t )
  ( V5M          drawing      V5M             t t t t t )
  ( V5M          net          V5M_net         t t t t nil )
  ( M6M          drawing      M6M             t t t t t )
  ( M6M          net          M6M_net         t t t t nil )
  ( M6M          pin          M6M_pin         t t t t nil )
  ( SIONCOVER    drawing      SIONCOVER       t t t t t )
  ( CI           drawing      CI              t t t t t )
  ( SCTVER       drawing      SCTVER          t t t t t )
  ( FCV          drawing      FCV             t t t t t )
  ( NWACC        drawing      NWACC           t t t t t )
  ( PWACC        drawing      PWACC           t t t t t )
  ( DIFACC       drawing      DIFACC          t t t t t )
  ( PCHT         drawing      PCHT            t t t t t )
  ( NCHT         drawing      NCHT            t t t t t )
  ( CTACC        drawing      CTACC           t t t t t )
  ( HVNW         drawing      HVNW            t t t t t )
  ( HVNW         net          HVNW_net        t t t t nil )
  ( HVPW         drawing      HVPW            t t t t t )
  ( HVPW         net          HVPW_net        t t t t nil )
  ( M1OBS        drawing      M1OBS           t t t t t )
  ( M2OBS        drawing      M2OBS           t t t t t )
  ( M3OBS        drawing      M3OBS           t t t t t )
  ( M4OBS        drawing      M4OBS           t t t t t )
  ( M5OBS        drawing      M5OBS           t t t t t )
  ( M6OBS        drawing      M6OBS           t t t t t )
  ( RFLVS        drawing      RFLVS           t t t t t )
  ( SPOVER       drawing      SPOVER          t t t t t )
  ( SPODLP       drawing      SPODLP          t t t t t )
  ( CTVER        drawing      CTVER           t t t t t )
  ( M1VER        drawing      M1VER           t t t t t )
  ( M2VER        drawing      M2VER           t t t t t )
  ( NNA          drawing      NNA             t t t t t )
  ( NCU          drawing      NCU             t t t t t )
  ( NCH          drawing      NCH             t t t t t )
  ( NCM          drawing      NCM             t t t t t )
  ( PNPIOLVS     drawing      PNPIOLVS        t t t t t )
  ( PGPR         drawing      PGPR            t t t t t )
  ( EFUSEDRC     drawing      EFUSEDRC        t t t t t )
  ( HV33         drawing      HV33            t t t t t )
  ( HV25         drawing      HV25            t t t t t )
  ( HV18         drawing      HV18            t t t t t )
  ( PIODRC       drawing      PIODRC          t t t t t )
  ( NIODRC       drawing      NIODRC          t t t t t )
  ( NOHT         drawing      NOHT            t t t t t )
  ( DACHKPAT     drawing      DACHKPAT        t t t t t )
  ( HT           drawing      HT              t t t t t )
  ( NODIFOPC     drawing      NODIFOPC        t t t t t )
  ( PPPO         drawing      PPPO            t t t t t )
  ( SPO          drawing      SPO             t t t t t )
  ( SDIF         drawing      SDIF            t t t t t )
  ( PCU          drawing      PCU             t t t t t )
  ( PCH          drawing      PCH             t t t t t )
  ( PCM          drawing      PCM             t t t t t )
  ( SDIFVER      drawing      SDIFVER         t t t t t )
  ( PODLP        drawing      PODLP           t t t t t )
  ( NOM2OPC      drawing      NOM2OPC         t t t t t )
  ( NOPOSGDRC    drawing      NOPOSGDRC       t t t t t )
  ( RESLVS2      drawing      RESLVS2         t t t t t )
  ( CUPDRC       drawing      CUPDRC          t t t t t )
  ( PADDRC       drawing      PADDRC          t t t t t )
  ( NOPGDRC2     drawing      NOPGDRC2        t t t t t )
  ( NOWELL       drawing      NOWELL          t t t t t )
  ( OMLVS2       drawing      OMLVS2          t t t t t )
  ( NOPGDRC3     drawing      NOPGDRC3        t t t t t )
  ( NI           drawing      NI              t t t t t )
  ( PI           drawing      PI              t t t t t )
  ( PCDC         drawing      PCDC            t t t t t )
  ( NCDC         drawing      NCDC            t t t t t )
  ( FRAME        drawing      FRAME           t t t t t )
  ( SCRIBE       drawing      SCRIBE          t t t t t )
  ( NOM1D        drawing      NOM1D           t t t t t )
  ( NOM2D        drawing      NOM2D           t t t t t )
  ( NOM3D        drawing      NOM3D           t t t t t )
  ( NOM4D        drawing      NOM4D           t t t t t )
  ( NOM5D        drawing      NOM5D           t t t t t )
  ( NOM6D        drawing      NOM6D           t t t t t )
  ( NOM1OPC      drawing      NOM1OPC         t t t t t )
  ( DIFD         drawing      DIFD            t t t t t )
  ( NOIODRC      drawing      NOIODRC         t t t t t )
  ( NODIFD       drawing      NODIFD          t t t t t )
  ( POD          drawing      POD             t t t t t )
  ( NOPOD        drawing      NOPOD           t t t t t )
  ( NOMD         drawing      NOMD            t t t t t )
  ( POOPCPLUS    drawing      POOPCPLUS       t t t t t )
  ( POOPCMINUS   drawing      POOPCMINUS      t t t t t )
  ( NOPOOPC      drawing      NOPOOPC         t t t t t )
  ( CAPLVS       drawing      CAPLVS          t t t t t )
  ( NOMOPC       drawing      NOMOPC          t t t t t )
  ( NPNLVS       drawing      NPNLVS          t t t t t )
  ( NOCTOPC      drawing      NOCTOPC         t t t t t )
  ( NOVOPC       drawing      NOVOPC          t t t t t )
  ( FR6B         drawing      FR6B            t t t t t )
  ( GFR6B        drawing      GFR6B           t t t t t )
  ( FR7K         drawing      FR7K            t t t t t )
  ( GFR7K        drawing      GFR7K           t t t t t )
  ( RESLVS       drawing      RESLVS          t t t t t )
  ( PNPLVS       drawing      PNPLVS          t t t t t )
  ( NOPGDRC      drawing      NOPGDRC         t t t t t )
  ( OMDRC        drawing      OMDRC           t t t t t )
  ( SRAMLVS      drawing      SRAMLVS         t t t t t )
  ( OMLVS        drawing      OMLVS           t t t t t )
  ( DILVS        drawing      DILVS           t t t t t )
  ( DIODRC       drawing      DIODRC          t t t t t )
  ( RIODRC       drawing      RIODRC          t t t t t )
  ( SRAMCELL     drawing      SRAMCELL        t t t t t )
  ( SRAMPR       drawing      SRAMPR          t t t t t )
  ( USRAM        drawing      USRAM           t t t t t )
  ( SRAMDRC      drawing      SRAMDRC         t t t t t )
  ( PS           drawing      PS              t t t t t )
  ( NSM          drawing      NSM             t t t t t )
 ;System-Reserved Layers:
  ( background   drawing      background      t nil t nil nil )
  ( grid         drawing      grid            t nil t nil nil )
  ( grid         drawing1     grid1           t nil t nil nil )
  ( annotate     drawing      annotate        t t t t nil )
  ( annotate     drawing1     annotate1       t t t t nil )
  ( annotate     drawing2     annotate2       t t t t nil )
  ( annotate     drawing3     annotate3       t t t t nil )
  ( annotate     drawing4     annotate4       t t t t nil )
  ( annotate     drawing5     annotate5       t t t t nil )
  ( annotate     drawing6     annotate6       t t t t nil )
  ( annotate     drawing7     annotate7       t t t t nil )
  ( annotate     drawing8     annotate8       t t t t nil )
  ( annotate     drawing9     annotate9       t t t t nil )
  ( instance     drawing      instance        t t t t nil )
  ( instance     label        instanceLbl     t t t t nil )
  ( prBoundary   drawing      prBoundary      t nil t t t )
  ( prBoundary   boundary     prBoundaryBnd   t nil t t nil )
  ( prBoundary   label        prBoundaryLbl   t t t t nil )
  ( align        drawing      defaultPacket   t t t t nil )
  ( hardFence    drawing      hardFence       t t t t nil )
  ( softFence    drawing      softFence       t t t t nil )
  ( text         drawing      text            t t t t nil )
  ( text         drawing1     text1           t t t t nil )
  ( text         drawing2     text2           t t t t nil )
  ( border       drawing      border          t t t t nil )
  ( device       drawing      device          t t t t nil )
  ( device       label        deviceLbl       t t t t nil )
  ( device       drawing1     device1         t t t t nil )
  ( device       drawing2     device2         t t t t nil )
  ( device       annotate     deviceAnt       t t t t nil )
  ( wire         drawing      wire            t t t t nil )
  ( wire         label        wireLbl         t t t t nil )
  ( wire         flight       wireFlt         t t t t nil )
  ( pin          label        pinLbl          t t t t nil )
  ( pin          drawing      pin             t t t t nil )
  ( pin          annotate     pinAnt          t t t t nil )
  ( axis         drawing      axis            t nil t t nil )
  ( edgeLayer    drawing      edgeLayer       t t t t nil )
  ( edgeLayer    pin          edgeLayerPin    t t t t nil )
  ( snap         drawing      snap            t t t t nil )
  ( stretch      drawing      stretch         t t t t nil )
  ( y0           drawing      y0              t t t t nil )
  ( y1           drawing      y1              t t t t nil )
  ( y2           drawing      y2              t t t t nil )
  ( y3           drawing      y3              t t t t nil )
  ( y4           drawing      y4              t t t t nil )
  ( y5           drawing      y5              t t t t nil )
  ( y6           drawing      y6              t t t t nil )
  ( y7           drawing      y7              t t t t nil )
  ( y8           drawing      y8              t t t t nil )
  ( y9           drawing      y9              t t t t nil )
  ( hilite       drawing      hilite          t t t t nil )
  ( hilite       drawing1     hilite1         t t t t nil )
  ( hilite       drawing2     hilite2         t t t t nil )
  ( hilite       drawing3     hilite3         t t t t nil )
  ( hilite       drawing4     hilite4         t t t t nil )
  ( hilite       drawing5     hilite5         t t t t nil )
  ( hilite       drawing6     hilite6         t t t t nil )
  ( hilite       drawing7     hilite7         t t t t nil )
  ( hilite       drawing8     hilite8         t t t t nil )
  ( hilite       drawing9     hilite9         t t t t nil )
  ( select       drawing      select          t t t t nil )
  ( drive        drawing      drive           t t t t nil )
  ( hiz          drawing      hiz             t t t t nil )
  ( resist       drawing      resist          t t t t nil )
  ( spike        drawing      spike           t t t t nil )
  ( supply       drawing      supply          t t t t nil )
  ( unknown      drawing      unknown         t t t t nil )
  ( unset        drawing      unset           t t t t nil )
  ( designFlow   drawing      designFlow      t nil nil nil nil )
  ( designFlow   drawing1     designFlow1     t nil nil nil nil )
  ( designFlow   drawing2     designFlow2     t nil nil nil nil )
  ( designFlow   drawing3     designFlow3     t nil nil nil nil )
  ( designFlow   drawing4     designFlow4     t nil nil nil nil )
  ( designFlow   drawing5     designFlow5     t nil nil nil nil )
  ( designFlow   drawing6     designFlow6     t nil nil nil nil )
  ( designFlow   drawing7     designFlow7     t nil nil nil nil )
  ( designFlow   drawing8     designFlow8     t nil nil nil nil )
  ( designFlow   drawing9     designFlow9     t nil nil nil nil )
  ( changedLayer tool0        changedLayerTl0 nil nil t nil nil )
  ( changedLayer tool1        changedLayerTl1 nil nil t nil nil )
  ( marker       warning      markerWarn      t t t t nil )
  ( marker       error        markerErr       t t t t nil )
  ( Row          drawing      Row             t t t t nil )
  ( Row          label        RowLbl          t t t t nil )
  ( Group        drawing      Group           t t t t nil )
  ( Group        label        GroupLbl        t t t t nil )
  ( Cannotoccupy drawing      Cannotoccupy    t t t t nil )
  ( Cannotoccupy boundary     CannotoccupyBnd t t t t nil )
  ( Canplace     drawing      Canplace        t t t t nil )
  ( Unrouted     drawing      Unrouted        t t t t nil )
  ( Unrouted     drawing1     Unrouted1       t t t t nil )
  ( Unrouted     drawing2     Unrouted2       t t t t nil )
  ( Unrouted     drawing3     Unrouted3       t t t t nil )
  ( Unrouted     drawing4     Unrouted4       t t t t nil )
  ( Unrouted     drawing5     Unrouted5       t t t t nil )
  ( Unrouted     drawing6     Unrouted6       t t t t nil )
  ( Unrouted     drawing7     Unrouted7       t t t t nil )
  ( Unrouted     drawing8     Unrouted8       t t t t nil )
  ( Unrouted     drawing9     Unrouted9       t t t t nil )
  ( Row          boundary     RowBnd          t t t t nil )
  ( Unrouted     track        UnroutedTrk     t t t t nil )
  ( marker       annotate     markerAno       t t t t nil )
  ( marker       info         markerInf       t t t t nil )
  ( marker       ackWarn      markerAck       t t t t nil )
  ( marker       soError      markerSer       t t t t nil )
  ( marker       soCritical   markerScr       t t t t nil )
  ( marker       critical     markerCrt       t t t t nil )
  ( marker       fatal        markerFat       t t t t nil )
  ( Group        boundary     GroupBnd        t nil t t nil )
  ( y0           flight       y0Flt           t t t t nil )
  ( y1           flight       y1Flt           t t t t nil )
  ( y2           flight       y2Flt           t t t t nil )
  ( y3           flight       y3Flt           t t t t nil )
  ( y4           flight       y4Flt           t t t t nil )
  ( y5           flight       y5Flt           t t t t nil )
  ( y6           flight       y6Flt           t t t t nil )
  ( y7           flight       y7Flt           t t t t nil )
  ( y8           flight       y8Flt           t t t t nil )
  ( y9           flight       y9Flt           t t t t nil )
  ( border       boundary     area            t nil t t nil )
  ( snap         grid         snap            t nil t nil nil )
  ( snap         boundary     snap            t nil t t nil )
 ) ;techDisplays

 techLayerProperties(
 ;( PropName               Layer1 [ Layer2 ]            PropValue )
 ;( --------               ------ ----------            --------- )
  ( sheetResistance        M1                           0.183000 )
  ( sheetResistance        M2                           0.104000 )
  ( sheetResistance        M3                           0.104000 )
  ( sheetResistance        M4                           0.104000 )
  ( sheetResistance        M5                           0.104000 )
  ( sheetResistance        M6M                          0.024000 )
  ( sheetResistance        PM                           0.019000 )
 ) ;techLayerProperties

 techDerivedLayers(
 ;( DerivedLayerName          #          composition  )
 ;( ----------------          ------     ------------ )
  ( NWHVNW                    10001      ( NW		'or		HVNW		))
  ( NWHVPW                    10002      ( NW		'or		HVPW		))
  ( HVNWPW                    10003      ( HVNW		'or		HVPW		))
  ( NWHVNWPW                  10004      ( NWHVNW	'or		NWHVPW		))
  ( HVPWAVONW                 10005      ( HVPW		'avoiding	NW		))
  ( HVPWAVOHVNW               10006      ( HVPW		'avoiding	HVNW		))
  ( NDAVONWHVNWPW             10007      ( ND		'avoiding	NWHVNWPW	))
  ( NWENCND                   10008      ( NW		'enclosing	ND		))
  ( HVNWENCND                 10009      ( HVNW		'enclosing	ND		))
  ( PDAVONWHVNWPW             10010      ( PD		'avoiding	NWHVNWPW	))
  ( PDAVOND                   10011      ( PD		'avoiding	ND		))
  ( NWENCPD                   10012      ( NW		'enclosing	PD		))
  ( HVNWENCPD                 10013      ( HVNW		'enclosing	PD		))
  ( HVPWENCPD                 10014      ( HVPW		'enclosing	PD		))
  ( NPD                       10015      ( ND		'or		PD		))
  ( POCOIND                   10016      ( PO		'coincident	ND		))
  ( POCOIPD                   10017      ( PO		'coincident	PD		))
  ( NDCOIPO                   10018      ( ND		'coincident	PO		))
  ( PDCOIPO                   10019      ( PD		'coincident	PO		))
  ( POSTRND                   10020      ( PO		'straddling	ND		))
  ( POSTRPD                   10021      ( PO		'straddling	PD		))
  ( POND                      10022      ( PO		'and		ND		))
  ( POPD                      10023      ( PO		'and		PD		))
  ( NIHVPW                    10024      ( NI		'and		HVPW		))
  ( NINONWHVNWPW              10025      ( NI		'not		NWHVNWPW	))
  ( PINW                      10026      ( PI		'and		NW		))
  ( PIHVNW                    10027      ( PI		'and		HVNW		))
  ( PINONWHVNWPW              10028      ( PI		'not		NWHVNWPW	))
  ( PCMPS                     10029      ( PCM		'or		PS		))
  ( NDOUTNWHVNW               10030      ( ND		'outside	NWHVNW		))
  ( NDINNWHVNW                10031      ( ND		'inside		NWHVNW		))
  ( PDOUTNWHVNW               10032      ( PD		'outside	NWHVNW		))
  ( PDINNWHVNW                10033      ( PD		'inside		NWHVNW		))
  ( NDHV18                    10034      ( ND		'inside		HV18		))
  ( PDHV18                    10035      ( PD		'inside		HV18		))
  ( PONDHV18                  10036      ( POND		'and		HV18		))
  ( POPDHV18                  10037      ( POPD		'and		HV18		))
  ( NDHV25                    10038      ( ND		'inside		HV25		))
  ( PDHV25                    10039      ( PD		'inside		HV25		))
  ( PONDHV25                  10040      ( POND		'and		HV25		))
  ( POPDHV25                  10041      ( POPD		'and		HV25		))
  ( NDHV33                    10042      ( ND		'inside		HV33		))
  ( PDHV33                    10043      ( PD		'inside		HV33		))
  ( PONDHV33                  10044      ( POND		'and		HV33		))
  ( POPDHV33                  10045      ( POPD		'and		HV33		))
  ( CTPO                      10046      ( CT		'and		PO		))
  ( NDPD                      10047      ( ND		'buttOnly	PD		))
  ( CTND                      10048      ( CT		'and		NDPD		))
  ( PDND                      10049      ( PD		'buttOnly	ND		))
  ( CTPD                      10050      ( CT		'and		PDND		))
  ( M1NODA                    10051      ( M1		'outside	DACHKPAT	))
  ( M2NODA                    10052      ( M2		'outside	DACHKPAT	))
  ( CTNOSRAM                  10053      ( CT		'outside	SRAMDRC		))
  ( V1NOSRAM                  10054      ( V1		'outside	SRAMDRC		))
  ( NDNNA                     10055      ( ND		'inside		NNA		))
  ( NWRHVPW                   10056      ( NWR		'or		HVPW		))
  ( NWRAVOHVPW                10057      ( NWR		'avoiding	HVPW		))
  ( NDNWR                     10058      ( ND		'inside		NWR		))
  ( CTNWR                     10059      ( CT		'inside		NWR		))
  ( NPPOAVOPI                 10060      ( NPPO		'avoiding	PI		))
  ( PONPPO                    10061      ( PO		'inside		NPPO		))
  ( CTNPPO                    10062      ( CT		'inside		NPPO		))
  ( PPPOAVONI                 10063      ( PPPO		'avoiding	NI		))
  ( POPPPO                    10064      ( PO		'inside		PPPO		))
  ( CTPPPO                    10065      ( CT		'inside		PPPO		))
  ( PPPONW                    10066      ( PPPO		'or		NW		))
  ( PPPOHVNW                  10067      ( PPPO		'or		HVNW		))
  ( GCNW                      10068      ( GC		'and		NW		))
  ( GCHVNW                    10069      ( GC		'and		HVNW		))
  ( NIGCNW                    10070      ( NI		'and		GCNW		))
  ( NIGCHVNW                  10071      ( NI		'and		GCHVNW		))
  ( NDGC                      10072      ( ND		'inside		GC		))
  ( POGC                      10073      ( PO		'inside		GC		))
  ( NDGCNW                    10074      ( ND		'inside		GCNW		))
  ( NOWELLOUTNIODRC           10075      ( NOWELL	'outside	NIODRC		))
  ( POCI                      10076      ( PO		'and		CI		))
  ( noOverlapLayer1           11001      ( NW		'and		HVNW		))	; HVNW_c
  ( noOverlapLayer2           11002      ( NW		'and		HVPW		))	; HVPW_ct1
  ( noOverlapLayer3           11003      ( HVNW		'and		HVPW		))	; HVPW_ct2
  ( noOverlapLayer4           11004      ( NI		'and		PI		))	; PI_pi
  ( noOverlapLayer5           11005      ( NCM		'and		HVPW		))	; NCM_pi1
  ( noOverlapLayer6           11006      ( NCM		'and		NWHVNW		))	; NCM_pi2
  ( noOverlapLayer7           11007      ( NCH		'and		HVPW		))	; NCH_pi1
  ( noOverlapLayer8           11008      ( NCH		'and		NWHVNW		))	; NCH_pi2
  ( noOverlapLayer9           11009      ( NSM		'and		HVPW		))	; NSM_pi1
  ( noOverlapLayer10          11010      ( NSM		'and		NWHVNW		))	; NSM_pi2
  ( noOverlapLayer11          11011      ( PCM		'outside	NW		))	; PCM_po
  ( noOverlapLayer12          11012      ( PCH		'outside	NW		))	; PCH_po
  ( noOverlapLayer13          11013      ( PS		'outside	NW		))	; PS_po
  ( noOverlapLayer14          11014      ( HV25		'and		HV18		))	; HV25_pi
  ( noOverlapLayer15          11015      ( HV33		'and		HV18		))	; HV33_pi1
  ( noOverlapLayer16          11016      ( HV33		'and		HV25		))	; HV33_pi2
  ( noOverlapLayer17          11017      ( CT		'and		POND		))	; CT_pt1
  ( noOverlapLayer18          11018      ( CT		'and		POPD		))	; CT_pt2
  ( noOverlapLayer19          11019      ( CT		'outside	M1		))	; M1_eh
  ( noOverlapLayer20          11020      ( V1		'outside	M1		))	; V1_ed
  ( noOverlapLayer21          11021      ( V1		'outside	M2		))	; M2_ee
  ( noOverlapLayer22          11022      ( V2		'outside	M2		))	; V2_ee
  ( noOverlapLayer23          11023      ( V2		'outside	M3		))	; M3_ee
  ( noOverlapLayer24          11024      ( V3		'outside	M3		))	; V3_ee
  ( noOverlapLayer25          11025      ( V3		'outside	M4		))	; M4_ee
  ( noOverlapLayer26          11026      ( V4		'outside	M4		))	; V4_ee
  ( noOverlapLayer27          11027      ( V4		'outside	M5		))	; M5_ee
  ( noOverlapLayer28          11028      ( V5M		'outside	M5		))	; V5M_e
  ( noOverlapLayer29          11029      ( V5M		'outside	M6M		))	; M6M_ee
  ( noOverlapLayer30          11030      ( PV		'outside	M6M		))	; PV_e
  ( noOverlapLayer31          11031      ( PV		'outside	PM		))	; PM_e
  ( noOverlapLayer32          11032      ( NNA		'and		NW		))	; NNA_c1
  ( noOverlapLayer33          11033      ( NNA		'and		HVNW		))	; NNA_c2
  ( noOverlapLayer34          11034      ( NNA		'and		PD		))	; NNA_c3
  ( noOverlapLayer35          11035      ( NNA		'and		NCM		))	; NNA_pi1
  ( noOverlapLayer36          11036      ( NNA		'and		NCH		))	; NNA_pi2
  ( noOverlapLayer37          11037      ( NNA		'and		NSM		))	; NNA_pi4
  ( noOverlapLayer38          11038      ( NWR		'and		NW		))	; NWR_c1
  ( noOverlapLayer39          11039      ( NWR		'and		HVNW		))	; NWR_c2
  ( noOverlapLayer40          11040      ( NWR		'and		PD		))	; NWR_c3
  ( noOverlapLayer41          11041      ( NWR		'and		NNA		))	; NWR_c4
  ( noOverlapLayer42          11042      ( NWR		'and		HVPW		))	; NWR_ct
  ( noOverlapLayer43          11043      ( NWR		'and		PI		))	; NWR_pi1
  ( noOverlapLayer44          11044      ( NWR		'and		NCM		))	; NWR_pi2
  ( noOverlapLayer45          11045      ( NWR		'and		NCH		))	; NWR_pi3
  ( noOverlapLayer46          11046      ( NWR		'and		NSM		))	; NWR_pi5
  ( noOverlapLayer47          11047      ( NWR		'and		HV18		))	; NWR_pi7
  ( noOverlapLayer48          11048      ( NWR		'and		HV25		))	; NWR_pi8
  ( noOverlapLayer49          11049      ( NWR		'and		HV33		))	; NWR_pi9
  ( noOverlapLayer50          11050      ( NPPO		'and		NNA		))	; NPPO_c1
  ( noOverlapLayer51          11051      ( NPPO		'and		NWR		))	; NPPO_c2
  ( noOverlapLayer52          11052      ( NPPO		'and		PI		))	; NPPO_ct
  ( noOverlapLayer53          11053      ( NPPO		'straddling	HV18		))	; NPPO_pk1
  ( noOverlapLayer54          11054      ( NPPO		'straddling	HV25		))	; NPPO_pk2
  ( noOverlapLayer55          11055      ( NPPO		'straddling	HV33		))	; NPPO_pk3
  ( noOverlapLayer56          11056      ( NPPO		'and		PD		))	; NPPO_pi2
  ( noOverlapLayer57          11057      ( NPPO		'and		NCM		))	; NPPO_pi3
  ( noOverlapLayer58          11058      ( NPPO		'and		NCH		))	; NPPO_pi4
  ( noOverlapLayer59          11059      ( NPPO		'and		NSM		))	; NPPO_pi6
  ( noOverlapLayer60          11060      ( NPPO		'and		PCM		))	; NPPO_pi8
  ( noOverlapLayer61          11061      ( NPPO		'and		PCH		))	; NPPO_pi9
  ( noOverlapLayer62          11062      ( NPPO		'and		PS		))	; NPPO_pi11
  ( noOverlapLayer63          11063      ( PPPO		'and		NNA		))	; PPPO_c1
  ( noOverlapLayer64          11064      ( PPPO		'and		NWR		))	; PPPO_c2
  ( noOverlapLayer65          11065      ( PPPO		'and		NI		))	; PPPO_ct
  ( noOverlapLayer66          11066      ( PPPO		'straddling	HV18		))	; PPPO_pk1
  ( noOverlapLayer67          11067      ( PPPO		'straddling	HV25		))	; PPPO_pk2
  ( noOverlapLayer68          11068      ( PPPO		'straddling	HV33		))	; PPPO_pk3
  ( noOverlapLayer69          11069      ( PPPO		'and		ND		))	; PPPO_pi1
  ( noOverlapLayer70          11070      ( PPPO		'and		NCM		))	; PPPO_pi3
  ( noOverlapLayer71          11071      ( PPPO		'and		NCH		))	; PPPO_pi4
  ( noOverlapLayer72          11072      ( PPPO		'and		NSM		))	; PPPO_pi6
  ( noOverlapLayer73          11073      ( PPPO		'and		PCM		))	; PPPO_pi8
  ( noOverlapLayer74          11074      ( PPPO		'and		PCH		))	; PPPO_pi9
  ( noOverlapLayer75          11075      ( PPPO		'and		PS		))	; PPPO_pi11
  ( noOverlapLayer76          11076      ( PPPO		'and		NPPO		))	; PPPO_pi12
  ( noOverlapLayer77          11077      ( CT		'and		SB		))	; SB_c
  ( noOverlapLayer78          11078      ( SB		'and		NNA		))	; SB_pi1
  ( noOverlapLayer79          11079      ( SB		'and		NWR		))	; SB_pi2
  ( noOverlapLayer80          11080      ( GC		'and		PD		))	; GC_c1
  ( noOverlapLayer81          11081      ( GC		'and		NWR		))	; GC_c2
  ( noOverlapLayer82          11082      ( GC		'and		HVPW		))	; GC_pi1
  ( noOverlapLayer83          11083      ( GC		'and		PI		))	; GC_pi2
  ( noOverlapLayer84          11084      ( GC		'and		NNA		))	; GC_pi3
  ( noOverlapLayer85          11085      ( GC		'and		NPPO		))	; GC_pi4
  ( noOverlapLayer86          11086      ( GC		'and		PPPO		))	; GC_pi5
  ( noOverlapLayer87          11087      ( NOWELL	'and		NW		))	; NOWELL_c1
  ( noOverlapLayer88          11088      ( NOWELL	'and		HVNW		))	; NOWELL_c2
  ( noOverlapLayer89          11089      ( NOWELL	'and		HVPW		))	; NOWELL_c3
  ( noOverlapLayer90          11090      ( NOWELL	'and		ND		))	; NOWELL_c4
  ( noOverlapLayer91          11091      ( NOWELL	'and		PD		))	; NOWELL_c5
  ( noOverlapLayer92          11092      ( NOWELL	'and		NNA		))	; NOWELL_c6
  ( noOverlapLayer93          11093      ( NOWELL	'and		NWR		))	; NOWELL_c7
  ( noOverlapLayer94          11094      ( NOWELL	'and		NPPO		))	; NOWELL_c8
  ( noOverlapLayer95          11095      ( NOWELL	'and		PPPO		))	; NOWELL_c9
  ( noOverlapLayer96          11096      ( NOWELL	'and		GC		))	; NOWELL_c10
  ( noOverlapLayer97          11097      ( CI		'and		CT		))	; CI_pi1
  ( noOverlapLayer98          11098      ( CI		'and		PD		))	; CI_pi2
  ( noOverlapLayer99          11099      ( CI		'and		SB		))	; CI_pi3
  ( noOverlapLayer100         11100      ( CI		'and		NPPO		))	; CI_pi5
  ( noOverlapLayer101         11101      ( CI		'and		PPPO		))	; CI_pi6
  ( noOverlapLayer102         11102      ( CI		'outside	HVPW		))	; CI_po
  ( noOverlapLayer103         11103      ( DNW		'and		NNA		))	; DNW_c1
  ( noOverlapLayer104         11104      ( DNW		'and		NWR		))	; DNW_c2
  ( noOverlapLayer105         11105      ( DNW		'and		NOWELL		))	; DNW_c3
  ( noOverlapLayer106         11106      ( DNW		'and		NSM		))	; DNW_pi1
  ( noOverlapLayer107         11107      ( DNW		'and		PS		))	; DNW_pi2
  ( noOverlapLayer108         11108      ( DNW		'and		PNPLVS		))	; DNW_pi3
  ( noOverlapLayer109         11109      ( NCHT		'outside	HVPW		))	; NCHT_po
  ( noOverlapLayer110         11110      ( NCHT		'and		NNA		))	; NCNT_pi1
  ( noOverlapLayer111         11111      ( NCHT		'and		NWR		))	; NCNT_pi2
  ( noOverlapLayer112         11112      ( NCHT		'and		NPPO		))	; NCNT_pi3
  ( noOverlapLayer113         11113      ( NCHT		'and		PPPO		))	; NCNT_pi4
  ( noOverlapLayer114         11114      ( NCHT		'and		CI		))	; NCNT_pi5
  ( noOverlapLayer115         11115      ( PCHT		'outside	HVNW		))	; PCHT_po
  ( noOverlapLayer116         11116      ( PCHT		'and		GC		))	; PCNT_pi1
  ( noOverlapLayer117         11117      ( PCHT		'and		NWR		))	; PCNT_pi2
  ( noOverlapLayer118         11118      ( PCHT		'and		NPPO		))	; PCNT_pi3
  ( noOverlapLayer119         11119      ( PCHT		'and		PPPO		))	; PCNT_pi4
 ) ;techDerivedLayers

) ;layerDefinitions


;********************************
; LAYER RULES
;********************************
layerRules(

 equivalentLayers(
 ;( list of layers )
 ;( -------------- )
 ) ;equivalentLayers

 functions(
 ;( layer                       function        [maskNumber])
 ;( -----                       --------        ------------)
  ( NW                       	"nwell"     	1            )
  ( PWLVS                      	"pwell"     	2            )
  ( HVNW                       	"nwell"     	3            )
  ( HVPW                      	"pwell"     	4            )
  ( ND                       	"ndiff"      	5            )
  ( PD                       	"pdiff"      	6            )
  ( NI                       	"nplus"      	7            )
  ( PI                       	"pplus"      	8            )
  ( PO                       	"poly"      	9            )
  ( CT                       	"cut"       	10           )
  ( DNW                      	"nwell"     	11           )
  ( M1                       	"metal"     	12           )
  ( V1                       	"cut"       	13           )
  ( M2                       	"metal"     	14           )
  ( V2                       	"cut"       	15           )
  ( M3                       	"metal"     	16           )
  ( V3                       	"cut"       	17           )
  ( M4                       	"metal"     	18           )
  ( V4                       	"cut"       	19           )
  ( M5                       	"metal"     	20           )
  ( V5M                      	"cut"       	21           )
  ( M6M                      	"metal"     	22           )
  ( PV                       	"cut"       	23           )
  ( PM                       	"metal"     	24           )
 ) ;functions

 mfgResolutions(
 ;( layer                       mfgResolution )
 ;( -----                       ------------- )
 ) ;mfgResolutions

 routingDirections(
 ;( layer                       direction     )
 ;( -----                       ---------     )
  ( PO                      	"none"       )
  ( M1                       	"horizontal" )
  ( M2                       	"vertical"   )
  ( M3                       	"horizontal" )
  ( M4                       	"vertical"   )
  ( M5                       	"horizontal" )
  ( M6M                      	"vertical"   )
 ) ;routingDirections

 incompatibleLayers(
 ;( layer                       incompatibleLayers       )
 ;( -----                       ------------------       )
 ) ;incompatibleLayers

 labelLayers(
 ;( textLayer   layers        )
 ;( ---------   ----------------------------------        )
 ) ;labelLayers

 stampLabelLayers(
 ;( textLayer   layers        )
 ;( ---------   ----------------------------------        )
  ( text	PO	M1	M2	M3	M4	M5	M6M	)
 ) ;stampLabelLayers

 currentDensity(
 ;( rule                	layer1    	layer2    	value    )
 ;( ----                	------    	------    	-----    )
 ) ;currentDensity

 currentDensityTables(
 ;( rule                	layer1    
 ;  (( index1Definitions	[index2Definitions]) [defaultValue] )
 ;  (table))
 ;( ----------------------------------------------------------------------)
 ) ;currentDensityTables

) ;layerRules


;********************************
; VIADEFS
;********************************
viaDefs(

 standardViaDefs(
 ;( viaDefName	layer1	layer2	(cutLayer cutWidth cutHeight [resistancePerCut]) 
 ;   (cutRows	cutCols	(cutSpace)) 
 ;   (layer1Enc) (layer2Enc)	(layer1Offset)	(layer2Offset)	(origOffset) 
 ;   [implant1	 (implant1Enc)	[implant2	(implant2Enc) [well/substrate]]]) 
 ;( -------------------------------------------------------------------------- ) 
  ( VHP         M6M     PM      ("PV"     2.0      2.0)
     (1		1	(2.0 2.0))
     (0.5 0.5)	(1.0 1.0)	(0.0 0.0)	(0.0 0.0)	(0.0 0.0)
  )
  ( VH5         M5      M6M     ("V5M"    0.36     0.36)
     (1		1	(0.34 0.34))
;     (0.03 0.03)	(0.03 0.09)	(0.0 0.0)	(0.0 0.0)	(0.0 0.0)
     (0.03 0.03)	(0.09 0.09)	(0.0 0.0)	(0.0 0.0)	(0.0 0.0)
  )
  ( VH4         M4      M5      ("V4"     0.13     0.13)
     (1		1	(0.15 0.15))
;     (0.005 0.05)	(0.005 0.05)	(0.0 0.0)	(0.0 0.0)	(0.0 0.0)
     (0.05 0.05)	(0.05 0.05)	(0.0 0.0)	(0.0 0.0)	(0.0 0.0)
  )
  ( VH3         M3      M4      ("V3"     0.13     0.13)
     (1		1	(0.15 0.15))
;     (0.005 0.05)	(0.005 0.05)	(0.0 0.0)	(0.0 0.0)	(0.0 0.0)
     (0.05 0.05)	(0.05 0.05)	(0.0 0.0)	(0.0 0.0)	(0.0 0.0)
  )
  ( VH2         M2      M3      ("V2"     0.13     0.13)
     (1		1	(0.15 0.15))
;     (0.005 0.05)	(0.005 0.05)	(0.0 0.0)	(0.0 0.0)	(0.0 0.0)
     (0.05 0.05)	(0.05 0.05)	(0.0 0.0)	(0.0 0.0)	(0.0 0.0)
  )
  ( VH1         M1      M2      ("V1"     0.13     0.13)
     (1		1	(0.15 0.15))
;     (0.005 0.05)	(0.005 0.05)	(0.0 0.0)	(0.0 0.0)	(0.0 0.0)
     (0.05 0.05)	(0.05 0.05)	(0.0 0.0)	(0.0 0.0)	(0.0 0.0)
  )
  ( CT1         PO      M1      ("CT"     0.12     0.12)
     (1		1	(0.14 0.14))
;     (0.04 0.05)	(0.0 0.05)	(0.0 0.0)	(0.0 0.0)	(0.0 0.0)
     (0.05 0.05)	(0.05 0.05)	(0.0 0.0)	(0.0 0.0)	(0.0 0.0)
  )
  ( CTNW        ND      M1      ("CT"     0.12     0.12)
     (1		1	(0.14 0.14))
;     (0.04 0.05)	(0.0 0.05)	(0.0 0.0)	(0.0 0.0)	(0.0 0.0)
     (0.05 0.05)	(0.05 0.05)	(0.0 0.0)	(0.0 0.0)	(0.0 0.0)
     NI			(0.02 0.02)	HVNW		(0.17 0.17)
  )
  ( CTPW        PD      M1      ("CT"     0.12     0.12)
     (1		1	(0.14 0.14))
;     (0.04 0.05)	(0.0 0.05)	(0.0 0.0)	(0.0 0.0)	(0.0 0.0)
     (0.05 0.05)	(0.05 0.05)	(0.0 0.0)	(0.0 0.0)	(0.0 0.0)
     PI			(0.02 0.02)	HVPW		(0.17 0.17)	
  )
 ) ;standardViaDefs

 customViaDefs(
 ;( viaDefName libName cellName viewName layer1 layer2 resistancePerCut)
 ;( ---------- ------- -------- -------- ------ ------ ----------------)
 ) ;customViaDefs

 standardViaVariants(
 ;( viaVariantName viaDefName (cutLayer cutWidth cutHeight) 
 ;   (cutRows	cutCol	(cutSpace)) 
 ;   (layer1Enc) (layer2Enc)	(layer1Offset)	(layer2Offset)	(origOffset) 
 ;   (implant1Enc) (implant2Enc) (cut_pattern) ) 
 ;( -------------------------------------------------------------------------- ) 
 ) ;standardViaVariants

 customViaVariants(
 ;(viaVariantName viaDefName (paramName paramValue) ...)
 ;( -------------------------------------------------------------------------- )
 ) ;customViaVariants

) ;viaDefs



;********************************
; CONSTRAINT GROUPS
;********************************
constraintGroups(

 ;( group	[override] )
 ;( -----	---------- )
  ( "default"	nil
  ) ;default

 ;( group	[override] )
 ;( -----	---------- )
  ( "virtuosoDefaultExtractorSetup"	nil

    interconnect(
     ( validLayers   (NW  PWLVS  HVNW  HVPW  ND  PD  PO  NWR  CT  M1  V1  M2  V2  M3  V3  M4  V4  M5  V5M  M6M  PV  PM  ) )
     ( validVias     (VHP  VH5  VH4  VH3  VH2  VH1  CT1  CTNW  CTPW  ) )
     ( errorLayer    noOverlapLayer1 )
     ( errorLayer    noOverlapLayer2 )
     ( errorLayer    noOverlapLayer3 )
     ( errorLayer    noOverlapLayer4 )
     ( errorLayer    noOverlapLayer5 )
     ( errorLayer    noOverlapLayer6 )
     ( errorLayer    noOverlapLayer7 )
     ( errorLayer    noOverlapLayer8 )
     ( errorLayer    noOverlapLayer9 )
     ( errorLayer    noOverlapLayer10 )
     ( errorLayer    noOverlapLayer11 )
     ( errorLayer    noOverlapLayer12 )
     ( errorLayer    noOverlapLayer13 )
     ( errorLayer    noOverlapLayer14 )
     ( errorLayer    noOverlapLayer15 )
     ( errorLayer    noOverlapLayer16 )
     ( errorLayer    noOverlapLayer17 )
     ( errorLayer    noOverlapLayer18 )
     ( errorLayer    noOverlapLayer19 )
     ( errorLayer    noOverlapLayer20 )
     ( errorLayer    noOverlapLayer21 )
     ( errorLayer    noOverlapLayer22 )
     ( errorLayer    noOverlapLayer23 )
     ( errorLayer    noOverlapLayer24 )
     ( errorLayer    noOverlapLayer25 )
     ( errorLayer    noOverlapLayer26 )
     ( errorLayer    noOverlapLayer27 )
     ( errorLayer    noOverlapLayer28 )
     ( errorLayer    noOverlapLayer29 )
     ( errorLayer    noOverlapLayer30 )
     ( errorLayer    noOverlapLayer31 )
     ( errorLayer    noOverlapLayer32 )
     ( errorLayer    noOverlapLayer33 )
     ( errorLayer    noOverlapLayer34 )
     ( errorLayer    noOverlapLayer35 )
     ( errorLayer    noOverlapLayer36 )
     ( errorLayer    noOverlapLayer37 )
     ( errorLayer    noOverlapLayer38 )
     ( errorLayer    noOverlapLayer39 )
     ( errorLayer    noOverlapLayer40 )
     ( errorLayer    noOverlapLayer41 )
     ( errorLayer    noOverlapLayer42 )
     ( errorLayer    noOverlapLayer43 )
     ( errorLayer    noOverlapLayer44 )
     ( errorLayer    noOverlapLayer45 )
     ( errorLayer    noOverlapLayer46 )
     ( errorLayer    noOverlapLayer47 )
     ( errorLayer    noOverlapLayer48 )
     ( errorLayer    noOverlapLayer49 )
     ( errorLayer    noOverlapLayer50 )
     ( errorLayer    noOverlapLayer51 )
     ( errorLayer    noOverlapLayer52 )
     ( errorLayer    noOverlapLayer53 )
     ( errorLayer    noOverlapLayer54 )
     ( errorLayer    noOverlapLayer55 )
     ( errorLayer    noOverlapLayer56 )
     ( errorLayer    noOverlapLayer57 )
     ( errorLayer    noOverlapLayer58 )
     ( errorLayer    noOverlapLayer59 )
     ( errorLayer    noOverlapLayer60 )
     ( errorLayer    noOverlapLayer61 )
     ( errorLayer    noOverlapLayer62 )
     ( errorLayer    noOverlapLayer63 )
     ( errorLayer    noOverlapLayer64 )
     ( errorLayer    noOverlapLayer65 )
     ( errorLayer    noOverlapLayer66 )
     ( errorLayer    noOverlapLayer67 )
     ( errorLayer    noOverlapLayer68 )
     ( errorLayer    noOverlapLayer69 )
     ( errorLayer    noOverlapLayer70 )
     ( errorLayer    noOverlapLayer71 )
     ( errorLayer    noOverlapLayer72 )
     ( errorLayer    noOverlapLayer73 )
     ( errorLayer    noOverlapLayer74 )
     ( errorLayer    noOverlapLayer75 )
     ( errorLayer    noOverlapLayer76 )
     ( errorLayer    noOverlapLayer77 )
     ( errorLayer    noOverlapLayer78 )
     ( errorLayer    noOverlapLayer79 )
     ( errorLayer    noOverlapLayer80 )
     ( errorLayer    noOverlapLayer81 )
     ( errorLayer    noOverlapLayer82 )
     ( errorLayer    noOverlapLayer83 )
     ( errorLayer    noOverlapLayer84 )
     ( errorLayer    noOverlapLayer85 )
     ( errorLayer    noOverlapLayer86 )
     ( errorLayer    noOverlapLayer87 )
     ( errorLayer    noOverlapLayer88 )
     ( errorLayer    noOverlapLayer89 )
     ( errorLayer    noOverlapLayer90 )
     ( errorLayer    noOverlapLayer91 )
     ( errorLayer    noOverlapLayer92 )
     ( errorLayer    noOverlapLayer93 )
     ( errorLayer    noOverlapLayer94 )
     ( errorLayer    noOverlapLayer95 )
     ( errorLayer    noOverlapLayer96 )
     ( errorLayer    noOverlapLayer97 )
     ( errorLayer    noOverlapLayer98 )
     ( errorLayer    noOverlapLayer99 )
     ( errorLayer    noOverlapLayer100 )
     ( errorLayer    noOverlapLayer101 )
     ( errorLayer    noOverlapLayer102 )
     ( errorLayer    noOverlapLayer103 )
     ( errorLayer    noOverlapLayer104 )
     ( errorLayer    noOverlapLayer105 )
     ( errorLayer    noOverlapLayer106 )
     ( errorLayer    noOverlapLayer107 )
     ( errorLayer    noOverlapLayer108 )
     ( errorLayer    noOverlapLayer109 )
     ( errorLayer    noOverlapLayer110 )
     ( errorLayer    noOverlapLayer111 )
     ( errorLayer    noOverlapLayer112 )
     ( errorLayer    noOverlapLayer113 )
     ( errorLayer    noOverlapLayer114 )
     ( errorLayer    noOverlapLayer115 )
     ( errorLayer    noOverlapLayer116 )
     ( errorLayer    noOverlapLayer117 )
     ( errorLayer    noOverlapLayer118 )
     ( errorLayer    noOverlapLayer119 )
    ) ;interconnect
  ) ;virtuosoDefaultExtractorSetup

 ;( group	[override] )
 ;( -----	---------- )
  ( "virtuosoDefaultSetup"	nil

    interconnect(
     ( validLayers   (NW  PWLVS  HVNW  HVPW  ND  PD  PO  NWR  CT  M1  V1  M2  V2  M3  V3  M4  V4  M5  V5M  M6M  PV  PM  ) )
     ( validVias     (VHP  VH5  VH4  VH3  VH2  VH1  CT1  CTNW  CTPW  ) )
     ( errorLayer    noOverlapLayer1 )
     ( errorLayer    noOverlapLayer2 )
     ( errorLayer    noOverlapLayer3 )
     ( errorLayer    noOverlapLayer4 )
     ( errorLayer    noOverlapLayer5 )
     ( errorLayer    noOverlapLayer6 )
     ( errorLayer    noOverlapLayer7 )
     ( errorLayer    noOverlapLayer8 )
     ( errorLayer    noOverlapLayer9 )
     ( errorLayer    noOverlapLayer10 )
     ( errorLayer    noOverlapLayer11 )
     ( errorLayer    noOverlapLayer12 )
     ( errorLayer    noOverlapLayer13 )
     ( errorLayer    noOverlapLayer14 )
     ( errorLayer    noOverlapLayer15 )
     ( errorLayer    noOverlapLayer16 )
     ( errorLayer    noOverlapLayer17 )
     ( errorLayer    noOverlapLayer18 )
     ( errorLayer    noOverlapLayer19 )
     ( errorLayer    noOverlapLayer20 )
     ( errorLayer    noOverlapLayer21 )
     ( errorLayer    noOverlapLayer22 )
     ( errorLayer    noOverlapLayer23 )
     ( errorLayer    noOverlapLayer24 )
     ( errorLayer    noOverlapLayer25 )
     ( errorLayer    noOverlapLayer26 )
     ( errorLayer    noOverlapLayer27 )
     ( errorLayer    noOverlapLayer28 )
     ( errorLayer    noOverlapLayer29 )
     ( errorLayer    noOverlapLayer30 )
     ( errorLayer    noOverlapLayer31 )
     ( errorLayer    noOverlapLayer32 )
     ( errorLayer    noOverlapLayer33 )
     ( errorLayer    noOverlapLayer34 )
     ( errorLayer    noOverlapLayer35 )
     ( errorLayer    noOverlapLayer36 )
     ( errorLayer    noOverlapLayer37 )
     ( errorLayer    noOverlapLayer38 )
     ( errorLayer    noOverlapLayer39 )
     ( errorLayer    noOverlapLayer40 )
     ( errorLayer    noOverlapLayer41 )
     ( errorLayer    noOverlapLayer42 )
     ( errorLayer    noOverlapLayer43 )
     ( errorLayer    noOverlapLayer44 )
     ( errorLayer    noOverlapLayer45 )
     ( errorLayer    noOverlapLayer46 )
     ( errorLayer    noOverlapLayer47 )
     ( errorLayer    noOverlapLayer48 )
     ( errorLayer    noOverlapLayer49 )
     ( errorLayer    noOverlapLayer50 )
     ( errorLayer    noOverlapLayer51 )
     ( errorLayer    noOverlapLayer52 )
     ( errorLayer    noOverlapLayer53 )
     ( errorLayer    noOverlapLayer54 )
     ( errorLayer    noOverlapLayer55 )
     ( errorLayer    noOverlapLayer56 )
     ( errorLayer    noOverlapLayer57 )
     ( errorLayer    noOverlapLayer58 )
     ( errorLayer    noOverlapLayer59 )
     ( errorLayer    noOverlapLayer60 )
     ( errorLayer    noOverlapLayer61 )
     ( errorLayer    noOverlapLayer62 )
     ( errorLayer    noOverlapLayer63 )
     ( errorLayer    noOverlapLayer64 )
     ( errorLayer    noOverlapLayer65 )
     ( errorLayer    noOverlapLayer66 )
     ( errorLayer    noOverlapLayer67 )
     ( errorLayer    noOverlapLayer68 )
     ( errorLayer    noOverlapLayer69 )
     ( errorLayer    noOverlapLayer70 )
     ( errorLayer    noOverlapLayer71 )
     ( errorLayer    noOverlapLayer72 )
     ( errorLayer    noOverlapLayer73 )
     ( errorLayer    noOverlapLayer74 )
     ( errorLayer    noOverlapLayer75 )
     ( errorLayer    noOverlapLayer76 )
     ( errorLayer    noOverlapLayer77 )
     ( errorLayer    noOverlapLayer78 )
     ( errorLayer    noOverlapLayer79 )
     ( errorLayer    noOverlapLayer80 )
     ( errorLayer    noOverlapLayer81 )
     ( errorLayer    noOverlapLayer82 )
     ( errorLayer    noOverlapLayer83 )
     ( errorLayer    noOverlapLayer84 )
     ( errorLayer    noOverlapLayer85 )
     ( errorLayer    noOverlapLayer86 )
     ( errorLayer    noOverlapLayer87 )
     ( errorLayer    noOverlapLayer88 )
     ( errorLayer    noOverlapLayer89 )
     ( errorLayer    noOverlapLayer90 )
     ( errorLayer    noOverlapLayer91 )
     ( errorLayer    noOverlapLayer92 )
     ( errorLayer    noOverlapLayer93 )
     ( errorLayer    noOverlapLayer94 )
     ( errorLayer    noOverlapLayer95 )
     ( errorLayer    noOverlapLayer96 )
     ( errorLayer    noOverlapLayer97 )
     ( errorLayer    noOverlapLayer98 )
     ( errorLayer    noOverlapLayer99 )
     ( errorLayer    noOverlapLayer100 )
     ( errorLayer    noOverlapLayer101 )
     ( errorLayer    noOverlapLayer102 )
     ( errorLayer    noOverlapLayer103 )
     ( errorLayer    noOverlapLayer104 )
     ( errorLayer    noOverlapLayer105 )
     ( errorLayer    noOverlapLayer106 )
     ( errorLayer    noOverlapLayer107 )
     ( errorLayer    noOverlapLayer108 )
     ( errorLayer    noOverlapLayer109 )
     ( errorLayer    noOverlapLayer110 )
     ( errorLayer    noOverlapLayer111 )
     ( errorLayer    noOverlapLayer112 )
     ( errorLayer    noOverlapLayer113 )
     ( errorLayer    noOverlapLayer114 )
     ( errorLayer    noOverlapLayer115 )
     ( errorLayer    noOverlapLayer116 )
     ( errorLayer    noOverlapLayer117 )
     ( errorLayer    noOverlapLayer118 )
     ( errorLayer    noOverlapLayer119 )
    ) ;interconnect
  ) ;virtuosoDefaultSetup

 ;( group	[override] )
 ;( -----	---------- )
  ( "VLMDefaultSetup"	nil

    interconnect(
     ( validLayers   (NW  PWLVS  HVNW  HVPW  ND  PD  PO  NWR  CT  M1  V1  M2  V2  M3  V3  M4  V4  M5  V5M  M6M  PV  PM  ) )
     ( validVias     (VHP  VH5  VH4  VH3  VH2  VH1  CT1  CTNW  CTPW  ) )
     ( errorLayer    noOverlapLayer1 )
     ( errorLayer    noOverlapLayer2 )
     ( errorLayer    noOverlapLayer3 )
     ( errorLayer    noOverlapLayer4 )
     ( errorLayer    noOverlapLayer5 )
     ( errorLayer    noOverlapLayer6 )
     ( errorLayer    noOverlapLayer7 )
     ( errorLayer    noOverlapLayer8 )
     ( errorLayer    noOverlapLayer9 )
     ( errorLayer    noOverlapLayer10 )
     ( errorLayer    noOverlapLayer11 )
     ( errorLayer    noOverlapLayer12 )
     ( errorLayer    noOverlapLayer13 )
     ( errorLayer    noOverlapLayer14 )
     ( errorLayer    noOverlapLayer15 )
     ( errorLayer    noOverlapLayer16 )
     ( errorLayer    noOverlapLayer17 )
     ( errorLayer    noOverlapLayer18 )
     ( errorLayer    noOverlapLayer19 )
     ( errorLayer    noOverlapLayer20 )
     ( errorLayer    noOverlapLayer21 )
     ( errorLayer    noOverlapLayer22 )
     ( errorLayer    noOverlapLayer23 )
     ( errorLayer    noOverlapLayer24 )
     ( errorLayer    noOverlapLayer25 )
     ( errorLayer    noOverlapLayer26 )
     ( errorLayer    noOverlapLayer27 )
     ( errorLayer    noOverlapLayer28 )
     ( errorLayer    noOverlapLayer29 )
     ( errorLayer    noOverlapLayer30 )
     ( errorLayer    noOverlapLayer31 )
     ( errorLayer    noOverlapLayer32 )
     ( errorLayer    noOverlapLayer33 )
     ( errorLayer    noOverlapLayer34 )
     ( errorLayer    noOverlapLayer35 )
     ( errorLayer    noOverlapLayer36 )
     ( errorLayer    noOverlapLayer37 )
     ( errorLayer    noOverlapLayer38 )
     ( errorLayer    noOverlapLayer39 )
     ( errorLayer    noOverlapLayer40 )
     ( errorLayer    noOverlapLayer41 )
     ( errorLayer    noOverlapLayer42 )
     ( errorLayer    noOverlapLayer43 )
     ( errorLayer    noOverlapLayer44 )
     ( errorLayer    noOverlapLayer45 )
     ( errorLayer    noOverlapLayer46 )
     ( errorLayer    noOverlapLayer47 )
     ( errorLayer    noOverlapLayer48 )
     ( errorLayer    noOverlapLayer49 )
     ( errorLayer    noOverlapLayer50 )
     ( errorLayer    noOverlapLayer51 )
     ( errorLayer    noOverlapLayer52 )
     ( errorLayer    noOverlapLayer53 )
     ( errorLayer    noOverlapLayer54 )
     ( errorLayer    noOverlapLayer55 )
     ( errorLayer    noOverlapLayer56 )
     ( errorLayer    noOverlapLayer57 )
     ( errorLayer    noOverlapLayer58 )
     ( errorLayer    noOverlapLayer59 )
     ( errorLayer    noOverlapLayer60 )
     ( errorLayer    noOverlapLayer61 )
     ( errorLayer    noOverlapLayer62 )
     ( errorLayer    noOverlapLayer63 )
     ( errorLayer    noOverlapLayer64 )
     ( errorLayer    noOverlapLayer65 )
     ( errorLayer    noOverlapLayer66 )
     ( errorLayer    noOverlapLayer67 )
     ( errorLayer    noOverlapLayer68 )
     ( errorLayer    noOverlapLayer69 )
     ( errorLayer    noOverlapLayer70 )
     ( errorLayer    noOverlapLayer71 )
     ( errorLayer    noOverlapLayer72 )
     ( errorLayer    noOverlapLayer73 )
     ( errorLayer    noOverlapLayer74 )
     ( errorLayer    noOverlapLayer75 )
     ( errorLayer    noOverlapLayer76 )
     ( errorLayer    noOverlapLayer77 )
     ( errorLayer    noOverlapLayer78 )
     ( errorLayer    noOverlapLayer79 )
     ( errorLayer    noOverlapLayer80 )
     ( errorLayer    noOverlapLayer81 )
     ( errorLayer    noOverlapLayer82 )
     ( errorLayer    noOverlapLayer83 )
     ( errorLayer    noOverlapLayer84 )
     ( errorLayer    noOverlapLayer85 )
     ( errorLayer    noOverlapLayer86 )
     ( errorLayer    noOverlapLayer87 )
     ( errorLayer    noOverlapLayer88 )
     ( errorLayer    noOverlapLayer89 )
     ( errorLayer    noOverlapLayer90 )
     ( errorLayer    noOverlapLayer91 )
     ( errorLayer    noOverlapLayer92 )
     ( errorLayer    noOverlapLayer93 )
     ( errorLayer    noOverlapLayer94 )
     ( errorLayer    noOverlapLayer95 )
     ( errorLayer    noOverlapLayer96 )
     ( errorLayer    noOverlapLayer97 )
     ( errorLayer    noOverlapLayer98 )
     ( errorLayer    noOverlapLayer99 )
     ( errorLayer    noOverlapLayer100 )
     ( errorLayer    noOverlapLayer101 )
     ( errorLayer    noOverlapLayer102 )
     ( errorLayer    noOverlapLayer103 )
     ( errorLayer    noOverlapLayer104 )
     ( errorLayer    noOverlapLayer105 )
     ( errorLayer    noOverlapLayer106 )
     ( errorLayer    noOverlapLayer107 )
     ( errorLayer    noOverlapLayer108 )
     ( errorLayer    noOverlapLayer109 )
     ( errorLayer    noOverlapLayer110 )
     ( errorLayer    noOverlapLayer111 )
     ( errorLayer    noOverlapLayer112 )
     ( errorLayer    noOverlapLayer113 )
     ( errorLayer    noOverlapLayer114 )
     ( errorLayer    noOverlapLayer115 )
     ( errorLayer    noOverlapLayer116 )
     ( errorLayer    noOverlapLayer117 )
     ( errorLayer    noOverlapLayer118 )
     ( errorLayer    noOverlapLayer119 )
    ) ;interconnect
  ) ;VLMDefaultSetup

 ;( group	[override] )
 ;( -----	---------- )
  ( "foundry"	nil

    spacings(
     ( minWidth                   "NW"				0.62 ) 		; NW_w
     ( minSameNetSpacing          "NW"				0.62 )		; NW_s
     ( minDiffNetSpacing          "NW"				1.2  )		; NW_sp
     ( minArea                    "NW"				1.55 )		; NW_a
     ( minWidth                   "HVNW"			0.62 )		; HVNW_w
     ( minSameNetSpacing          "HVNW"			0.62 )		; HVNW_s
     ( minDiffNetSpacing          "HVNW"			1.2  )		; HVNW_sp
     ( minSpacing                 "HVNW"	"NW"		1.2  )		; HVNW_c
     ( minArea                    "HVNW"			1.55 )		; HVNW_a
     ( minWidth                   "HVPW"			0.62 )		; HVPW_w
     ( minWidth                   "NWHVPW"			0.62 )		; HVPW_wa1
     ( minWidth                   "HVNWPW"			0.62 )		; HVPW_wa2
     ( minSpacing                 "HVPW"			0.62 )		; HVPW_s
     ( minSpacing                 "HVPWAVONW"			0.62 )		; HVPW_ct1
     ( minSpacing                 "HVPWAVOHVNW"			0.62 )		; HVPW_ct2
     ( minArea                    "HVPW"			1.55 )		; HVPW_a
     ( minHoleArea                "NWHVNWPW"			1.55 )		; HVPW_db
     ( minWidth                   "ND"				0.11 )		; ND_w
     ( minDiagonalWidth           "ND"				0.18 )		; ND_w45
     ( minSpacing                 "ND"				0.14 )		; ND_s
     ( minDiagonalSpacing         "ND"				0.18 )		; ND_s45
     ( minSpacing                 "NDAVONWHVNWPW"	"NW"	0.22 )		; ND_cs1
     ( minSpacing                 "NDAVONWHVNWPW"	"HVNW"	0.22 )		; ND_cs2
     ( minArea                    "ND"				0.06 )		; ND_a
     ( minWidth                   "PD"				0.11 )		; PD_w
     ( minDiagonalWidth           "PD"				0.18 )		; PD_w45
     ( minSpacing                 "PD"				0.14 )		; PD_s
     ( minDiagonalSpacing         "PD"				0.18 )		; PD_s45
     ( minSpacing                 "PDAVONWHVNWPW"	"NW"	0.17 )		; PD_cs1
     ( minSpacing                 "PDAVONWHVNWPW"	"HVNW"	0.17 )		; PD_cs2
     ( minSpacing                 "PDAVONWHVNWPW"	"HVPW"	0.17 )		; PD_cs3
     ( minSpacing                 "PDAVOND"		"ND"	0.15 )		; PD_ct
     ( minArea                    "PD"				0.06 )		; PD_a
     ( minHoleArea                "NPD"				0.1 )		; PD_db
     ( minWidth                   "PO"				0.1  )		; PO_w
     ( minSpacing                 "PO"				0.14 )		; PO_s
     ( minSpacing                 "POND"			0.15 )		; PO_si1
     ( minSpacing                 "POPD"			0.15 )		; PO_si2
     ( minSpacing                 "POSTRND"	"ND"		0.05 )		; PO_cd1
     ( minSpacing                 "POSTRPD"	"PD"		0.05 )		; PO_cd2
     ( minArea                    "PO"				0.06 )		; PO_a
     ( minHoleArea                "PO"				0.11 )		; PO_d
     ( diagonalShapesAllowed      "PO"				nil )		; PO_p45
     ( minWidth                   "NI"				0.24 )		; NI_w
     ( minWidth                   "NIHVPW"			0.24 )		; NI_wk
     ( minSpacing                 "NI"				0.24 )		; NI_s
     ( minArea                    "NI"				0.123 )		; NI_a
     ( minArea                    "NINONWHVNWPW"		0.123 )		; NI_ao
     ( minHoleArea                "NI"				0.123 )		; NI_d
     ( diagonalShapesAllowed      "NI"				nil )		; NI_p45
     ( minWidth                   "PI"				0.24 )		; PI_w
     ( minWidth                   "PINW"			0.24 )		; PI_wk1
     ( minWidth                   "PIHVNW"			0.24 )		; PI_wk2
     ( minSpacing                 "PI"				0.24 )		; PI_s
     ( minArea                    "PI"				0.123 )		; PI_a
     ( minArea                    "PINONWHVNWPW"		0.123 )		; PI_ao
     ( minHoleArea                "PI"				0.123 )		; PI_d
     ( diagonalShapesAllowed      "PI"				nil )		; PI_p45
     ( minWidth                   "NCM"				0.24 )		; NCM_w
     ( minSpacing                 "NCM"				0.28 )		; NCM_s
     ( minSpacing                 "NCM"		"POND"		0.22 )		; NCM_cq
     ( minArea                    "NCM"				1.04 )		; NCM_a
     ( minHoleArea                "NCM"				1.55 )		; NCM_d
     ( diagonalShapesAllowed      "NCM"				nil )		; NCM_p45
     ( minWidth                   "NCH"				0.24 )		; NCH_w
     ( minSpacing                 "NCH"				0.28 )		; NCH_s
     ( minSpacing                 "NCH"		"POND"		0.22 )		; NCH_cq
     ( minArea                    "NCH"				1.04 )		; NCH_a
     ( minHoleArea                "NCH"				1.55 )		; NCH_d
     ( diagonalShapesAllowed      "NCH"				nil )		; NCH_p45
     ( minWidth                   "NSM"				0.24 )		; NSM_w
     ( minSpacing                 "NSM"				0.28 )		; NSM_s
     ( minSpacing                 "NSM"		"POND"		0.22 )		; NSM_cq
     ( minArea                    "NSM"				1.04 )		; NSM_a
     ( minHoleArea                "NSM"				1.55 )		; NSM_d
     ( diagonalShapesAllowed      "NSM"				nil )		; NSM_p45
     ( minWidth                   "PCM"				0.24 )		; PCM_w
     ( minSpacing                 "PCM"				0.28 )		; PCM_s
     ( minSpacing                 "PCM"		"POPD"		0.22 )		; PCM_cq
     ( minArea                    "PCM"				1.04 )		; PCM_a
     ( minHoleArea                "PCM"				1.55 )		; PCM_d
     ( diagonalShapesAllowed      "PCM"				nil )		; PCM_p45
     ( minWidth                   "PCH"				0.24 )		; PCH_w
     ( minSpacing                 "PCH"				0.28 )		; PCH_s
     ( minSpacing                 "PCH"		"POPD"		0.22 )		; PCH_cq
     ( minArea                    "PCH"				1.04 )		; PCH_a
     ( minHoleArea                "PCH"				1.55 )		; PCH_d
     ( diagonalShapesAllowed      "PCH"				nil )		; PCH_p45
     ( minWidth                   "PS"				0.24 )		; PS_w
     ( minSpacing                 "PS"				0.28 )		; PS_s
     ( minSpacing                 "PS"		"POPD"		0.22 )		; PS_cq
     ( minArea                    "PS"				1.04 )		; PS_a
     ( minHoleArea                "PCMPS"			1.55 )		; PS_db
     ( diagonalShapesAllowed      "PS"				nil )		; PS_p45
     ( minWidth                   "HV18"			0.62 )		; HV18_w
     ( minSpacing                 "HV18"			0.62 )		; HV18_s
     ( minSpacing                 "NDHV18"			0.18 )		; HV18_si1
     ( minSpacing                 "PDHV18"			0.18 )		; HV18_si2
     ( minSpacing                 "PONDHV18"			0.25 )		; HV18_sj1
     ( minSpacing                 "POPDHV18"			0.25 )		; HV18_sj2
     ( minSpacing                 "HV18"	"NDOUTNWHVNW"	0.62 )		; HV18_co1
     ( minSpacing                 "HV18"	"PDINNWHVNW"	0.62 )		; HV18_co2
     ( minArea                    "HV18"			1.55 )		; HV18_a
     ( minHoleArea                "HV18"			1.55 )		; HV18_d
     ( minWidth                   "HV25"			0.62 )		; HV25
     ( minSpacing                 "HV25"			0.62 )		; HV25_s
     ( minSpacing                 "NDHV25"			0.18 )		; HV25_si1
     ( minSpacing                 "PDHV25"			0.18 )		; HV25_si2
     ( minSpacing                 "PONDHV25"			0.25 )		; HV25_sj1
     ( minSpacing                 "POPDHV25"			0.25 )		; HV25_sj2
     ( minSpacing                 "HV25"	"NDOUTNWHVNW"	0.62 )		; HV25_co1
     ( minSpacing                 "HV25"	"PDINNWHVNW"	0.62 )		; HV25_co2
     ( minArea                    "HV25"			1.55 )		; HV25_a
     ( minHoleArea                "HV25"			1.55 )		; HV25_d
     ( minWidth                   "HV33"			0.62 )		; HV33
     ( minSpacing                 "HV33"			0.62 )		; HV33_s
     ( minSpacing                 "NDHV33"			0.18 )		; HV33_si1
     ( minSpacing                 "PDHV33"			0.18 )		; HV33_si2
     ( minSpacing                 "PONDHV33"			0.25 )		; HV33_sj1
     ( minSpacing                 "POPDHV33"			0.25 )		; HV33_sj2
     ( minSpacing                 "HV33"	"NDOUTNWHVNW"	0.62 )		; HV33_co1
     ( minSpacing                 "HV33"	"PDINNWHVNW"	0.62 )		; HV33_co2
     ( minArea                    "HV33"			1.55 )		; HV33_a
     ( minHoleArea                "HV33"			1.55 )		; HV33_d
     ( minWidth                   "CT"				0.12 )		; CT_wh
     ( maxWidth                   "CT"				0.12 )		; CT_wh
     ( minSpacing                 "CT"				0.14 )		; CT_s
     ( viaSpacing                 "CT"		(3	0.16	0.16) )		; CT_sa
     ( minSpacing                 "CT"		"PO"		0.08 )		; CT_co
     ( minSpacing                 "CTPO"	"ND"		0.1 )		; CT_cq1
     ( minSpacing                 "CTPO"	"PD"		0.1 )		; CT_cq2
     ( minSpacing                 "CTND"	"PDND"		0.06 )		; CT_ca1
     ( minSpacing                 "CTPD"	"NDPD"		0.06 )		; CT_ca2
     ( diagonalShapesAllowed      "CT"				nil )		; CT_p45
     ( minWidth                   "M1"				0.12 )		; M1_w
     ( minDiagonalWidth           "M1"				0.19 )		; M1_w45
     ( maxWidth                   "M1NODA"			1.0 )		; M1_wf
     ( minDiagonalSpacing         "M1"				0.19 )		; M1_s45
     ( minHoleArea                "M1"				0.2 )		; M1_d
     ( minWidth                   "V1"				0.13 )		; V1_wh
     ( maxWidth                   "V1"				0.13 )		; V1_wh
     ( minSpacing                 "V1"				0.15 )		; V1_s
     ( viaSpacing                 "V1"		(3	0.19	0.19) )		; V1_sa
     ( diagonalShapesAllowed      "V1"				nil )		; V1_p45
     ( minWidth                   "M2"				0.14 )		; M2_w
     ( minDiagonalWidth           "M2"				0.19 )		; M2_w45
    ;( protrusionWidth            "M2"		(0.56	0.28	0.28) )		; M2_wp
     ( maxWidth                   "M2NODA"			3.0 )		; M2_wf
     ( minDiagonalSpacing         "M2"				0.19 )		; M2_s45
     ( minArea                    "M2"				0.07 )		; M2_a
     ( minHoleArea                "M2"				0.2 )		; M2_d
     ( minWidth                   "V2"				0.13 )		; V2_wh
     ( maxWidth                   "V2"				0.13 )		; V2_wh
     ( minSpacing                 "V2"				0.15 )		; V2_s
     ( viaSpacing                 "V2"		(3	0.19	0.19) )		; V2_sa
     ( diagonalShapesAllowed      "V2"				nil )		; V2_p45
     ( minWidth                   "M3"				0.14 )		; M3_w
     ( minDiagonalWidth           "M3"				0.19 )		; M3_w45
    ;( protrusionWidth            "M3"		(0.56	0.28	0.28) )		; M3_wp
     ( maxWidth                   "M3"				3.0 )		; M3_wg
     ( minDiagonalSpacing         "M3"				0.19 )		; M3_s45
     ( minArea                    "M3"				0.07 )		; M3_a
     ( minHoleArea                "M3"				0.2 )		; M3_d
     ( minWidth                   "V3"				0.13 )		; V3_wh
     ( maxWidth                   "V3"				0.13 )		; V3_wh
     ( minSpacing                 "V3"				0.15 )		; V3_s
     ( viaSpacing                 "V3"		(3	0.19	0.19) )		; V3_sa
     ( diagonalShapesAllowed      "V3"				nil )		; V3_p45
     ( minWidth                   "M4"				0.14 )		; M4_w
     ( minDiagonalWidth           "M4"				0.19 )		; M4_w45
    ;( protrusionWidth            "M4"		(0.56	0.28	0.28) )		; M4_wp
     ( maxWidth                   "M4"				3.0 )		; M4_wg
     ( minDiagonalSpacing         "M4"				0.19 )		; M4_s45
     ( minArea                    "M4"				0.07 )		; M4_a
     ( minHoleArea                "M4"				0.2 )		; M4_d
     ( minWidth                   "V4"				0.13 )		; V4_wh
     ( maxWidth                   "V4"				0.13 )		; V4_wh
     ( minSpacing                 "V4"				0.15 )		; V4_s
     ( viaSpacing                 "V4"		(3	0.19	0.19) )		; V4_sa
     ( diagonalShapesAllowed      "V4"				nil )		; V4_p45
     ( minWidth                   "M5"				0.14 )		; M5_w
     ( minDiagonalWidth           "M5"				0.19 )		; M5_w45
    ;( protrusionWidth            "M5"		(0.56	0.28	0.28) )		; M5_wp
     ( maxWidth                   "M5"				3.0 )		; M5_wg
     ( minDiagonalSpacing         "M5"				0.19 )		; M5_s45
     ( minArea                    "M5"				0.07 )		; M5_a
     ( minHoleArea                "M5"				0.2 )		; M5_d
     ( minWidth                   "V5M"				0.36 )		; V5M_wh
     ( maxWidth                   "V5M"				0.36 )		; V5M_wh
     ( minSpacing                 "V5M"				0.34 )		; V5M_s
     ( viaSpacing                 "V5M"		(3	0.54	0.54) )		; V5M_sb
     ( diagonalShapesAllowed      "V5M"				nil )		; V5M_p45
     ( minWidth                   "M6M"				0.42 )		; M6M_w
     ( minDiagonalWidth           "M6M"				0.6 )		; M6M_w45
     ( maxWidth                   "M6M"				12.0 )		; M6M_wg
     ( minDiagonalSpacing         "M6M"				0.6 )		; M6M_s45
     ( minArea                    "M6M"				0.565 )		; M6M_a
     ( minHoleArea                "M6M"				0.8 )		; M6M_d
     ( minWidth                   "PV"				2.0 )		; PV_wh
     ( maxWidth                   "PV"				2.0 )		; PV_wh
     ( minSpacing                 "PV"				2.0 )		; PV_s
     ( minWidth                   "PM"				2.0 )		; PM_w
     ( maxWidth                   "PM"				200.0 )		; PM_wg
     ( minSpacing                 "PM"				2.0 )		; PM_s
     ( minArea                    "PM"				12.6 )		; PM_a
     ( minWidth                   "NNA"				1.52 )		; NNA_w
     ( minSpacing                 "NNA"				0.62 )		; NNA_s
     ( minSpacing                 "NNA"		"NW"		1.2 )		; NNA_c1
     ( minSpacing                 "NNA"		"HVNW"		1.2 )		; NNA_c2
     ( minSpacing                 "NNA"		"PD"		0.6 )		; NNA_c3
     ( minSpacing                 "NNA"		"HVPW"		1.2 )		; NNA_co1
     ( minSpacing                 "NNA"		"ND"		0.6 )		; NNA_co2
     ( minArea                    "NNA"				2.31 )		; NNA_a
     ( minHoleArea                "NNA"				1.55 )		; NNA_d
     ( minWidth                   "NWR"				1.8 )		; NWR_w
     ( minWidth                   "NWRHVPW"			0.62 )		; NWR_wa
     ( minSpacing                 "NWR"				1.2 )		; NWR_s
     ( minSpacing                 "NWR"		"NW"		1.2 )		; NWR_c1
     ( minSpacing                 "NWR"		"HVNW"		1.2 )		; NWR_c2
     ( minSpacing                 "NWR"		"PD"		0.4 )		; NWR_c3
     ( minSpacing                 "NWR"		"NNA"		1.2 )		; NWR_c4
     ( minSpacing                 "NWR"		"ND"		0.4 )		; NWR_co
     ( minSpacing                 "NWRAVOHVPW"	"HVPW"		0.62 )		; NWR_ct
     ( minArea                    "NWR"				3.24 )		; NWR_a
     ( minHoleArea                "NWRHVPW"			1.55 )		; NWR_db
     ( minWidth                   "NPPO"			0.62 )		; NPPO_w
     ( minSpacing                 "NPPO"			0.62 )		; NPPO_s
     ( minSpacing                 "NPPO"	"NNA"		1.2 )		; NPPO_c1
     ( minSpacing                 "NPPO"	"NWR"		1.2 )		; NPPO_c2
     ( minSpacing                 "NPPO"	"NI"		0.24 )		; NPPO_co
     ( minSpacing                 "NPPOAVOPI"	"PI"		0.22 )		; NPPO_ct
     ( minArea                    "NPPO"			1.55 )		; NPPO_a
     ( minHoleArea                "NPPO"			1.55 )		; NPPO_d
     ( minWidth                   "PPPO"			0.62 )		; PPPO_w
     ( minWidth                   "PPPONW"			0.62 )		; PPPO_wa1
     ( minWidth                   "PPPOHVNW"			0.62 )		; PPPO_wa2
     ( minSpacing                 "PPPO"			0.62 )		; PPPO_s
     ( minSpacing                 "PPPO"	"NNA"		1.2 )		; PPPO_c1
     ( minSpacing                 "PPPO"	"NWR"		1.2 )		; PPPO_c2
     ( minSpacing                 "PPPO"	"NW"		0.62 )		; PPPO_ce1
     ( minSpacing                 "PPPO"	"HVNW"		0.62 )		; PPPO_ce2
     ( minSpacing                 "PPPO"	"PI"		0.24 )		; PPPO_co
     ( minSpacing                 "PPPOAVONI"	"NI"		0.22 )		; PPPO_ct
     ( minArea                    "PPPO"			1.55 )		; PPPO_a
     ( minHoleArea                "PPPO"			1.55 )		; PPPO_d
     ( minWidth                   "SB"				0.43 )		; SB_w
     ( minSpacing                 "SB"				0.43 )		; SB_s
     ( minSpacing                 "SB"		"CT"		0.22 )		; SB_c
     ( minSpacing                 "SB"		"ND"		0.22 )		; SB_cd2
     ( minSpacing                 "SB"		"PD"		0.22 )		; SB_cd3
     ( minSpacing                 "SB"		"POPD"		0.38 )		; SB_cr2
     ( minArea                    "SB"				1.0 )		; SB_a
     ( minHoleArea                "SB"				1.0 )		; SB_d
     ( minWidth                   "GC"				1.8 )		; GC_w
     ( minWidth                   "GCNW"			1.8 )		; GC_wk1
     ( minWidth                   "GCHVNW"			1.8 )		; GC_wk2
     ( minWidth                   "NIGCNW"			0.24 )		; GC_wm1
     ( minWidth                   "NIGCHVNW"			0.24 )		; GC_wm2
     ( minSpacing                 "GC"				1.2 )		; GC_s
     ( minSpacing                 "GC"		"PD"		0.4 )		; GC_c1
     ( minSpacing                 "GC"		"NWR"		1.2 )		; GC_c2
     ( minSpacing                 "GC"		"NW"		1.2 )		; GC_co1
     ( minSpacing                 "GC"		"HVNW"		1.2 )		; GC_co2
     ( minSpacing                 "GC"		"ND"		0.4 )		; GC_co3
     ( minArea                    "GC"				3.24 )		; GC_a
     ( minArea                    "NIGCNW"			0.123 )		; GC_ai1
     ( minArea                    "NIGCHVNW"			0.123 )		; GC_ai2
     ( minHoleArea                "GC"				3.24 )		; GC_d
     ( minWidth                   "NOWELL"			0.62 )		; NOWELL_w
     ( minSpacing                 "NOWELL"			0.62 )		; NOWELL_s
     ( minSpacing                 "NOWELLOUTNIODRC"	"NW"	1.75 )		; NOWELL_c1
     ( minSpacing                 "NOWELLOUTNIODRC"	"HVNW"	1.75 )		; NOWELL_c2
     ( minSpacing                 "NOWELLOUTNIODRC"	"HVPW"	1.75 )		; NOWELL_c3
     ( minSpacing                 "NOWELLOUTNIODRC"	"ND"	2.0 )		; NOWELL_c4
     ( minSpacing                 "NOWELLOUTNIODRC"	"PD"	2.0 )		; NOWELL_c5
     ( minSpacing                 "NOWELL"	"NNA"		1.75 )		; NOWELL_c6
     ( minSpacing                 "NOWELL"	"NWR"		1.75 )		; NOWELL_c7
     ( minSpacing                 "NOWELL"	"NPPO"		1.75 )		; NOWELL_c8
     ( minSpacing                 "NOWELL"	"PPPO"		1.75 )		; NOWELL_c9
     ( minSpacing                 "NOWELL"	"GC"		1.75 )		; NOWELL_c10
     ( minArea                    "NOWELL"			1.55 )		; NOWELL_a
     ( minHoleArea                "NOWELL"			1.55 )		; NOWELL_d
     ( minWidth                   "CI"				1.6 )		; CI_w1
     ( minWidth                   "POCI"			1.0 )		; CI_w2
     ( minSpacing                 "CI"				0.62 )		; CI_s
     ( minSpacing                 "CI"		"CT"		0.2 )		; CI_c1
     ( minSpacing                 "CI"		"ND"		0.2 )		; CI_co1
     ( minSpacing                 "CI"		"PD"		0.2 )		; CI_co2
     ( minArea                    "CI"				3.0 )		; CI_a
     ( minHoleArea                "CI"				3.0 )		; CI_d
     ( minWidth                   "DNW"				8.0 )		; DNW_w
     ( minSpacing                 "DNW"				8.0 )		; DNW_s
     ( minSpacing                 "DNW"		"NNA"		6.5 )		; DNW_c1
     ( minSpacing                 "DNW"		"NWR"		6.5 )		; DNW_c2
     ( minSpacing                 "DNW"		"NOWELL"	6.5 )		; DNW_c3
     ( minSpacing                 "DNW"		"NWHVNW"	6.5 )		; DNW_ch
     ( minSpacing                 "DNW"		"NDOUTNWHVNW"	3.0 )		; DNW_cs1
     ( minSpacing                 "DNW"		"PDOUTNWHVNW"	3.0 )		; DNW_cs2
     ( minSpacing                 "DNW"		"NDINNWHVNW"	0.5 )		; DNW_cq1
     ( minSpacing                 "DNW"		"PDINNWHVNW"	1.0 )		; DNW_cq2
     ( minArea                    "DNW"				64.0 )		; DNW_a
     ( minHoleArea                "DNW"				64.0 )		; DNW_d
     ( minWidth                   "NCHT"			0.56 )		; NCHT_w
     ( minSpacing                 "NCHT"			0.62 )		; NCHT_s
     ( minSpacing                 "NCHT"	"POND"		0.32 )		; NCHT_cq
     ( minArea                    "NCHT"			1.55 )		; NCHT_a
     ( minHoleArea                "NCHT"			1.04 )		; NCHT_d
     ( diagonalShapesAllowed      "NCHT"			nil )		; NCHT_p45
     ( minWidth                   "PCHT"			0.56 )		; PCHT_w
     ( minSpacing                 "PCHT"			0.62 )		; PCHT_s
     ( minSpacing                 "PCHT"	"POPD"		0.32 )		; PCHT_cq
     ( minArea                    "PCHT"			1.55 )		; PCHT_a
     ( minHoleArea                "PCHT"			1.04 )		; PCHT_d
     ( diagonalShapesAllowed      "PCHT"			nil )		; PCHT_p45
    ) ;spacings

    orderedSpacings(
     ( minEnclosure               "NWENCND"	"ND"		0.17 )		; ND_em1
     ( minEnclosure               "HVNWENCND"	"ND"		0.17 )		; ND_em2
     ( minEnclosure               "NWENCPD"	"PD"		0.22 )		; PD_em1
     ( minEnclosure               "HVNWENCPD"	"PD"		0.45 )		; PD_em2
     ( minEnclosure               "HVPWENCPD"	"PD"		0.17 )		; PD_em3
     ( minExtension               "PO"		"ND"		0.16 )		; PO_o1
     ( minExtension               "PO"		"PD"		0.16 )		; PO_o2
     ( minExtension               "ND"		"PO"		0.18 )		; PO_o3
     ( minExtension               "PD"		"PO"		0.18 )		; PO_o4
     ( minExtension               "NI"		"NW"		0.24 )		; NI_ot1
     ( minExtension               "NI"		"HVNW"		0.24 )		; NI_ot2
     ( minExtension               "NI"		"HVPW"		0.24 )		; NI_ot3
     ( minExtension               "PI"		"NW"		0.24 )		; PI_ot1
     ( minExtension               "PI"		"HVNW"		0.24 )		; PI_ot2
     ( minExtension               "PI"		"HVPW"		0.24 )		; PI_ot3
     ( minEnclosure               "NCM"		"POND"		0.22 )		; NCM_en
     ( minEnclosure               "NCM"		"ND"		0.07 )		; NCM_em
     ( minEnclosure               "NCH"		"POND"		0.22 )		; NCH_en
     ( minEnclosure               "NCH"		"ND"		0.07 )		; NCH_em
     ( minEnclosure               "NSM"		"POND"		0.22 )		; NSM_en
     ( minEnclosure               "NSM"		"ND"		0.07 )		; NSM_em
     ( minEnclosure               "PCM"		"POPD"		0.22 )		; PCM_en
     ( minEnclosure               "PCM"		"PD"		0.07 )		; PCM_em
     ( minEnclosure               "PCH"		"POPD"		0.22 )		; PCH_en
     ( minEnclosure               "PCH"		"PD"		0.07 )		; PCH_em
     ( minEnclosure               "PS"		"POPD"		0.22 )		; PS_en
     ( minEnclosure               "PS"		"PD"		0.07 )		; PS_em
;     ( minOppExtension            "PO"		"CT"		(0.04 0.05) )	; CT_eg1
;     ( minOppExtension            "ND"		"CT"		(0.04 0.05) )	; CT_eg2
;     ( minOppExtension            "PD"		"CT"		(0.04 0.05) )	; CT_eg3
;     ( minOppExtension            "M1"		"CTNOSRAM"	(0.0 0.05) )	; M1_eh
;     ( minOppExtension            "M1"		"V1NOSRAM"	(0.005 0.05) )	; V1_ed
     ( minExtension               "M5"		"V5M"		0.03 )		; V5M_e
;     ( minOppExtension            "M6M"		"V5M"		(0.03 0.09) )	; M6M_ee
     ( minExtension               "M6M"		"PV"		0.5 )		; PV_e
     ( minExtension               "PM"		"PV"		1.0 )		; PM_e
     ( minExtension               "PO"		"NDNNA"		0.35 )		; NNA_oa
     ( minEnclosure               "HVPW"	"NNA"		0.62 )		; NNA_em
     ( minExtension               "NI"		"NWR"		0.24 )		; NWR_ot
     ( minEnclosure               "NI"		"NDNWR"		0.4 )		; NWR_en1
     ( minEnclosure               "ND"		"CTNWR"		0.3 )		; NWR_en2
     ( minEnclosure               "NWR"		"ND"		0.4 )		; NWR_em
     ( minExtension               "NW"		"NPPO"		0.62 )		; NPPO_o1
     ( minExtension               "HVNW"	"NPPO"		0.62 )		; NPPO_o2
     ( minEnclosure               "NI"		"PONPPO"	0.22 )		; NPPO_en1
     ( minEnclosure               "ND"		"CTNPPO"	0.2 )		; NPPO_en2
     ( minEnclosure               "PO"		"CTNPPO"	0.2 )		; NPPO_en3
     ( minEnclosure               "NPPO"	"ND"		0.32 )		; NPPO_em1
     ( minEnclosure               "NPPO"	"PO"		0.32 )		; NPPO_em2
     ( minEnclosure               "NPPO"	"NI"		0.1 )		; NPPO_em3
     ( minEnclosure               "PI"		"POPPPO"	0.22 )		; PPPO_en1
     ( minEnclosure               "PD"		"CTPPPO"	0.2 )		; PPPO_en2
     ( minEnclosure               "PO"		"CTPPPO"	0.2 )		; PPPO_en3
     ( minEnclosure               "PPPO"	"PD"		0.32 )		; PPPO_em1
     ( minEnclosure               "PPPO"	"PO"		0.32 )		; PPPO_em2
     ( minEnclosure               "PPPO"	"PI"		0.1 )		; PPPO_em3
     ( minExtension               "SB"		"PO"		0.3 )		; SB_o1
     ( minExtension               "SB"		"ND"		0.22 )		; SB_o2
     ( minExtension               "SB"		"PD"		0.22 )		; SB_o3
     ( minExtension               "PO"		"SB"		0.39 )		; SB_o4
     ( minExtension               "ND"		"SB"		0.22 )		; SB_o5
     ( minExtension               "PD"		"SB"		0.22 )		; SB_o6
     ( minEnclosure               "GC"		"ND"		0.4 )		; GC_em
     ( minEnclosure               "NW"		"NDGC"		0.4 )		; GC_en1
     ( minEnclosure               "HVNW"	"NDGC"		0.4 )		; GC_en2
     ( minEnclosure               "NI"		"POGC"		0.02 )		; GC_en3
     ( minEnclosure               "PCH"		"NDGCNW"	0.22 )		; GC_ej
     ( minEnclosure               "CI"		"POND"		0.3 )		; CI_en1, CI_o1
     ( minEnclosure               "NI"		"CI"		0.5 )		; CI_em1
     ( minEnclosure               "DNW"		"NDINNWHVNW"	0.5 )		; DNW_en1
     ( minEnclosure               "DNW"		"PDINNWHVNW"	0.5 )		; DNW_en2
     ( minEnclosure               "NWHVNW"	"DNW"		1.5 )		; DNW_eb
     ( minEnclosure               "NCHT"	"POND"		0.32 )		; NCHT_en
     ( minEnclosure               "NCHT"	"ND"		0.07 )		; NCHT_em
     ( minEnclosure               "PCHT"	"POPD"		0.32 )		; PCHT_en
     ( minEnclosure               "PCHT"	"PD"		0.07 )		; PCHT_em
    ) ;orderedSpacings

    spacingTables(
    ;( constraint 		layer1 		    [layer2]
    ;   (( index1Definitions    [index2Defintions]) [defaultValue] )
    ;   ( table) )
    ;( --------------------------------------------)
     ( minSpacing                "M1"
	(( "width"   nil  nil 	 "length"   nil   nil  ) )
	(
	   (0.0       0.0       )	0.12
	   (0.0       0.521     )	0.12
	   (0.181     0.0       )	0.17
	   (0.181     0.521     )	0.17
	) ; M1_s, M1_ss
     )
     ( minNumCut                 "V1"
	(( "width"   nil  nil )	1 )
	(
	   0.419      2
	   1.009      4
	) ; V1_nw, V1_nh, M2_nw, M2_nh
     )
     ( minSpacing                "M2"
	(( "width"   nil  nil 	 "width"    nil   nil  ) )
	(
	   (0.0       0.0       )	0.14
	   (0.0       0.211     )	0.14
	   (0.0       1.501     )	0.14
	   (0.211     0.0       )	0.19
	   (0.211     0.211     )	0.19
	   (0.211     1.501     )	0.19
	   (1.501     0.0       )	0.5
	   (1.501     0.211     )	0.5
	   (1.501     1.501     )	0.5
	) ; M2_s, M2_sw1, M2_sw2, M2_sv1, M2_sv2
     )
;     ( minOppExtension           "M2"                "V1"
;	(( "width"   nil  nil ) )
;	(
;	   0.0        (0.005 0.05)
;	   1.001      (0.02 0.05)
;	   1.201      (0.06 0.06)
;	) ; M2_ee, M2_eg, M2_ew
;     )
;     ( minOppExtension           "M2"                "V2"
;	(( "width"   nil  nil ) )
;	(
;	   0.0        (0.005 0.05)
;	   1.001      (0.02 0.05)
;	   1.201      (0.06 0.06)
;	) ; V2_ee, V2_eg, V2_ew
;     )
     ( minNumCut                 "V2"
	(( "width"   nil  nil )	1 )
	(
	   0.419      2
	   1.009      4
	) ; V2_nw, V2_nh, M3_nw, M3_nh
     )
     ( minSpacing                "M3"
	(( "width"   nil  nil 	 "width"    nil   nil  ) )
	(
	   (0.0       0.0       )	0.14
	   (0.0       0.211     )	0.14
	   (0.0       1.501     )	0.14
	   (0.211     0.0       )	0.19
	   (0.211     0.211     )	0.19
	   (0.211     1.501     )	0.19
	   (1.501     0.0       )	0.5
	   (1.501     0.211     )	0.5
	   (1.501     1.501     )	0.5
	) ; M3_s, M3_sw1, M3_sw2, M3_sv1, M3_sv2
     )
;     ( minOppExtension           "M3"                "V2"
;	(( "width"   nil  nil ) )
;	(
;	   0.0        (0.005 0.05)
;	   1.001      (0.02 0.05)
;	   1.201      (0.06 0.06)
;	) ; M3_ee, M3_eg, M3_ew
;     )
;     ( minOppExtension           "M3"                "V3"
;	(( "width"   nil  nil ) )
;	(
;	   0.0        (0.005 0.05)
;	   1.001      (0.02 0.05)
;	   1.201      (0.06 0.06)
;	) ; V3_ee, V3_eg, V3_ew
;     )
     ( minNumCut                 "V3"
	(( "width"   nil  nil )	1 )
	(
	   0.419      2
	   1.009      4
	) ; V3_nw, V3_nh, M4_nw, M4_nh
     )
     ( minSpacing                "M4"
	(( "width"   nil  nil 	 "width"    nil   nil  ) )
	(
	   (0.0       0.0       )	0.14
	   (0.0       0.211     )	0.14
	   (0.0       1.501     )	0.14
	   (0.211     0.0       )	0.19
	   (0.211     0.211     )	0.19
	   (0.211     1.501     )	0.19
	   (1.501     0.0       )	0.5
	   (1.501     0.211     )	0.5
	   (1.501     1.501     )	0.5
	) ; M4_s, M4_sw1, M4_sw2, M4_sv1, M4_sv2
     )
;     ( minOppExtension           "M4"                "V3"
;	(( "width"   nil  nil ) )
;	(
;	   0.0        (0.005 0.05)
;	   1.001      (0.02 0.05)
;	   1.201      (0.06 0.06)
;	) ; M4_ee, M4_eg, M4_ew
;     )
;     ( minOppExtension           "M4"                "V4"
;	(( "width"   nil  nil ) )
;	(
;	   0.0        (0.005 0.05)
;	   1.001      (0.02 0.05)
;	   1.201      (0.06 0.06)
;	) ; V4_ee, V4_eg, V4_ew
;     )
     ( minNumCut                 "V4"
	(( "width"   nil  nil )	1 )
	(
	   0.419      2
	   1.009      4
	) ; V4_nw, V4_nh, M5_nw, M5_nh
     )
     ( minSpacing                "M5"
	(( "width"   nil  nil 	 "width"    nil   nil  ) )
	(
	   (0.0       0.0       )	0.14
	   (0.0       0.211     )	0.14
	   (0.0       1.501     )	0.14
	   (0.211     0.0       )	0.19
	   (0.211     0.211     )	0.19
	   (0.211     1.501     )	0.19
	   (1.501     0.0       )	0.5
	   (1.501     0.211     )	0.5
	   (1.501     1.501     )	0.5
	) ; M5_s, M5_sw1, M5_sw2, M5_sv1, M5_sv2
     )
;     ( minOppExtension           "M5"                "V4"
;	(( "width"   nil  nil ) )
;	(
;	   0.0        (0.005 0.05)
;	   1.001      (0.02 0.05)
;	   1.201      (0.06 0.06)
;	) ; M5_ee, M5_eg, M5_ew
;     )
     ( minNumCut                 "V5M"
	(( "width"   nil  nil )	1 )
	(
	   1.259      2
	   2.939      4
	) ; V5M_nw, V5M_nh, M6M_nw, M6M_nh
     )
     ( minSpacing                "M6M"
	(( "width"   nil  nil 	 "length"   nil   nil  ) )
	(
	   (0.0       0.0       )	0.42
	   (0.0       1.501     )	0.42
	   (0.0       3.001     )	0.42
	   (0.0       4.501     )	0.42
	   (0.0       7.501     )	0.42
	   (1.501     0.0       )	0.5
	   (1.501     1.501     )	0.5
	   (1.501     3.001     )	0.5
	   (1.501     4.501     )	0.5
	   (1.501     7.501     )	0.5
	   (3.001     0.0       )	0.9
	   (3.001     1.501     )	0.9
	   (3.001     3.001     )	0.9
	   (3.001     4.501     )	0.9
	   (3.001     7.501     )	0.9
	   (4.501     0.0       )	1.5
	   (4.501     1.501     )	1.5
	   (4.501     3.001     )	1.5
	   (4.501     4.501     )	1.5
	   (4.501     7.501     )	1.5
	   (7.501     0.0       )	2.5
	   (7.501     1.501     )	2.5
	   (7.501     3.001     )	2.5
	   (7.501     4.501     )	2.5
	   (7.501     7.501     )	2.5
	) ; M6M_s, M6M_ss1, M6M_ss2, M6M_ss3, M6M_ss4, M6M_sv1, M6M_sv2, M6M_sv3, M6M_sv4
     )
    ) ;spacingTables
  ) ;foundry
) ;constraintGroups


;********************************
; DEVICES
;********************************
devices(
tcCreateCDSDeviceClass()

;
; no cdsVia devices
;

;
; no cdsMos devices
;

;
; no cdsResistor devices
;
;
; no ruleContact devices
;


multipartPathTemplates(
; ( name [masterPath] [offsetSubpaths] [encSubPaths] [subRects] )
; 
;   masterPath:
;   (layer [width] [choppable] [endType] [beginExt] [endExt] [justify] [offset]
;   [connectivity])
; 
;   offsetSubpaths:
;   (layer [width] [choppable] [separation] [justification] [begOffset] [endOffset]
;   [connectivity])
; 
;   encSubPaths:
;   (layer [enclosure] [choppable] [separation] [begOffset] [endOffset]
;   [connectivity])
; 
;   subRects:
;   (layer [width] [length] [choppable] [separation] [justification] [space] [begOffset] [endOffset] [gap] 
;   [connectivity] [beginSegOffset] [endSegOffset])
; 
;   connectivity:
;   ([I/O type] [pin] [accDir] [dispPinName] [height] [ layer]
;    [layer] [justification] [font] [textOptions] [orientation]
;    [refHandle] [offset])
; 
; ( --------------------------------------------------------------------- )
  ( GLHVPW
    (("PD" "drawing")		0.22	nil	flush	0.0	0.0	center	0.0)
    ((("M1" "drawing")		0.22	t	0.0	center	0.0	0.0)
     (("PI" "drawing")		0.26	nil	0.0	center	0.02	0.02)
     (("HVPW" "drawing")	0.56	nil	0.0	center	0.17	0.17)
    )
    nil
    ((("CT" "drawing")		0.12	0.12	t	0.0	center	0.14	-0.05	-0.05	minimum	nil	0.0	0.0)
    )
  )
  ( GLHVNW
    (("ND" "drawing")		0.22	nil	flush	0.0	0.0	center	0.0)
    ((("M1" "drawing")		0.22	t	0.0	center	0.0	0.0)
     (("NI" "drawing")		0.26	nil	0.0	center	0.02	0.02)
     (("HVNW" "drawing")	0.56	nil	0.0	center	0.17	0.17)
    )
    nil
    ((("CT" "drawing")		0.12	0.12	t	0.0	center	0.14	-0.05	-0.05	minimum	nil	0.0	0.0)
    )
  )
  ( GLHVDNW
    (("ND" "drawing")		0.22	nil	flush	0.0	0.0	center	0.0)
    ((("M1" "drawing")		0.22	t	0.0	center	0.0	0.0)
     (("NI" "drawing")		0.26	nil	0.0	center	0.02	0.02)
     (("DNW" "drawing")		1.22	nil	0.0	center	0.5	0.5)
     (("HVNW" "drawing")	4.22	nil	0.0	center	2.0	2.0)
    )
    nil
    ((("CT" "drawing")		0.12	0.12	t	0.0	center	0.14	-0.05	-0.05	minimum	nil	0.0	0.0)
    )
  )
  ( GRHVPW
    (("PD" "drawing")		0.22	nil	flush	0.0	0.0	center	0.0)
    ((("M1" "drawing")		0.22	t	0.0	center	0.0	0.0)
     (("PI" "drawing")		0.26	nil	0.0	center	0.02	-0.02)
     (("HVPW" "drawing")	0.56	nil	0.0	center	0.17	-0.17)
    )
    nil
    ((("CT" "drawing")		0.12	0.12	t	0.0	center	0.14	-0.05	-0.11	minimum	nil	0.0	0.0)
    )
  )
  ( GRHVNW
    (("ND" "drawing")		0.22	nil	flush	0.0	0.0	center	0.0)
    ((("M1" "drawing")		0.22	t	0.0	center	0.0	0.0)
     (("NI" "drawing")		0.26	nil	0.0	center	0.02	-0.02)
     (("HVNW" "drawing")	0.56	nil	0.0	center	0.17	-0.17)
    )
    nil
    ((("CT" "drawing")		0.12	0.12	t	0.0	center	0.14	-0.05	-0.11	minimum	nil	0.0	0.0)
    )
  )
  ( GRHVDNW
    (("ND" "drawing")		0.22	nil	flush	0.0	0.0	center	0.0)
    ((("M1" "drawing")		0.22	t	0.0	center	0.0	0.0)
     (("NI" "drawing")		0.26	nil	0.0	center	0.02	-0.02)
     (("DNW" "drawing")		1.22	nil	0.0	center	0.5	-0.5)
     (("HVNW" "drawing")	4.22	nil	0.0	center	2.0	-2.0)
    )
    nil
    ((("CT" "drawing")		0.12	0.12	t	0.0	center	0.14	-0.05	-0.11	minimum	nil	0.0	0.0)
    )
  )
)  ;multipartPathTemplates


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Opus Symbolic Device Class Definition
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
; no other device classes
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Opus Symbolic Device Declaration
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Device Extraction Declaration
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


) ;devices


;********************************
; LE RULES
;********************************
leRules(

 leLswLayers(
 ;( layer               purpose         )
 ;( -----               -------         )
 ) ;leLswLayers

) ;leRules


;********************************
; SITEDEFS
;********************************
siteDefs(

 scalarSiteDefs(
 ;( siteDefName          type width  height  symInX symInY symInR90)
 ;( -----------          ---- -----  ------  ------ ------ -------)
 ) ;scalarSiteDefs

 arraySiteDefs(
 ; ( name	type
 ;  ((siteDefName     dx      dy      orientation) ...)
 ;   [symX] [symY] [symR90] )

 ) ;arraySiteDefs

) ;siteDefs


;********************************
; VIASPECS
;********************************

viaSpecs(
 ;(layer1  layer2  (viaDefName ...) 
 ;   [(        
 ;	(layer1MinWidth layer1MaxWidth layer2MinWidth layer2MaxWidth 
 ;            (viaDefName ...)) 
 ;	...         
 ;   )])       
 ;( ------------------------------------------------------------------------ ) 
   ( M6M    PM      ("VHP")
   )
   ( M5     M6M     ("VH5")
   )
   ( M4     M5      ("VH4")
   )
   ( M3     M4      ("VH3")
   )
   ( M2     M3      ("VH2")
   )
   ( M1     M2      ("VH1")
   )
   ( PO     M1      ("CT1")
   )
) ;viaSpecs
