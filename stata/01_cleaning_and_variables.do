import delimited "<DATA_DIR>/Final table_correct dates2.csv"


*******************************************************
*** Variable Labels 
*******************************************************

* Demographic Data (10)
label variable sinan "Unique patient identifier"
label variable race "Patient race"
label variable country "Country of origin"
label variable dob "Date of birth"
label variable age_tb "Age at TB diagnosis"
label variable sex "Patient sex"
label variable education "Years of education"
label variable occupation "Patient occupation"
label variable tx_city "Treatment city"
label variable address_type "Address type"

* Diagnosis and Treatment (13)
label variable lab_confirmed "Laboratory confirmation"
label variable tx_seq "Treatment sequence"
label variable notification_date "TB notification date"
label variable tx_start "Treatment start date"
label variable diagnostic_date "TB diagnostic date"
label variable case_type "Type of TB case"
label variable case_outcome "TB case outcome"
label variable end_date "Treatment end date"
label variable clinical_form_1 "Primary clinical form"
label variable clinical_form_2 "Secondary clinical form"
label variable clinical_form_3 "Tertiary clinical form"
label variable clinical_classif "Clinical classification"

* Clinical and Social Status (8)
label variable hiv "HIV status"
label variable aids "AIDS status"
label variable diabetes "Diabetes status"
label variable alcoholism "Alcoholism status"
label variable mental_issue "Mental health condition"
label variable drug_use "Drug use"
label variable other_immuno_condition "Other immunosuppressive conditions"
label variable tobacco_use "Tobacco use"

* Household Contacts and Address (3)
label variable total_contacts "Total contacts"
label variable examined_contacts "Contacts examined"
label variable contact_disease "Disease in contacts"

* Treatment Administration (2)
label variable tx_administration_type "Treatment administration type"
label variable supervised_tx_effectiveness "Supervised treatment effectiveness"

* Laboratory Tests (3)
label variable sputum_culture "Sputum culture"
label variable tmr_tb "Molecular test performed"
label variable another_site_culture "Culture from another site"

* Bacteriological Tests (9)
label variable bac1 "Bacteriological test 1"
label variable bac2 "Bacteriological test 2"
label variable bac3 "Bacteriological test 3"
label variable bac4 "Bacteriological test 4"
label variable bac5 "Bacteriological test 5"
label variable bac6 "Bacteriological test 6"
label variable bac7 "Bacteriological test 7"
label variable bac8 "Bacteriological test 8"
label variable bac9 "Bacteriological test 9"

* Death  (2)
label variable dod "Date of death"
label variable cause_of_death_code "Cause of death code"

*******************************************************
* 3. Replace Categorical Values with Numeric Codes and Apply Labels 
*******************************************************

* Race

*** cria codigo e depois vc gera um novo
replace race = "1" if race == "Preto"
replace race = "2" if race == "Branco"
replace race = "3" if race == "Pardo"
replace race = "4" if race == "Indigena"
replace race = "5" if race == "Amarelo"
replace race = "." if race == "Ignorado" | missing(race)
destring race, replace
label define race_label 1 "Black" 2 "White" 3 "Brown" 4 "Indigenous" 5 "Yellow", replace
label values race race_label

* Country 

* Primeiro, substituir 'BRASIL' por '1'
replace country = "1" if country == "BRASIL"

* Depois, substituir todos os outros valores que não são 'BRASIL' para '2'
replace country = "2" if country != "1" & country != ""

* Por fim, substituir os valores vazios por '.'
replace country = "." if country == ""

* Converter de string para numérico
destring country, replace

* Definir os rótulos para as categorias
label define country_label 1 "Brazil" 2 "Other countries"
label values country country_label

* SEX
replace sex = "0" if sex == "F"
replace sex = "1" if sex == "M"
replace sex = "." if missing(sex)
destring sex, replace
label define sex_label 0 "Female" 1 "Male" 
label values sex sex_label

*Age

* Criar a variável de faixa etária (age_group)
gen age_group = .
replace age_group = 1 if age_tb < 15   
replace age_group = 2 if age_tb >= 15 & age_tb < 30  
replace age_group = 3 if age_tb >= 30 & age_tb < 45  
replace age_group = 4 if age_tb >= 45 & age_tb < 60  
replace age_group = 5 if age_tb >= 60  
label define age_group_label 1 "Under 15" 2 "15-29" 3 "30-44" 4 "45-59" 5 "60 and above"
label values age_group age_group_label

* Education Level
replace education = "0" if education == "Nenhuma"
replace education = "1" if education == "De 1 a 3 anos"
replace education = "2" if education == "De 4 a 7 anos"
replace education = "3" if education == "De 8 a 11 anos"
replace education = "4" if education == "De 12 a 14 anos"
replace education = "5" if education == "15 anos e mais"
replace education = "." if education == "Ignorado" | missing(education)
destring education, replace
label define education_label 0 "None" 1 "1-3 years" 2 "4-7 years" 3 "8-11 years" 4 "12-14 years" 5 "15 or more years" 
label values education education_label

* Occupation
replace occupation = "1" if occupation == "Desempregado"
replace occupation = "2" if occupation == "Dona de Casa"
replace occupation = "3" if occupation == "Detento"
replace occupation = "4" if occupation == "Profissional de Saude"
replace occupation = "5" if occupation == "Profissional Sistema Penitenciario"
replace occupation = "6" if occupation == "Outra" | missing(occupation)
replace occupation = "7" if occupation == "Aposentado"
destring occupation, replace
label define occupation_label 1 "Unemployed" 2 "Housewife" 3 "Inmate" 4 "Health Professional" 5 "Penitentiary Worker" 6 "Other" 7 "Retired"
label values occupation occupation_label

* Adress type
replace address_type = "1" if address_type == "ENDERECO PADRAO"
replace address_type = "2" if address_type == "DETENTO"
replace address_type = "3" if address_type == "SEM RESIDENCIA FIXA"
replace address_type = "." if missing(address_type)
destring address_type, replace
label define address_type_label 1 "Regular residence" 2 "Inmate" 3 "Homeless" 
label values address_type address_type_label

* Laboratorial confirmation
label define lab_confirmed_label 1 "Confirmed" 0 "Not Confirmed"
label values lab_confirmed lab_confirmed_label

* Case Type Classification
replace case_type = "1" if case_type == "Novo"
replace case_type = "2" if case_type == "Recidiva"
replace case_type = "3" if case_type == "Retr Aband"
replace case_type = "4" if case_type == "Retrat apos falencia/resistencia"
replace case_type = "5" if case_type == "Retrat apos mud esquema int/tox"
destring case_type, replace
label define case_type_label 1 "New" 2 "Recurrence" 3 "Retreatment after Abandonment" 4 "Retreatment after Failure/Resistance" 5 "Retreatment after Regimen Change"
label values case_type case_type_label

* Case Outcome Classification
replace case_outcome = "1" if case_outcome == "Cura"
replace case_outcome = "2" if case_outcome == "Obito TB"
replace case_outcome = "3" if case_outcome == "Obito NTB"
replace case_outcome = "4" if case_outcome == "Abandono"
replace case_outcome = "5" if case_outcome == "Falencia/Resistencia"
replace case_outcome = "6" if case_outcome == "Transf Outro Estado/Pais"
replace case_outcome = "7" if case_outcome == "Mud Diag"
replace case_outcome = "8" if case_outcome == "Mud Esquema Intoler/Toxicidade"
replace case_outcome = "9" if case_outcome == "Abandono Primario"
replace case_outcome = "10" if case_outcome == "Em Tratamento Ambulatorial"
replace case_outcome = "11" if case_outcome == "Transf"
replace case_outcome = "12" if case_outcome == "Faltoso"
replace case_outcome = "13" if case_outcome == "Em Tratamento Internado"
replace case_outcome = "." if missing(case_outcome)
destring case_outcome, replace
label define case_outcome_label 1 "Cured" 2 "TB Death" 3 "Non-TB Death" 4 "Abandoned" 5 "Failure/Resistance" 6 "Transferred to Other State/Country" 7 "Changed Diagnosis" 8 "Changed Regimen due to Intolerance/Toxicity" 9 "Primary Abandonment" 10 "In Outpatient Treatment" 11 "Transferred" 12 "Missed Appointment" 13 "Inpatient Treatment" 
label values case_outcome case_outcome_label

* Clinical Forms
replace clinical_form_1 = "1" if clinical_form_1 == "Pul"
replace clinical_form_1 = "2" if clinical_form_1 != "Pul" & !missing(clinical_form_1)
replace clinical_form_1 = "." if missing(clinical_form_1) 
destring clinical_form_1, replace 
label define clinical_form_label 1 "Pulmonary" 2 "Extrapulmonary"
label values clinical_form_1 clinical_form_label

* Clinical Classification
replace clinical_classif = "1" if clinical_classif == "Pul"
replace clinical_classif = "2" if clinical_classif == "Ext"
replace clinical_classif = "3" if clinical_classif == "P+E" | clinical_classif == "Dissem"
replace clinical_classif = "." if missing(clinical_classif)
destring clinical_classif, replace
label define clinical_classif_label 1 "Pulmonary" 2 "Extrapulmonary" 3 "Pulmonary + Extrapulmonary"
label values clinical_classif clinical_classif_label

* Clinical and Social Status

* HIV
replace hiv = "1" if hiv == "Pos" 
replace hiv = "2" if hiv == "Neg" 
replace hiv = "." if hiv == "N/realiz" | hiv == "And" | hiv == "S/inf" | missing(hiv) 
destring hiv, replace
label define hiv_label 1 "Positive" 2 "Negative" 
label values hiv hiv_label

* AIDS
replace aids = "1" if aids == "S"
replace aids = "0" if aids == "N"
replace aids = "." if missing(aids)
destring aids, replace
label define aids_label 1 "Yes" 0 "No" 
label values aids aids_label

* DIABETES
replace diabetes = "1" if diabetes == "S"
replace diabetes = "0" if diabetes == "N"
replace diabetes = "." if missing(diabetes)
destring diabetes, replace 
label define diabetes_label 1 "Yes" 0 "No" 
label values diabetes diabetes_label

* ALCOHOLISM
replace alcoholism = "1" if alcoholism == "S"
replace alcoholism = "0" if alcoholism == "N"
replace alcoholism = "." if missing(alcoholism)
destring alcoholism, replace 
label define alcoholism_label 1 "Yes" 0 "No" 
label values alcoholism alcoholism_label

* MENTAL ISSUE
replace mental_issue = "1" if mental_issue == "S"
replace mental_issue = "0" if mental_issue == "N"
replace mental_issue = "." if missing(mental_issue)
destring mental_issue, replace
label define mental_issue_label 1 "Yes" 0 "No" 
label values mental_issue mental_issue_label

* DRUG USE
replace drug_use = "1" if drug_use == "S"
replace drug_use = "0" if drug_use == "N"
replace drug_use = "." if missing(drug_use) 
destring drug_use, replace
label define drug_use_label 1 "Yes" 0 "No"
label values drug_use drug_use_label

* OTHER IMUNNOSSUPRESSIVE CONDITION 
replace other_immuno_condition = "1" if other_immuno_condition == "S"
replace other_immuno_condition = "0" if other_immuno_condition == "N"
replace other_immuno_condition = "." if missing(other_immuno_condition)
destring other_immuno_condition, replace
label define other_immune_label 1 "Yes" 0 "No" 
label values other_immuno_condition other_immune_label

* TOBACCO USE
replace tobacco_use = "1" if tobacco_use == "S"
replace tobacco_use = "0" if tobacco_use == "N"
replace tobacco_use = "." if missing(tobacco_use)
destring tobacco_use, replace
label define tobacco_label 1 "Yes" 0 "No" 
label values tobacco_use tobacco_label

* Molecular Test Performed (mudar aqui ta escrito tmr ao inves de trm)
replace tmr_tb = "1" if tmr_tb == "Mtb detectado - Rifamp sensivel"
replace tmr_tb = "2" if tmr_tb == "Mtb nao detectado"
replace tmr_tb = "3" if tmr_tb == "Mtb detectado - Rifamp resistente"
replace tmr_tb = "4" if tmr_tb == "Mtb detectado - Rifamp indeterm"
replace tmr_tb = "5" if tmr_tb == "Teste invalido"
replace tmr_tb = "6" if tmr_tb == "N/realiz"
replace tmr_tb = "." if missing(tmr_tb)
destring tmr_tb, replace
label define tmr_tb_label 1 "Mtb detected - Rifamp sensitive" 2 "Mtb not detected" 3 "Mtb detected - Rifamp resistant" 4 "Mtb detected - Rifamp indeterminate" 5 "Invalid test" 6 "Not performed" 
label values tmr_tb tmr_tb_label

* Control Bacteriological Tests
foreach var in bac1 bac2 bac3 bac4 bac5 bac6 bac7 bac8 bac9 {
 
    encode `var', generate(`var'_num)
    replace `var'_num = 1 if `var' == "Pos"        
    replace `var'_num = 2 if `var' == "Neg"         
    replace `var'_num = . if `var' == "N/realiz" | `var' == "S/inf" | `var' == "And" | missing(`var')  
    
   
    label define bac_label_`var' 1 "Positive" 2 "Negative"
    label values `var'_num bac_label_`var'
}
drop bac1 bac2 bac3 bac4 bac5 bac6 bac7 bac8 bac9

* Type of treatment administration administration 

* Garantir que a variável está no formato string antes de fazer as substituições
replace tx_administration_type = "1" if tx_administration_type == "Supervisionado"
replace tx_administration_type = "2" if tx_administration_type == "Auto-Administrado"
replace tx_administration_type = "." if tx_administration_type == "S/inf"
replace tx_administration_type = "." if tx_administration_type == ""
destring tx_administration_type, replace force
label define tx_admin_label 1 "Supervised" 2 "Self-Administered" 
label values tx_administration_type tx_admin_label

* Supervised Administration
replace supervised_tx_effectiveness = "1" if supervised_tx_effectiveness == "S"
replace supervised_tx_effectiveness = "2" if supervised_tx_effectiveness == "N"
destring supervised_tx_effectiveness, replace 
label define supervised_tx_effectiveness 1 "Effective" 2 "Not effective"
label values supervised_tx_effectiveness supervised_tx_effect_label

* Hospital Admission
replace hosp_admission = "1" if hosp_admission == "S"
replace hosp_admission = "0" if hosp_admission == "N"
replace hosp_admission = "." if missing(hosp_admission)
destring hosp_admission, replace
label define hosp_admission_label 1 "Yes" 0 "No" 
label values hosp_admission hosp_admission_label

* Disease Discovery
replace disease_discovery = "1" if disease_discovery == "Demanda Ambulatorial"
replace disease_discovery = "2" if disease_discovery == "Elucidacao Diagn. em Internacao"
replace disease_discovery = "3" if disease_discovery == "Busca Ativa em Instituicao"
replace disease_discovery = "5" if disease_discovery == "Descob. Apos Obito"
replace disease_discovery = "6" if disease_discovery == "Urgencia / Emergencia"
replace disease_discovery = "7" if disease_discovery == "Busca Ativa na Comunidade"
replace disease_discovery = "9" if disease_discovery == "Investigacao de Contatos"
replace disease_discovery = "." if disease_discovery == "nan" | disease_discovery == "S/inf"
destring disease_discovery, replace

label define disease_discovery_label 1 "Outpatient Demand" 2 "Diagnosis Clarification in Hospitalization" 3 "Active Search in Institution" 5 "Discovery After Death" 6 "Emergency / Urgency" 7 "Active Search in the Community" 9 "Contact Investigation"

