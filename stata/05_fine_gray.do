


** Age 
gen agebin_TB1 = .
replace agebin_TB1 = 0 if age_atTB1 < 15
replace agebin_TB1 = 1 if age_atTB1 >= 15
label define agebinlbl 0 "<15 years" 1 "≥15 years"
label values agebin_TB1 agebinlbl

** homeless and incarceration
gen homeless_atTB1 = socialvuln_atTB1 == 3
gen inmate_atTB1 = socialvuln_atTB1 == 2


** race binary
gen race_atTB1_new = .
replace race_atTB1_new = 0 if race_new == 1
replace race_atTB1_new = 1 if inlist(race_new, 2, 3, 4)

label define race_bin 0 "White" 1 "Non-white"
label values race_atTB1_new race_bin

** Recoding RACE
gen race3 = .
replace race3 = 1 if race == 2
replace race3 = 2 if race == 1 | race == 3
replace race3 = 3 if race == 4 | race == 5
label define race3lbl 1 "White" 2 "Black/Brown" 3 "Other"
label values race3 race3lbl

** tb anatomic location binary
gen tbloc_atTB1_new = .
replace tbloc_atTB1_new = 0 if tbloc_atTB1 == 1
replace tbloc_atTB1_new = 1 if inlist(tbloc_atTB1, 2, 3)

label define tbloc_bin 0 "Pulmonary only" 1 "Any extrapulmonary"
label values tbloc_atTB1_new tbloc_bin


**** Education
gen educ3 = .
replace educ3 = 0 if inlist(educ_atTB1_new, 1) // Nenhuma
replace educ3 = 1 if inlist(educ_atTB1_new, 2, 3, 4) // Fundamental completo ou incompleto
replace educ3 = 2 if inlist(educ_atTB1_new, 5) // Médio completo
replace educ3 = 3 if inlist(educ_atTB1_new, 6) // Superior
label define educ3lab 0 "None" 1 "Primary" 2 "Secondary" 3 "Higher"
label values educ3 educ3lab

gen educ4 = .
replace educ4 = 0 if educ_atTB1_new == 1                     // Nenhuma escolaridade
replace educ4 = 1 if inlist(educ_atTB1_new, 2, 3)             // Até 7 anos
replace educ4 = 2 if educ_atTB1_new == 4                      // 8–11 anos
replace educ4 = 3 if inlist(educ_atTB1_new, 5, 6)             // 12 anos ou mais

label define educ4lbl 0 "None" 1 "≤7 years" 2 "8–11 years" 3 "≥12 years"
label values educ4 educ4lbl

gen tx_admin_binary = (tx_admin_atTB1 == 2)
label define tx_admin_label 0 "Self-Administered" 1 "Supervised", modify
label values tx_admin_binary tx_admin_label



* UNIVARIATE FINE & GRAY MODELS FOR RECURRENCE



stset time_to_event, failure(event_type == 1) id(study_sinan)

* 1. Amostra total


stcrreg sex, compete(event_type == 2)
stcrreg age_atTB1, compete(event_type == 2)
stcrreg i.tbloc_atTB1, compete(event_type == 2)
stcrreg hiv_atTB1, compete(event_type == 2)
stcrreg diabetes_atTB1, compete(event_type == 2)
stcrreg alc_atTB1, compete(event_type == 2)
stcrreg mental_atTB1, compete(event_type == 2)
stcrreg drugs_atTB1, compete(event_type == 2)
stcrreg tobac_atTB1, compete(event_type == 2)
stcrreg immuno_atTB1, compete(event_type == 2)
stcrreg tx_admin_atTB1, compete(event_type == 2)
stcrreg i.socialvuln_atTB1, compete(event_type == 2)
stcrreg retreatment_TB1, compete(event_type == 2)
stcrreg bactest2_TB1, compete(event_type ==2)

stcrreg i.edu_atTB1, compete(event_type == 2)
stcrreg i.race3, compete(event_type == 2)
stcrreg effect_atTB1, compete(event_type ==2)
stcrreg hosp_atTB1, compete(event_type ==2)

* 2. Subgrupo: <15 anos

* Para o subgrupo < 15 anos
stset time_to_event if agebin_TB1 == 0, failure(event_type == 1) id(study_sinan)


stcrreg sex, compete(event_type == 2) 
stcrreg race_atTB1_new, compete(event_type == 2)
stcrreg age_atTB1, compete(event_type == 2) 
stcrreg ib1.tbloc_atTB1_new, compete(event_type == 2) 
stcrreg hiv_atTB1, compete(event_type == 2) 
stcrreg immuno_atTB1, compete(event_type == 2) 
stcrreg tx_admin_atTB1, compete(event_type == 2) 
stcrreg retreatment_TB1, compete(event_type == 2) 
stcrreg hosp_atTB1, compete(event_type ==2)
stcrreg effect_atTB1, compete(event_type ==2)

gen time_10y = min(time_to_event, 3650)
gen recurrence_10y = (time_to_event <= 3650 & event_type == 1)
stset time_10y if agebin_TB1 == 0, failure(recurrence_10y) id(study_sinan)


* 3. Subgrupo: ≥15 anos
stset time_to_event if agebin_TB1 == 1, failure(event_type == 1) id(study_sinan)

stcrreg sex, compete(event_type == 2) 
stcrreg age_atTB1, compete(event_type == 2) 
stcrreg ib2.tbloc_atTB1, compete(event_type == 2) 
stcrreg hiv_atTB1, compete(event_type == 2)
stcrreg diabetes_atTB1, compete(event_type == 2) 
stcrreg alc_atTB1, compete(event_type == 2) 
stcrreg mental_atTB1, compete(event_type == 2) 
stcrreg drugs_atTB1, compete(event_type == 2) 
stcrreg tobac_atTB1, compete(event_type == 2) 
stcrreg immuno_atTB1, compete(event_type == 2) 
stcrreg tx_admin_atTB1, compete(event_type == 2) crre
stcrreg i.educ4, compete(event_type == 2)

