


*** Testando correlacao e colinearidade
*** Escolha das variaveis


xi: corr sex age_atTB1 hiv_atTB1 diabetes_atTB1 immuno_atTB1 alc_atTB1 drugs_atTB1 tobac_atTB1 homeless_atTB1 inmate_atTB1 tx_admin_atTB1 retreatment_TB1 i.race3 i.educ_atTB1_new i.tbloc_atTB1 i.hosp_atTB1 mental_atTB1


xi: corr sex age_atTB1 hiv_atTB1 diabetes_atTB1 immuno_atTB1 alc_atTB1 drugs_atTB1 tobac_atTB1 homel
> ess_atTB1 inmate_atTB1 tx_admin_atTB1 retreatment_TB1 i.race3 i.educ_atTB1_new i.tbloc_atTB1 i.hosp_
> atTB1
i.race3           _Irace3_1-3         (naturally coded; _Irace3_1 omitted)
i.educ_atTB1_~w   _Ieduc_atTB_0-6     (naturally coded; _Ieduc_atTB_0 omitted)
i.tbloc_atTB1     _Itbloc_atT_1-3     (naturally coded; _Itbloc_atT_1 omitted)
i.hosp_atTB1      _Ihosp_atTB_0-1     (naturally coded; _Ihosp_atTB_0 omitted)
(obs=90,783)

             |      sex age_at~1 hiv_at~1 diabet~1 immuno~1 alc_at~1 drugs_~1 tobac_~1 homele~1
-------------+---------------------------------------------------------------------------------
         sex |   1.0000
   age_atTB1 |   0.0230   1.0000
   hiv_atTB1 |   0.0363   0.0242   1.0000
diabetes_a~1 |  -0.0359   0.2726  -0.0474   1.0000
immuno_atTB1 |  -0.0470   0.0421  -0.0084   0.0058   1.0000
   alc_atTB1 |   0.1915   0.1036   0.0062  -0.0275  -0.0330   1.0000
 drugs_atTB1 |   0.1720  -0.1283   0.0369  -0.0763  -0.0319   0.3689   1.0000
 tobac_atTB1 |   0.1477   0.0846  -0.0253  -0.0263  -0.0249   0.3348   0.2777   1.0000
homeless_a~1 |   0.0486   0.0403   0.0393  -0.0133  -0.0095   0.1562   0.1373   0.0496   1.0000
inmate_atTB1 |   0.2433  -0.1748  -0.0410  -0.0923  -0.0342  -0.0591   0.1015   0.0611  -0.0495
tx_admin_a~1 |  -0.0687   0.0623   0.0852   0.0098   0.0361  -0.0548  -0.0799  -0.0606  -0.0324
retreatmen~1 |   0.0208  -0.0166   0.0441  -0.0133   0.0005   0.0559   0.0886   0.0332   0.0713
   _Irace3_2 |   0.0355  -0.0837  -0.0027  -0.0317  -0.0375   0.0602   0.0710   0.0472   0.0363
   _Irace3_3 |  -0.0144   0.0369  -0.0181   0.0110   0.0036  -0.0271  -0.0300  -0.0235  -0.0023
_Ieduc_atT~1 |   0.0312   0.1969  -0.0081   0.0569  -0.0036   0.0660  -0.0084   0.0328   0.0230
_Ieduc_atT~2 |   0.1097   0.1510   0.0023   0.0294  -0.0168   0.1073   0.0853   0.0997   0.0365
_Ieduc_atT~3 |  -0.0047  -0.1531   0.0133  -0.0455  -0.0063  -0.0448   0.0229  -0.0145  -0.0218
_Ieduc_atT~4 |  -0.0863  -0.0519   0.0029  -0.0148   0.0177  -0.0777  -0.0663  -0.0676  -0.0227
_Ieduc_atT~5 |  -0.0810   0.0348   0.0092   0.0041   0.0335  -0.0633  -0.0645  -0.0622  -0.0194
_Ieduc_atT~6 |  -0.0835  -0.3465  -0.0401  -0.0479   0.0055  -0.0786  -0.0738  -0.0952  -0.0224
_Itbloc_at~2 |  -0.0998   0.0247   0.0616  -0.0348   0.0376  -0.0826  -0.1018  -0.1165  -0.0392
_Itbloc_at~3 |   0.0043   0.0119   0.1226  -0.0104   0.0451   0.0009  -0.0147  -0.0181  -0.0076
_Ihosp_atT~1 |  -0.0033   0.0234   0.1519   0.0163   0.0623   0.0675   0.0315  -0.0037   0.0784

             | inmate~1 tx_adm~1 retrea~1 _Irace~2 _Irace~3 _Ieduc~1 _Ieduc~2 _Ieduc~3 _Ieduc~4
-------------+---------------------------------------------------------------------------------
inmate_atTB1 |   1.0000
tx_admin_a~1 |  -0.1576   1.0000
retreatmen~1 |  -0.0158   0.0296   1.0000
   _Irace3_2 |   0.0356  -0.0877   0.0206   1.0000
   _Irace3_3 |  -0.0324   0.0257  -0.0004  -0.1149   1.0000