label values disease_discovery disease_discovery_label

* Resistance
replace resistance = "." if resistance == "AND"

replace resistance = "1" if resistance == "SENS"
replace resistance = "2" if resistance == "TB R"  
replace resistance = "3" if resistance == "TB MR" 


destring resistance, replace

label define resistance_label 1 "SENS" 2 "TB R" 3 "TB MR" 

label values resistance resistance_label

*Sputum culture 
gen sputum_culture_num = .


* Atribuir valores numéricos às categorias relevantes
replace sputum_culture_num = 1 if sputum_culture == "Pos"
replace sputum_culture_num = 2 if sputum_culture == "Neg"
replace sputum_culture_num = 3 if sputum_culture == "N/realiz" | sputum_culture == "S/inf" | sputum_culture == "And" | sputum_culture == ""

destring sputum_culture_num, replace

label define sputum_culture_label 1 "Positive" 2 "Negative" 3 "Not Performed / No Information"

label values sputum_culture_num sputum_culture_label

**************************************************
** DATES  
**************************************************

gen dob_dt=date(dob,"MDY")
format dob_dt %td

gen txstart_dt = date(tx_start, "MDY")
format txstart_dt %td

gen notification_dt = date(notification_date, "MDY")
format notification_dt %td

gen diagnostic_dt = date(diagnostic_date, "MDY")
format diagnostic_dt %td

gen end_dt = date(end_date, "MDY")
format end_dt %td

gen dod_dt = date(dod, "MDY")
format dod_dt %td

drop dob notification_date tx_start diagnostic_date end_date dod

**************************************************
** EXCLUSION 
**************************************************


* Excluding the cases with "change in diagnosis" as case outcome

count if case_outcome == 7
drop if case_outcome == 7
*** 8,315 deleted cases 


* Cases transfered to another state or region at the first episode

count if (case_type ==1) & ((case_outcome ==6 | case_outcome ==11))
drop if (case_type ==1) & ((case_outcome ==6 | case_outcome ==11))
*** 1,861 observations deleted


* New cases without outcome
count if (case_type ==1) & ((case_outcome ==10 | case_outcome ==13))
drop if (case_type ==1) & ((case_outcome ==10 | case_outcome ==13))
*** 6 observations deleted


count if (case_type ==1) & (case_outcome ==.)
drop if (case_type ==1) & (case_outcome ==.)
*** 12,475 observations deleted

**************************************************
** ORDER OF EVENTS AND INCONSISTENCIES
**************************************************

* Checking Order of events
sort sinan txstart_dt tx_seq case_outcome

bysort sinan (tx_seq): gen txseq_lag = tx_seq[_n-1]

bysort sinan (txstart_dt): gen txdate_lag = txstart_dt[_n-1]

format txdate_lag %td

gen txstart_txseq_incon = (tx_seq < txseq_lag & txstart_dt > txdate_lag)

* Generating proxy date variable. Uses Trt start if available, replaces with diagnosis date is tx start date is missing

gen proxy_date=txstart_dt
replace proxy_date= diagnostic_dt if proxy_date==.
format proxy_date %td


* Checking for inconsistencies in txt seq and proxy date which replace missing tx start date with diagnosis date
sort sinan proxy_date tx_seq case_outcome race country education
bysort sinan (proxy_date): gen proxydate_lag = proxy_date[_n-1]
format proxydate_lag %td

gen proxy_txseq_incon = (tx_seq < txseq_lag & proxy_date > proxydate_lag)

codebook proxy_txseq_incon
** 10 inconsistent observations. 


**************************************

* DATA CLEANING

**************************************

. list sinan if proxy_txseq_incon==1

*        +---------+
*        |   sinan |
*        |---------|
*   106. |    1458 |
*  4976. |  186251 |
* 25902. | 1077292 |
* 43327. | 2025818 |
* 58015. | 2486113 |
*        |---------|
* 80099. | 3633237 |
* 86531. | 3885102 |
*131170. | 5758683 |
*137058. | 6023124 |
*158113. | 6780190 |
*        +---------+

tostring sinan, generate(study_sinan)

* After inspecting data obs 7657 incorrectly assigned sinan

** Adding the x to the new study_sinan variable for these
replace study_sinan="x1458" in 106

replace study_sinan="x186251" in 4976

replace study_sinan="x1077292" in 25902

replace study_sinan="x2025818" in 43327


replace study_sinan="x3885102" in 86530

* 58015 exclude from analysis dates inconsistent
drop if sinan==2486113
* 2 obs dropped


* 80099 exclude from analysis dates inconsistent
drop if sinan== 3633237
* 2 obs dropped


* 131170 exclude from analysis dates inconsistent
drop if sinan==5758683
* 2 obs dropped


*137058 exclude from analysis dates inconsistent
drop if sinan==6023124 
* 5 obs dropped


*158113 exclude from analysis dates inconsistent
drop if sinan== 6780190
* 2 obs dropped


* 13 dropped due to date inconsistencies


************************************************
** REGENERATE PROXY DATE VARIABLES
************************************************

drop txseq_lag txdate_lag txstart_txseq_incon proxy_date proxydate_lag proxy_txseq_incon


* Rue-run code below


**************************************************
** ORDER OF EVENTS AND INCONSISTENCIES
**************************************************

* Checking Order of events
sort study_sinan txstart_dt tx_seq case_outcome

bysort study_sinan (tx_seq): gen txseq_lag = tx_seq[_n-1]

bysort study_sinan (txstart_dt): gen txdate_lag = txstart_dt[_n-1]

format txdate_lag %td

gen txstart_txseq_incon = (tx_seq < txseq_lag & txstart_dt > txdate_lag)

* Generating proxy date variable. Uses Trt start if available, replaces with diagnosis date is tx start date is missing

gen proxy_date=txstart_dt
replace proxy_date= diagnostic_dt if proxy_date==.
format proxy_date %td


* Checking for inconsistencies in txt seq and proxy date which replace missing tx start date with diagnosis date
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): gen proxydate_lag = proxy_date[_n-1]
format proxydate_lag %td

gen proxy_txseq_incon = (tx_seq < txseq_lag & proxy_date > proxydate_lag)

codebook proxy_txseq_incon
** 3 inconsistent observations. 

. list sinan if proxy_txseq_incon==1

*        +---------+
*        |   sinan |
*        |---------|
* 41646. |  257161 |
*175321. | 7360797 |
*215712. | 8868793 |
*        +---------+

replace study_sinan="x257161" in 41646



* 175321 - duplicate notification
drop in 175321

*215712 - duplicate notification & misassigned sinan
replace study_sinan="x8868793" in 215712
drop in 215711

* duplicate notification in obs 215710
drop in 215710


* 3 duplicate notifications dropped




************************************************
** REGENERATE PROXY DATE VARIABLES
************************************************

drop txseq_lag txdate_lag txstart_txseq_incon proxy_date proxydate_lag proxy_txseq_incon


* Rue-run code below


**************************************************
** ORDER OF EVENTS AND INCONSISTENCIES
**************************************************

* Checking Order of events
sort study_sinan txstart_dt tx_seq case_outcome

bysort study_sinan (tx_seq): gen txseq_lag = tx_seq[_n-1]

bysort study_sinan (txstart_dt): gen txdate_lag = txstart_dt[_n-1]

format txdate_lag %td

gen txstart_txseq_incon = (tx_seq < txseq_lag & txstart_dt > txdate_lag)

* Generating proxy date variable. Uses Trt start if available, replaces with diagnosis date is tx start date is missing

gen proxy_date=txstart_dt
replace proxy_date= diagnostic_dt if proxy_date==.
format proxy_date %td


* Checking for inconsistencies in txt seq and proxy date which replace missing tx start date with diagnosis date
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): gen proxydate_lag = proxy_date[_n-1]
format proxydate_lag %td

gen proxy_txseq_incon = (tx_seq < txseq_lag & proxy_date > proxydate_lag)

codebook proxy_txseq_incon


** 0 inconsistent observations!





**********************************
* GREAT! - DATA IS CLEANER
**********************************









**************************************************
** GENERATING VARIABLES FOR RECURRENCE
**************************************************

* Generating binary variables for cure and recurrence

gen cured = 1 if (case_outcome == 1)
gen recurrence = 1 if (case_type == 2)

* Sorting data by sinan and proxy date.
sort study_sinan proxy_date tx_seq case_outcome

* Generating variables for recurrence after a cure and recurrence without a prior cure case

bysort study_sinan (proxy_date): gen had_cure_before = (cured[_n-1] == 1)
gen recurrence_after_cure = (recurrence == 1 & had_cure_before == 1)
gen recurrence_without_prior_cure = (recurrence == 1 & had_cure_before == 0)


* Generating variable to see who ever experienced a recurrence
sort study_sinan proxy_date tx_seq case_outcome
egen ever_had_recurrence = max(recurrence), by(study_sinan)
label variable ever_had_recurrence "Ever had at least one recurrence"
codebook ever_had_recurrence


* Identificar pacientes que tiveram pelo menos um "new case"
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen ever_had_new = max(case_type == 1)
label variable ever_had_new "Ever had a new TB case"

* Identificar pacientes que tiveram pelo menos uma cura
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen ever_had_cure = max(cured == 1)
label variable ever_had_cure "Ever had at least one TB cure"


** total_recurrences is which recurrence episode the case is
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): gen total_recurrences = sum(recurrence)
label variable total_recurrences "Which recurrence episode the case is"

* total_recurrences[_N] ensures every row for that patient gets their final recurrence count.
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): gen total_recurrences_count = total_recurrences[_N]
label variable total_recurrences_count "Every row for that patient gets their final recurrence count"








*** IS - Who had a cure of their 1st TB episode?

* Number which cure the row is
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): gen total_cures = sum(cured)








* Criar variável que marca a **primeira entrada** em que o paciente atende aos critérios
sort study_sinan proxy_date tx_seq case_outcome
gen at_risk_population = 0
bysort study_sinan (proxy_date): replace at_risk_population = 1 if ever_had_new == 1 & ever_had_cure == 1 & _n == 1

* Verificar quantos pacientes foram marcados corretamente
tab at_risk_population

*at_risk_pop |
*    ulation |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |     87,110       35.12       35.12
*          1 |    160,952       64.88      100.00
*------------+-----------------------------------
*      Total |    248,062      100.00


label variable at_risk_population "At-risk population: first new TB case that cured"


* Identificar pacientes que tiveram pelo menos uma recorrência após a cura
*bysort sinan (proxy_date): egen ever_had_recurrence = max(recurrence_after_cure == 1)
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen ever_had_curethenrecurrence = max(recurrence_after_cure == 1)

* Criar variável que identifica quem, dentro da população de risco, teve recorrência na **primeira entrada**
sort study_sinan proxy_date tx_seq case_outcome
gen at_risk_recurrence =.
bysort study_sinan (proxy_date): replace at_risk_recurrence = 1 if at_risk_population == 1 & ever_had_curethenrecurrence == 1 & _n == 1

bysort study_sinan (proxy_date): replace at_risk_recurrence = 0 if at_risk_population == 1 & ever_had_curethenrecurrence == 0 & _n == 1


* Verificar quantos pacientes tiveram recorrência
tab at_risk_recurrence

*at_risk_rec |
*    urrence |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |    151,101       93.88       93.88
*          1 |      9,851        6.12      100.00
*------------+-----------------------------------
*      Total |    160,952      100.00



label variable at_risk_recurrence "Recurrence within at-risk population (first entry)"




* Making intermediate variable to flag when the cure of the 1st TB episode was
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): gen cure_sum = sum(total_cures)



* Generate variable for ever population at risk
sort study_sinan proxy_date tx_seq case_outcome
 bysort study_sinan (proxy_date): egen ever_pop_at_risk = max(at_risk_population == 1)


* Flagging the cure of the 1st episode

gen cure_TBepisode1_flag=.
replace cure_TBepisode1_flag=1 if total_cures==1 & cure_sum==1 & ever_pop_at_risk==1


** Checking to make sure all population at risk has a cure flagged
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen ever_cureTB1_flag = max(cure_TBepisode1_flag == 1)
tab ever_cureTB1_flag



*ever_cureTB |
*     1_flag |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |     66,276       26.72       26.72
*          1 |    181,786       73.28      100.00
*------------+-----------------------------------
*      Total |    248,062      100.00



	  
tab ever_pop_at_risk

*ever_pop_at |
*      _risk |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |     66,276       26.72       26.72
*          1 |    181,786       73.28      100.00
*------------+-----------------------------------
*      Total |    248,062      100.00

. list sinan if ever_pop_at_risk==1 & ever_cureTB1_flag!=1, clean

*            sinan  
* 81182.   4224002  
* 81183.   4224002  
* 81184.   4224002  
* 81185.   4224002  
*152220.   6713711  
*152221.   6713711  
*152222.   6713711  
*152223.   6713711  
*155934.    681191  
*155935.    681191  
*155936.    681191  
*155937.    681191  
*166131.    708478  
*166132.    708478  
*166133.    708478  
*166134.    708478  
*220889.   9027835  
*220890.   9027835  
*220891.   9027835  
*220892.   9027835  


*** THESE ARE DUPLICATE NOTIFICATIONS FOR THE SAME CASE - ALL SAME DATES AND INFO
* 81182.   4224002  
* 81183.   4224002  
* 81184.   4224002  
* 81185.   4224002  

drop in 81182
drop in 81182
drop in 81182

*** THESE ARE DUPLICATE NOTIFICATIONS FOR THE SAME CASE - ALL SAME DATES AND INFO
** The row numbers have been updated since we deleted some above

*152220.   6713711  
*152221.   6713711  
*152222.   6713711  
*152223.   6713711  

drop in 152217
drop in 152217
drop in 152217

*** THESE ARE DUPLICATE NOTIFICATIONS FOR THE SAME CASE - ALL SAME DATES AND INFO
** The row numbers have been updated since we deleted some above

*155934.    681191  
*155935.    681191  
*155936.    681191  
*155937.    681191  

drop in 155929
drop in 155929
drop in 155929



*** THESE ARE DUPLICATE NOTIFICATIONS FOR THE SAME CASE - ALL SAME DATES AND INFO
** The row numbers have been updated since we deleted some above


*166131.    708478  
*166132.    708478  
*166133.    708478  
*166134.    708478  

drop in 166123
drop in 166123
drop in 166123


*** THESE ARE DUPLICATE NOTIFICATIONS FOR THE SAME CASE - ALL SAME DATES AND INFO
** The row numbers have been updated since we deleted some above

*220889.   9027835  
*220890.   9027835  
*220891.   9027835  
*220892.   9027835  

drop in 220877
drop in 220877
drop in 220877

* 15 duplicate notifications dropped

*******************************************

* NOW DATA IS EVEN CLEANER - SO LET'S RUN ALL THE CODE AGAIN

*******************************************

* DROP THE VARIABLES WE GENERATED

drop txseq_lag txdate_lag txstart_txseq_incon proxy_date proxydate_lag proxy_txseq_incon cured recurrence had_cure_before recurrence_after_cure recurrence_without_prior_cure ever_had_recurrence ever_had_new ever_had_cure total_recurrences total_recurrences_count total_cures at_risk_population ever_had_curethenrecurrence at_risk_recurrence cure_sum ever_pop_at_risk cure_TBepisode1_flag ever_cureTB1_flag


* Rue-run code below


**************************************************
** ORDER OF EVENTS AND INCONSISTENCIES
**************************************************

* Checking Order of events
sort study_sinan txstart_dt tx_seq case_outcome

bysort study_sinan (tx_seq): gen txseq_lag = tx_seq[_n-1]