stcrreg retreatment_TB1, compete(event_type == 2) 
stcrreg hosp_atTB1, compete(event_type ==2)

stcrreg homeless_atTB1 , compete(event_type ==2)
stcrreg inmate_atTB1 , compete(event_type ==2)
stcrreg i.race3, compete(event_type == 2) 
stcrreg i.educ4, compete (event_type == 2) 
stcrreg hosp_atTB1, compete(event_type ==2)
stcrreg i.agegroup_atTB1, compete(event_type ==2)

** age > 15 (age continuous, race 3 groups, education 4 groups, including hospitalization and interruptions of treatment. )
stcrreg sex age_atTB1 i.race3 i.educ4 i.tbloc_atTB1 hiv_atTB1 diabetes_atTB1 mental_atTB1 alc_atTB1 drugs_atTB1 tobac_atTB1 immuno_atTB1 homeless_atTB1 inmate_atTB1 hosp_atTB1 tx_admin_binary i.cat_total_contacts, compete(event_type == 2)

*** age > 15 with new race and education classification, age group

stcrreg sex i.agegroup_atTB1 i.race3 i.educ4 ib2.tbloc_atTB1 hiv_atTB1 diabetes_atTB1 mental_atTB1 alc_atTB1 drugs_atTB1 tobac_atTB1 immuno_atTB1 homeless_atTB1 inmate_atTB1 i.hosp_atTB1 tx_admin_binary, compete(event_type == 2)

stcrreg sex i.agegroup_atTB1 i.educ4 ib2.tbloc_atTB1 hiv_atTB1 diabetes_atTB1 mental_atTB1 alc_atTB1 drugs_atTB1 tobac_atTB1 immuno_atTB1 homeless_atTB1 inmate_atTB1 i.hosp_atTB1 tx_admin_binary, compete(event_type == 2)

******

stcrreg sex i.agegroup_atTB1 i.educ4 ib2.tbloc_atTB1 hiv_atTB1 diabetes_atTB1 mental_atTB1 alc_atTB1 drugs_atTB1 tobac_atTB1 immuno_atTB1 i.hosp_atTB1 tx_admin_binary, compete(event_type == 2)


*** age < 15
stcrreg sex age_atTB1 race_atTB1_new ib1.tbloc_atTB1_new hiv_atTB1 hosp_atTB1, compete(event_type == 2)

*** > 15 excludind education and race

stcrreg sex age_atTB1 i.tbloc_atTB1 hiv_atTB1 diabetes_atTB1 immuno_atTB1 alc_atTB1 drugs_atTB1 tobac_atTB1 homeless_atTB1 inmate_atTB1 i.hosp_atTB1 tx_admin_atTB1 retreatment_TB1, compete(event_type == 2)
*** i.cat_total_contacts



***** Graphs/ CIF curves 

** Hospitalization


stcurve, cif at1(hosp_atTB1==0) at2(hosp_atTB1==1) ///
    xlabel(0 "0" 365 "1" 730 "2" 1095 "3" 1460 "4" 1825 "5" ///
           2190 "6" 2555 "7" 2920 "8" 3285 "9" 3650 "10" 4015 "11" 1480 "12") ///
    ylabel(0(.05).30) ///
    xtitle("Time since cure (months)") ///
    title("Cumulative incidence of TB recurrence by hospitalization (≥15 years)") ///
    legend(order(1 "Not hospitalized" 2 "Hospitalized") ///
          position(11) ring(0) alignment(left) cols(1) ///
           region(style(none) margin(l+10))) ///
    text(0.005 3650 "p < 0.001", place(e) size(small)) ///
    graphregion(color(white))
graph save hosp_cif_adul.gph, replace


stcurve, cif at1(hosp_atTB1==0) at2(hosp_atTB1==1) ///
    xlabel(0 "0" 365 "1" 730 "2" 1095 "3" 1460 "4" 1825 "5" ///
           2190 "6" 2555 "7" 2920 "8" 3285 "9") ///
    ylabel(0(.05).30) ///
    xtitle("Time since cure (months)") ///
    title("Cumulative incidence of TB recurrence by hospitalization (<15 years)") ///
    legend(order(1 "Not hospitalized" 2 "Hospitalized") ///
           position(11) ring(0) cols(1) region(lcolor(none))) ///
    text(0.28 3650 "p < 0.001", size(small)) ///
    graphregion(color(white) margin(t=10 l=20 r=10 b=20))
graph save hosp_cif_chil.gph, replace



	


tab homeless_filtered recurred, chi2
tab tx_admin_atTB1 recurred, chi2
	
*** HIV	

// --- Tempo 0 dias ---
di "At risk at 0 days"
count if hiv_atTB1 == 0
count if hiv_atTB1 == 1

// --- Tempo 1825 dias (5 anos) ---
di "At risk at 1825 days (5 years)"
count if _t > 1825 & hiv_atTB1 == 0
count if _t > 1825 & hiv_atTB1 == 1

// --- Tempo 3650 dias (10 anos) ---
di "At risk at 3650 days (10 years)"
count if _t > 3650 & hiv_atTB1 == 0
count if _t > 3650 & hiv_atTB1 == 1


**** adults 

// --- Tempo 0 dias ---
di "At risk at 0 days (age ≥ 15)"
count if hiv_atTB1 == 0 & age_atTB1 >= 15
count if hiv_atTB1 == 1 & age_atTB1 >= 15

