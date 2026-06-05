

* Criar uma versão filtrada da variável "education" para pacientes com mais de 18 anos
gen education_filtered = edu_atTB1 if age_atTB1 > 15
label variable education_filtered "Education (only >15 years)"
label values education_filtered edu_atTB1


* Criar versões filtradas para comportamentos de risco apenas para (idade ≥ 15 anos)
gen alcoholism_filtered = alc_atTB1 if age_atTB1 >= 15
label variable alcoholism_filtered "Alcoholism (only ≥15 years)"
label values alcoholism_filtered alc_atTB1

gen tobacco_use_filtered = tobac_atTB1 if age_atTB1 >= 15
label variable tobacco_use_filtered "Tobacco use (only ≥15 years)"
label values tobacco_use_filtered tobac_atTB1

gen drug_use_filtered = drugs_atTB1 if age_atTB1 >= 15
label variable drug_use_filtered "Drug use (only ≥15 years)"
label values drug_use_filtered drugs_atTB1

gen mental_filtered = mental_atTB1 if age_atTB1 >= 15
label variable mental_filtered "Mental Issue (only ≥15 years)"
label values mental_filtered mental_atTB1

gen aids_filtered = aids_atTB1 if hiv_atTB1 ==1
label variable aids_filtered "AIDS PLHIV"
label values aids_filtered aids_atTB1


gen inmate_filtered = inmate_atTB1 if age_atTB1 >= 15
label variable inmate_filtered "Incarceration (only ≥15 years)"
label values inmate_filtered inmate_atTB1

gen homeless_filtered = homeless_atTB1 if age_atTB1 >= 15
label variable homeless_filtered "Homelessness (only ≥15 years)"
label values homeless_filtered homeless_atTB1


*********************
* Table 1 



dtable age_atTB1, ///
    continuous(age_atTB1, statistics(mean sd median min max)) ///
    factor( ///
        race_new sex agegroup_atTB1 education_filtered ///
        tbloc_atTB1 lab_atTB1 hiv_atTB1 aids_filtered ///
        diabetes_atTB1 immuno_atTB1 alcoholism_filtered drug_use_filtered tobacco_use_filtered ///
        socialvuln_atTB1 tx_admin_atTB1 effect_atTB1 ///
        disease_atTB1 sputum_atTB1 hosp_atTB1 ///
        , statistics(fvfrequency fvpercent) ///
    ) ///
    export("Tabela1.xlsx", replace)

	

************************
* Table 1 for cases who died during the firrst Tb episode!

dtable age_tb ///
    if new_case_no_cure_death == 1, ///
    continuous(age_tb, statistics(mean sd median min max)) ///
    factor(race sex age_group education_filtered clinical_classif lab_confirmed hiv aids ///
        diabetes other_immuno_condition alcoholism_filtered drug_use_filtered tobacco_use_filtered ///
        address_type tx_administration_type supervised_tx_effectiveness ///
        disease_discovery sputum_culture_num hosp_admission, statistics(fvfrequency fvpercent)) ///
    export(Tabela1_morte_primeiroepisodio.xlsx, replace)


******
gen recurred = (event_type == 1) 

dtable age_atTB1, ///
    by(recurred, tests) ///
    continuous(age_atTB1, statistics(mean sd median min max) test(kwallis)) ///
    factor( ///
        race_new sex agegroup_atTB1 education_filtered ///
        tbloc_atTB1 lab_atTB1 hiv_atTB1 aids_filtered ///
        diabetes_atTB1 immuno_atTB1 alcoholism_filtered drug_use_filtered tobacco_use_filtered ///
        inmate_filtered homeless_filtered tx_admin_atTB1 effect_atTB1 ///
        disease_atTB1 sputum_atTB1 hosp_atTB1 ///
        , statistics(fvfrequency fvpercent) test(pearson) ///
    ) ///
    export("Tabela1comparison.xlsx", replace)






	


	
	

	