bysort study_sinan (txstart_dt): gen txdate_lag = txstart_dt[_n-1]

format txdate_lag %td

gen txstart_txseq_incon = (tx_seq < txseq_lag & txstart_dt > txdate_lag)

* Generating proxy date variable. Uses Trt start if available, replaces with diagnosis date is tx start date is missing

gen proxy_date=txstart_dt
replace proxy_date= diagnostic_dt if proxy_date==.
format proxy_date %td


* Checking for inconsistencies in txt seq and proxy date which replace missing tx start date with diagnosis date
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): gen proxydate_lag = proxy_date[_n-1]
format proxydate_lag %td

gen proxy_txseq_incon = (tx_seq < txseq_lag & proxy_date > proxydate_lag)

codebook proxy_txseq_incon


** 0 inconsistent observations!



**************************************************
** GENERATING VARIABLES FOR RECURRENCE
**************************************************
sort study_sinan proxy_date tx_seq case_outcome

* Generating binary variables for cure and recurrence

gen cured = 1 if (case_outcome == 1)
gen recurrence = 1 if (case_type == 2)

* Sorting data by sinan and proxy date.
sort study_sinan proxy_date tx_seq case_outcome

* Generating variables for recurrence after a cure and recurrence without a prior cure case

bysort study_sinan (proxy_date): gen had_cure_before = (cured[_n-1] == 1)
gen recurrence_after_cure = (recurrence == 1 & had_cure_before == 1)
gen recurrence_without_prior_cure = (recurrence == 1 & had_cure_before == 0)


* Generating variable to see who ever experienced a recurrence
sort study_sinan proxy_date tx_seq case_outcome
egen ever_had_recurrence = max(recurrence), by(study_sinan)
label variable ever_had_recurrence "Ever had at least one recurrence"
codebook ever_had_recurrence


* Identificar pacientes que tiveram pelo menos um "new case"
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen ever_had_new = max(case_type == 1)
label variable ever_had_new "Ever had a new TB case"

* Identificar pacientes que tiveram pelo menos uma cura
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen ever_had_cure = max(cured == 1)
label variable ever_had_cure "Ever had at least one TB cure"


** total_recurrences is which recurrence episode the case is
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): gen total_recurrences = sum(recurrence)
label variable total_recurrences "Which recurrence episode the case is"

* total_recurrences[_N] ensures every row for that patient gets their final recurrence count.
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): gen total_recurrences_count = total_recurrences[_N]
label variable total_recurrences_count "Every row for that patient gets their final recurrence count"








*** IS - Who had a cure of their 1st TB episode?

* Number which cure the row is
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): gen total_cures = sum(cured)








* Criar variável que marca a **primeira entrada** em que o paciente atende aos critérios
sort study_sinan proxy_date tx_seq case_outcome
gen at_risk_population = 0
bysort study_sinan (proxy_date): replace at_risk_population = 1 if ever_had_new == 1 & ever_had_cure == 1 & _n == 1

* Verificar quantos pacientes foram marcados corretamente
tab at_risk_population

*at_risk_pop |
*    ulation |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |     87,096       35.11       35.11
*          1 |    160,951       64.89      100.00
*------------+-----------------------------------
*      Total |    248,047      100.00


label variable at_risk_population "At-risk population: first new TB case that cured"


* Identificar pacientes que tiveram pelo menos uma recorrência após a cura
*bysort sinan (proxy_date): egen ever_had_recurrence = max(recurrence_after_cure == 1)
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen ever_had_curethenrecurrence = max(recurrence_after_cure == 1)

* Criar variável que identifica quem, dentro da população de risco, teve recorrência na **primeira entrada**
gen at_risk_recurrence =.
bysort study_sinan (proxy_date): replace at_risk_recurrence = 1 if at_risk_population == 1 & ever_had_curethenrecurrence == 1 & _n == 1

bysort study_sinan (proxy_date): replace at_risk_recurrence = 0 if at_risk_population == 1 & ever_had_curethenrecurrence == 0 & _n == 1


* Verificar quantos pacientes tiveram recorrência
tab at_risk_recurrence

*at_risk_rec |
*    urrence |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |    151,100       93.88       93.88
*          1 |      9,851        6.12      100.00
*------------+-----------------------------------
*      Total |    160,951      100.00

label variable at_risk_recurrence "Recurrence within at-risk population (first entry)"




* Making intermediate variable to flag when the cure of the 1st TB episode was
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): gen cure_sum = sum(total_cures)



* Generate variable for ever population at risk
sort study_sinan proxy_date tx_seq case_outcome
 bysort study_sinan (proxy_date): egen ever_pop_at_risk = max(at_risk_population == 1)


* Flagging the cure of the 1st episode

gen cure_TBepisode1_flag=.
replace cure_TBepisode1_flag=1 if total_cures==1 & cure_sum==1 & ever_pop_at_risk==1


** Checking to make sure all population at risk has a cure flagged
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen ever_cureTB1_flag = max(cure_TBepisode1_flag == 1)

. tab ever_cureTB1_flag

*ever_cureTB |
*     1_flag |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |     66,276       26.72       26.72
*          1 |    181,771       73.28      100.00
*------------+-----------------------------------
*      Total |    248,047      100.00


	  
tab ever_pop_at_risk

*ever_pop_at |
*      _risk |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |     66,276       26.72       26.72
*          1 |    181,771       73.28      100.00
*------------+-----------------------------------
*      Total |    248,047      100.00

***** TOTALS ARE ADDING CORRECTLY

. list sinan if ever_pop_at_risk==1 & ever_cureTB1_flag!=1, clean

* O obs - GREAT!



* Verifying that a cure for TB episode 1 is flagged for each person at risk

. tab cure_TBepisode1_flag

*cure_TBepis |
*  ode1_flag |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          1 |    160,951      100.00      100.00
*------------+-----------------------------------
*      Total |    160,951      100.00

* PERFECT - 160,951 cures flagged for the 160,951 at risk



label variable cure_TBepisode1_flag "Flag for cure of 1st TB episode"





* Flag the primary recurrence after cure of the 1st TB episode
sort study_sinan proxy_date tx_seq case_outcome
gen primary_recurrence = 0
bysort study_sinan (proxy_date): replace primary_recurrence = 1 if recurrence == 1 & cure_TBepisode1_flag[_n-1] == 1 & total_recurrences==1



. tab primary_recurrence

*primary_rec |
*urrence |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |    238,228       96.03       96.03
*          1 |      9,850        3.97      100.00
*------------+-----------------------------------
*      Total |    248,078      100.00


*9,850 primary recurrences


. tab at_risk_recurrence

* Recurrence |
*     within |
*    at-risk |
* population |
*     (first |
*     entry) |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |    151,100       93.88       93.88
*          1 |      9,851        6.12      100.00
*------------+-----------------------------------
*      Total |    160,951      100.00




* Why aren't these totals matching?


* Inspected Data - sinan 257161 has a misassigned sinan for one of the episodes


replace study_sinan="x257161" in 41646


*****************************************

* NOW LETS RUN ALL OF THE CODE AGAIN

*****************************************


*******************************************

* NOW DATA IS EVEN CLEANER - SO LET'S RUN ALL THE CODE AGAIN

*******************************************

* DROP THE VARIABLES WE GENERATED

drop txseq_lag txdate_lag txstart_txseq_incon proxy_date proxydate_lag proxy_txseq_incon cured recurrence had_cure_before recurrence_after_cure recurrence_without_prior_cure ever_had_recurrence ever_had_new ever_had_cure total_recurrences total_recurrences_count total_cures at_risk_population ever_had_curethenrecurrence at_risk_recurrence cure_sum ever_pop_at_risk cure_TBepisode1_flag ever_cureTB1_flag primary_recurrence


* Rue-run code below


**************************************************
** ORDER OF EVENTS AND INCONSISTENCIES
**************************************************

* Checking Order of events
sort study_sinan txstart_dt tx_seq case_outcome

bysort study_sinan (tx_seq): gen txseq_lag = tx_seq[_n-1]

bysort study_sinan (txstart_dt): gen txdate_lag = txstart_dt[_n-1]

format txdate_lag %td

gen txstart_txseq_incon = (tx_seq < txseq_lag & txstart_dt > txdate_lag)

* Generating proxy date variable. Uses Trt start if available, replaces with diagnosis date is tx start date is missing

gen proxy_date=txstart_dt
replace proxy_date= diagnostic_dt if proxy_date==.
format proxy_date %td


* Checking for inconsistencies in txt seq and proxy date which replace missing tx start date with diagnosis date
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): gen proxydate_lag = proxy_date[_n-1]
format proxydate_lag %td

gen proxy_txseq_incon = (tx_seq < txseq_lag & proxy_date > proxydate_lag)

codebook proxy_txseq_incon


** 0 inconsistent observations!



**************************************************
** GENERATING VARIABLES FOR RECURRENCE
**************************************************

* Generating binary variables for cure and recurrence
sort study_sinan proxy_date tx_seq case_outcome
gen cured = 1 if (case_outcome == 1)
gen recurrence = 1 if (case_type == 2)

* Sorting data by sinan and proxy date.
sort study_sinan proxy_date tx_seq case_outcome

* Generating variables for recurrence after a cure and recurrence without a prior cure case
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): gen had_cure_before = (cured[_n-1] == 1)
gen recurrence_after_cure = (recurrence == 1 & had_cure_before == 1)
gen recurrence_without_prior_cure = (recurrence == 1 & had_cure_before == 0)


* Generating variable to see who ever experienced a recurrence
sort study_sinan proxy_date tx_seq case_outcome
egen ever_had_recurrence = max(recurrence), by(study_sinan)
label variable ever_had_recurrence "Ever had at least one recurrence"
codebook ever_had_recurrence


* Identificar pacientes que tiveram pelo menos um "new case"
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen ever_had_new = max(case_type == 1)
label variable ever_had_new "Ever had a new TB case"

* Identificar pacientes que tiveram pelo menos uma cura
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen ever_had_cure = max(cured == 1)
label variable ever_had_cure "Ever had at least one TB cure"


** total_recurrences is which recurrence episode the case is
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): gen total_recurrences = sum(recurrence)
label variable total_recurrences "Which recurrence episode the case is"

* total_recurrences[_N] ensures every row for that patient gets their final recurrence count.
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): gen total_recurrences_count = total_recurrences[_N]
label variable total_recurrences_count "Every row for that patient gets their final recurrence count"








*** IS - Who had a cure of their 1st TB episode?

* Number which cure the row is
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): gen total_cures = sum(cured)








* Criar variável que marca a **primeira entrada** em que o paciente atende aos critérios
sort study_sinan proxy_date tx_seq case_outcome
gen at_risk_population = 0
bysort study_sinan (proxy_date): replace at_risk_population = 1 if ever_had_new == 1 & ever_had_cure == 1 & _n == 1

* Verificar quantos pacientes foram marcados corretamente
tab at_risk_population

*at_risk_pop |
*    ulation |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |     87,095       35.11       35.11
*          1 |    160,952       64.89      100.00
*------------+-----------------------------------
*      Total |    248,047      100.00



label variable at_risk_population "At-risk population: first new TB case that cured"


* Identificar pacientes que tiveram pelo menos uma recorrência após a cura
*bysort sinan (proxy_date): egen ever_had_recurrence = max(recurrence_after_cure == 1)
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen ever_had_curethenrecurrence = max(recurrence_after_cure == 1)

* Criar variável que identifica quem, dentro da população de risco, teve recorrência na **primeira entrada**
sort study_sinan proxy_date tx_seq case_outcome
gen at_risk_recurrence =.
bysort study_sinan (proxy_date): replace at_risk_recurrence = 1 if at_risk_population == 1 & ever_had_curethenrecurrence == 1 & _n == 1

bysort study_sinan (proxy_date): replace at_risk_recurrence = 0 if at_risk_population == 1 & ever_had_curethenrecurrence == 0 & _n == 1


* Verificar quantos pacientes tiveram recorrência
tab at_risk_recurrence

*at_risk_rec |
*    urrence |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |    151,101       93.88       93.88
*          1 |      9,851        6.12      100.00
*------------+-----------------------------------
*      Total |    160,952      100.00



label variable at_risk_recurrence "Recurrence within at-risk population (first entry)"




* Making intermediate variable to flag when the cure of the 1st TB episode was
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): gen cure_sum = sum(total_cures)



* Generate variable for ever population at risk
sort study_sinan proxy_date tx_seq case_outcome
 bysort study_sinan (proxy_date): egen ever_pop_at_risk = max(at_risk_population == 1)


* Flagging the cure of the 1st episode

gen cure_TBepisode1_flag=.
replace cure_TBepisode1_flag=1 if total_cures==1 & cure_sum==1 & ever_pop_at_risk==1


** Checking to make sure all population at risk has a cure flagged
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen ever_cureTB1_flag = max(cure_TBepisode1_flag == 1)

. tab ever_cureTB1_flag

*ever_cureTB |
*     1_flag |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |     66,276       26.72       26.72
*          1 |    181,771       73.28      100.00
*------------+-----------------------------------
*      Total |    248,047      100.00


	  
tab ever_pop_at_risk

*ever_pop_at |
*      _risk |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |     66,276       26.72       26.72
*          1 |    181,771       73.28      100.00
*------------+-----------------------------------
*      Total |    248,047      100.00

***** TOTALS ARE ADDING CORRECTLY

. list sinan if ever_pop_at_risk==1 & ever_cureTB1_flag!=1, clean

* O obs - GREAT!



* Verifying that a cure for TB episode 1 is flagged for each person at risk

. tab cure_TBepisode1_flag

*cure_TBepis |
*  ode1_flag |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          1 |    160,952      100.00      100.00
*------------+-----------------------------------
*      Total |    160,952      100.00



********** SINCE WE CLEANED THE DATA, THE NUMBER AT RISK INCREASED BY 1

* PERFECT - 160,952 cures flagged for the 160,952 at risk



label variable cure_TBepisode1_flag "Flag for cure of 1st TB episode"





* Flag the primary recurrence after cure of the 1st TB episode
sort study_sinan proxy_date tx_seq case_outcome
gen primary_recurrence = 0
bysort study_sinan (proxy_date): replace primary_recurrence = 1 if recurrence == 1 & cure_TBepisode1_flag[_n-1] == 1 & total_recurrences==1



. tab primary_recurrence

*primary_rec |
*    urrence |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |    238,196       96.03       96.03
*          1 |      9,851        3.97      100.00
*------------+-----------------------------------
*      Total |    248,047      100.00



*9,851 primary recurrences


. tab at_risk_recurrence

* Recurrence |
*     within |
*    at-risk |
* population |
*     (first |
*     entry) |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |    151,101       93.88       93.88
*          1 |      9,851        6.12      100.00
*------------+-----------------------------------
*      Total |    160,952      100.00



***** GREAT ! Now the totals are matching




 
 * Who ever had a primary recurrence? Marking all rows of a sinan with it.
 sort study_sinan proxy_date tx_seq case_outcome
 bysort study_sinan (proxy_date): egen ever_had_primaryrecurr = max(primary_recurrence == 1)
 label variable ever_had_primaryrecurr "Ever had at least one recurrence after cure of 1st TB episode"
 
 
 
 
 
 ***************************************************
** RECURRENCE AFTER RETREATMENT (1ST EPISODE OF TB)
***************************************************

**** Identify the first TB episode with incomplete treatment (First case New + incomplete treatment) 

* Sorting data by sinan and proxy date.
sort study_sinan proxy_date tx_seq case_outcome

