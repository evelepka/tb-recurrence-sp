# tb-recurrence-sp

Analysis code for **"Risk and determinants of tuberculosis recurrence: a 12-year population-based cohort study"** (São Paulo state, Brazil, 2013–2024).

Lepka de Lima E, Salles I, Cohn S, Lindoso AA, Fukasava S, Golub JE, Cox SR.

## Study

Population-based retrospective cohort of 154,579 individuals successfully treated for a first tuberculosis episode in São Paulo state. Data linked from the state surveillance system (TBweb) and the national mortality database. Competing-risks survival analysis (Fine–Gray) with mortality as the competing event. Models stratified by age (<15 vs. ≥15 years).

## Pipeline

### Stata — data preparation, models, and tables

| Step | File | Description |
|---|---|---|
| 1 | [`stata/01_cleaning_and_variables.do`](stata/01_cleaning_and_variables.do) | Imports raw linked dataset; creates variable labels, derived variables, and the analytic cohort |
| 2 | [`stata/02_collinearity.do`](stata/02_collinearity.do) | Collinearity checks on candidate covariates |
| 3 | [`stata/03_table1.do`](stata/03_table1.do) | Descriptive Table 1 |
| 4 | [`stata/04_fine_gray.do`](stata/04_fine_gray.do) | Main Fine–Gray competing-risks models (univariable + multivariable, adults and children). The Stata code also writes intermediate `.gph` files; these are *not* the figures shown in the paper |
| 5 | [`stata/05_sensitivity_censoring.do`](stata/05_sensitivity_censoring.do) | Time-restricted sensitivity analyses (censoring at 1, 2, 5 years) |

### R — all figures used in the paper

| Step | File | Description |
|---|---|---|
| 6 | [`R/survival_analysis.R`](R/survival_analysis.R) | **All final figures**: cumulative incidence curves (overall and stratified by HIV, age, sex, social vulnerability, hospitalization, etc.), interval-specific incidence (≤3 months, 3–12 months, 1–2 years, 2–5 years, >5 years) with Poisson 95% CIs, and the early- vs. late-recurrence partitioning |

Stata builds and analyses the cohort; R reads the resulting `.dta` to produce every figure that appears in the manuscript.

## Data

Patient-level data are **not** included in this repository. The cohort was built from:

- **TBweb** — São Paulo state tuberculosis surveillance system (São Paulo State Department of Health)
- **SIM** — Sistema de Informação sobre Mortalidade (Brazilian national mortality database)

Access requires authorization from the data custodians. The cleaning script uses a `<DATA_DIR>` placeholder for the input/output data folder — replace with your local path before running.

## Software

- Stata 19.5 (StataCorp, College Station, TX, USA)
- R 4.5.0 with `cmprsk`, `survival`, `prodlim`, `riskRegression`, `tidyverse`, `patchwork`

## Citation

Manuscript under review. Please cite the published article once available.

## License

Code released for transparency and reproducibility. Contact the corresponding authors for reuse: evelynlepka@gmail.com (E. Lepka de Lima), scox26@jhmi.edu (S. Cox).