// --- Tempo 1825 dias (5 anos) ---
di "At risk at 1825 days (5 years, age ≥ 15)"
count if _t > 1825 & hiv_atTB1 == 0 & age_atTB1 >= 15
count if _t > 1825 & hiv_atTB1 == 1 & age_atTB1 >= 15

// --- Tempo 3650 dias (10 anos) ---
di "At risk at 3650 days (10 years, age ≥ 15)"
count if _t > 3650 & hiv_atTB1 == 0 & age_atTB1 >= 15
count if _t > 3650 & hiv_atTB1 == 1 & age_atTB1 >= 15

**** children

// --- Tempo 0 dias ---
di "At risk at 0 days (age < 15)"
count if hiv_atTB1 == 0 & age_atTB1 < 15
count if hiv_atTB1 == 1 & age_atTB1 < 15

// --- Tempo 1825 dias (5 anos) ---
di "At risk at 1825 days (5 years, age < 15)"
count if _t > 1825 & hiv_atTB1 == 0 & age_atTB1 < 15
count if _t > 1825 & hiv_atTB1 == 1 & age_atTB1 < 15

// --- Tempo 3650 dias (10 anos) ---
di "At risk at 3650 days (10 years, age < 15)"
count if _t > 3650 & hiv_atTB1 == 0 & age_atTB1 < 15
count if _t > 3650 & hiv_atTB1 == 1 & age_atTB1 < 15

// --- Tempo 3650 dias (9 anos) ---
di "At risk at 3650 days (10 years, age < 15)"
count if _t > 3285 & hiv_atTB1 == 0 & age_atTB1 < 15
count if _t > 3285 & hiv_atTB1 == 1 & age_atTB1 < 15



*****

* "Number at risk:" "HIV-: 135,081   72,002   14,027" 
* "HIV+:    9,409    4,893    1,013"
 

stcurve, cif at1(hiv_atTB1=0) at2(hiv_atTB1=1) ///
    xlabel(0 "0" 365 "1" 730 "2" 1095 "3" 1460 "4" 1825 "5" ///
           2190 "6" 2555 "7" 2920 "8" 3285 "9" 3650 "10" 4015 "11" 4380 "12") ///
    ylabel(0(.05).30) ///
    xtitle("Time since cure (years)") ///
    title("Cumulative incidence of TB recurrence by HIV status (total population)", size(medium)) ///
    legend(order(1 "HIV-negative" 2 "HIV-positive") ///
           position(11) ring(0) cols(1) region(lcolor(none))) ///
    text(0.28 3650 "p < 0.001", size(small)) ///
    graphregion(color(white) margin(t=10 l=20 r=5 b=20))
graph save hiv_total_cif.gph, replace
 




**** para obter os valores no olho!!!
stcurve, cif at1(hiv_atTB1=0) at2(hiv_atTB1=1) ///
    xlabel(0 "0" 365 "1" 730 "2" 1095 "3" 1460 "4" 1825 "5" ///
           2190 "6" 2555 "7" 2920 "8" 3285 "9" 3650 "10" 4015 "11" 4380 "12")
    ylabel(0(.025).30, angle(0)) /// ⬅️ grades a cada 0.025
    xtitle("Time since cure (years)") ///
    title("Cumulative incidence of TB recurrence by HIV status", size(medium)) ///
    legend(order(1 "HIV-negative" 2 "HIV-positive") ///
           position(11) ring(0) cols(1) region(lcolor(none))) ///
    text(0.28 3650 "p < 0.001", size(small)) ///
    graphregion(color(white) margin(t=10 l=20 r=5 b=20))


**** HIV >= 15 years 


* "Number at risk:" "HIV-: 130,977   69,977   13,513" 
*.                  "HIV+:    9,368   4,865    1,005"

stcurve, cif at1(hiv_atTB1=0) at2(hiv_atTB1=1) ///
    xlabel(0 "0" 365 "1" 730 "2" 1095 "3" 1460 "4" 1825 "5" ///
           2190 "6" 2555 "7" 2920 "8" 3285 "9" 3650 "10" 4015 "11" 4380 "12")
    ylabel(0(.05).30) ///
    xtitle("Time since cure (years)") ///
    title("Cumulative incidence of TB recurrence by HIV status (≥15 years)") ///
    legend(order(1 "HIV-negative" 2 "HIV-positive") ///
           position(11) ring(0) cols(1) region(lcolor(none))) ///
    text(0.28 3650 "p < 0.001", size(small)) ///
    graphregion(color(white) margin(t=10 l=20 r=5 b=20))	
graph save hiv_cif_adul.gph, replace 

*** children 

 stcurve, cif at1(hiv_atTB1=0) at2(hiv_atTB1=1) ///
    xlabel(0 "0" 365 "1" 730 "2" 1095 "3" 1460 "4" 1825 "5" ///
           2190 "6" 2555 "7" 2920 "8" 3285 "9" 3650 "10") ///
    ylabel(0(.05).30) ///
    xtitle("Time since cure (months)") ///
    title("Cumulative incidence of TB recurrence by HIV status (<15 years)", size(medium)) ///
    legend(order(1 "HIV-negative" 2 "HIV-positive") ///
           position(11) ring(0) cols(1) region(style(none))) ///
    text(0.28 3650 "p < 0.001", place(e) size(small)) ///
    graphregion(color(white) margin(t=10 l=20 r=5 b=20)) ///
    name(hiv_cif_child, replace)


	
*** Homeless	

// --- Tempo 0 dias ---
di "At risk at 0 days (age ≥ 15)"
count if homeless_atTB1 == 0 & age_atTB1 >= 15
count if homeless_atTB1 == 1 & age_atTB1 >= 15