**** Cases with Incomplete Treatment
gen treatment_incomplete = 1 if ((case_outcome == 4) |  (case_outcome == 5) | (case_outcome == 8) | (case_outcome == 9))
replace treatment_incomplete = 0 if missing(treatment_incomplete)

**** First case (New Case) with incomplete treatment 

bysort study_sinan (proxy_date): gen firstcase_new_incomplete = (case_type == 1 & treatment_incomplete == 1 & _n == 1)






***** THIS PART BELOW IS GOOD!!!! IS editted to include possibility of multiple retreatments before cure.
sort study_sinan proxy_date tx_seq case_outcome
gen retreatment=1 if case_type==3 | case_type==4 | case_type==5
bysort study_sinan (proxy_date): gen total_retreatments = sum(retreatment)

gen retreatment_withcure=1 if (case_type==3 | case_type==4 | case_type==5) & case_outcome ==1
bysort study_sinan (proxy_date): gen total_retreatmentcures = sum(retreatment_withcure)

bysort study_sinan (proxy_date): egen ever_1stcase_new_incomplete = max(firstcase_new_incomplete == 1)

gen retreatment_cure_newincomplete=1 if ever_1stcase_new_incomplete==1 & retreatment_withcure==1 & total_retreatmentcures==1

label variable retreatment_cure_newincomplete "1st Retreatment case with a cure of the 1st TB episode"


. tab retreatment_cure_newincomplete

*        1st |
*Retreatment |
*case with a |
*cure of the |
*     1st TB |
*    episode |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          1 |      6,888      100.00      100.00
*------------+-----------------------------------
*      Total |      6,888      100.00

*6,888 people had a cure of 1st tb episode after retreatment, this includes people who may have had multiple retreatments before the cure of the 1st episode


*_____________________________________________







***********************************************************************
* NEW CASES WITHOUT CURE - IDENTIFING WHO DIED DURING 1st TB TREATMENT
***********************************************************************


* Criar uma variável para identificar pacientes com caso novo e sem cura
sort study_sinan proxy_date tx_seq case_outcome
gen new_case_no_cure = 0
bysort study_sinan (proxy_date): replace new_case_no_cure = 1 if ever_had_new == 1 & ever_had_cure == 0 & _n == 1


* Criar variável para identificar mortes após um caso novo sem cura, mesmo que tenha havido retratamentos
bysort study_sinan (proxy_date): egen ever_died_no_cure = max(case_outcome == 2 | case_outcome == 3)

* Criar variável para marcar mortes na primeira entrada que atende aos critérios
gen new_case_no_cure_death = 0
bysort study_sinan (proxy_date): replace new_case_no_cure_death = 1 if new_case_no_cure == 1 & ever_died_no_cure == 1 & _n == 1

* Tabular para verificar quantos pacientes morreram dentro dessa população
tab new_case_no_cure_death


**  17,695  observations 


* Adicionar rótulo geral para as variáveis
label variable new_case_no_cure "New TB case, never cured"
label variable ever_died_no_cure "Died at any time after a new TB case without cure"
label variable new_case_no_cure_death "New TB case, never cured, died"





*** DROP THESE CASES IN CERTAIN MOMENT







*-------------------------------------------------------------
* Multiple recurrences
*-------------------------------------------------------------

sort study_sinan proxy_date tx_seq case_outcome

* ENSURING THAT THE ROW BEFORE THE NEXT RECCURENCE IS A CURE WHEN GENERATING THESE VARIABLES

* Step 1: Initialize the variable
gen recurrence_num = .

* Step 2: Assign 1 for primary recurrence
bysort study_sinan (proxy_date): replace recurrence_num = 1 if primary_recurrence == 1 

* Step 3: Assign 2 for the second recurrence
bysort study_sinan (proxy_date): replace recurrence_num = 2 if _n > 1 & total_cures[_n-1] == 2 & total_recurrences == 2

* Step 4: Assign 3 for the third recurrence
bysort study_sinan (proxy_date): replace recurrence_num = 3 if _n > 1 & total_cures[_n-1] == 3 & total_recurrences == 3

* Step 5: Assign 4 for the fourth recurrence
bysort study_sinan (proxy_date): replace recurrence_num = 4 if _n > 1 & total_cures[_n-1] == 4 & total_recurrences == 4

* Step 6: Assign 5 for the 5th recurrence
bysort study_sinan (proxy_date): replace recurrence_num = 5 if _n > 1 & total_cures[_n-1] == 5 & total_recurrences == 5

* Assign 0 for no recurrences
replace recurrence_num=0 if total_recurrences_count==0

label variable recurrence_num "Recurrence #: recurrence must have occurred after obs. cure of prev episode"

label define recurrence_num_label 0 "No recurrences" 1 "Primary Recurrence" 2 "2nd recurrence" 3 "3rd recurrence" 4 "4th recurrence" 5 "5th recurrence"
label values recurrence_num recurrence_num_label




. tab recurrence_num

*     Recurrence #: |
*   recurrence must |
*     have occurred |
*after obs. cure of |
*      prev episode |      Freq.     Percent        Cum.
*-------------------+-----------------------------------
*    No recurrences |    208,073       94.94       94.94
*Primary Recurrence |      9,851        4.49       99.44
*    2nd recurrence |      1,089        0.50       99.93
*    3rd recurrence |        127        0.06       99.99
*    4th recurrence |         14        0.01      100.00
*    5th recurrence |          3        0.00      100.00
*-------------------+-----------------------------------
*             Total |    219,157      100.00









************************************************
* Categorizing cases - CHECAR!!!
************************************************
sort study_sinan proxy_date tx_seq case_outcome

** Categorizing cases
gen case_cat=.

* New + Cure case. No primary recurrence cases.
replace case_cat=0 if case_type==1 & case_outcome==1 & ever_had_primaryrecurr==0

* New+ Cure case, before the primary recurrence WITHOUT RETREATMENT.
replace case_cat=1 if ever_had_primaryrecurr == 1 & case_type==1 & case_outcome==1


* Death in 1st TB episode
replace case_cat=2 if new_case_no_cure_death==1


* New + Abandonned case

replace case_cat=3 if case_type==1 & case_outcome==4 & case_cat==.

* New + Failure/Resistance case.
replace case_cat=4 if case_type==1 & case_outcome==5 & case_cat==.

*New + Changed Regimen case.
replace case_cat=5 if case_type==1 & case_outcome==8 & case_cat==.

*New + Primary Abandonment case.
replace case_cat=6 if case_type==1 & case_outcome==9 & case_cat==.

*New + missed appointment
replace case_cat=7 if case_type==1 & case_outcome==12 & case_cat==.

*Retreatment case.
replace case_cat = 8 if (case_type==3 | case_type==4 | case_type==5) & case_cat==.


* Primary recurrence case.
replace case_cat=9 if primary_recurrence == 1

* Second Recurrence.
replace case_cat=10 if recurrence_num == 2 & case_cat==.

* Third Recurrence.
replace case_cat=11 if recurrence_num == 3 & case_cat==.

* 4th Recurrence.
replace case_cat=12 if recurrence_num == 4 & case_cat==.

* 5th Recurrence.
replace case_cat=13 if recurrence_num == 5 & case_cat==.

* No New case observed.
replace case_cat=99 if ever_had_new==0




codebook case_cat

* 13 missing a category

. . list sinan if case_cat==., clean

*            sinan  
* 57399.   3257430  
* 62639.   3489763  
* 74854.    391277  
*110427.   5268505  
*136943.   6205191  
*137353.   6216032  
*145329.   6493730  
*153354.   6737671  
*153355.   6737671  
*209419.   8737033  
*225500.   9189506  
*232698.   9423172  
*237753.   9509307  


* obs 57399 primary recurrence outcome was transferred out of state.
replace case_cat=89 in 57399
replace recurrence_num=89 in 57399


* obs 62639 primary recurrence outcome was transferred out of state.
replace case_cat=89 in 62639
replace recurrence_num=89 in 62639


* obs 74854 incorrectly marked as new case. had a recurrence prior w no outcome.
replace case_type= 2 in 74854
replace case_cat=89 in 74854
replace recurrence_num=89 in 74854

* obs 110427 - recurrence after 1st episode outcome was transferred out of state - EXCLUDE !
replace case_cat=9999 in 110427



* obs 136943 - recurrence after previous recurrence episode outcome was transferred out of state
replace case_cat=89 in 136943
replace recurrence_num=89 in 136943


* obs 137353 - recurrence after primary recurrence episode outcome was transferred out of state
replace case_cat=89 in 137353
replace recurrence_num=89 in 137353


* obs 145329 - recurrence after 1st episode outcome was transferred out of state - EXCLUDE !
replace case_cat=9999 in 145329


* obs 153354 - recurrence after primary recurrence outcome was transferred out of state - this row is Recurrence 2
replace case_cat=89 in 153354
replace recurrence_num=89 in 153354

*obs 153355 - recurrence prior with previous recurrence was cured - this row is Recurrence 3
replace case_cat=89 in 153355
replace recurrence_num=89 in 153355


* obs 209419  - recurrence after previous recurrence episode outcome was transferred out of state
replace case_cat=89 in 209419
replace recurrence_num=89 in 209419


*obs 225500 - recurrence after primary recurrence outcome was transferred out of state
replace case_cat=89 in 225500
replace recurrence_num=89 in 225500


* obs 232698 - recurrence after primary recurrence episode outcome was transferred out of state
replace case_cat=89 in 232698
replace recurrence_num=89 in 232698


*obs 237753 - recurrence after primary recurrence episode outcome was transferred out of state
replace case_cat=89 in 237753
replace recurrence_num=89 in 237753




codebook case_cat

* 0 Missing




. tab case_cat

*   case_cat |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |    145,062       58.48       58.48
*          1 |      9,010        3.63       62.11
*          2 |     17,695        7.13       69.25
*          3 |     22,620        9.12       78.37
*          4 |      1,123        0.45       78.82
*          5 |      1,361        0.55       79.37
*          6 |      1,542        0.62       79.99
*          7 |          1        0.00       79.99
*          8 |     17,943        7.23       87.22
*          9 |      9,851        3.97       91.20
*         10 |        880        0.35       91.55
*         11 |        103        0.04       91.59
*         12 |         13        0.01       91.60
*         13 |          3        0.00       91.60
*         89 |         11        0.00       91.60
*         99 |     20,827        8.40      100.00
*       9999 |          2        0.00      100.00
*------------+-----------------------------------
*      Total |    248,047      100.00







* Labeling case_cat and fixing label for recurrence_num
label variable case_cat "Case Category"

label define case_label 0 "New + Cure case. No primary recurrences." 1 "New+ Cure case, before the primary recurrence WITHOUT RETREATMENT" 2 "Death in 1st TB episode" 3 "New + Abandonned case" 4 "New + Failure/Resistance case" 5 "New + Changed Regimen case" 6 "New + Primary Abandonment case" 7 "New + missed appointment" 8 "Retreatment case" 9 "Primary recurrence case" 10 "Second Recurrence" 11 "Third Recurrence" 12 "4th Recurrence" 13 "5th Recurrence" 99 "No New case observed" 89 "recurrence w/o known outcome of prior notification: transferred or missing" 9999 "recurrence after 1st episode outcome was transferred out of state - EXCLUDE !"
label values case_cat case_label


label define recurrence_num_label 89 "Recurrence after unknown outcome of prior episode", add





sort study_sinan proxy_date tx_seq case_outcome


* create variable for exclusions
gen exclude=.




* set exclusion as 1 for Those who did not have a new case for their 1st tb episode
replace exclude=1 if ever_had_new==0


* set exclusion as 2 for Those who DID have a new case, BUT NO CURE of 1st tb episode
replace exclude=2 if ever_had_new==1 & ever_cureTB1_flag==0 


* set exclusion as 3 for Those who died during TB episode 1 with no cure
replace exclude=3 if new_case_no_cure_death==1



label variable exclude "Exclusion Criteria"

label define exclude_label 1 "Exclusion 1: Did not have a new case for their 1st tb episode" 2 "Exclusion 2: DID have a new case, BUT NO CURE of 1st tb episode" 3 "Exclusion 3: Died during TB episode 1 with no cure"
label values exclude exclude_label



. tab exclude

*                                exclude |      Freq.     Percent        Cum.
*----------------------------------------+-----------------------------------
*Exclusion 1: Did not have a new case fo |     20,827       31.42       31.42
*Exclusion 2: DID have a new case, BUT N |     27,754       41.88       73.30
*Exclusion 3: Died during TB episode 1 w |     17,695       26.70      100.00
*----------------------------------------+-----------------------------------
*                                  Total |     66,276      100.00





save "<DATA_DIR>/evelyn_cleandataset_0320.dta"

************************************************************

* USE ISADORA'S CLEAN DATASET for the analysis after here

*** evelyn_cleandataset_0320.dta

************************************************************


** How many sinan's had more that 1 new case?
gen new=.
replace new=1 if case_type==1
bysort study_sinan (proxy_date): gen total_news = sum(new)
label variable total_news "Which new episode the case is"
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): gen total_news_count = total_news[_N]
. tab total_news_count

*total_news_ |
*      count |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |     20,827        8.40        8.40
*          1 |    227,193       91.59       99.99
*          2 |         11        0.00       99.99
*          4 |         16        0.01      100.00
*------------+-----------------------------------
*      Total |    248,047      100.00


. list study_sinan case_type case_outcome proxy_date end_dt ever_pop_at_risk if total_news_count>1, clean

*          study_~n                       case_type          case_outcome   proxy_d~e      end_dt   ever_p~k  
*  9882.    1330357                             New   Primary Abandonment   16aug2024   26dec2024          0  
*  9883.    1330357                             New   Primary Abandonment   16aug2024   02oct2024          0  
*  9884.    1330357                             New   Primary Abandonment   16aug2024   02oct2024          0  
*  9885.    1330357                             New   Primary Abandonment   16aug2024   26dec2024          0  
* 27769.    2146242                             New                 Cured   14sep2016   13mar2017          1  
* 27770.    2146242                             New                 Cured   25aug2023   05mar2024          1  
* 40697.      25282                             New             Abandoned   05apr2022   17jul2022          0  
* 40698.      25282                             New             Abandoned   05apr2022   16jul2022          0  
* 40699.      25282                             New             Abandoned   05apr2022   16jul2022          0  
* 40700.      25282                             New             Abandoned   05apr2022   17jul2022          0  
*122215.    5646895                             New             Abandoned   29may2017   24jul2017          0  
*122216.    5646895   Retreatment after Abandonment   Primary Abandonment   24nov2017   15feb2018          0  
*122217.    5646895                             New             Abandoned   10sep2018   11feb2019          0  
*122218.    5646895   Retreatment after Abandonment   Primary Abandonment   17sep2024   18sep2024          0  
*123649.     571936                             New                 Cured   14mar2023   27sep2023          1  
*123650.     571936                             New                 Cured   14mar2023   27sep2023          1  
*189315.    8021636                             New                 Cured   13jan2021   13aug2021          1  
*189316.    8021636                             New                 Cured   13jan2021   13aug2021          1  
*189317.    8021636                             New                 Cured   13jan2021           .          1  
*189318.    8021636                             New                 Cured   13jan2021           .          1  
*192540.    8201087                             New          Non-TB Death   07apr2021   18aug2021          0  
*192541.    8201087                             New             Abandoned   18oct2021   18jan2022          0  
*192542.    8201087   Retreatment after Abandonment          Non-TB Death   07jun2022   23aug2022          0  
*212622.    8801365                             New                 Cured   26dec2022   29jun2023          1  
*212623.    8801365                             New                 Cured   26dec2022   29jun2023          1  
*212624.    8801365                             New                 Cured   26dec2022   26jun2023          1  
*212625.    8801365                             New                 Cured   26dec2022   26jun2023          1 

