
coefplot, ///
    eform ///
    drop(_cons) ///
    xline(1) ///
    xscale(log range(0.4 6)) ///
    xlabel(0.5 1 2 5, grid) ///
    title("Adjusted SHR for TB Recurrence (<15 years)") ///
    ciopts(recast(rcap)) ///
    rename( ///
        sex = "Sex (male)" ///
        age_atTB1 = "Age (years)" ///
        race_atTB1_new = "Race (non-White)" ///
        tbloc_atTB1_new = "Pulmonary only" ///
        hiv_atTB1 = "HIV" ///
        hosp_atTB1 = "Hospitalization" ///
    )
	