// --- Tempo 1825 dias (5 anos) ---
di "At risk at 1825 days (5 years, age ≥ 15)"
count if _t > 1825 & homeless_atTB1 == 0 & age_atTB1 >= 15
count if _t > 1825 & homeless_atTB1 == 1 & age_atTB1 >= 15

// --- Tempo 3650 dias (10 anos) ---
di "At risk at 3650 days (10 years, age ≥ 15)"
count if _t > 3650 & homeless_atTB1 == 0 & age_atTB1 >= 15
count if _t > 3650 & homeless_atTB1 == 1 & age_atTB1 >= 15



** Number at risk homelessness
* Homeless–: 145,989 78,111 15,561
* Homeless+:  3,367  1,398  184


stcurve, cif at1(homeless_atTB1=0) at2(homeless_atTB1=1) ///
    xlabel(0 "0" 365 "1" 730 "2" 1095 "3" 1460 "4" 1825 "5" ///
           2190 "6" 2555 "7" 2920 "8" 3285 "9" 3650 "10" 4015 "11" 4380 "12")
    ylabel(0(.05).30) ///
    xtitle("Time since cure (years)") ///
    title("Cumulative incidence of TB recurrence by homelessness (≥15 years)") ///
    legend(order(1 "Not homeless" 2 "Homeless") ///
           position(11) ring(0) cols(1) region(lcolor(none))) ///
    text(0.28 3650 "p < 0.001", size(small)) ///
    graphregion(color(white) margin(l=30 b=20))
graph save hom_cif_adul.gph, replace


	
*** Inmate

// --- Tempo 0 dias ---
di "At risk at 0 days (age ≥ 15)"
count if inmate_atTB1 == 0 & age_atTB1 >= 15
count if inmate_atTB1 == 1 & age_atTB1 >= 15

// --- Tempo 1825 dias (5 anos) ---
di "At risk at 1825 days (5 years, age ≥ 15)"
count if _t > 1825 & inmate_atTB1 == 0 & age_atTB1 >= 15
count if _t > 1825 & inmate_atTB1 == 1 & age_atTB1 >= 15

// --- Tempo 3650 dias (10 anos) ---
di "At risk at 3650 days (10 years, age ≥ 15)"
count if _t > 3650 & inmate_atTB1 == 0 & age_atTB1 >= 15
count if _t > 3650 & inmate_atTB1 == 1 & age_atTB1 >= 15


* Number at risk
* Not incarcerated: 129,282       67,593       13,818
* Incarcerated:     20,074        11,916       1,927


stcurve, cif at1(inmate_atTB1==0) at2(inmate_atTB1==1) ///
    xlabel(0 "0" 365 "1" 730 "2" 1095 "3" 1460 "4" 1825 "5" ///
           2190 "6" 2555 "7" 2920 "8" 3285 "9" 3650 "10" 4015 "11" 4380 "12")
    ylabel(0(.05).30) ///
    xtitle("Time since cure (years)") ///
    title("Cumulative incidence of TB recurrence by incarceration (≥15 years)") ///
    legend(order(1 "Not incarcerated" 2 "Incarcerated") ///
           position(11) ring(0) cols(1) region(lcolor(none))) ///
    text(0.28 3650 "p < 0.001", size(small)) ///
    graphregion(color(white) margin(t=10 l=20 r=5 b=20))
graph save inc_cif_adul.gph, replace




     



**** tobbaco

// --- Tempo 0 dias ---
di "At risk at 0 days (age ≥ 15)"
count if tobac_atTB1 == 0 & age_atTB1 >= 15
count if tobac_atTB1 == 1 & age_atTB1 >= 15

// --- Tempo 1825 dias (5 anos) ---
di "At risk at 1825 days (5 years, age ≥ 15)"
count if _t > 1825 & tobac_atTB1 == 0 & age_atTB1 >= 15
count if _t > 1825 & tobac_atTB1 == 1 & age_atTB1 >= 15

// --- Tempo 3650 dias (10 anos) ---
di "At risk at 3650 days (10 years, age ≥ 15)"
count if _t > 3650 & tobac_atTB1 == 0 & age_atTB1 >= 15
count if _t > 3650 & tobac_atTB1 == 1 & age_atTB1 >= 15

*Number at risk
*Non-smokers:   116,119      64,115      14,407
*Smokers:        33,237      15,394       1,338


stcurve, cif at1(tobac_atTB1==0) at2(tobac_atTB1==1) ///
    xlabel(0 "0" 365 "1" 730 "2" 1095 "3" 1460 "4" 1825 "5" ///
           2190 "6" 2555 "7" 2920 "8" 3285 "9" 3650 "10" 4015 "11" 4380 "12")
    ylabel(0(.05).30) ///
    xtitle("Time since cure (years)") ///
    title("Cumulative incidence of TB recurrence by tobacco use (≥15 years)") ///
    legend(order(1 "Non-smokers" 2 "Smokers") ///
           position(11) ring(0) cols(1) region(lcolor(none))) ///
    text(0.28 3650 "p < 0.001", size(small)) ///
    graphregion(color(white) margin(t=10 l=20 r=5 b=20))
graph save tobac_cif_adul.gph, replace




***** Alcohol


// --- Tempo 0 dias ---
di "At risk at 0 days (age ≥ 15)"
count if alc_atTB1 == 0 & age_atTB1 >= 15
count if alc_atTB1 == 1 & age_atTB1 >= 15