* those with 0 for ever_pop_at_risk will be dropped
* We see duplicate notifications for the same event

* Obs 27769. & 27770. are two different ppl

replace study_sinan="x2146242" in 27770


* Obs 123649 & 123650 - duplicate notification for the same event.
drop in 123649

* Obs 189315, 189316, 189317, 189318 - duplicate notifications for the same event.

drop in 189315
drop in 189315
drop in 189315


* Obs 212622, 212623, 212624, 212625 - duplicate notifications for the same event.
drop in 212618
drop in 212618
drop in 212618


* 7 duplicate notifications dropped

save "<DATA_DIR>/evelyn_cleandataset_0324.dta"

*******************

* NOW THE DATASET IS EVEN CLEANER !!!!

*******************

***********************

* Let's regenerate all of our variables again...

***********************
drop txseq_lag txdate_lag txstart_txseq_incon proxy_date proxydate_lag proxy_txseq_incon cured recurrence had_cure_before recurrence_after_cure recurrence_without_prior_cure ever_had_recurrence ever_had_new ever_had_cure total_recurrences total_recurrences_count total_cures at_risk_population ever_had_curethenrecurrence at_risk_recurrence cure_sum ever_pop_at_risk cure_TBepisode1_flag ever_cureTB1_flag primary_recurrence ever_had_primaryrecurr treatment_incomplete firstcase_new_incomplete retreatment total_retreatments retreatment_withcure total_retreatmentcures ever_1stcase_new_incomplete retreatment_cure_newincomplete new_case_no_cure ever_died_no_cure new_case_no_cure_death recurrence_num case_cat exclude event_date died death_before_cureTB1 new total_news total_news_count






**************************************************
** ORDER OF EVENTS AND INCONSISTENCIES
**************************************************

* Checking Order of events
sort study_sinan txstart_dt tx_seq case_outcome

bysort study_sinan (tx_seq): gen txseq_lag = tx_seq[_n-1]

bysort study_sinan (txstart_dt): gen txdate_lag = txstart_dt[_n-1]

format txdate_lag %td

gen txstart_txseq_incon = (tx_seq < txseq_lag & txstart_dt > txdate_lag)

* Generating proxy date variable. Uses Trt start if available, replaces with diagnosis date is tx start date is missing

gen proxy_date=txstart_dt
replace proxy_date= diagnostic_dt if proxy_date==.
format proxy_date %td


* Checking for inconsistencies in txt seq and proxy date which replace missing tx start date with diagnosis date
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): gen proxydate_lag = proxy_date[_n-1]
format proxydate_lag %td

gen proxy_txseq_incon = (tx_seq < txseq_lag & proxy_date > proxydate_lag)

codebook proxy_txseq_incon


** 0 inconsistent observations!



**************************************************
** GENERATING VARIABLES FOR RECURRENCE
**************************************************

* Generating binary variables for cure and recurrence
sort study_sinan proxy_date tx_seq case_outcome
gen cured = 1 if (case_outcome == 1)
gen recurrence = 1 if (case_type == 2)

* Sorting data by sinan and proxy date.
sort study_sinan proxy_date tx_seq case_outcome

* Generating variables for recurrence after a cure and recurrence without a prior cure case
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): gen had_cure_before = (cured[_n-1] == 1)
gen recurrence_after_cure = (recurrence == 1 & had_cure_before == 1)
gen recurrence_without_prior_cure = (recurrence == 1 & had_cure_before == 0)


* Generating variable to see who ever experienced a recurrence
sort study_sinan proxy_date tx_seq case_outcome
egen ever_had_recurrence = max(recurrence), by(study_sinan)
label variable ever_had_recurrence "Ever had at least one recurrence"
codebook ever_had_recurrence


* Identificar pacientes que tiveram pelo menos um "new case"
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen ever_had_new = max(case_type == 1)
label variable ever_had_new "Ever had a new TB case"

* Identificar pacientes que tiveram pelo menos uma cura
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen ever_had_cure = max(cured == 1)
label variable ever_had_cure "Ever had at least one TB cure"


** total_recurrences is which recurrence episode the case is
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): gen total_recurrences = sum(recurrence)
label variable total_recurrences "Which recurrence episode the case is"

* total_recurrences[_N] ensures every row for that patient gets their final recurrence count.
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): gen total_recurrences_count = total_recurrences[_N]
label variable total_recurrences_count "Every row for that patient gets their final recurrence count"








*** IS - Who had a cure of their 1st TB episode?

* Number which cure the row is
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): gen total_cures = sum(cured)








* Criar variável que marca a **primeira entrada** em que o paciente atende aos critérios
sort study_sinan proxy_date tx_seq case_outcome
gen at_risk_population = 0
bysort study_sinan (proxy_date): replace at_risk_population = 1 if ever_had_new == 1 & ever_had_cure == 1 & _n == 1

* Verificar quantos pacientes foram marcados corretamente
tab at_risk_population


*at_risk_pop |
*    ulation |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |     87,087       35.11       35.11
*          1 |    160,953       64.89      100.00
*------------+-----------------------------------
*      Total |    248,040      100.00





label variable at_risk_population "At-risk population: first new TB case that cured"


* Identificar pacientes que tiveram pelo menos uma recorrência após a cura
*bysort sinan (proxy_date): egen ever_had_recurrence = max(recurrence_after_cure == 1)
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen ever_had_curethenrecurrence = max(recurrence_after_cure == 1)

* Criar variável que identifica quem, dentro da população de risco, teve recorrência na **primeira entrada**
sort study_sinan proxy_date tx_seq case_outcome
gen at_risk_recurrence =.
bysort study_sinan (proxy_date): replace at_risk_recurrence = 1 if at_risk_population == 1 & ever_had_curethenrecurrence == 1 & _n == 1

bysort study_sinan (proxy_date): replace at_risk_recurrence = 0 if at_risk_population == 1 & ever_had_curethenrecurrence == 0 & _n == 1


* Verificar quantos pacientes tiveram recorrência
tab at_risk_recurrence

*at_risk_rec |
*    urrence |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |    151,102       93.88       93.88
*          1 |      9,851        6.12      100.00
*------------+-----------------------------------
*      Total |    160,953      100.00



label variable at_risk_recurrence "Recurrence within at-risk population (first entry)"




* Making intermediate variable to flag when the cure of the 1st TB episode was
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): gen cure_sum = sum(total_cures)



* Generate variable for ever population at risk
sort study_sinan proxy_date tx_seq case_outcome
 bysort study_sinan (proxy_date): egen ever_pop_at_risk = max(at_risk_population == 1)


* Flagging the cure of the 1st episode

gen cure_TBepisode1_flag=.
replace cure_TBepisode1_flag=1 if total_cures==1 & cure_sum==1 & ever_pop_at_risk==1


** Checking to make sure all population at risk has a cure flagged
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen ever_cureTB1_flag = max(cure_TBepisode1_flag == 1)

. tab ever_cureTB1_flag

*ever_cureTB |
*     1_flag |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |     66,276       26.72       26.72
*          1 |    181,764       73.28      100.00
*------------+-----------------------------------
*      Total |    248,040      100.00


	  
tab ever_pop_at_risk


*ever_pop_at |
*      _risk |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |     66,276       26.72       26.72
*          1 |    181,764       73.28      100.00
*------------+-----------------------------------
*      Total |    248,040      100.00



***** TOTALS ARE ADDING CORRECTLY

. list sinan if ever_pop_at_risk==1 & ever_cureTB1_flag!=1, clean

* O obs - GREAT!



* Verifying that a cure for TB episode 1 is flagged for each person at risk

. tab cure_TBepisode1_flag

*cure_TBepis |
*  ode1_flag |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          1 |    160,953      100.00      100.00
*------------+-----------------------------------
*      Total |    160,953      100.00




********** SINCE WE CLEANED THE DATA, THE NUMBER AT RISK INCREASED

* PERFECT - 160,953 cures flagged for the 160,953 at risk



label variable cure_TBepisode1_flag "Flag for cure of 1st TB episode"





* Flag the primary recurrence after cure of the 1st TB episode
sort study_sinan proxy_date tx_seq case_outcome
gen primary_recurrence = 0
bysort study_sinan (proxy_date): replace primary_recurrence = 1 if recurrence == 1 & cure_TBepisode1_flag[_n-1] == 1 & total_recurrences==1



. tab primary_recurrence

*primary_rec |
*    urrence |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |    238,189       96.03       96.03
*          1 |      9,851        3.97      100.00
*------------+-----------------------------------
*      Total |    248,040      100.00



*9,851 primary recurrences


. tab at_risk_recurrence

* Recurrence |
*     within |
*    at-risk |
* population |
*     (first |
*     entry) |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |    151,102       93.88       93.88
*          1 |      9,851        6.12      100.00
*------------+-----------------------------------
*      Total |    160,953      100.00



***** GREAT ! Totals are matching




 
 * Who ever had a primary recurrence? Marking all rows of a sinan with it.
 sort study_sinan proxy_date tx_seq case_outcome
 bysort study_sinan (proxy_date): egen ever_had_primaryrecurr = max(primary_recurrence == 1)
 label variable ever_had_primaryrecurr "Ever had at least one recurrence after cure of 1st TB episode"
 
 
 
 
 
 ***************************************************
** RECURRENCE AFTER RETREATMENT (1ST EPISODE OF TB)
***************************************************

**** Identify the first TB episode with incomplete treatment (First case New + incomplete treatment) 

* Sorting data by sinan and proxy date.
sort study_sinan proxy_date tx_seq case_outcome

**** Cases with Incomplete Treatment
gen treatment_incomplete = 1 if ((case_outcome == 4) |  (case_outcome == 5) | (case_outcome == 8) | (case_outcome == 9))
replace treatment_incomplete = 0 if missing(treatment_incomplete)

**** First case (New Case) with incomplete treatment 

bysort study_sinan (proxy_date): gen firstcase_new_incomplete = (case_type == 1 & treatment_incomplete == 1 & _n == 1)






***** THIS PART BELOW IS GOOD!!!! IS editted to include possibility of multiple retreatments before cure.
sort study_sinan proxy_date tx_seq case_outcome
gen retreatment=1 if case_type==3 | case_type==4 | case_type==5
bysort study_sinan (proxy_date): gen total_retreatments = sum(retreatment)

gen retreatment_withcure=1 if (case_type==3 | case_type==4 | case_type==5) & case_outcome ==1
bysort study_sinan (proxy_date): gen total_retreatmentcures = sum(retreatment_withcure)

bysort study_sinan (proxy_date): egen ever_1stcase_new_incomplete = max(firstcase_new_incomplete == 1)

gen retreatment_cure_newincomplete=1 if ever_1stcase_new_incomplete==1 & retreatment_withcure==1 & total_retreatmentcures==1

label variable retreatment_cure_newincomplete "1st Retreatment case with a cure of the 1st TB episode"


. tab retreatment_cure_newincomplete

*        1st |
*Retreatment |
*case with a |
*cure of the |
*     1st TB |
*    episode |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          1 |      6,888      100.00      100.00
*------------+-----------------------------------
*      Total |      6,888      100.00

*6,888 people had a cure of 1st tb episode after retreatment, this includes people who may have had multiple retreatments before the cure of the 1st episode


*_____________________________________________







***********************************************************************
* NEW CASES WITHOUT CURE - IDENTIFING WHO DIED DURING 1st TB TREATMENT
***********************************************************************


* Criar uma variável para identificar pacientes com caso novo e sem cura
sort study_sinan proxy_date tx_seq case_outcome
gen new_case_no_cure = 0
bysort study_sinan (proxy_date): replace new_case_no_cure = 1 if ever_had_new == 1 & ever_had_cure == 0 & _n == 1


* Criar variável para identificar mortes após um caso novo sem cura, mesmo que tenha havido retratamentos
bysort study_sinan (proxy_date): egen ever_died_no_cure = max(case_outcome == 2 | case_outcome == 3)

* Criar variável para marcar mortes na primeira entrada que atende aos critérios
gen new_case_no_cure_death = 0
bysort study_sinan (proxy_date): replace new_case_no_cure_death = 1 if new_case_no_cure == 1 & ever_died_no_cure == 1 & _n == 1

* Tabular para verificar quantos pacientes morreram dentro dessa população
tab new_case_no_cure_death


**  17,695  observations 


* Adicionar rótulo geral para as variáveis
label variable new_case_no_cure "New TB case, never cured"
label variable ever_died_no_cure "Died at any time after a new TB case without cure"
label variable new_case_no_cure_death "New TB case, never cured, died"





*** DROP THESE CASES IN CERTAIN MOMENT







*-------------------------------------------------------------
* Multiple recurrences
*-------------------------------------------------------------

sort study_sinan proxy_date tx_seq case_outcome

* ENSURING THAT THE ROW BEFORE THE NEXT RECCURENCE IS A CURE WHEN GENERATING THESE VARIABLES

* Step 1: Initialize the variable
gen recurrence_num = .

* Step 2: Assign 1 for primary recurrence
bysort study_sinan (proxy_date): replace recurrence_num = 1 if primary_recurrence == 1 

* Step 3: Assign 2 for the second recurrence
bysort study_sinan (proxy_date): replace recurrence_num = 2 if _n > 1 & total_cures[_n-1] == 2 & total_recurrences == 2

* Step 4: Assign 3 for the third recurrence
bysort study_sinan (proxy_date): replace recurrence_num = 3 if _n > 1 & total_cures[_n-1] == 3 & total_recurrences == 3

* Step 5: Assign 4 for the fourth recurrence
bysort study_sinan (proxy_date): replace recurrence_num = 4 if _n > 1 & total_cures[_n-1] == 4 & total_recurrences == 4

* Step 6: Assign 5 for the 5th recurrence
bysort study_sinan (proxy_date): replace recurrence_num = 5 if _n > 1 & total_cures[_n-1] == 5 & total_recurrences == 5

* Assign 0 for no recurrences
replace recurrence_num=0 if total_recurrences_count==0

label variable recurrence_num "Recurrence #: recurrence must have occurred after obs. cure of prev episode"

label define recurrence_num_label 0 "No recurrences" 1 "Primary Recurrence" 2 "2nd recurrence" 3 "3rd recurrence" 4 "4th recurrence" 5 "5th recurrence"
label values recurrence_num recurrence_num_label




. tab recurrence_num

*     Recurrence #: recurrence must have |
*       occurred after obs. cure of prev |
*                                episode |      Freq.     Percent        Cum.
*----------------------------------------+-----------------------------------
*                         No recurrences |    208,066       94.94       94.94
*                     Primary Recurrence |      9,851        4.50       99.44
*                         2nd recurrence |      1,089        0.50       99.93
*                         3rd recurrence |        127        0.06       99.99
*                         4th recurrence |         14        0.01      100.00
*                         5th recurrence |          3        0.00      100.00
*----------------------------------------+-----------------------------------
*                                  Total |    219,150      100.00










************************************************
* Categorizing cases - CHECAR!!!
************************************************
sort study_sinan proxy_date tx_seq case_outcome

** Categorizing cases
gen case_cat=.

* New + Cure case. No primary recurrence cases.
replace case_cat=0 if case_type==1 & case_outcome==1 & ever_had_primaryrecurr==0

* New+ Cure case, before the primary recurrence WITHOUT RETREATMENT.
replace case_cat=1 if ever_had_primaryrecurr == 1 & case_type==1 & case_outcome==1


* Death in 1st TB episode
replace case_cat=2 if new_case_no_cure_death==1