_Ieduc_atT~1 |  -0.0115  -0.0309   0.0023   0.0234  -0.0124   1.0000
_Ieduc_atT~2 |   0.1407  -0.0601   0.0185   0.0495  -0.0132  -0.2099   1.0000
_Ieduc_atT~3 |  -0.0144   0.0018   0.0038   0.0071  -0.0135  -0.2498  -0.5645   1.0000
_Ieduc_atT~4 |  -0.0863   0.0489  -0.0165  -0.0597   0.0206  -0.0991  -0.2239  -0.2665   1.0000
_Ieduc_atT~5 |  -0.0685   0.1009  -0.0105  -0.0971   0.0527  -0.0621  -0.1403  -0.1670  -0.0662
_Ieduc_atT~6 |  -0.0700   0.0144  -0.0198   0.0066   0.0028  -0.0577  -0.1305  -0.1553  -0.0616
_Itbloc_at~2 |  -0.1342   0.1198  -0.0217  -0.0553   0.0105  -0.0349  -0.0819   0.0108   0.0640
_Itbloc_at~3 |  -0.0508   0.0597   0.0105  -0.0201   0.0041  -0.0078  -0.0171   0.0049   0.0088
_Ihosp_atT~1 |  -0.1138   0.0681   0.0847  -0.0119   0.0030   0.0042  -0.0087  -0.0189  -0.0022

             | _Ieduc~5 _Ieduc~6 _Itblo~2 _Itblo~3 _Ihosp~1
-------------+---------------------------------------------
_Ieduc_atT~5 |   1.0000
_Ieduc_atT~6 |  -0.0386   1.0000
_Itbloc_at~2 |   0.0911   0.0448   1.0000
_Itbloc_at~3 |   0.0173   0.0103  -0.0694   1.0000
_Ihosp_atT~1 |   0.0133   0.0428   0.1609   0.1716   1.0000


xi: collin sex age_atTB1 hiv_atTB1 diabetes_atTB1 immuno_atTB1 ///
alc_atTB1 drugs_atTB1 tobac_atTB1 homeless_atTB1 inmate_atTB1 ///
tx_admin_atTB1 retreatment_TB1 i.race3 i.educ_atTB1_new i.tbloc_atTB1 i.hosp_atTB1


*/
i.race3           _Irace3_1-3         (naturally coded; _Irace3_1 omitted)
i.educ_atTB1_~w   _Ieduc_atTB_0-6     (naturally coded; _Ieduc_atTB_0 omitted)
i.tbloc_atTB1     _Itbloc_atT_1-3     (naturally coded; _Itbloc_atT_1 omitted)
i.hosp_atTB1      _Ihosp_atTB_0-1     (naturally coded; _Ihosp_atTB_0 omitted)
(obs=90,783)

  Collinearity Diagnostics

                        SQRT                   R-
  Variable      VIF     VIF    Tolerance    Squared
----------------------------------------------------
       sex      1.14    1.07    0.8755      0.1245
 age_atTB1      1.51    1.23    0.6615      0.3385
 hiv_atTB1      1.05    1.03    0.9484      0.0516
diabetes_atTB1      1.10    1.05    0.9099      0.0901
immuno_atTB1      1.01    1.01    0.9865      0.0135
 alc_atTB1      1.34    1.16    0.7488      0.2512
drugs_atTB1      1.30    1.14    0.7712      0.2288
tobac_atTB1      1.20    1.09    0.8365      0.1635
homeless_atTB1      1.05    1.02    0.9526      0.0474
inmate_atTB1      1.22    1.10    0.8228      0.1772
tx_admin_atTB1      1.07    1.03    0.9363      0.0637
retreatment_TB1      1.02    1.01    0.9784      0.0216
 _Irace3_2      1.05    1.02    0.9548      0.0452
 _Irace3_3      1.02    1.01    0.9822      0.0178
_Ieduc_atTB_1      4.58    2.14    0.2185      0.7815
_Ieduc_atTB_2     11.10    3.33    0.0901      0.9099
_Ieduc_atTB_3     12.34    3.51    0.0810      0.9190
_Ieduc_atTB_4      5.16    2.27    0.1937      0.8063
_Ieduc_atTB_5      2.84    1.69    0.3517      0.6483
_Ieduc_atTB_6      2.94    1.72    0.3397      0.6603
_Itbloc_atT_2      1.11    1.05    0.9045      0.0955
_Itbloc_atT_3      1.06    1.03    0.9423      0.0577
_Ihosp_atTB_1      1.11    1.06    0.8979      0.1021
----------------------------------------------------
  Mean VIF      2.54

                           Cond
        Eigenval          Index
---------------------------------
    1     6.5749          1.0000
    2     1.5733          2.0443
    3     1.2488          2.2945
    4     1.1201          2.4228
    5     1.0465          2.5066
    6     1.0408          2.5134
    7     1.0151          2.5450
    8     1.0003          2.5638
    9     0.9792          2.5912
    10     0.9662          2.6086
    11     0.9479          2.6337
    12     0.9234          2.6685
    13     0.8813          2.7314
    14     0.8500          2.7813
    15     0.7529          2.9551
    16     0.6700          3.1325
    17     0.5846          3.3536
    18     0.5559          3.4390
    19     0.4851          3.6817
    20     0.3972          4.0687
    21     0.2270          5.3819
    22     0.0940          8.3623
    23     0.0570         10.7354
    24     0.0085         27.7337
---------------------------------
 Condition Number        27.7337 
 Eigenvalues & Cond Index computed from scaled raw sscp (w/ intercept)
 Det(correlation matrix)    0.0181

*/