// --- Tempo 1825 dias (5 anos, age ≥ 15) ---
di "At risk at 1825 days (5 years, age ≥ 15)"
count if _t > 1825 & alc_atTB1 == 0 & age_atTB1 >= 15
count if _t > 1825 & alc_atTB1 == 1 & age_atTB1 >= 15

// --- Tempo 3650 dias (10 anos, age ≥ 15) ---
di "At risk at 3650 days (10 years, age ≥ 15)"
count if _t > 3650 & alc_atTB1 == 0 & age_atTB1 >= 15
count if _t > 3650 & alc_atTB1 == 1 & age_atTB1 >= 15


*Number at risk
*No alcohol use:   125,718      67,797      13,647
*Alcohol use:       23,638      11,712       2,098

stcurve, cif at1(alc_atTB1==0) at2(alc_atTB1==1) ///
    xlabel(0 "0" 365 "1" 730 "2" 1095 "3" 1460 "4" 1825 "5" ///
           2190 "6" 2555 "7" 2920 "8" 3285 "9" 3650 "10" 4015 "11" 4380 "12")
    ylabel(0(.05).30) ///
    xtitle("Time since cure (years)") ///
    title("Cumulative incidence of TB recurrence by alcohol use (≥15 years)") ///
    legend(order(1 "No alcohol use" 2 "Alcohol use") ///
           position(11) ring(0) cols(1) region(lcolor(none))) ///
    text(0.28 3650 "p < 0.001", size(small)) ///
    graphregion(color(white) margin(t=10 l=20 r=5 b=20))
graph save alc_cif_adul.gph, replace

**** drug use

// --- Tempo 0 dias ---
di "At risk at 0 days (age ≥ 15)"
count if drugs_atTB1 == 0 & age_atTB1 >= 15
count if drugs_atTB1 == 1 & age_atTB1 >= 15

// --- Tempo 1825 dias (5 anos, age ≥ 15) ---
di "At risk at 1825 days (5 years, age ≥ 15)"
count if _t > 1825 & drugs_atTB1 == 0 & age_atTB1 >= 15
count if _t > 1825 & drugs_atTB1 == 1 & age_atTB1 >= 15

// --- Tempo 3650 dias (10 anos, age ≥ 15) ---
di "At risk at 3650 days (10 years, age ≥ 15)"
count if _t > 3650 & drugs_atTB1 == 0 & age_atTB1 >= 15
count if _t > 3650 & drugs_atTB1 == 1 & age_atTB1 >= 15


*Number at risk
*No drug use:   127,409      68,757      14,139
*Drug use:       21,947      10,752       1,606

stcurve, cif at1(drugs_atTB1==0) at2(drugs_atTB1==1) ///
    xlabel(0 "0" 365 "1" 730 "2" 1095 "3" 1460 "4" 1825 "5" ///
           2190 "6" 2555 "7" 2920 "8" 3285 "9" 3650 "10" 4015 "11" 1480 "12")
    ylabel(0(.05).30) ///
    xtitle("Time since cure (years)") ///
    title("Cumulative incidence of TB recurrence by drug use (≥15 years)") ///
    legend(order(1 "No drug use" 2 "Drug use") ///
           position(11) ring(0) cols(1) region(lcolor(none))) ///
    text(0.28 3650 "p < 0.001", size(small)) ///
    graphregion(color(white) margin(t=10 l=20 r=5 b=20))
graph save drug_cif_adul.gph, replace



*** education	
	
stcurve, cif at1(educ4==1) at2(educ4==2) at3(educ4==3) ///
    xlabel(0 "0" 365 "1" 730 "2" 1095 "3" 1460 "4" 1825 "5" ///
           2190 "6" 2555 "7" 2920 "8" 3285 "9" 3650 "10" 4015 "11" 1480 "12")
    ylabel(0(.05).30) ///
    xtitle("Time since cure (months)") ///
    title("Cumulative incidence of TB recurrence by education (≥15 years)") ///
    legend(order(1 "≤7 years" 2 "8–11 years" 3 "≥12 years") ///
           position(11) ring(0) alignment(left) cols(1) ///
           region(style(none) margin(l+10))) ///
    text(0.005 3650 "p < 0.001", place(e) size(small)) ///
    graphregion(color(white))
graph save educ_cif_adul.gph, replace


	


**** Sex

// --- Tempo 0 dias ---
di "At risk at 0 days (total population)"
count if sex == 0
count if sex == 1

// --- Tempo 1825 dias (5 anos) ---
di "At risk at 1825 days (5 years, total population)"
count if _t > 1825 & sex == 0
count if _t > 1825 & sex == 1

// --- Tempo 3650 dias (10 anos) ---
di "At risk at 3650 days (10 years, total population)"
count if _t > 3650 & sex == 0
count if _t > 3650 & sex == 1


**Number at risk
*Female:     46,933      24,972       5,345
*Male:      107,646      57,496      11,070




stcurve, cif at1(sex==0) at2(sex==1) ///
    xlabel(0 "0" 365 "1" 730 "2" 1095 "3" 1460 "4" 1825 "5" ///
           2190 "6" 2555 "7" 2920 "8" 3285 "9" 3650 "10" 4015 "11" 4380 "12")
    ylabel(0(.05).30) ///
    xtitle("Time since cure (years)") ///
    title("Cumulative incidence of TB recurrence by sex (total population)") ///
    legend(order(1 "Female" 2 "Male") ///
           position(11) ring(0) cols(1) region(lcolor(none))) ///
    text(0.28 3650 "p < 0.001", size(small)) ///
    graphregion(color(white) margin(t=10 l=20 r=5 b=20))
graph save sex_cif_total.gph, replace