* New + Abandonned case

replace case_cat=3 if case_type==1 & case_outcome==4 & case_cat==.

* New + Failure/Resistance case.
replace case_cat=4 if case_type==1 & case_outcome==5 & case_cat==.

*New + Changed Regimen case.
replace case_cat=5 if case_type==1 & case_outcome==8 & case_cat==.

*New + Primary Abandonment case.
replace case_cat=6 if case_type==1 & case_outcome==9 & case_cat==.

*New + missed appointment
replace case_cat=7 if case_type==1 & case_outcome==12 & case_cat==.

*Retreatment case.
replace case_cat = 8 if (case_type==3 | case_type==4 | case_type==5) & case_cat==.


* Primary recurrence case.
replace case_cat=9 if primary_recurrence == 1

* Second Recurrence.
replace case_cat=10 if recurrence_num == 2 & case_cat==.

* Third Recurrence.
replace case_cat=11 if recurrence_num == 3 & case_cat==.

* 4th Recurrence.
replace case_cat=12 if recurrence_num == 4 & case_cat==.

* 5th Recurrence.
replace case_cat=13 if recurrence_num == 5 & case_cat==.

* No New case observed.
replace case_cat=99 if ever_had_new==0




codebook case_cat

* 13 missing a category

. . list sinan if case_cat==., clean


*            sinan  
* 57398.   3257430  
* 62638.   3489763  
* 74853.    391277  
*110426.   5268505  
*136941.   6205191  
*137351.   6216032  
*145327.   6493730  
*153352.   6737671  
*153353.   6737671  
*209414.   8737033  
*225492.   9189506  
*232690.   9423172  
*237745.   9509307 


*            sinan  
* 57399.   3257430  
* 62639.   3489763  
* 74854.    391277  
*110427.   5268505  
*136943.   6205191  
*137353.   6216032  
*145329.   6493730  
*153354.   6737671  
*153355.   6737671  
*209419.   8737033  
*225500.   9189506  
*232698.   9423172  
*237753.   9509307  


* obs 57398 primary recurrence outcome was transferred out of state.
replace case_cat=89 in 57398
replace recurrence_num=89 in 57398


* obs 62638 primary recurrence outcome was transferred out of state.
replace case_cat=89 in 62638
replace recurrence_num=89 in 62638


* obs 74853 incorrectly marked as new case. had a recurrence prior w no outcome.
replace case_cat=89 in 74853
replace recurrence_num=89 in 74853

* obs 110426 - recurrence after 1st episode outcome was transferred out of state - EXCLUDE !
replace case_cat=9999 in 110426


* obs 136941 - recurrence after previous recurrence episode outcome was transferred out of state
replace case_cat=89 in 136941
replace recurrence_num=89 in 136941

* 137351 - recurrence after primary recurrence episode outcome was transferred out of state
replace case_cat=89 in 137351
replace recurrence_num=89 in 137351


*145327 - recurrence after 1st episode outcome was transferred out of state - EXCLUDE !
replace case_cat=9999 in 145327

* 153352 - recurrence after primary recurrence outcome was transferred out of state - this row is Recurrence 2

replace case_cat=89 in 153352
replace recurrence_num=89 in 153352

*153353 - recurrence prior with previous recurrence was cured - this row is Recurrence 3

replace case_cat=89 in 153353
replace recurrence_num=89 in 153353


*209414 - recurrence after previous recurrence episode outcome was transferred out of state
replace case_cat=89 in 209414
replace recurrence_num=89 in 209414


*225492 - recurrence after primary recurrence outcome was transferred out of state
replace case_cat=89 in 225492
replace recurrence_num=89 in 225492


*232690 - recurrence after primary recurrence episode outcome was transferred out of state
replace case_cat=89 in 232690
replace recurrence_num=89 in 232690


*237745 - recurrence after primary recurrence episode outcome was transferred out of state

replace case_cat=89 in 237745
replace recurrence_num=89 in 237745




codebook case_cat

* 0 Missing




. tab case_cat

*   case_cat |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |    145,055       58.48       58.48
*          1 |      9,010        3.63       62.11
*          2 |     17,695        7.13       69.25
*          3 |     22,620        9.12       78.37
*          4 |      1,123        0.45       78.82
*          5 |      1,361        0.55       79.37
*          6 |      1,542        0.62       79.99
*          7 |          1        0.00       79.99
*          8 |     17,943        7.23       87.22
*          9 |      9,851        3.97       91.20
*         10 |        880        0.35       91.55
*         11 |        103        0.04       91.59
*         12 |         13        0.01       91.60
*         13 |          3        0.00       91.60
*         89 |         11        0.00       91.60
*         99 |     20,827        8.40      100.00
*       9999 |          2        0.00      100.00
*------------+-----------------------------------
*      Total |    248,040      100.00





* Labeling case_cat and fixing label for recurrence_num
label variable case_cat "Case Category"

label values case_cat case_label




sort study_sinan proxy_date tx_seq case_outcome


* create variable for exclusions
gen exclude=.




* set exclusion as 1 for Those who did not have a new case for their 1st tb episode
replace exclude=1 if ever_had_new==0


* set exclusion as 2 for Those who DID have a new case, BUT NO CURE of 1st tb episode
replace exclude=2 if ever_had_new==1 & ever_cureTB1_flag==0 


* set exclusion as 3 for Those who died during TB episode 1 with no cure
replace exclude=3 if new_case_no_cure_death==1



label variable exclude "Exclusion Criteria"


label values exclude exclude_label



. tab exclude

*                                exclude |      Freq.     Percent        Cum.
*----------------------------------------+-----------------------------------
*Exclusion 1: Did not have a new case fo |     20,827       31.42       31.42
*Exclusion 2: DID have a new case, BUT N |     27,754       41.88       73.30
*Exclusion 3: Died during TB episode 1 w |     17,695       26.70      100.00
*----------------------------------------+-----------------------------------
*                                  Total |     66,276      100.00


save "<DATA_DIR>/evelyn_cleandataset_0324.dta", replace










** How many sinan's had more that 1 new case?
gen new=.
replace new=1 if case_type==1
bysort study_sinan (proxy_date): gen total_news = sum(new)
label variable total_news "Which new episode the case is"
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): gen total_news_count = total_news[_N]

tab total_news_count

*total_news_ |
*      count |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |     20,827        8.40        8.40
*          1 |    227,198       91.60       99.99
*          2 |          7        0.00      100.00
*          4 |          8        0.00      100.00
*------------+-----------------------------------
*      Total |    248,040      100.00



. tab total_news_count ever_pop_at_risk

*total_news |   ever_pop_at_risk
*    _count |         0          1 |     Total
*-----------+----------------------+----------
*         0 |    20,827          0 |    20,827 
*         1 |    45,434    181,764 |   227,198 
*         2 |         7          0 |         7 
*         4 |         8          0 |         8 
*-----------+----------------------+----------
*     Total |    66,276    181,764 |   248,040 



* Those who are in our at risk population only had 1 new case in their records so this is good.


*******************************
* SURVIVAL ANALYSIS
*******************************

. codebook ever_pop_at_risk

. tab ever_pop_at_risk

*ever_pop_at |
*      _risk |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |     66,276       26.72       26.72
*          1 |    181,764       73.28      100.00
*------------+-----------------------------------
*      Total |    248,040      100.00



* Keeping the records for those who are in the at risk population

drop if ever_pop_at_risk==0
*This removes the people from our exclusions ( those which a value for the variable exclude)

*66,276 obs dropped

************************************************************

* SAVED A NEW DATASET WITH ONLY THE PEOPLE WHO ARE PART OF THE AT RISK POPULATION

************************************************************

save "<DATA_DIR>/evelyn_cleandataset_atriskpopulation.dta"



. tab cure_TBepisode1_flag

*   Flag for |
*cure of 1st |
* TB episode |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          1 |    160,953      100.00      100.00
*------------+-----------------------------------
*      Total |    160,953      100.00



* 160,953 had cure of TB episode 1




**********************************

* SETTING THE CURE DATE

**********************************

* Generating variable for the cure date
gen cure_date=.

* Setting the cure date as the end_date of Tb episode 1
replace cure_date= end_dt if cure_TBepisode1_flag==1
format cure_date %td


* Who cured TB episode 1 but has a missing end date/ cure date

. count if cure_TBepisode1_flag==1 & end_dt==.
*  858 of 160,953 missing end date/ cure date



*****************

* of 160,953, who died after the cure and did not have recurrence?

*****************

* WHO IN THE AT RISK POPULATION BUT DIED after the cure and did not have a primary recurrence
. count if dod_dt>cure_date & ever_had_primaryrecurr==0 & dod_dt!=. & cure_date!=.
*  2,387

gen died_after_cureTB1=.
replace died_after_cureTB1=1 if dod_dt>cure_date & ever_had_primaryrecurr==0 & dod_dt!=. & cure_date!=.
label variable died_after_cureTB1 "DIED after TB 1 cure and did not have a primary recurrence"


. tab died_after_cureTB1

* DIED after |
*  TB 1 cure |
*and did not |
*     have a |
*    primary |
* recurrence |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          1 |      2,387      100.00      100.00
*------------+-----------------------------------
*      Total |      2,387      100.00

* 2,387 of 160,953 died after the cure and did not have recurrence.






**********************************

* SETTING THE EVENT DATE

**********************************

gen event_date=.

* Set the event date for the primary recurrence

replace event_date=proxy_date if primary_recurrence==1

* Set the event date for death before primary recurrence
replace event_date=dod_dt if died_after_cureTB1==1

format event_date %td


**********************************

* SETTING THE TIME TO EVENT

**********************************

sort study_sinan proxy_date tx_seq case_outcome

* Have all rows of the sinan have the date of cure of TB episode 1

bysort study_sinan (proxy_date): egen curedate_TB1 = max(cure_date)
format curedate_TB1 %td


* How many from our at risk population had either event (primary recurrence or death after TB episode 1 cure NO recurrence)

. count if primary_recurrence==1 | died_after_cureTB1==1
*  12,238

. count if event_date!=.
*  12,238



* Time from cure to recurrence or death
gen time_to_event = event_date - curedate_TB1

. count if time_to_event!=.
*  12,238 - Perfect this aligns with the number expected

save "<DATA_DIR>/evelyn_cleandataset_atriskpopulation.dta", replace



*************************************

* Keep primary recurrences
* keep death_before_cureTB1=1
* Keep Cure of 1st tb episode with NO primary recurrence - THOSE WHO ARE STILL ABLE TO HAVE EITHER OF THESE


. count if primary_recurrence==1
*  9,851

. count if died_after_cureTB1==1
*  2,387

. count if cure_TBepisode1_flag==1 & ever_had_primaryrecurr==0 & died_after_cureTB1==.
*  148,715



**********************************

* SETTING THE EVENT TYPE

**********************************

gen event_type = .

* PRIMARY RECURRENCE
replace event_type = 1 if primary_recurrence==1

* COMPETING RISK: Death after TB episode 1 cure NO recurrence
replace event_type = 2 if died_after_cureTB1==1

* CENSORED CASES
replace event_type = 0 if cure_TBepisode1_flag==1 & ever_had_primaryrecurr==0 & died_after_cureTB1==.


. tab event_type

* event_type |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |    148,715       92.40       92.40
*          1 |      9,851        6.12       98.52
*          2 |      2,387        1.48      100.00
*------------+-----------------------------------
*      Total |    160,953      100.00




save "<DATA_DIR>/evelyn_cleandataset_atriskpopulation.dta", replace





*****

************* NEW !!!!! - 03/24/2025

*****


**********************************

* Time from start of TB episode 1 to cure of TB episode 1

**********************************

gen start_TB1=.

sort study_sinan proxy_date tx_seq case_outcome

replace start_TB1= proxy_date if case_type==1

format start_TB1 %td

bysort study_sinan (proxy_date): egen startdate_TB1 = max(start_TB1)

format startdate_TB1 %td

gen startTB1_to_cureTB1= curedate_TB1-startdate_TB1

codebook startTB1_to_cureTB1

*--------------------------------------------------------------------------------------------------------
*startTB1_to_cureTB1                                                                          (unlabeled)
*--------------------------------------------------------------------------------------------------------

*                  Type: Numeric (float)

*                 Range: [1,4302]                      Units: 1
*         Unique values: 1,653                     Missing .: 934/181,764

*                  Mean: 255.773
*             Std. dev.: 226.925

*           Percentiles:     10%       25%       50%       75%       90%
*                            181       183       193       234       351


************* NEW Ends here.


**********************

* Looking into who is missing duration of TB episode 1 - who are the 934 observations with missing


. count if startTB1_to_cureTB1==. & event_type==.
*  76 obs missing duration of TB episode 1 and are not part of out survival analysis population

. tab event_type if startTB1_to_cureTB1==.

* event_type |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |        858      100.00      100.00
*------------+-----------------------------------
*      Total |        858      100.00

*** OF 934 missing : 858 are part of our censored pop., 76 are not part of our survival analysis



save "<DATA_DIR>/evelyn_cleandataset_atriskpopulation.dta", replace


**********************************

* CRITERIA FOR INCLUSION IN SURVIVAL ANALYSIS

* 1) Cure date is not missing

**********************************


* Drop those with missing cure dates for TB episode 1

. count if event_type==0 & curedate_TB1==.
*  858
drop if event_type==0 & curedate_TB1==.

. count if event_type==1 & curedate_TB1==.
*  0

. count if event_type==2 & curedate_TB1==.
*  0

save "<DATA_DIR>/evelyn_cleandataset_atriskpopulation.dta", replace

. . count if event_type!=. & startTB1_to_cureTB1==.
*  0. OK so everyone who is in our survival analysis has a duration of 1st TB episode





******************************************************************

* Checking start of TB episode 1 to cure of Tb episode 1 durations

******************************************************************

. codebook startTB1_to_cureTB1 if event_type!=.

*--------------------------------------------------------------------------------------------------------
*startTB1_to_cureTB1                                                                          (unlabeled)
*--------------------------------------------------------------------------------------------------------

*                  Type: Numeric (float)

*                 Range: [1,4302]                      Units: 1
*         Unique values: 1,653                     Missing .: 0/160,095

*                  Mean: 228.865
*             Std. dev.:  148.12

*           Percentiles:     10%       25%       50%       75%       90%
*                            181       183       191       221       288




** Less than 1 months (30 days)


. . count if startTB1_to_cureTB1<30 & event_type!=.
*  16 have time from start of TB episode 1 to cure of TB episode 1 <30 days


. list study_sinan event_type startTB1_to_cureTB1 if startTB1_to_cureTB1<30,clean


*          study_~n   event~pe   startT~1  
* 21206.     217700          0          9  
* 49610.     368580          0         29  
* 49615.     368599          0         29  
* 65992.     446137          0          1  
* 71465.     472077          0          3  
* 75729.    4971459          0          6  
* 75773.    4976806          0         29  
* 78184.    5121876          0         27  
* 97096.    6169924          0          9  
*123913.    7318495          0          1  
*126760.    7441309          0          1  
*129093.    7534768          0          3  
*137577.    8236383          0          8  
*144565.    8613780          0          6  
*145361.    8639877          0          5  
*160416.    9063231          0          8  


** Less than 4 months (122 days)
. count if startTB1_to_cureTB1<122 & event_type!=.

*  119 have TB episode 1 duration < 4 months



** Greater than 1 year (365 days)
. count if startTB1_to_cureTB1>365 & event_type!=.

*  8,414 have tb episode duration > 365 days


