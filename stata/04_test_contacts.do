*** Teste contatos

gen cat_total_contacts = .
replace cat_total_contacts = 0 if total_contacts == 0
replace cat_total_contacts = 1 if inrange(total_contacts, 1, 4)
replace cat_total_contacts = 2 if total_contacts >= 5
label define contact_cat 0 "0" 1 "1–4" 2 "≥5"
label values cat_total_contacts contact_cat

gen bin_contact_disease = (contact_disease >= 1)
label define cd_bin 0 "0" 1 "≥1"
label values bin_contact_disease cd_bin

gen cat_examined_contacts = .
replace cat_examined_contacts = 0 if examined_contacts == 0
replace cat_examined_contacts = 1 if inrange(examined_contacts, 1, 4)
replace cat_examined_contacts = 2 if examined_contacts >= 5

label define examined_cat 0 "0" 1 "1–4" 2 "≥5"
label values cat_examined_contacts examined_cat

stcrreg i.cat_total_contacts, compete(competing_event)
stcrreg i.cat_examined_contacts, compete(competing_event)
stcrreg bin_contact_disease, compete(competing_event)

stcrreg i.cat_total_contacts, compete(event_type == 2)