stcurve, cif at1(sex==0) at2(sex==1) ///
    xlabel(0 "0" 365 "1" 730 "2" 1095 "3" 1460 "4" 1825 "5" ///
           2190 "6" 2555 "7" 2920 "8" 3285 "9" 3650 "10" 4015 "11" 4380 "12")
    ylabel(0(.05).30) ///
    xtitle("Time since cure (months)") ///
    title("Cumulative incidence of TB recurrence by sex (≥15 years)") ///
    legend(order(1 "Female" 2 "Male") ///
           position(11) ring(0) alignment(left) cols(1) ///
           region(style(none) margin(l+10))) ///
    text(0.005 3650 "p < 0.001", place(e) size(small)) ///
    graphregion(color(white))
graph save sex_cif_adul.gph, replace


stcurve, cif at1(sex==0) at2(sex==1) ///
   xlabel(0 "0" 365 "1" 730 "2" 1095 "3" 1460 "4" 1825 "5" ///
           2190 "6" 2555 "7" 2920 "8" 3285 "9" 3650 "10" 4015 "11" 4380 "12")
    ylabel(0(.05).30) ///
    xtitle("Time since cure (months)") ///
    title("Cumulative incidence of TB recurrence by sex (<15 years)") ///
    legend(order(1 "Male" 2 "Female") ///
           position(11) ring(0) alignment(left) cols(1) ///
           region(style(none) margin(l+10))) ///
    text(0.005 3650 "p < 0.001", place(e) size(small)) ///
    graphregion(color(white))
graph save sex_cif_child.gph, replace



**** Combination Curves

graph combine hiv_cif_chil.gph hosp_cif_chil.gph, ///
    cols(2) iscale(1) graphregion(color(white))


graph combine graph1.gph graph2.gph, col(1)



graph combine inc_cif_adul.gph hom_cif_adul.gph, col(2)


****** SHR PLOTS
** Distal Variables 

coefplot, eform drop(_cons) ///
keep(sex 3.agegroup_atTB1 4.agegroup_atTB1 5.agegroup_atTB1 ///
     2.race3 3.race3 ///
     1.educ4 2.educ4 3.educ4) ///
coeflabel( ///
    sex = "Male" ///
    3.agegroup_atTB1 = "Age 30–44" ///
    4.agegroup_atTB1 = "Age 45–59" ///
    5.agegroup_atTB1 = "Age ≥60" ///
    2.race3 = "Black or Brown" ///
    3.race3 = "Indigenous and Asian" ///
    1.educ4 = "≤7 years (education)" ///
    2.educ4 = "8–11 years (education)" ///
    3.educ4 = "≥12 years (education)" ///
) ///
xline(1) xlabel(0.5 1 1.5 2) ///
xtitle("Subdistribution Hazard Ratio (SHR)") ///
title("Sociodemographic Factors", size(medium))


*** Intermediate 

coefplot, eform drop(_cons) ///
keep(alc_atTB1 drugs_atTB1 tobac_atTB1) ///
coeflabel( alc_atTB1 = "Alcohol use" ///
    drugs_atTB1 = "Illicit drug use" ///
    tobac_atTB1 = "Tobacco use") ///
xline(1) xtitle("SHR") title("Behavioral Risk Factors")


coefplot, eform drop(_cons) ///
keep(inmate_atTB1 homeless_atTB1) ///
coeflabel(inmate_atTB1 = "Incarceration" ///
    homeless_atTB1 = "Homelessness") ///
xline(1) xtitle("Subdistribution Hazard Ratio (SHR)") ///
title("Social Vulnerability")

coefplot, eform drop(_cons) ///
keep(hiv_atTB1 diabetes_atTB1 mental_atTB1 immuno_atTB1) ///
coeflabel( ///
    hiv_atTB1 = "HIV" ///
    diabetes_atTB1 = "Diabetes" ///
    mental_atTB1 = "Mental health issue" ///
    immuno_atTB1 = "Other immuno condition" ///
) ///
xline(1) ///
xtitle("SHR") ///
title("Clinical Vulnerability")








coefplot, eform drop(_cons) xline(1) ///
coeflabel( ///
    sex = "Male" ///
    3.agegroup_atTB1 = "Age 30–44" ///
    4.agegroup_atTB1 = "Age 45–59" ///
    5.agegroup_atTB1 = "Age ≥60" ///
    2.race3 = "Black or Brown" ///
    3.race3 = "Indigenous and Asian" ///
    1.educ4 = "≤7 years (education)" ///
    2.educ4 = "8–11 years (education)" ///
    3.educ4 = "≥12 years (education)" ///
    1.tbloc_atTB1 = "Pulmonary" ///
    3.tbloc_atTB1 = "Pulmonary + Extrapulmonary" ///
    hiv_atTB1 = "HIV" ///
    diabetes_atTB1 = "Diabetes" ///
    mental_atTB1 = "Mental health issue" ///
    alc_atTB1 = "Alcohol use" ///
    drugs_atTB1 = "Illicit drug use" ///
    tobac_atTB1 = "Tobacco use" ///
    immuno_atTB1 = "Other immuno condition" ///
    homeless_atTB1 = "Homelessness" ///
    inmate_atTB1 = "Incarceration" ///
    hosp_atTB1 = "Hospitalization" ///
    tx_admin_binary = "Self-administered treatment" ///
) ///
xlabel(0.5 1 1.5 2 2.5) ///
xtitle("Subdistribution Hazard Ratio (SHR)") ///
title("Adjusted SHR for TB Recurrence (≥15 years)", size(medium)) ///
note("Estimates from multivariable competing risks regression, adjusted for all variables listed.")