* OF those with > 1 year TB episode 1 duration. How many had retreatment of 1st TB episode?
. count if startTB1_to_cureTB1>365 & event_type!=. & total_retreatmentcures>=1
*  5,174 had retreatment before cure of 8,414



** Greater than 2 years (731 days)
. count if startTB1_to_cureTB1>731 & event_type!=.
*  1,727

* OF those with > 2 years TB episode 1 duration. How many had retreatment of 1st TB episode?

. count if startTB1_to_cureTB1>731 & event_type!=. & total_retreatmentcures>=1
*  1,680 had retreatment before cure of 1,727



. codebook startTB1_to_cureTB1 if event_type==1

*--------------------------------------------------------------------------------------------------------
*startTB1_to_cureTB1                                                                          (unlabeled)
*--------------------------------------------------------------------------------------------------------

*                  Type: Numeric (float)

*                 Range: [30,3706]                     Units: 1
*         Unique values: 716                       Missing .: 0/9,851

*                  Mean:  251.29
*             Std. dev.: 205.343

*           Percentiles:     10%       25%       50%       75%       90%
*                            181       183       192       234       344




**** SHOULD WE DO A SENSITIVTY ANALYSIS? those with cure < 1 < 4, < 6 months?





** Consider resistance and retreatments before cure of TB episode 1

* THOUGHTS...
* < 1 month : Flag for exclusion; likely not legitimate cures
* < 4 months : Questionable; consider excluding or analyzing separately (sensitivity analysis)
* 6–12 months : Likely standard; include in primary analysis
* > 12 months : Plausible, esp. for DR-TB or retreatment after abandonment; include with flag for prolonged

* safest is excluding if less than 6 months trt duration...
* Sensitivity analysis including those with 4 to 6 months...
* look at who had retreatment or resistance and had episode duration longer than 1 year...




gen TB1_duration=.
replace TB1_duration=1 if startTB1_to_cureTB1<30 & startTB1_to_cureTB1!=.
replace TB1_duration=2 if startTB1_to_cureTB1>=30 & startTB1_to_cureTB1<=120 & startTB1_to_cureTB1!=.
replace TB1_duration=3 if startTB1_to_cureTB1>120 & startTB1_to_cureTB1<180 & startTB1_to_cureTB1!=.
replace TB1_duration=4 if (startTB1_to_cureTB1>=180 & startTB1_to_cureTB1<=365) & startTB1_to_cureTB1!=.
replace TB1_duration=5 if startTB1_to_cureTB1>365 & startTB1_to_cureTB1<=730 & startTB1_to_cureTB1!=.
replace TB1_duration=6 if startTB1_to_cureTB1>730 & startTB1_to_cureTB1!=.


label variable TB1_duration "Categories: TB Episode 1 TRT Duration"

label define tb1_duration_label 1 "Less than 1 months (30 days)" 2 "1 month to 4 months" 3 ">4 months to <6 months" 4 "6 months to 1 year" 5 "More than 1 year to 2 years" 6 "More than 2 years"

label values TB1_duration tb1_duration_label

. tab TB1_duration if event_type!=.

*Categories: TB Episode 1 TRT |
*                    Duration |      Freq.     Percent        Cum.
*-----------------------------+-----------------------------------
*Less than 1 months (30 days) |         16        0.01        0.01
*         1 month to 4 months |         95        0.06        0.07
*      >4 months to <6 months |      6,933        4.33        4.40
*          6 months to 1 year |    144,637       90.34       94.74
* More than 1 year to 2 years |      6,686        4.18       98.92
*           More than 2 years |      1,728        1.08      100.00
*-----------------------------+-----------------------------------
*                       Total |    160,095      100.00


save "<DATA_DIR>/evelyn_cleandataset_atriskpopulation.dta", replace






*** Looking into resistance of TB episode 1


sort study_sinan proxy_date tx_seq case_outcome

gen resistance_TB1_flag=.

replace resistance_TB1_flag= resistance if case_type==1


bysort study_sinan (proxy_date): egen resistance_TB1 = max(resistance_TB1_flag)


label values resistance_TB1 resistance_label
label variable resistance_TB1 "TB Episode 1 Resistance Result"



. tab TB1_duration resistance_TB1 if event_type!=.

*       Categories: TB |
*        Episode 1 TRT |  TB Episode 1 Resistance Result
*             Duration |      SENS       TB R      TB MR |     Total
*----------------------+---------------------------------+----------
*Less than 1 months (3 |         0          1          0 |         1 
*  1 month to 4 months |        17          0          0 |        17 
*>4 months to <6 month |     1,402         22          0 |     1,424 
*   6 months to 1 year |    29,610        651         15 |    30,276 
*More than 1 year to 2 |     1,403        292        131 |     1,826 
*    More than 2 years |       461         36         68 |       565 
*----------------------+---------------------------------+----------
*                Total |    32,893      1,002        214 |    34,109 



* Now retreatments before TB episode 1 Cure

bysort study_sinan (proxy_date): egen retreatment_TB1 = max(retreatment_cure_newincomplete)
label variable retreatment_TB1 "TB Episode 1 had Retreatments prior to cure"

. tab TB1_duration retreatment_TB1 if event_type!=.

*                      | TB Episode
*                      |   1 had
*                      | Retreatmen
*       Categories: TB |  ts prior
*        Episode 1 TRT |  to cure
*             Duration |         1 |     Total
*----------------------+-----------+----------
*  1 month to 4 months |         1 |         1 
*>4 months to <6 month |         2 |         2 
*   6 months to 1 year |     1,646 |     1,646 
*More than 1 year to 2 |     3,493 |     3,493 
*    More than 2 years |     1,681 |     1,681 
*----------------------+-----------+----------
*                Total |     6,823 |     6,823 



save "<DATA_DIR>/evelyn_cleandataset_atriskpopulation.dta", replace



. count if event_type!=. & startTB1_to_cureTB1<150
*  286 obs had cure in < 5 months






**********************************************

* Decisions from meeting on 02 April 2025

**********************************************


* drop if treatment completion is same day as end of Follow-up period (31 December 2024)
* drop if time to recurrence =0 days / keep if at least 1 day after treatment
* Check about cure date is missaligned with monthly sputum results
* Keep those with month 6 sputum results and treatment duration is 5 - 6 months
* reclassify 27 with TB death code as recurrence and use the date of death as their time to event












. tab event_type

* event_type |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |    147,857       92.36       92.36
*          1 |      9,851        6.15       98.51
*          2 |      2,387        1.49      100.00
*------------+-----------------------------------
*      Total |    160,095      100.00




count if startTB1_to_cureTB1<180 & event_type!=.
*  7,044



 tab event_type if startTB1_to_cureTB1>=180

* event_type |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |    141,376       92.37       92.37
*          1 |      9,365        6.12       98.49
*          2 |      2,310        1.51      100.00
*------------+-----------------------------------
*      Total |    153,051      100.00













**********************************

* CRITERIA FOR INCLUSION IN SURVIVAL ANALYSIS

* 1) Cure date before 31 December 2024 (end_dt)

* Follow-up is through 31 December 2024

**********************************



*** Dropping those who had a cure after 30 DEC 2024 or cure date is missing

. count if event_type==0 & curedate_TB1 > date("30dec2024", "DMY") & curedate_TB1!=.
*  3
drop if event_type==0 & curedate_TB1 > date("30dec2024", "DMY") & curedate_TB1!=.


. count if event_type==0 & curedate_TB1==.
*  858
drop if event_type==0 & curedate_TB1==.




. count if event_type==1 & curedate_TB1> date("30dec2024", "DMY") & curedate_TB1!=.
*  0


. count if event_type==1 & curedate_TB1==.
*  0




. count if event_type==2 & curedate_TB1> date("30dec2024", "DMY") & curedate_TB1!=.
*  0

. count if event_type==2 & curedate_TB1==.
*  0



************************

* Exclusions

* n= 3 dropped with cureTB1 date after 30 december 2024
* n=858 dropped with missing cureTB1 date

************************





************************

* Treatment duration

************************

* Checking for negative smear results for month 5 or 6 and treatment duration was 5-6 months

sort study_sinan proxy_date tx_seq case_outcome

* Month 5 bac test results
bysort study_sinan (proxy_date): gen bactest5_TB1_flag = 2 if bac5_num == 2 & _n == 1
bysort study_sinan (proxy_date): egen bactest5_TB1 = max(bactest5_TB1_flag)

* Month 6 bac test results
bysort study_sinan (proxy_date): gen bactest6_TB1_flag = 2 if bac6_num == 2 & _n == 1
bysort study_sinan (proxy_date): egen bactest6_TB1 = max(bactest6_TB1_flag)




count if (startTB1_to_cureTB1>=150 & startTB1_to_cureTB1<180) & event_type!=. & (bactest6_TB1 ==2)
* 2,704 with treatment duration between 5-6 months have a negative sputum result for month 6. We will include these.


count if (startTB1_to_cureTB1>=150 & startTB1_to_cureTB1<180) & event_type!=. & (bactest6_TB1 ==.)
* 4,054 do not have a negative sputum result for month 6. we have to exclude these.


**************************

* Exclusion

* Treatment duration>= 6 months (180 days)

**************************
count if startTB1_to_cureTB1<150
*332
drop if startTB1_to_cureTB1<150

count if (startTB1_to_cureTB1>=150 & startTB1_to_cureTB1<180) & event_type!=. & (bactest6_TB1 ==.)
* 4,054 do not have a negative sputum result for month 6. we have to exclude these.
drop if (startTB1_to_cureTB1>=150 & startTB1_to_cureTB1<180) & event_type!=. & (bactest6_TB1 ==.)


* n= 4386 observations dropped due to treatment duration < 6 months


save "<DATA_DIR>/evelyn_cleandataset_atriskpopulation_dropped<6monthtrtduration.dta"



******************************

* EXCLUSION

* drop if time to recurrence=0 days

* n=3 dropped
******************************


. count if time_to_event==0 & event_type==1
  3
drop if time_to_event==0 & event_type==1




***********************************

* reclassify 27 with TB death code as recurrence and use the date of death as their time to event

***********************************

gen tb_death = inlist(cause_of_death_code, "A150", "A162", "A165", "A169", "A180", "A183")

count if event_type == 2 & tb_death == 1
* 29

list sinan cause_of_death_code if event_type == 2 & tb_death == 1, sepby(cause_of_death_code)

* reclassify as recurrence
replace event_type=1 if event_type == 2 & tb_death == 1

* date of death is already set as time to their event







*******************************************


* Labeling event_type

label variable event_type "Survival Analysis: Event Type"

label define event_type_label 0 "CENSORED CASES: cured with no recurrence" 1 "PRIMARY RECCURENCE" 2 "COMPETING RISK: Death after TB episode 1"

label values event_type event_type_label


* Summary

. tab event_type

*          Survival Analysis: Event Type |      Freq.     Percent        Cum.
*----------------------------------------+-----------------------------------
*CENSORED CASES: cured with no recurrenc |    143,807       92.33       92.33
*                     PRIMARY RECCURENCE |      9,640        6.19       98.52
*COMPETING RISK: Death after TB episode  |      2,302        1.48      100.00
*----------------------------------------+-----------------------------------
*                                  Total |    155,749      100.00






save "<DATA_DIR>/evelyn_cleandataset_atriskpopulation_dropped<6monthtrtduration.dta", replace







* Recoding 




*** making varibles specific to TB 1

* Age

gen age_TB1=.
replace age_TB1=age_tb if new==1
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen age_atTB1 = max(age_TB1)

label variable age_atTB1 "TB Episode 1: Age"

* Race
gen race_new=.
replace race_new=1 if race==2
replace race_new=2 if race==1
replace race_new=2 if race==3
replace race_new=3 if race==4
replace race_new=4 if race==5
replace race_new=. if race==.


label variable race_new "Race"
label define racenew_label 1 "White" 2 "Black/Brown" 3 "Indigenous" 4 "Asian"
label values race_new racenew_label

* Education
gen educ_TB1 = .
replace edu_TB1=educ_final if new==1
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen edu_atTB1 = max(edu_TB1)
label values edu_atTB1 educ_final_lbl

label variable edu_atTB1 "TB Episode 1: Education"
label values edu_atTB1 educ_final_lbl

* HIV

** recoding HIV

gen hiv_new=.
replace hiv_new=1 if hiv==1
replace hiv_new=0 if hiv==2

gen hiv_TB1=.
replace hiv_TB1=hiv_new if new==1
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen hiv_atTB1 = max(hiv_TB1)

label variable hiv_atTB1 "TB Episode 1: HIV Status"
label define hivnew_label 0 "Negative" 1 "Positive"
label values hiv_atTB1 hivnew_label


* Diabetes
gen diabetes_TB1=.
replace diabetes_TB1=diabetes if new==1
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen diabetes_atTB1 = max(diabetes_TB1)

label variable diabetes_atTB1 "TB Episode 1: Diabetes Status"
label values diabetes_atTB1 diabetes_label

* Alcoholism
gen alc_TB1=.
replace alc_TB1=alcoholism if new==1
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen alc_atTB1 = max(alc_TB1)

label variable alc_atTB1 "TB Episode 1: Alcoholism"
label values alc_atTB1 alcoholism_label

* Mental Issue
gen mental_TB1=.
replace mental_TB1=mental_issue if new==1
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen mental_atTB1 = max(mental_TB1)

label variable mental_atTB1 "TB Episode 1: Mental Issue"
label values mental_atTB1 mental_issue_label

* Drug use
gen drugs_TB1=.
replace drugs_TB1=drug_use if new==1
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen drugs_atTB1 = max(drugs_TB1)

label variable drugs_atTB1 "TB Episode 1: Drug Use"
label values drugs_atTB1 drug_use_label

* Other immuno condition
gen immuno_TB1=.
replace immuno_TB1=other_immuno_condition if new==1
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen immuno_atTB1 = max(immuno_TB1)

label variable immuno_atTB1 "TB Episode 1: Other immuno condition"
label values immuno_atTB1 other_immune_label

* tobacco_use 
gen tobac_TB1=.
replace tobac_TB1=tobacco_use if new==1
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen tobac_atTB1 = max(tobac_TB1)


label variable tobac_atTB1 "TB Episode 1: Tobacco Use"
label values tobac_atTB1 tobacco_label

* address_type 
gen socialvuln_TB1=.
replace socialvuln_TB1=address_type if new==1
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen socialvuln_atTB1 = max(socialvuln_TB1)

label variable socialvuln_atTB1 "TB Episode 1: Social Vulnerability"
label values socialvuln_atTB1 address_type_label


* tx_administration_type 
gen tx_admin_TB1=.
replace tx_admin_TB1=tx_administration_type if new==1
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen tx_admin_atTB1 = max(tx_admin_TB1)

label variable tx_admin_atTB1 "TB Episode 1: Type of TX administration"
label values tx_admin_atTB1 tx_admin_label

* Clinical classification
gen tbloc_TB1=.
replace tbloc_TB1=clinical_classif if new==1
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen tbloc_atTB1 = max(tbloc_TB1)

label variable tbloc_atTB1 "TB Episode 1: TB Location"
label values tbloc_atTB1 clinical_classif_label


* AIDS
gen aids_TB1=.
replace aids_TB1=aids if new==1
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen aids_atTB1 = max(aids_TB1)

label variable aids_atTB1 "TB Episode 1: AIDS Status"
label define aidsnew_label 0 "No" 1 "Yes"
label values aids_atTB1 aidsnew_label

* Age group

gen agegroup_TB1=.
replace agegroup_TB1=age_group if new==1
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen agegroup_atTB1 = max(agegroup_TB1)

label variable agegroup_atTB1 "TB Episode 1: Age Group"
label values agegroup_atTB1 age_group_label

