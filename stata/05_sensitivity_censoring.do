// 1 ano (365 dias)
gen time_cens_1y = min(time_to_event, 365)
gen event_1y = .
replace event_1y = 1 if event_type == 1 & time_to_event <= 365
replace event_1y = 0 if time_to_event > 365 | event_type == 0

// 2 anos (730 dias)
gen time_cens_2y = min(time_to_event, 730)
gen event_2y = .
replace event_2y = 1 if event_type == 1 & time_to_event <= 730
replace event_2y = 0 if time_to_event > 730 | event_type == 0

// 5 anos (1826 dias)
gen time_cens_5y = min(time_to_event, 1826)
gen event_5y = .
replace event_5y = 1 if event_type == 1 & time_to_event <= 1826
replace event_5y = 0 if time_to_event > 1826 | event_type == 0


stset time_cens_1y if agebin_TB1 == 1, failure(event_1y) id(study_sinan)
stcrreg sex i.agegroup_atTB1 i.race3 i.educ4 ib2.tbloc_atTB1 ///
    hiv_atTB1 diabetes_atTB1 mental_atTB1 alc_atTB1 drugs_atTB1 ///
    tobac_atTB1 immuno_atTB1 homeless_atTB1 inmate_atTB1 ///
    i.hosp_atTB1 tx_admin_binary, compete(event_type == 2)

	
stset time_cens_2y if agebin_TB1 == 1, failure(event_2y) id(study_sinan)
stcrreg sex i.agegroup_atTB1 i.race3 i.educ4 ib2.tbloc_atTB1 ///
    hiv_atTB1 diabetes_atTB1 mental_atTB1 alc_atTB1 drugs_atTB1 ///
    tobac_atTB1 immuno_atTB1 homeless_atTB1 inmate_atTB1 ///
    i.hosp_atTB1 tx_admin_binary, compete(event_type == 2)
	

stset time_cens_5y if agebin_TB1 == 1, failure(event_5y) id(study_sinan)
stcrreg sex i.agegroup_atTB1 i.race3 i.educ4 ib2.tbloc_atTB1 ///
    hiv_atTB1 diabetes_atTB1 mental_atTB1 alc_atTB1 drugs_atTB1 ///
    tobac_atTB1 immuno_atTB1 homeless_atTB1 inmate_atTB1 ///
    i.hosp_atTB1 tx_admin_binary, compete(event_type == 2)
	
**********                               

// Recorrência precoce: ≤ 1 ano (365 dias)
gen event_early = event_type == 1 & time_to_event <= 365

// Recorrência intermediária: entre 1 e 2 anos
gen event_intermed = event_type == 1 & inrange(time_to_event, 366, 730)

// Recorrência tardia: > 2 anos
gen event_late = event_type == 1 & time_to_event > 730






stset time_to_event if agebin_TB1 == 1 & time_to_event <= 365, failure(event_early) id(study_sinan)

stcrreg sex i.agegroup_atTB1 i.race3 i.educ4 ib2.tbloc_atTB1 ///
    hiv_atTB1 diabetes_atTB1 mental_atTB1 alc_atTB1 drugs_atTB1 ///
    tobac_atTB1 immuno_atTB1 homeless_atTB1 inmate_atTB1 ///
    i.hosp_atTB1 tx_admin_binary, compete(event_type == 2)

	


stset time_to_event if agebin_TB1 == 1 & inrange(time_to_event, 366, 730), failure(event_intermed) id(study_sinan)

stcrreg sex i.agegroup_atTB1 i.race3 i.educ4 ib2.tbloc_atTB1 ///
    hiv_atTB1 diabetes_atTB1 mental_atTB1 alc_atTB1 drugs_atTB1 ///
    tobac_atTB1 immuno_atTB1 homeless_atTB1 inmate_atTB1 ///
    i.hosp_atTB1 tx_admin_binary, compete(event_type == 2)



stset time_to_event if agebin_TB1 == 1 & time_to_event > 730, failure(event_late) id(study_sinan)

stcrreg sex i.agegroup_atTB1 i.race3 i.educ4 ib2.tbloc_atTB1 ///
    hiv_atTB1 diabetes_atTB1 mental_atTB1 alc_atTB1 drugs_atTB1 ///
    tobac_atTB1 immuno_atTB1 homeless_atTB1 inmate_atTB1 ///
    i.hosp_atTB1 tx_admin_binary, compete(event_type == 2)
	