coefplot, eform drop(_cons) xline(1) ///
keep( ///
    sex 3.agegroup_atTB1 4.agegroup_atTB1 5.agegroup_atTB1 ///
    2.race3 3.race3 1.educ4 2.educ4 3.educ4 ///
    alc_atTB1 drugs_atTB1 tobac_atTB1 ///
    inmate_atTB1 homeless_atTB1 ///
    hiv_atTB1 diabetes_atTB1 mental_atTB1 immuno_atTB1 ///
    1.tbloc_atTB1 3.tbloc_atTB1 1.hosp_atTB1 tx_admin_binary ///
) ///
coeflabel( ///
    sex = "Male" ///
    3.agegroup_atTB1 = "Age 30–44" ///
    4.agegroup_atTB1 = "Age 45–59" ///
    5.agegroup_atTB1 = "Age ≥60" ///
    2.race3 = "Black or Brown" ///
    3.race3 = "Indigenous and Asian" ///
    1.educ4 = "≤7 years (education)" ///
    2.educ4 = "8–11 years (education)" ///
    3.educ4 = "≥12 years (education)" ///
    alc_atTB1 = "Alcohol use" ///
    drugs_atTB1 = "Illicit drug use" ///
    tobac_atTB1 = "Tobacco use" ///
    inmate_atTB1 = "Incarceration" ///
    homeless_atTB1 = "Homelessness" ///
    hiv_atTB1 = "HIV" ///
    diabetes_atTB1 = "Diabetes" ///
    mental_atTB1 = "Mental health issue" ///
    immuno_atTB1 = "Other immuno condition" ///
    1.tbloc_atTB1 = "Pulmonary" ///
    3.tbloc_atTB1 = "Pulmonary + Extrapulmonary" ///
    1.hosp_atTB1 = "Hospitalization" ///
    tx_admin_binary = "Self-administered treatment" ///
) ///
xlabel(0.5 1 1.5 2 2.5) ///
xtitle("Subdistribution Hazard Ratio (SHR)") ///
title("Adjusted SHR for TB Recurrence (≥15 years)", size(medium)) ///
note("Estimates from multivariable competing risks regression, adjusted for all variables listed.")


coefplot, eform drop(_cons) xline(1) ///
coeflabel( ///
    sex = "Male" ///
    3.agegroup_atTB1 = "Age 30–44" ///
    4.agegroup_atTB1 = "Age 45–59" ///
    5.agegroup_atTB1 = "Age ≥60" ///
    2.race3 = "Black or Brown" ///
    3.race3 = "Indigenous and Asian" ///
    1.educ4 = "≤7 years (education)" ///
    2.educ4 = "8–11 years (education)" ///
    3.educ4 = "≥12 years (education)" ///
	alc_atTB1 = "Alcohol use" ///
    drugs_atTB1 = "Illicit drug use" ///
    tobac_atTB1 = "Tobacco use" ///
    homeless_atTB1 = "Homelessness" ///
    inmate_atTB1 = "Incarceration" ///
    hiv_atTB1 = "HIV" ///
    diabetes_atTB1 = "Diabetes" ///
    mental_atTB1 = "Mental health issue" ///
    immuno_atTB1 = "Other immuno condition" ///
    1.tbloc_atTB1 = "Pulmonary" ///
    3.tbloc_atTB1 = "Pulmonary + Extrapulmonary" ///
    hosp_atTB1 = "Hospitalization" ///
    tx_admin_binary = "Self-administered treatment" ///
) ///
xlabel(0.5 1 1.5 2 2.5) ///
xtitle("Subdistribution Hazard Ratio (SHR)") ///
title("Adjusted SHR for TB Recurrence (≥15 years)", size(medium)) ///
note("Estimates from multivariable competing risks regression, adjusted for all variables listed.")




coefplot, eform drop(_cons) xline(1) ///
order( ///
    sex 3.agegroup_atTB1 4.agegroup_atTB1 5.agegroup_atTB1 ///
    2.race3 3.race3 1.educ4 2.educ4 3.educ4 ///
    alc_atTB1 tobac_atTB1 drugs_atTB1 ///
    inmate_atTB1 homeless_atTB1 ///
    hiv_atTB1 diabetes_atTB1 mental_atTB1 immuno_atTB1 ///
    1.tbloc_atTB1 3.tbloc_atTB1 hosp_atTB1 tx_admin_binary ///
) ///
coeflabel( ///
    sex = "Male" ///
    3.agegroup_atTB1 = "Age 30–44" ///
    4.agegroup_atTB1 = "Age 45–59" ///
    5.agegroup_atTB1 = "Age ≥60" ///
    2.race3 = "Black or Brown" ///
    3.race3 = "Indigenous and Asian" ///
    1.educ4 = "≤7 years (education)" ///
    2.educ4 = "8–11 years (education)" ///
    3.educ4 = "≥12 years (education)" ///
    alc_atTB1 = "Alcohol use" ///
    tobac_atTB1 = "Tobacco use" ///
    drugs_atTB1 = "Illicit drug use" ///
    inmate_atTB1 = "Incarceration" ///
    homeless_atTB1 = "Homelessness" ///
    hiv_atTB1 = "HIV" ///
    diabetes_atTB1 = "Diabetes" ///
    mental_atTB1 = "Mental health issue" ///
    immuno_atTB1 = "Other immuno condition" ///
    1.tbloc_atTB1 = "Pulmonary" ///
    3.tbloc_atTB1 = "Pulmonary + Extrapulmonary" ///
    hosp_atTB1 = "Hospitalization" ///
    tx_admin_binary = "Self-administered treatment" ///
) ///
xlabel(0.5 1 1.5 2 2.5) ///
xtitle("Subdistribution Hazard Ratio (SHR)") ///
title("Adjusted SHR for TB Recurrence (≥15 years)", size(medium)) ///
note("Estimates from multivariable competing risks regression, adjusted for all variables listed.")