* Effectiveness

gen effect_TB1=.
replace effect_TB1=supervised_tx_effectiveness if new==1
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen effect_atTB1 = max(effect_TB1)

label variable effect_atTB1 "TB Episode 1: Supervised TX Effectiveness"
label define effectiveness_label 1 "Effective" 2 "Not effective"
label values effect_atTB1 effectiveness_label

* Lab confirmation

gen lab_TB1=.
replace lab_TB1=lab_confirmed if new==1
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen lab_atTB1 = max(lab_TB1)

label variable lab_atTB1 "TB Episode 1: Lab confirmation"
label values lab_atTB1 lab_confirmed_label




* diesease
gen disease_TB1=.
replace disease_TB1=disease_discovery if new==1
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen disease_atTB1 = max(disease_TB1)

label variable disease_atTB1 "TB Episode 1: Disease Discovery"
label values disease_atTB1 disease_discovery_label

*sputum
gen sputum_TB1=.
replace sputum_TB1=sputum_culture_num if new==1
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen sputum_atTB1 = max(sputum_TB1)

label variable sputum_atTB1 "TB Episode 1: Sputum Culture"
label values sputum_atTB1 sputum_culture_label

*hosp_admission
gen hosp_TB1=.
replace hosp_TB1=hosp_admission if new==1
sort study_sinan proxy_date tx_seq case_outcome
bysort study_sinan (proxy_date): egen hosp_atTB1 = max(hosp_TB1)

label variable hosp_atTB1 "TB Episode 1: Hospital Admission"
label values hosp_atTB1 hosp_admission_label

*baciloscopic control at month 2
bysort study_sinan (proxy_date): gen bactest2_TB1_flag = 0 if bac2_num == 2 & _n == 1
bysort study_sinan (proxy_date): replace bactest2_TB1_flag = 1 if bac2_num == 1 & _n == 1
bysort study_sinan (proxy_date): egen bactest2_TB1 = max(bactest2_TB1_flag)

label variable bactest2_TB1 "TB Episode 1: 2 bac test"
label define bac2result 0 "Negative" 1 "Positive", replace
label values bactest2_TB1 bac2result


**** Varibles for regimen change or retreatment after abandonment
replace retreatment_TB1=0 if retreatment_TB1!=1
label define retreatment_lbl 0 "No" 1 "Yes"
label values retreatment_TB1 retreatment_lbl



** Recoding RACE
gen race3 = .
replace race3 = 1 if race == 2
replace race3 = 2 if race == 1 | race == 3
replace race3 = 3 if race == 4 | race == 5
label define race3lbl 1 "White" 2 "Black/Brown" 3 "Other"
label values race3 race3lbl



drop age_TB1 edu_TB1 hiv_TB1 diabetes_TB1 alc_TB1 mental_TB1 drugs_TB1 immuno_TB1 tobac_TB1 socialvuln_TB1 tx_admin_TB1 tbloc_TB1 aids_TB1 agegroup_TB1 effect_TB1 lab_TB1 disease_TB1 hosp_TB1 sputum_TB1 edu_TB1

drop if event_type==.
drop if startTB1_to_cureTB1>913
tab bactest2_TB1

**********************************************************************

* Set event date for CENSORED group which will be the date we are following through 31 December 2024
replace event_date = date("31dec2024", "DMY") if event_type==0

* Set Time to event for CENSORED group

replace time_to_event = event_date - curedate_TB1 if event_type == 0




**********************************

* Now we need to remove the rows for cases that do not go into our survival analysis

**********************************



** How many are in dataset but not part of our survival analysis?
count if event_type==.
*  20,765

drop if event_type==.


**********************************

* drop thise with over 2.5 yrs of treatment

* n=1,170 dropped

**********************************

count if startTB1_to_cureTB1>913
*   1,170

drop if startTB1_to_cureTB1>913






. tab event_type

*          Survival Analysis: Event Type |      Freq.     Percent        Cum.
*----------------------------------------+-----------------------------------
*CENSORED CASES: cured with no recurrenc |    142,841       92.41       92.41
*                     PRIMARY RECCURENCE |      9,464        6.12       98.53
*COMPETING RISK: Death after TB episode  |      2,274        1.47      100.00
*----------------------------------------+-----------------------------------
*                                  Total |    154,579      100.00




  
**********************************

* Saving a new dataset for our survival analysis

**********************************

save "<DATA_DIR>/evelyn_survivalanalysis_final_040725.dta"




**********************************

* Set Up Survival Data

**********************************



. stset time_to_event, failure(event_type == 1) id(study_sinan)


*Survival-time data settings

*           ID variable: study_sinan
*         Failure event: event_type==1
*Observed time interval: (time_to_event[_n-1], time_to_event]
*     Exit on or before: failure

*--------------------------------------------------------------------------
*    154,579  total observations
*          0  exclusions
*--------------------------------------------------------------------------
*    154,579  observations remaining, representing
*    154,579  subjects
*      9,464  failures in single-failure-per-subject data
*  306429369  total analysis time at risk and under observation
*                                                At risk from t =         0
*                                     Earliest observed entry t =         0
*                                          Last observed exit t =     4,222




save "<DATA_DIR>/evelyn_survivalanalysis_final_040725.dta", replace




***************************************

* Variables for the model

***************************************

* sex age_atTB1 edu_atTB1 race_new hiv_atTB1 diabetes_atTB1 alc_atTB1 mental_atTB1 drugs_atTB1 immuno_atTB1 tobac_atTB1 socialvuln_atTB1 tx_admin_atTB1 tbloc_atTB1 retreatment_TB1


*****************

* sex
	* 0
	
* age_atTB1 
	* 147 missing

* edu_atTB1 
	* 34,356
	
* race_new
	* 29,160

* hiv_atTB1 
	* 10,089


* diabetes_atTB1 
	* 0

* alc_atTB1 
	* 0

* mental_atTB1 
	* 0

* drugs_atTB1 
	* 0

* immuno_atTB1 
	* 0

* tobac_atTB1 
	* 0

* socialvuln_atTB1 
	* 0
	
* tx_admin_atTB1 
	* 10,619

* tbloc_atTB1 
	* 1

* retreatment_TB1
	* 0


	
	
	
save "<DATA_DIR>/evelyn_survivalanalysis_final_040725.dta", replace







. stcrreg sex age_atTB1 i.tbloc_atTB1 hiv_atTB1 immuno_atTB1 diabetes_atTB1 alc_atTB1 mental_atTB1 tobac_atTB1 dru
> gs_atTB1 tx_admin_atTB1 i.socialvuln_atTB1 retreatment_TB1, compete(event_type == 2)

        Failure _d: event_type==1
  Analysis time _t: time_to_event
       ID variable: study_sinan

Iteration 0:  Log pseudolikelihood =  -93698.86  
Iteration 1:  Log pseudolikelihood =  -93698.29  
Iteration 2:  Log pseudolikelihood =  -93698.29  

Competing-risks regression                        No. of obs      =    135,273
                                                  No. of subjects =    135,273
Failure event:   event_type == 1                  No. failed      =      8,315
Competing event: event_type == 2                  No. competing   =      1,990
                                                  No. censored    =    124,968

                                                  Wald chi2(15)   =    3127.82
Log pseudolikelihood =  -93698.29                 Prob > chi2     =     0.0000

                                     (Std. err. adjusted for 135,273 clusters in study_sinan)
---------------------------------------------------------------------------------------------
                            |               Robust
                         _t |        SHR   std. err.      z    P>|z|     [95% conf. interval]
----------------------------+----------------------------------------------------------------
                        sex |   1.232256   .0361191     7.13   0.000     1.163459    1.305121
                  age_atTB1 |   .9956864   .0007913    -5.44   0.000     .9941367    .9972385
                            |
                tbloc_atTB1 |
            Extrapulmonary  |   .5301366   .0230521   -14.59   0.000      .486827    .5772991
Pulmonary + Extrapulmonary  |   .8325357   .0574321    -2.66   0.008      .727249    .9530652
                            |
                  hiv_atTB1 |   2.107814   .0738884    21.27   0.000     1.967858    2.257723
               immuno_atTB1 |    1.12515      .1404     0.94   0.345     .8810377    1.436899
             diabetes_atTB1 |   1.039536   .0540692     0.75   0.456     .9387854      1.1511
                  alc_atTB1 |   1.250158   .0404545     6.90   0.000     1.173331    1.332016
               mental_atTB1 |   1.003206    .095927     0.03   0.973     .8317596    1.209992
                tobac_atTB1 |   1.142371   .0317761     4.79   0.000     1.081758     1.20638
                drugs_atTB1 |   1.296598   .0402408     8.37   0.000     1.220079    1.377917
             tx_admin_atTB1 |   1.001032   .0324113     0.03   0.975     .9394808    1.066616
                            |
           socialvuln_atTB1 |
                    Inmate  |    2.01925   .0564255    25.15   0.000     1.911632    2.132926
                  Homeless  |   2.061904   .1101532    13.55   0.000     1.856926    2.289508
                            |
            retreatment_TB1 |    1.91538   .0903203    13.78   0.000      1.74629    2.100843
---------------------------------------------------------------------------------------------












sex age_atTB1 edu_atTB1 race_new hiv_atTB1 diabetes_atTB1 alc_atTB1 mental_atTB1 drugs_atTB1 immuno_atTB1 tobac_atTB1 socialvuln_atTB1 tx_admin_atTB1 tbloc_atTB1 retreatment_TB1




stcrreg sex age_atTB1 i.tbloc_atTB1 hiv_atTB1 immuno_atTB1 diabetes_atTB1 alc_atTB1 mental_atTB1 tobac_atTB1 drugs_atTB1 tx_admin_atTB1 i.socialvuln_atTB1 retreatment_TB1, compete(event_type == 2)
		
stcurve, cif at1(hiv_new=0) at2(hiv_new=1)	
stcurve, cif at1(address_type=1) at2(address_type=2) at3(address_type=3)
stcurve, cif at1(tobacco_use=0) at2(tobacco_use=1)	







************************

* Everything below here is just my notes


************************
	
	
	
	
	
	
	
	
	
************************

* Running Fine & Gray's Competing Risks Model

** sample code shared by evelyn

************************


*** example with sex
stcrreg sex, compete(event_type == 2)  


*        Failure _d: event_type==1
*  Analysis time _t: time_to_event
*       ID variable: study_sinan

*Iteration 0:  Log pseudolikelihood = -111226.05  
*Iteration 1:  Log pseudolikelihood = -111226.05  

*Competing-risks regression                        No. of obs      =    155,749
*                                                  No. of subjects =    155,749
*Failure event:   event_type == 1                  No. failed      =      9,640
*Competing event: event_type == 2                  No. competing   =      2,302
*                                                  No. censored    =    143,807

*                                                  Wald chi2(1)    =     481.12
*Log pseudolikelihood = -111226.05                 Prob > chi2     =     0.0000

*                      (Std. err. adjusted for 155,749 clusters in study_sinan)
*------------------------------------------------------------------------------
*             |               Robust
*          _t |        SHR   std. err.      z    P>|z|     [95% conf. interval]
*-------------+----------------------------------------------------------------
*         sex |   1.750903    .044712    21.93   0.000     1.665426    1.840767
*------------------------------------------------------------------------------

stcurve, cif at1(sex=0) at2(sex=1)






******** NOTES

************************

* Running Fine & Gray's Competing Risks Model

* OR, Cumulative Incidence Function (CIF)

* accounts for competing risk

************************


* AIC to choose best model - READ MORE INTO INTO Variable Selection


* WHAT COVARIATES TO INCLUDE?

* Do analysis to choose what covariates to include...

* AGE
* SEX
* RACE
* HIV
* DIABETES
* time to recurrence
* treatment duration 
* generate binary variable for prison
* houseless
* Education

* co-linearity men, tobacco, alcohol


* line of code for the Fine & Gray's model

*stcrreg age_tb sex hiv diabetes, compete(event_type == 2)











***************************

* Variable selection

***************************


* Creating a dummy variable for y
gen log_time = log(_t)


* checking for collinearity among predictors, the choice of your outcome (y) doesn't matter — because you're not actually interpreting the regression model. You're just using it as a tool to detect multicollinearity among your independent variables.



* Education

regress log_time i.education
vif

*    Variable |       VIF       1/VIF  
*-------------+----------------------
*   education |
*          1  |      3.35    0.298243
*          2  |      7.32    0.136695
*          3  |      7.85    0.127336
*          4  |      3.62    0.275921
*          5  |      2.19    0.456343
*-------------+----------------------
*    Mean VIF |      4.87

* 7.32 & 7.85 for categories 2 and 3, combine into new variable with merged categories 2 and 3


gen edu=.
replace edu=0 if education==0
replace edu=1 if education==1
replace edu=2 if (education==2 | education==3)
replace edu=3 if education==4
replace edu=4 if education==5

label variable edu "Education Categories"

label define edu_label 0 "None" 1 "1-3 years" 2 "4-11 years" 3 "12-14 years" 4 "15 or more years"

label values edu edu_label


regress log_time i.edu
. vif

*    Variable |       VIF       1/VIF  
*-------------+----------------------
*         edu |
*          1  |      3.35    0.298243
*          2  |      6.14    0.162867
*          3  |      3.62    0.275921
*          4  |      2.19    0.456343
*-------------+----------------------
*    Mean VIF |      3.83


* Race
regress log_time i.race

vif

*    Variable |       VIF       1/VIF  
*-------------+----------------------
*        race |
*          2  |      2.66    0.375384
*          3  |      2.66    0.376196
*          4  |      1.02    0.978440
*          5  |      1.07    0.936101
*-------------+----------------------
*    Mean VIF |      1.85


* Occupation
* other category is employed

regress log_time i.occupation
. vif

*    Variable |       VIF       1/VIF  
*-------------+----------------------
*  occupation |
*          2  |      1.38    0.722709
*          3  |      1.78    0.561558
*          4  |      1.10    0.904981
*          5  |      1.01    0.988908
*          6  |      2.30    0.434774
*          7  |      1.37    0.728777
*-------------+----------------------
*    Mean VIF |      1.49


* fixing direction of hiv variable
gen hiv_new=.
replace hiv_new=1 if hiv==1
replace hiv_new=0 if hiv==2

* Sex and tobacco use

. regress log_time i.sex i.tobacco_use


. vif

*    Variable |       VIF       1/VIF  
*-------------+----------------------
*       1.sex |      1.02    0.979436
*1.tobacco_~e |      1.02    0.979436
*-------------+----------------------
*    Mean VIF |      1.02



. tab occupation address_type

*                    |           Address type
* Patient occupation | Regular r     Inmate   Homeless |     Total
*--------------------+---------------------------------+----------
*         Unemployed |    16,745        392      1,835 |    18,972 
*          Housewife |     8,835         17         27 |     8,879 
*             Inmate |     1,594     18,085         87 |    19,766 
*Health Professional |     2,298          6          6 |     2,310 
*Penitentiary Worker |       212         31          0 |       243 
*              Other |    92,735      1,517      1,564 |    95,816 
*            Retired |     8,538          8         47 |     8,593 
*--------------------+---------------------------------+----------
*              Total |   130,957     20,056      3,566 |   154,579 



* need education for children children will have different amount for education

if less than 8 years

* do children have missing ness
* education if theyb have age less than 18 years they will be categorized as this



* use adress type


* exclude occupation from the analysis

if less than 10 % of missing values, but if more than 30 % should be we 

*tx_administration_type








********


save "<DATA_DIR>/evelyn_cleandataset_survivalanalysis.dta", replace