coefplot, eform drop(_cons) xline(1) ///
coeflabel( ///
    sex = "Male" ///
    age_atTB1 = "Age at diagnosis (years)" ///
    race_atTB1_new = "Non-white" ///
    tbloc_atTB1_new = "Any extrapulmonary involvement" ///
    hiv_atTB1 = "HIV" ///
    hosp_atTB1 = "Hospitalization" ///
) ///
xlabel(0.2 0.5 1 2 5) ///
xtitle("Subdistribution Hazard Ratio (SHR)") ///
title("Adjusted SHR for TB Recurrence – Age <15 years", size(medium)) ///
note("Estimates from multivariable competing risks regression for individuals under 15 years old.")






******* Imputation


mi stset time_to_event, failure(event_type == 1) id(study_sinan)
mi stset time_to_event if agebin_TB1 == 1, failure(event_type == 1) id(study_sinan)


mi set mlong

mi register imputed age_atTB1 race3 educ4 hiv_atTB1 tx_admin_binary
mi register regular sex tbloc_atTB1 diabetes_atTB1 alc_atTB1 drugs_atTB1 tobac_atTB1 immuno_atTB1 homeless_atTB1 inmate_atTB1 hosp_atTB1 retreatment_TB1


mi impute chained (regress) age_atTB1 (mlogit) race3 (ologit) educ4 (logit) hiv_atTB1 (logit) tx_admin_binary = sex tbloc_atTB1 diabetes_atTB1 alc_atTB1 drugs_atTB1 tobac_atTB1 immuno_atTB1 homeless_atTB1 inmate_atTB1 hosp_atTB1 retreatment_TB1, add(10) rseed(2025)


mi impute chained (regress) age_atTB1 (mlogit) race3 (ologit) educ4 (logit) hiv_atTB1 = sex diabetes_atTB1 alc_atTB1 drugs_atTB1 tobac_atTB1 mental_atTB1 immuno_atTB1 homeless_atTB1 inmate_atTB1 hosp_atTB1 retreatment_TB1 tx_admin_binary, add(10) rseed(2025)

*****
mi set mlong
mi register imputed age_atTB1 race3 educ4 hiv_atTB1
mi register regular sex tbloc_atTB1 diabetes_atTB1 alc_atTB1 drugs_atTB1 tobac_atTB1 immuno_atTB1 homeless_atTB1 inmate_atTB1 hosp_atTB1 retreatment_TB1 tx_admin_binary

mi impute chained (regress) age_atTB1 (mlogit) race3 (ologit) educ4 (logit) hiv_atTB1 = sex diabetes_atTB1 alc_atTB1 drugs_atTB1 tobac_atTB1 immuno_atTB1 homeless_atTB1 inmate_atTB1 hosp_atTB1 retreatment_TB1 tx_admin_binary, add(10) rseed(2025)

mi estimate: stcrreg sex age_atTB1 i.race3 educ4 i.tbloc_atTB1_new hiv_atTB1 diabetes_atTB1 alc_atTB1 drugs_atTB1 tobac_atTB1 mental_atTB1 immuno_atTB1 homeless_atTB1 inmate_atTB1 hosp_atTB1 retreatment_TB1 tx_admin_binary, compete(event_type == 2)

mi estimate: stcrreg sex i.agegroup_atTB1 i.race3 educ4 i.tbloc_atTB1_new ///
    hiv_atTB1 diabetes_atTB1 alc_atTB1 drugs_atTB1 tobac_atTB1 ///
    mental_atTB1 immuno_atTB1 homeless_atTB1 inmate_atTB1 ///
    hosp_atTB1 retreatment_TB1 tx_admin_binary, compete(event_type == 2)

mi estimate: stcrreg sex age_atTB1 i.race3 i.educ4 i.tbloc_atTB1_new hiv_atTB1 diabetes_atTB1 alc_atTB1 drugs_atTB1 tobac_atTB1 immuno_atTB1 homeless_atTB1 inmate_atTB1 hosp_atTB1 retreatment_TB1 tx_admin_binary mental_atTB1, compete(event_type == 2)	

mi estimate: stcrreg sex age_atTB1 i.race3 i.educ4 i.tbloc_atTB1 hiv_atTB1 diabetes_atTB1 alc_atTB1 drugs_atTB1 tobac_atTB1 mental_atTB1 immuno_atTB1 homeless_atTB1 inmate_atTB1 hosp_atTB1 retreatment_TB1 tx_admin_binary, compete(event_type == 2)

	
mi estimate, esampvaryok: stcrreg sex i.agegroup_atTB1 i.race3 i.educ4 i.tbloc_atTB1 ///
    hiv_atTB1 diabetes_atTB1 alc_atTB1 drugs_atTB1 tobac_atTB1 ///
    mental_atTB1 immuno_atTB1 homeless_atTB1 inmate_atTB1 ///
    i.hosp_atTB1 tx_admin_binary, compete(event_type == 2)


mi estimate: stcrreg sex, compete(event_type == 2)
mi estimate: stcrreg age_atTB1, compete(event_type == 2)
mi estimate: stcrreg race_atTB1_new, compete(event_type == 2)
mi estimate: stcrreg ib1.tbloc_atTB1_new, compete(event_type == 2)
mi estimate: stcrreg hiv_atTB1, compete(event_type == 2)
mi estimate: stcrreg hosp_atTB1, compete(event_type == 2)


*** age < 15
mi estimate: stcrreg sex age_atTB1 race_atTB1_new ib1.tbloc_atTB1_new hiv_atTB1 hosp_atTB1, compete(event_type == 2)	
