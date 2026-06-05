## ----setup, include=FALSE-------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## -------------------------------------------------------------------------------------------------
install.packages("cmprsk")


## -------------------------------------------------------------------------------------------------
install.packages("survival")
install.packages("prodlim")
install.packages("ggplot2")
install.packages("tidyverse")
install.packages("riskRegression")


## -------------------------------------------------------------------------------------------------
library(cmprsk)
library(survival)
library(prodlim)
library(ggplot2)
library(tidyverse)
library(riskRegression)


## -------------------------------------------------------------------------------------------------
colnames(excel_0417)


## -------------------------------------------------------------------------------------------------
# Print unique values with counts
table(excel_0417$event_type)



## -------------------------------------------------------------------------------------------------
# Gray's test using cmprsk package
gray_model_hiv <- cmprsk::cuminc(
  ftime = excel_0417$`_t`,              # Time to event or censoring
  fstatus = excel_0417$event_type,      # Event indicator (1=progression, 2=death, 0=censored)
  group = excel_0417$hiv_atTB1,         # Grouping variable (e.g., HIV status)
  cencode = 0                           # Value indicating censored data
)

# Display the results of Gray's test
gray_model_hiv$Tests



## -------------------------------------------------------------------------------------------------
# Gray's test using cmprsk package
gray_model_age <- cmprsk::cuminc(
  ftime = excel_0417$`_t`,              # Time to event or censoring
  fstatus = excel_0417$event_type,      # Event indicator (1=progression, 2=death, 0=censored)
  group = excel_0417$agebin_TB1,        # Grouping variable (e.g., Age group)
  cencode = 0                           # Value indicating censored data
)

# Display the results of Gray's test
gray_model_age$Tests




## -------------------------------------------------------------------------------------------------
# Time in years 
excel_0417$time_years <- excel_0417$`_t` / 365

## -------------------

# --- Bloco inicial: só CARREGAR pacotes e rodar análises ---

library(cmprsk)
library(survival)

# 1) Garantir que os dados existem (você já importou na mão)
stopifnot(exists("excel_0417"))

# 2) Tempo em anos
excel_0417$time_years <- excel_0417$`_t` / 365

# 3) CIF total (recorrência vs. morte)
cif_total <- cmprsk::cuminc(
  ftime   = excel_0417$time_years,
  fstatus = excel_0417$event_type,
  cencode = 0
)
plot(cif_total,
     xlab="Time (years)", ylab="Cumulative incidence",
     lwd=2, lty=c(1,2),
     main="CIF: Recurrence (1) vs Death (2) — Total")

# 4) CIF por HIV + teste de Gray
cif_hiv <- cmprsk::cuminc(
  ftime   = excel_0417$time_years,
  fstatus = excel_0417$event_type,
  group   = excel_0417$hiv_atTB1,   # 0=neg, 1=pos
  cencode = 0
)
cif_hiv$Tests

plot(0,0,type="n", xlim=c(0,12), ylim=c(0,0.3),
     xlab="Time (years)", ylab="Cumulative incidence",
     main="CIF of Recurrence by HIV status")
lines(cif_hiv$`0 1`$time, cif_hiv$`0 1`$est, lwd=2)          # HIV-
lines(cif_hiv$`1 1`$time, cif_hiv$`1 1`$est, lwd=2, lty=2)    # HIV+
legend("topleft", c("HIV-","HIV+"), lwd=2, lty=c(1,2), bty="n")

# 5) (Opcional) Curva de hazard cause-specific (se 'muhaz' já estiver instalado)
if (requireNamespace("muhaz", quietly = TRUE)) {
  t  <- excel_0417$time_years
  ev <- as.integer(excel_0417$event_type == 1)   # 1=recorrência, outros=censura
  hz_all <- muhaz::muhaz(t, ev)
  plot(hz_all, main="Cause-specific hazard of recurrence",
       xlab="Time (years)", ylab="Hazard")
} else {
  message("Para ver a curva de hazard: instale uma ÚNICA vez quando quiser -> install.packages('muhaz')")
}





## -------------------------------------------------------------------------------------------------
cif <- cuminc(ftime = excel_0417$time_years, fstatus = excel_0417$event_type)



## -------------------------------------------------------------------------------------------------
names(cif) <- c("First TB Recurrence", "Death")



## -------------------------------------------------------------------------------------------------


# Aumentar margem para caber
par(mar = c(7, 5, 4, 2) + 0.1)

# Plotar o CIF
plot(cif,
     main = "Cumulative Incidence of TB Recurrence vs. Death (total population)",
     xlab = "",
     ylab = "Cumulative Incidence",
     lwd = 2,
     col = c("black", "black"),
     lty = c(1, 2),
     ylim = c(0, 0.3),
     xlim = c(0, 12),
     xaxt = "n" # não desenhar eixo x automático
)

# Definir pontos de tempo
time_points <- c(0, 5, 10)

# 1. Criar ticks de 0 a 12 no eixo X (sem rótulo)
axis(1, at = 0:12, labels = FALSE)

# 2. Escrever rótulos 0,1,2,...12 no eixo X
mtext(0:12, side = 1, at = 0:12, line = 1, cex = 0.8)

# 3. Escrever "Time (years)"
mtext("Time (years)", side = 1, line = 2.5)

# 4. Escrever "Number at risk"
mtext("Number at risk", side = 1, line = 4)

# 5. Calcular número de pessoas at risk (apenas em 0, 5 e 10 anos)
at_risk <- sapply(time_points, function(t) sum(excel_0417$time_years >= t))

# 6. Escrever número de pessoas at risk nos tempos 0, 5 e 10
mtext(at_risk, side = 1, at = time_points, line = 5.5, cex = 0.8)




## -------------------------------------------------------------------------------------------------
# gostei desse!!! 

# Abrir o dispositivo PDF
pdf("grafico_CIF_total_population.pdf", width = 8, height = 6)

# Margens
par(mar = c(10, 6, 4, 2) + 0.1)

# Plotar o CIF (total) com eixo Y em 0.05
plot(cif,
     xlab = "",
     ylab = "Cumulative Incidence",
     lwd  = 2,
     col  = c("black", "gray"),
     lty  = c(1, 2),
     ylim = c(0, 0.3),
     xlim = c(0, 12),
     xaxt = "n",
     yaxt = "n"     # <- desliga Y automático
)
axis(2, at = seq(0, 0.30, by = 0.05), las = 1)  # <- ticks a cada 0.05
box()

# Definir pontos de tempo para "Number at risk"
time_points <- c(0, 5, 10)

# Eixo X e "Number at risk"
axis(1, at = 0:12, labels = FALSE)
mtext(0:12, side = 1, at = 0:12, line = 1, cex = 0.8)
mtext("Time (years)", side = 1, line = 2.5)

mtext("Number at risk", side = 1, line = 4)
at_risk <- sapply(time_points, function(t) sum(excel_0417$time_years >= t))
mtext(at_risk, side = 1, at = time_points, line = 5.5, cex = 0.8)

# Fechar o dispositivo PDF
dev.off()



## -------------------------------------------------------------------------------------------------
#### HIV gostei desse!!!!!!

pdf("grafico_CIF_HIV.pdf", width = 8, height = 6)
#Ajustar margem para caber as informações
par(mar = c(10, 6, 4, 2) + 0.1)

# Plotar o gráfico vazio
plot(0, 0,
     xlim = c(0, 12),
     ylim = c(0, 0.3),
     xlab = "",
     ylab = "Cumulative Incidence",
     type = "n",
     xaxt = "n", # Sem eixo x automático
     yaxt = "n"  # Sem eixo y automático
)

# --- Eixo Y de 0.05 em 0.05 ---
axis(2, at = seq(0, 0.3, by = 0.05), las = 1)

# Plotar curvas
lines(cif_hiv$`0 1`$time, cif_hiv$`0 1`$est, col = "black", lty = 1, lwd = 2.5)  # HIV-negative
lines(cif_hiv$`1 1`$time, cif_hiv$`1 1`$est, col = "red", lty = 1, lwd = 2.5)    # HIV-positive

# Legenda
legend("topleft",
       legend = c("HIV-negative", "HIV-positive"),
       col = c("black", "red"),
       lty = 1,
       lwd = 2.5,
       cex = 1.0,
       bty = "n")

# --- Eixo X e informações abaixo ---

# 1. Colocar ticks de 0 a 12 anos
axis(1, at = 0:12, labels = FALSE)

# 2. Escrever anos 0-12
mtext(0:12, side = 1, at = 0:12, line = 1, cex = 0.8)

# 3. Rótulo do eixo X
mtext("Time (years)", side = 1, line = 2.8)

# 4. "Number at risk"
mtext("Number at risk", side = 1, line = 4.5, cex = 0.8)

# 5. Definir pontos para mostrar o número at risk
time_points <- c(0, 5, 10)

# 6. Calcular número at risk para HIV-negativo e HIV-positivo
at_risk_hiv_neg <- sapply(time_points, function(t) sum(excel_0417$time_years >= t & excel_0417$hiv_atTB1 == 0, na.rm = TRUE))
at_risk_hiv_pos <- sapply(time_points, function(t) sum(excel_0417$time_years >= t & excel_0417$hiv_atTB1 == 1, na.rm = TRUE))

# 7. Escrever rótulo "HIV-negative" e "HIV-positive" mais para a esquerda
mtext("HIV-negative", side = 1, at = -2.5, line = 5.8, adj = 0, cex = 0.8)
mtext("HIV-positive", side = 1, at = -2.5, line = 7.1, adj = 0, cex = 0.8)

# 8. Escrever número de HIV-negative
mtext(at_risk_hiv_neg, side = 1, at = time_points, line = 5.8, cex = 0.8)

# 9. Escrever número de HIV-positive
mtext(at_risk_hiv_pos, side = 1, at = time_points, line = 7.1, cex = 0.8)

# 10. text
# Adicionar p-value no gráfico
text(x = 10, y = 0.28, labels = "p < 0.001", cex = 0.8)

dev.off()


## -------------------------------------------------------------------------------------------------
# Abrir o arquivo PDF
pdf("grafico_HIV_CIF.pdf", width = 8, height = 6)

#### HIV
#Ajustar margem para caber as informações
par(mar = c(9, 5, 4, 2) + 0.1)

# Plotar o gráfico vazio
plot(0, 0,
     xlim = c(0, 12),
     ylim = c(0, 0.3),
     xlab = "",
     ylab = "Cumulative Incidence",
     type = "n",
     xaxt = "n", # Sem eixo x automático
     yaxt = "n"  # Sem eixo y automático
)

# --- Eixo Y de 0.05 em 0.05 ---
axis(2, at = seq(0, 0.3, by = 0.05), las = 1)

# Plotar curvas
lines(cif_hiv$`0 1`$time, cif_hiv$`0 1`$est, col = "black", lty = 1, lwd = 2.5)  # HIV-negative
lines(cif_hiv$`1 1`$time, cif_hiv$`1 1`$est, col = "red", lty = 1, lwd = 2.5)    # HIV-positive

# Legenda
legend("topleft",
       legend = c("HIV-negative", "HIV-positive"),
       col = c("black", "red"),
       lty = 1,
       lwd = 2.5,
       cex = 1.0,
       bty = "n")

# --- Eixo X e informações abaixo ---

# 1. Colocar ticks de 0 a 12 anos
axis(1, at = 0:12, labels = FALSE)

# 2. Escrever anos 0-12
mtext(0:12, side = 1, at = 0:12, line = 1, cex = 0.8)

# 3. Rótulo do eixo X
mtext("Time (years)", side = 1, line = 2.8)

# 4. "Number at risk"
mtext("Number at risk", side = 1, line = 4.5)

# 5. Definir pontos para mostrar o número at risk
time_points <- c(0, 5, 10)

# 6. Calcular número at risk para HIV-negativo e HIV-positivo
at_risk_hiv_neg <- sapply(time_points, function(t) sum(excel_0417$time_years >= t & excel_0417$hiv_atTB1 == 0, na.rm = TRUE))
at_risk_hiv_pos <- sapply(time_points, function(t) sum(excel_0417$time_years >= t & excel_0417$hiv_atTB1 == 1, na.rm = TRUE))

# 7. Escrever rótulo "HIV-negative" e "HIV-positive" mais para a esquerda
mtext("HIV −", side = 1, at = -2.0, line = 5.8, adj = 0, cex = 0.8)
mtext("HIV +", side = 1, at = -2.0, line = 7.1, adj = 0, cex = 0.8)

# 8. Escrever número de HIV-negative
mtext(at_risk_hiv_neg, side = 1, at = time_points, line = 5.8, cex = 0.8)

# 9. Escrever número de HIV-positive
mtext(at_risk_hiv_pos, side = 1, at = time_points, line = 7.1, cex = 0.8)

# 10. text
# Adicionar p-value no gráfico
text(x = 10, y = 0.28, labels = "p < 0.001", cex = 1)


# Fechar o arquivo
dev.off()



## -------------------------------------------------------------------------------------------------
# Filtrar apenas pessoas com idade >= 15 anos
excel_0417_subset <- subset(excel_0417, age_atTB1 >= 15)

# Criar objeto CIF para tabagismo
cif_tobacco <- cuminc(
  ftime = excel_0417_subset$time_years,
  fstatus = excel_0417_subset$event_type,
  group = excel_0417_subset$tobac_atTB1,
  cencode = 0)


## -------------------------------------------------------------------------------------------------
# Gray's test (diferença entre fumantes e não fumantes)
gray_test_tobacco <- cmprsk::cuminc(
  ftime = excel_0417_subset$time_years,
  fstatus = excel_0417_subset$event_type,
  group = excel_0417_subset$tobac_atTB1,
  cencode = 0
)
gray_test_tobacco$Tests



## -------------------------------------------------------------------------------------------------


#################


pdf("grafico_CIF_Tobacco.pdf", width = 8, height = 6)
par(mar = c(10, 6, 4, 2) + 0.1)

# Plot vazio
plot(0, 0,
     xlim = c(0, 12),
     ylim = c(0, 0.3),
     xlab = "",
     ylab = "Cumulative Incidence",
     type = "n",
     xaxt = "n",
     yaxt = "n"
)

# Eixo Y
axis(2, at = seq(0, 0.3, by = 0.05), las = 1)

# Curvas
lines(cif_tobacco$`0 1`$time, cif_tobacco$`0 1`$est,
      col = "black", lty = 1, lwd = 2.5)   # Não-fumantes
lines(cif_tobacco$`1 1`$time, cif_tobacco$`1 1`$est,
      col = "red", lty = 1, lwd = 2.5)     # Fumantes

# Legenda sem quadrado e sem caixa
legend("topleft",
       legend = c("Non-smoker", "Smoker"),
       col = c("black", "red"),
       lty = 1,
       lwd = 2.5,
       bty = "n",   # tira a caixa
       cex = 1.0
)

# Eixo X
axis(1, at = 0:12, labels = FALSE)
mtext(0:12, side = 1, at = 0:12, line = 1, cex = 0.8)
mtext("Time (years)", side = 1, line = 2.8)

# Número em risco
mtext("Number at risk", side = 1, line = 4.5, cex = 0.8)
time_points <- c(0, 5, 10)

at_risk_non <- sapply(time_points, function(t) sum(excel_0417$time_years >= t & excel_0417$tobac_atTB1 == 0, na.rm = TRUE))
at_risk_smk <- sapply(time_points, function(t) sum(excel_0417$time_years >= t & excel_0417$tobac_atTB1 == 1, na.rm = TRUE))

mtext("Non-smoker", side = 1, at = -2.5, line = 5.8, adj = 0, cex = 0.8)
mtext("Smoker",     side = 1, at = -2.5, line = 7.1, adj = 0, cex = 0.8)
mtext(at_risk_non, side = 1, at = time_points, line = 5.8, cex = 0.8)
mtext(at_risk_smk, side = 1, at = time_points, line = 7.1, cex = 0.8)

# p-value
text(x = 10, y = 0.28, labels = "p < 0.001", cex = 0.8)

dev.off()




## -------------------------------------------------------------------------------------------------


names(cif)
# Incidência cumulativa final de Recorrência
tail(cif$`Primary TB Recurrence`$est, 1)

# Incidência cumulativa final de Morte
tail(cif$`Death (Competing Risk)`$est, 1)




## -------------------------------------------------------------------------------------------------
tail(cif_hiv$`0 1`$est, 1)  # Cumulative incidence final de recorrência para HIV-negativo
tail(cif_hiv$`1 1`$est, 1)  # Cumulative incidence final de recorrência para HIV-positivo



## -------------------------------------------------------------------------------------------------
tail(cif_tobacco$`0 1`$est, 1)  # Cumulative incidence final de recorrência para não fumantes
tail(cif_tobacco$`1 1`$est, 1)  # Cumulative incidence final de recorrência para fumantes



## -------------------------------------------------------------------------------------------------
# 1. Filtrar idade >= 15 anos
excel_0417_subset_drugs <- subset(excel_0417, age_atTB1 >= 15)

# 2. Criar objeto CIF para uso de drogas
cif_drugs <- cuminc(
  ftime = excel_0417_subset_drugs$time_years,
  fstatus = excel_0417_subset_drugs$event_type,
  group = excel_0417_subset_drugs$drugs_atTB1,
  cencode = 0
)

# 3. Rodar o Gray's test para diferença entre usuários e não usuários
gray_test_drugs <- cmprsk::cuminc(
  ftime = excel_0417_subset_drugs$time_years,
  fstatus = excel_0417_subset_drugs$event_type,
  group = excel_0417_subset_drugs$drugs_atTB1,
  cencode = 0
)
gray_test_drugs$Tests  # Aqui você verá o p-valor
#####################
# Drug users curve CIF 

# Plotar a curva
par(mar = c(10, 6, 4, 2) + 0.1)  # Margens

plot(0, 0,
     xlim = c(0, 12),
     ylim = c(0, 0.3),
     xlab = "",
     ylab = "Cumulative Incidence",
     type = "n",
     xaxt = "n",
     yaxt = "n"
)

# Eixo Y
axis(2, at = seq(0, 0.3, by = 0.05), las = 1)

# Curvas
lines(cif_drugs$`0 1`$time, cif_drugs$`0 1`$est, col = "black", lty = 1, lwd = 2.5)  # Non-user
lines(cif_drugs$`1 1`$time, cif_drugs$`1 1`$est, col = "red", lty = 1, lwd = 2.5)    # Drug user

# Legenda
legend("topleft",
       legend = c("Non-user", "Drug user"),
       col = c("black", "red"),
       lty = 1,
       lwd = 2.5,
       cex = 0.9)

# Eixo X
axis(1, at = 0:12, labels = FALSE)
mtext(0:12, side = 1, at = 0:12, line = 1, cex = 0.8)
mtext("Time (years)", side = 1, line = 2.8)
mtext("Number at risk", side = 1, line = 4.5)

# Número de pessoas at risk
time_points <- c(0, 5, 10)

# Calcular at risk para cada grupo
at_risk_nonuser <- sapply(time_points, function(t) sum(excel_0417_subset_drugs$time_years >= t & excel_0417_subset_drugs$drugs_atTB1 == 0, na.rm = TRUE))
at_risk_user <- sapply(time_points, function(t) sum(excel_0417_subset_drugs$time_years >= t & excel_0417_subset_drugs$drugs_atTB1 == 1, na.rm = TRUE))

# Rótulos dos grupos
mtext("Non-user", side = 1, at = -2.5, line = 5.8, adj = 0, cex = 0.8)
mtext("Drug user", side = 1, at = -2.5, line = 7.1, adj = 0, cex = 0.8)

# Número de pessoas at risk nos tempos 0,5,10
mtext(at_risk_nonuser, side = 1, at = time_points, line = 5.8, cex = 0.8)
mtext(at_risk_user, side = 1, at = time_points, line = 7.1, cex = 0.8)

# Inserir p-valor do Gray's test
text(x = 10, y = 0.28, labels = "p < 0.001", cex = 1)


########


# Salvar em PDF
pdf("grafico_CIF_Drugs.pdf", width = 8, height = 6)

# Plotar a curva
par(mar = c(10, 6, 4, 2) + 0.1)  # Margens

plot(0, 0,
     xlim = c(0, 12),
     ylim = c(0, 0.3),
     xlab = "",
     ylab = "Cumulative Incidence",
     type = "n",
     xaxt = "n",
     yaxt = "n"
)

# Eixo Y
axis(2, at = seq(0, 0.3, by = 0.05), las = 1)

# Curvas
lines(cif_drugs$`0 1`$time, cif_drugs$`0 1`$est, col = "black", lty = 1, lwd = 2.5)  # Non-user
lines(cif_drugs$`1 1`$time, cif_drugs$`1 1`$est, col = "red",   lty = 1, lwd = 2.5)  # Drug user

# Legenda sem quadrado/caixa
legend("topleft",
       legend = c("Non-user", "Drug user"),
       col = c("black", "red"),
       lty = 1,
       lwd = 2.5,
       cex = 0.9,
       pch = NA,
       bty = "n")

# Eixo X
axis(1, at = 0:12, labels = FALSE)
mtext(0:12, side = 1, at = 0:12, line = 1, cex = 0.8)
mtext("Time (years)", side = 1, line = 2.8)
mtext("Number at risk", side = 1, line = 4.5)

# Número de pessoas at risk
time_points <- c(0, 5, 10)

# Calcular at risk para cada grupo
at_risk_nonuser <- sapply(time_points, function(t) sum(excel_0417_subset_drugs$time_years >= t & excel_0417_subset_drugs$drugs_atTB1 == 0, na.rm = TRUE))
at_risk_user    <- sapply(time_points, function(t) sum(excel_0417_subset_drugs$time_years >= t & excel_0417_subset_drugs$drugs_atTB1 == 1, na.rm = TRUE))

# Rótulos dos grupos
mtext("Non-user", side = 1, at = -2.5, line = 5.8, adj = 0, cex = 0.8)
mtext("Drug user", side = 1, at = -2.5, line = 7.1, adj = 0, cex = 0.8)

# Números em risco
mtext(at_risk_nonuser, side = 1, at = time_points, line = 5.8, cex = 0.8)
mtext(at_risk_user,    side = 1, at = time_points, line = 7.1, cex = 0.8)

# Inserir p-valor do Gray's test
text(x = 10, y = 0.28, labels = "p < 0.001", cex = 1)

dev.off()

## -------------------------------------------------------------------------------------------------
# Recorrência em Drug users = 1
tail(cif_drugs$`1 1`$est, 1)

# Recorrência em Non-drug users = 0
tail(cif_drugs$`0 1`$est, 1)



## -------------------------------------------------------------------------------------------------
### Alcohol


# Filtrar apenas pessoas com idade >= 15 anos
excel_0417_subset_alcohol <- subset(excel_0417, age_atTB1 >= 15)


# CIF para álcool
cif_alcohol <- cuminc(
  ftime = excel_0417_subset_alcohol$time_years,
  fstatus = excel_0417_subset_alcohol$event_type,
  group = excel_0417_subset_alcohol$alc_atTB1,
  cencode = 0
)


# Gray's test (diferença entre usuários e não usuários de álcool)
gray_test_alcohol <- cmprsk::cuminc(
  ftime = excel_0417_subset_alcohol$time_years,
  fstatus = excel_0417_subset_alcohol$event_type,
  group = excel_0417_subset_alcohol$alc_atTB1,
  cencode = 0
)
gray_test_alcohol$Tests  # Aqui você verá o p-valor




## -------------------------------------------------------------------------------------------------
# esse aqui!!!
# Salvar em PDF
pdf("grafico_CIF_Alcohol.pdf", width = 8, height = 6)

# Margens
par(mar = c(10, 6, 4, 2) + 0.1)

# Gráfico vazio
plot(0, 0,
     xlim = c(0, 12),
     ylim = c(0, 0.3),
     xlab = "",
     ylab = "Cumulative Incidence",
     type = "n",
     xaxt = "n",
     yaxt = "n"
)

# Eixo Y
axis(2, at = seq(0, 0.3, by = 0.05), las = 1)

# Curvas
lines(cif_alcohol$`0 1`$time, cif_alcohol$`0 1`$est,
      col = "black", lty = 1, lwd = 2.5)  # Non-user
lines(cif_alcohol$`1 1`$time, cif_alcohol$`1 1`$est,
      col = "red",   lty = 1, lwd = 2.5)  # Alcohol user

# Legenda só com linhas (sem quadradinho e sem caixa)
legend("topleft",
       legend = c("Non-user", "Alcohol user"),
       col    = c("black", "red"),
       lty    = 1,
       lwd    = 2.5,
       cex    = 0.9,
       bty    = "n",
       pch    = NA,
       pt.cex = 0)

# Eixo X
axis(1, at = 0:12, labels = FALSE)
mtext(0:12, side = 1, at = 0:12, line = 1, cex = 0.8)
mtext("Time (years)", side = 1, line = 2.8)
mtext("Number at risk", side = 1, line = 4.5)

# Número em risco
time_points <- c(0, 5, 10)
at_risk_nonalcohol <- sapply(time_points, function(t)
  sum(excel_0417_subset_alcohol$time_years >= t &
        excel_0417_subset_alcohol$alc_atTB1 == 0, na.rm = TRUE))
at_risk_alcohol <- sapply(time_points, function(t)
  sum(excel_0417_subset_alcohol$time_years >= t &
        excel_0417_subset_alcohol$alc_atTB1 == 1, na.rm = TRUE))

# Rótulos
mtext("Non-user",     side = 1, at = -2.7, line = 5.8, adj = 0, cex = 0.8)
mtext("Alcohol user", side = 1, at = -2.7, line = 7.1, adj = 0, cex = 0.8)

# Números abaixo dos tempos
mtext(at_risk_nonalcohol, side = 1, at = time_points, line = 5.8, cex = 0.8)
mtext(at_risk_alcohol,    side = 1, at = time_points, line = 7.1, cex = 0.8)

# p-valor
text(x = 10, y = 0.28, labels = "p < 0.001", cex = 1)

dev.off()





## -------------------------------------------------------------------------------------------------
# Recorrência em Alcohol users
tail(cif_alcohol$`1 1`$est, 1)

# Recorrência em Non-alcohol users
tail(cif_alcohol$`0 1`$est, 1)



## -------------------------------------------------------------------------------------------------
# Dividir em 3 gráficos
par(mfrow = c(1, 3), mar = c(6, 5, 4, 2) + 0.1, oma = c(3, 0, 3, 0)) 

# --- Primeiro gráfico: Tobacco ---
plot(0, 0,
     xlim = c(0, 12),
     ylim = c(0, 0.3),
     xlab = "Time (years)",  # <<< AQUI! Já colocamos o rótulo aqui
     ylab = "Cumulative Incidence",
     main = "Tobacco Use",
     type = "n",
     xaxt = "n", yaxt = "n")

axis(2, at = seq(0, 0.3, 0.05), las = 1)
axis(1, at = 0:12, labels = 0:12, cex.axis = 0.8, padj = 0.5)

lines(cif_tobacco$`0 1`$time, cif_tobacco$`0 1`$est, col = "black", lwd = 2.5)
lines(cif_tobacco$`1 1`$time, cif_tobacco$`1 1`$est, col = "red", lwd = 2.5)
text(10, 0.28, "p < 0.001", cex = 1)

# --- Segundo gráfico: Drug Use ---
plot(0, 0,
     xlim = c(0, 12),
     ylim = c(0, 0.3),
     xlab = "Time (years)",  # <<< AQUI TAMBÉM!
     ylab = "",
     main = "Drug Use",
     type = "n",
     xaxt = "n", yaxt = "n")

axis(2, at = seq(0, 0.3, 0.05), las = 1)
axis(1, at = 0:12, labels = 0:12, cex.axis = 0.8, padj = 0.5)

lines(cif_drugs$`0 1`$time, cif_drugs$`0 1`$est, col = "black", lwd = 2.5)
lines(cif_drugs$`1 1`$time, cif_drugs$`1 1`$est, col = "red", lwd = 2.5)
text(10, 0.28, "p < 0.001", cex = 1)

# --- Terceiro gráfico: Alcohol Use ---
plot(0, 0,
     xlim = c(0, 12),
     ylim = c(0, 0.3),
     xlab = "Time (years)",  # <<< AQUI TAMBÉM!
     ylab = "",
     main = "Alcohol Use",
     type = "n",
     xaxt = "n", yaxt = "n")

axis(2, at = seq(0, 0.3, 0.05), las = 1)
axis(1, at = 0:12, labels = 0:12, cex.axis = 0.8, padj = 0.5)

lines(cif_alcohol$`0 1`$time, cif_alcohol$`0 1`$est, col = "black", lwd = 2.5)
lines(cif_alcohol$`1 1`$time, cif_alcohol$`1 1`$est, col = "red", lwd = 2.5)
text(10, 0.28, "p < 0.001", cex = 1)

# --- Título geral no topo ---
mtext("Cumulative Incidence of TB Recurrence by Substance Use", outer = TRUE, line = 1, cex = 1.3)





## -------------------------------------------------------------------------------------------------

# Dividir em 3 gráficos
par(mfrow = c(1, 3), mar = c(10, 6, 4, 4) + 0.1, oma = c(6, 0, 4, 0))

# Definir tempo
time_points <- c(0, 5, 10)

# --- Primeiro gráfico: Tobacco Use ---
plot(0, 0, 
     xlim = c(0, 12),xaxs = "i"
     ylim = c(0, 0.3),
     xlab = "Time (years)", ylab = "Cumulative Incidence",
     main = "Tobacco Use",
     type = "n", xaxt = "n", yaxt = "n")

axis(1, at = 0:12, labels = 0:12, cex.axis = 0.8, padj = -0.5)

axis(2, at = seq(0, 0.3, 0.05), las = 1)
axis(1, at = 0:12, labels = 0:12, cex.axis = 0.8)

lines(cif_tobacco$`0 1`$time, cif_tobacco$`0 1`$est, col = "black", lwd = 2.5)
lines(cif_tobacco$`1 1`$time, cif_tobacco$`1 1`$est, col = "red", lwd = 2.5)
text(10, 0.28, "p < 0.001", cex = 1)

# Legenda de cor
legend("topleft", legend = c("Non-user", "User"),
       col = c("black", "red"), lty = 1, lwd = 2.5,
       bty = "n", cex = 0.8, inset = c(0.02, 0.02))

# Primeiro, escreve "Number at risk" mais acima
mtext("Number at risk", side = 1, outer = FALSE, line = 5.5, cex = 0.7)

# Depois, coloca os valores at risk
mtext(at_risk_nonsmoker, side = 1, at = time_points, line = 6.8, cex = 0.6)
mtext(at_risk_smoker, side = 1, at = time_points, line = 8.1, cex = 0.6)

# E escreve Non-user / User do lado
mtext("Non-user", side = 1, at = -6, line = 6.8, adj = 0, cex = 0.7)
mtext("User", side = 1, at = -6, line = 8.1, adj = 0, cex = 0.7)


# --- Segundo gráfico: Drug Use ---
plot(0, 0, 
     xlim = c(0, 12), xaxs = "i"
     ylim = c(0, 0.3),
     xlab = "Time (years)", ylab = "",
     main = "Drug Use",
     type = "n", xaxt = "n", yaxt = "n")

axis(2, at = seq(0, 0.3, 0.05), las = 1)
axis(1, at = 0:12, labels = 0:12, cex.axis = 0.8)

lines(cif_drugs$`0 1`$time, cif_drugs$`0 1`$est, col = "black", lwd = 2.5)
lines(cif_drugs$`1 1`$time, cif_drugs$`1 1`$est, col = "red", lwd = 2.5)
text(10, 0.28, "p < 0.001", cex = 1)

mtext(at_risk_nonuser, side = 1, at = time_points, line = 6.8, cex = 0.6)
mtext(at_risk_user, side = 1, at = time_points, line = 8.1, cex = 0.6)

# --- Terceiro gráfico: Alcohol Use ---
plot(0, 0, 
     xlim = c(0, 12), xaxs = "i"
     ylim = c(0, 0.3),
     xlab = "Time (years)", ylab = "",
     main = "Alcohol Use",
     type = "n", xaxt = "n", yaxt = "n")

axis(2, at = seq(0, 0.3, 0.05), las = 1)
axis(1, at = 0:12, labels = 0:12, cex.axis = 0.8)

lines(cif_alcohol$`0 1`$time, cif_alcohol$`0 1`$est, col = "black", lwd = 2.5)
lines(cif_alcohol$`1 1`$time, cif_alcohol$`1 1`$est, col = "red", lwd = 2.5)
text(10, 0.28, "p < 0.001", cex = 1)


mtext(at_risk_nonalcohol, side = 1, at = time_points, line = 6.8, cex = 0.6)
mtext(at_risk_alcohol, side = 1, at = time_points, line = 8.1, cex = 0.6)



##############

# layout
par(mfrow = c(1, 3), mar = c(10, 7, 4, 4) + 0.1, oma = c(6, 0, 4, 0))

time_points <- c(0, 5, 10)

### --- 1) Tobacco Use ---
plot(0, 0,
     xlim = c(0, 12), xaxs = "i",
     ylim = c(0, 0.3),
     xlab = "Time (years)", ylab = "Cumulative Incidence",
     main = "Tobacco Use",
     type = "n", xaxt = "n", yaxt = "n")

axis(2, at = seq(0, 0.3, 0.05), las = 1)
axis(1, at = 0:12, labels = 0:12, cex.axis = 0.8, padj = -0.3)  # apenas 1 vez

lines(cif_tobacco$`0 1`$time, cif_tobacco$`0 1`$est, col = "black", lwd = 2.5)
lines(cif_tobacco$`1 1`$time, cif_tobacco$`1 1`$est, col = "red",   lwd = 2.5)
text(10, 0.28, "p < 0.001", cex = 1)

# legenda sem clipping
op <- par(xpd = NA)
legend("topleft", legend = c("Non-user", "User"),
       col = c("black", "red"), lty = 1, lwd = 2.5,
       bty = "n", cex = 0.9, inset = c(0.02, 0.02))
par(op)

mtext("Number at risk", side = 1, line = 5.5, cex = 0.7)
mtext(at_risk_nonsmoker, side = 1, at = time_points, line = 6.8, cex = 0.6)
mtext(at_risk_smoker,    side = 1, at = time_points, line = 8.1, cex = 0.6)
mtext("Non-user", side = 1, at = -3, line = 6.8, adj = 0, cex = 0.7)
mtext("User",     side = 1, at = -3, line = 8.1, adj = 0, cex = 0.7)

### --- 2) Drug Use ---
plot(0, 0,
     xlim = c(0, 12), xaxs = "i",
     ylim = c(0, 0.3),
     xlab = "Time (years)", ylab = "",
     main = "Drug Use",
     type = "n", xaxt = "n", yaxt = "n")

axis(2, at = seq(0, 0.3, 0.05), las = 1)
axis(1, at = 0:12, labels = 0:12, cex.axis = 0.8, padj = -0.3)

lines(cif_drugs$`0 1`$time, cif_drugs$`0 1`$est, col = "black", lwd = 2.5)
lines(cif_drugs$`1 1`$time, cif_drugs$`1 1`$est, col = "red",   lwd = 2.5)
text(10, 0.28, "p < 0.001", cex = 1)

mtext(at_risk_nonuser, side = 1, at = time_points, line = 6.8, cex = 0.6)
mtext(at_risk_user,    side = 1, at = time_points, line = 8.1, cex = 0.6)

### --- 3) Alcohol Use ---
plot(0, 0,
     xlim = c(0, 12), xaxs = "i",
     ylim = c(0, 0.3),
     xlab = "Time (years)", ylab = "",
     main = "Alcohol Use",
     type = "n", xaxt = "n", yaxt = "n")

axis(2, at = seq(0, 0.3, 0.05), las = 1)
axis(1, at = 0:12, labels = 0:12, cex.axis = 0.8, padj = -0.3)

lines(cif_alcohol$`0 1`$time, cif_alcohol$`0 1`$est, col = "black", lwd = 2.5)
lines(cif_alcohol$`1 1`$time, cif_alcohol$`1 1`$est, col = "red",   lwd = 2.5)
text(10, 0.28, "p < 0.001", cex = 1)

mtext(at_risk_nonalcohol, side = 1, at = time_points, line = 6.8, cex = 0.6)
mtext(at_risk_alcohol,    side = 1, at = time_points, line = 8.1, cex = 0.6)




##########





## -------------------------------------------------------------------------------------------------
# Filtrar apenas pessoas com idade >= 15 anos
excel_0417_subset_inmate <- subset(excel_0417, age_atTB1 >= 15)

# CIF para encarceramento
cif_inmate <- cuminc(
  ftime = excel_0417_subset_inmate$time_years,
  fstatus = excel_0417_subset_inmate$event_type,
  group = excel_0417_subset_inmate$inmate_atTB1,
  cencode = 0
)

# Gray's test (diferença entre encarcerados e não encarcerados)
gray_test_inmate <- cmprsk::cuminc(
  ftime = excel_0417_subset_inmate$time_years,
  fstatus = excel_0417_subset_inmate$event_type,
  group = excel_0417_subset_inmate$inmate_atTB1,
  cencode = 0
)
gray_test_inmate$Tests  # Aqui você verá o p-valor


## -------------------------------------------------------------------------------------------------
library(cmprsk)




## -------------------------------------------------------------------------------------------------
# Estimar a incidência cumulativa final para cada grupo
# Pegando o último valor (final do acompanhamento)

# Para não presos (inmate_atTB1 == 0)
final_cif_noninmate <- tail(cif_inmate$`0 1`$est, n = 1)

# Para presos (inmate_atTB1 == 1)
final_cif_inmate <- tail(cif_inmate$`1 1`$est, n = 1)

# Mostrar os valores
final_cif_noninmate
final_cif_inmate



## -------------------------------------------------------------------------------------------------
# Margens
par(mar = c(10, 6, 4, 2) + 0.1)

# Gráfico vazio
plot(0, 0,
     xlim = c(0, 12),
     ylim = c(0, 0.3),
     xlab = "",
     ylab = "Cumulative Incidence",
     cex.main = 0.9,  # <-- diminui o tamanho do título!
     type = "n",
     xaxt = "n",
     yaxt = "n"

)

# Eixo Y
axis(2, at = seq(0, 0.3, by = 0.05), las = 1)

# Plotar curvas
lines(cif_inmate$`0 1`$time, cif_inmate$`0 1`$est, col = "black", lty = 1, lwd = 2.5)  # Sem histórico de encarceramento
lines(cif_inmate$`1 1`$time, cif_inmate$`1 1`$est, col = "red", lty = 1, lwd = 2.5)    # Com histórico de encarceramento


legend("topleft",
       legend = c("Non-incarcerated", "Incarcerated"),
       col = c("black", "red"),
       lty = 1,
       lwd = 2.5,
       cex = 0.7,       # <-- menor
       bty = "n")

# Eixo X
axis(1, at = 0:12, labels = FALSE)
mtext(0:12, side = 1, at = 0:12, line = 1, cex = 0.6)
mtext("Time (years)", side = 1, line = 2.8)
mtext("Number at risk", side = 1, at = -2.75, line = 4.5, adj = 0, cex = 0.8)  # <-- Corrigido aqui!

# Número at risk
time_points <- c(0, 5, 10)

at_risk_noninmate <- sapply(time_points, function(t) sum(excel_0417_subset_inmate$time_years >= t & excel_0417_subset_inmate$inmate_atTB1 == 0, na.rm = TRUE))
at_risk_inmate <- sapply(time_points, function(t) sum(excel_0417_subset_inmate$time_years >= t & excel_0417_subset_inmate$inmate_atTB1 == 1, na.rm = TRUE))

# Rótulos dos grupos
mtext("Non-incarcerated", side = 1, at = -2.75, line = 5.8, adj = 0, cex = 0.8)
mtext("Incarcerated", side = 1, at = -2.75, line = 7.1, adj = 0, cex = 0.8)

# Números abaixo dos tempos
mtext(at_risk_noninmate, side = 1, at = time_points, line = 5.8, cex = 0.7)
mtext(at_risk_inmate, side = 1, at = time_points, line = 7.1, cex = 0.7)

# Inserir p-valor no gráfico (ajuste o valor conforme Gray's test)
text(x = 10, y = 0.28, labels = "p < 0.001", cex = 0.6)

################


# Salvar em PDF
pdf("grafico_CIF_Inmate.pdf", width = 8, height = 6)

# Margens
par(mar = c(10, 7, 4, 2) + 0.1)

# Gráfico vazio
plot(0, 0,
     xlim = c(0, 12),
     ylim = c(0, 0.3),
     xlab = "",
     ylab = "Cumulative Incidence",
     cex.main = 0.9,
     type = "n",
     xaxt = "n",
     yaxt = "n"
)

# Eixo Y
axis(2, at = seq(0, 0.3, by = 0.05), las = 1)

# Curvas
lines(cif_inmate$`0 1`$time, cif_inmate$`0 1`$est,
      col = "black", lty = 1, lwd = 2.5)  # Não encarcerados
lines(cif_inmate$`1 1`$time, cif_inmate$`1 1`$est,
      col = "red", lty = 1, lwd = 2.5)    # Encarcerados

# Legenda padronizada
legend("topleft",
       legend = c("Non-incarcerated", "Incarcerated"),
       col    = c("black", "red"),
       lty    = 1,
       lwd    = 2.5,
       cex    = 0.9,
       bty    = "n",
       pch    = NA,
       pt.cex = 0)

# Eixo X
axis(1, at = 0:12, labels = FALSE)
mtext(0:12, side = 1, at = 0:12, line = 1, cex = 0.8)
mtext("Time (years)", side = 1, line = 2.8)
mtext("Number at risk", side = 1, line = 4.5, cex = 0.8)

# Número em risco
time_points <- c(0, 5, 10)
at_risk_noninmate <- sapply(time_points, function(t)
  sum(excel_0417_subset_inmate$time_years >= t &
        excel_0417_subset_inmate$inmate_atTB1 == 0, na.rm = TRUE))
at_risk_inmate <- sapply(time_points, function(t)
  sum(excel_0417_subset_inmate$time_years >= t &
        excel_0417_subset_inmate$inmate_atTB1 == 1, na.rm = TRUE))

# Rótulos dos grupos
mtext("Non-incarcerated", side = 1, at = -3.7, line = 5.8, adj = 0, cex = 0.8)
mtext("Incarcerated",    side = 1, at = -3.7, line = 7.1, adj = 0, cex = 0.8)

# Números abaixo dos tempos
mtext(at_risk_noninmate, side = 1, at = time_points, line = 5.8, cex = 0.8)
mtext(at_risk_inmate,    side = 1, at = time_points, line = 7.1, cex = 0.8)

# p-valor
text(x = 10, y = 0.28, labels = "p < 0.001", cex = 0.8)

dev.off()


## -------------------------------------------------------------------------------------------------
# Filtrar apenas pessoas com idade >= 15 anos
excel_0417_subset_homeless <- subset(excel_0417, age_atTB1 >= 15)

# CIF para homelessness
cif_homeless <- cuminc(
  ftime = excel_0417_subset_homeless$time_years,
  fstatus = excel_0417_subset_homeless$event_type,
  group = excel_0417_subset_homeless$homeless_atTB1,
  cencode = 0
)

# Gray's test (diferença entre em situação de rua e não)
gray_test_homeless <- cmprsk::cuminc(
  ftime = excel_0417_subset_homeless$time_years,
  fstatus = excel_0417_subset_homeless$event_type,
  group = excel_0417_subset_homeless$homeless_atTB1,
  cencode = 0
)
gray_test_homeless$Tests  # Aqui você verá o p-valor



## -------------------------------------------------------------------------------------------------
# Incidência cumulativa final para não-homeless
final_nonhomeless <- tail(cif_homeless$`0 1`$est, 1)

# Incidência cumulativa final para homeless
final_homeless <- tail(cif_homeless$`1 1`$est, 1)

# Mostrar os resultados
final_nonhomeless
final_homeless



## -------------------------------------------------------------------------------------------------
# Margens
par(mar = c(10, 7, 4, 2) + 0.1)

# Gráfico vazio
plot(0, 0,
     xlim = c(0, 12),
     ylim = c(0, 0.3),  # Mantido igual
     xlab = "",
     ylab = "Cumulative Incidence",
     cex.main = 0.9,  # Mesmo tamanho de título!
     type = "n",
     xaxt = "n",
     yaxt = "n"
)

# Eixo Y
axis(2, at = seq(0, 0.3, by = 0.05), las = 1)

# Plotar curvas
lines(cif_homeless$`0 1`$time, cif_homeless$`0 1`$est, col = "black", lty = 1, lwd = 2.5)  # Sem histórico de rua
lines(cif_homeless$`1 1`$time, cif_homeless$`1 1`$est, col = "red", lty = 1, lwd = 2.5)    # Com histórico de rua

# Legenda
legend("topleft",
       legend = c("Non-homeless", "Homeless"),
       col = c("black", "red"),
       lty = 1,
       lwd = 2.5,
       cex = 0.7,   # Legenda pequena
       bty = "n")   # Sem caixa

# Eixo X
axis(1, at = 0:12, labels = FALSE)
mtext(0:12, side = 1, at = 0:12, line = 1, cex = 0.6)
mtext("Time (years)", side = 1, line = 2.8)
mtext("Number at risk", side = 1, at = -2.75, line = 4.5, adj = 0, cex = 0.8)

# Número at risk
time_points <- c(0, 5, 10)

at_risk_nonhomeless <- sapply(time_points, function(t) sum(excel_0417_subset_homeless$time_years >= t & excel_0417_subset_homeless$homeless_atTB1 == 0, na.rm = TRUE))
at_risk_homeless <- sapply(time_points, function(t) sum(excel_0417_subset_homeless$time_years >= t & excel_0417_subset_homeless$homeless_atTB1 == 1, na.rm = TRUE))

# Rótulos dos grupos
mtext("Non-homeless", side = 1, at = -2.75, line = 5.8, adj = 0, cex = 0.8)
mtext("Homeless", side = 1, at = -2.75, line = 7.1, adj = 0, cex = 0.8)

# Números abaixo dos tempos
mtext(at_risk_nonhomeless, side = 1, at = time_points, line = 5.8, cex = 0.7)
mtext(at_risk_homeless, side = 1, at = time_points, line = 7.1, cex = 0.7)

# Inserir p-valor (ajuste conforme Gray's test para homelessness)
text(x = 10, y = 0.28, labels = "p < 0.001", cex = 0.6)

############

# Salvar em PDF
pdf("grafico_CIF_Homeless.pdf", width = 8, height = 6)

# Margens
par(mar = c(10, 7, 4, 2) + 0.1)

# Gráfico vazio
plot(0, 0,
     xlim = c(0, 12),
     ylim = c(0, 0.3),
     xlab = "",
     ylab = "Cumulative Incidence",
     type = "n",
     xaxt = "n",
     yaxt = "n"
)

# Eixo Y
axis(2, at = seq(0, 0.3, by = 0.05), las = 1)

# Curvas
lines(cif_homeless$`0 1`$time, cif_homeless$`0 1`$est,
      col = "black", lty = 1, lwd = 2.5)  # Non-homeless
lines(cif_homeless$`1 1`$time, cif_homeless$`1 1`$est,
      col = "red",   lty = 1, lwd = 2.5)  # Homeless

# Legenda padronizada
legend("topleft",
       legend = c("Non-homeless", "Homeless"),
       col    = c("black", "red"),
       lty    = 1,
       lwd    = 2.5,
       cex    = 0.9,
       bty    = "n",
       pch    = NA,
       pt.cex = 0)

# Eixo X
axis(1, at = 0:12, labels = FALSE)
mtext(0:12, side = 1, at = 0:12, line = 1, cex = 0.8)
mtext("Time (years)", side = 1, line = 2.8)
mtext("Number at risk", side = 1, line = 4.5, cex = 0.8)

# Número em risco
time_points <- c(0, 5, 10)
at_risk_nonhomeless <- sapply(time_points, function(t)
  sum(excel_0417_subset_homeless$time_years >= t &
        excel_0417_subset_homeless$homeless_atTB1 == 0, na.rm = TRUE))
at_risk_homeless <- sapply(time_points, function(t)
  sum(excel_0417_subset_homeless$time_years >= t &
        excel_0417_subset_homeless$homeless_atTB1 == 1, na.rm = TRUE))

# Rótulos dos grupos
mtext("Non-homeless", side = 1, at = -3.5, line = 5.8, adj = 0, cex = 0.8)
mtext("Homeless",     side = 1, at = -3.5, line = 7.1, adj = 0, cex = 0.8)

# Números abaixo dos tempos
mtext(at_risk_nonhomeless, side = 1, at = time_points, line = 5.8, cex = 0.8)
mtext(at_risk_homeless,    side = 1, at = time_points, line = 7.1, cex = 0.8)

# p-valor
text(x = 10, y = 0.28, labels = "p < 0.001", cex = 0.8)

dev.off()



## -------------------------------------------------------------------------------------------------
install.packages("patchwork")




## -------------------------------------------------------------------------------------------------
# Abrir o dispositivo PDF
pdf("grafico_social_adult.pdf", width = 8, height = 6)

# Salvar configuração atual
old_par <- par(no.readonly = TRUE)

# Abrir espaço para 2 gráficos lado a lado
par(mfrow = c(1, 2), mar = c(10, 6, 3, 4) + 0.1, oma = c(2, 2, 4, 2))

# ============================================
# Primeiro gráfico: Homelessness
# ============================================
plot(0, 0,
     xlim = c(0, 12),
     ylim = c(0, 0.3),
     xlab = "",
     ylab = "Cumulative Incidence",
     type = "n",
     xaxt = "n",
     yaxt = "n"
)

# Eixos e linhas
axis(2, at = seq(0, 0.3, by = 0.05), las = 1, cex.axis = 0.6)

lines(cif_homeless$`0 1`$time, cif_homeless$`0 1`$est, col = "black", lty = 1, lwd = 2.5)
lines(cif_homeless$`1 1`$time, cif_homeless$`1 1`$est, col = "red", lty = 1, lwd = 2.5)

legend("topleft",
       legend = c("Non-homeless", "Homeless"),
       col = c("black", "red"),
       lty = 1,
       lwd = 2.5,
       cex = 0.6,
       bty = "n")

axis(1, at = 0:12, labels = FALSE)
mtext(0:12, side = 1, at = 0:12, line = 1, cex = 0.6)
mtext("Time (years)", side = 1, line = 2.4, cex = 0.6)

# Número at risk - corrigido
time_points <- c(0, 5, 10)
at_risk_nonhomeless <- sapply(time_points, function(t) sum(excel_0417_subset_homeless$time_years >= t & excel_0417_subset_homeless$homeless_atTB1 == 0, na.rm = TRUE))
at_risk_homeless <- sapply(time_points, function(t) sum(excel_0417_subset_homeless$time_years >= t & excel_0417_subset_homeless$homeless_atTB1 == 1, na.rm = TRUE))

# Texto "Number at risk" e grupos
mtext("Number at risk", side = 1, at = -1.5, line = 3.8, adj = 1, cex = 0.7)
mtext("Non-homeless", side = 1, at = -1.5, line = 4.8, adj = 1, cex = 0.7)
mtext("Homeless", side = 1, at = -1.5, line = 5.8, adj = 1, cex = 0.7)

# Números para cada grupo
mtext(at_risk_nonhomeless, side = 1, at = time_points, line = 4.8, cex = 0.7)
mtext(at_risk_homeless, side = 1, at = time_points, line = 5.8, cex = 0.7)

# p-valor
text(x = 10, y = 0.28, labels = "p < 0.001", cex = 0.55)

# ============================================
# Segundo gráfico: Incarceration
# ============================================
plot(0, 0,
     xlim = c(0, 12),
     ylim = c(0, 0.3),
     xlab = "",
     ylab = "",  # Sem repetir eixo Y no segundo
     type = "n",
     xaxt = "n",
     yaxt = "n"
)

axis(2, at = seq(0, 0.3, by = 0.05), las = 1, cex.axis = 0.6)

lines(cif_inmate$`0 1`$time, cif_inmate$`0 1`$est, col = "black", lty = 1, lwd = 2.5)
lines(cif_inmate$`1 1`$time, cif_inmate$`1 1`$est, col = "red", lty = 1, lwd = 2.5)

legend("topleft",
       legend = c("Non-incarcerated", "Incarcerated"),
       col = c("black", "red"),
       lty = 1,
       lwd = 2.5,
       cex = 0.6,
       bty = "n")

axis(1, at = 0:12, labels = FALSE)
mtext(0:12, side = 1, at = 0:12, line = 1, cex = 0.6)
mtext("Time (years)", side = 1, line = 2.4, cex = 0.6)

# Número at risk - corrigido
at_risk_noninmate <- sapply(time_points, function(t) sum(excel_0417_subset_inmate$time_years >= t & excel_0417_subset_inmate$inmate_atTB1 == 0, na.rm = TRUE))
at_risk_inmate <- sapply(time_points, function(t) sum(excel_0417_subset_inmate$time_years >= t & excel_0417_subset_inmate$inmate_atTB1 == 1, na.rm = TRUE))

# Texto "Number at risk" e grupos
mtext("Number at risk", side = 1, at = -1.5, line = 3.8, adj = 1, cex = 0.7)
mtext("Non-incarcerated", side = 1, at = -1.5, line = 4.8, adj = 1, cex = 0.7)
mtext("Incarcerated", side = 1, at = -1.5, line = 5.8, adj = 1, cex = 0.7)

# Números para cada grupo
mtext(at_risk_noninmate, side = 1, at = time_points, line = 4.8, cex = 0.7)
mtext(at_risk_inmate, side = 1, at = time_points, line = 5.8, cex = 0.7)

# p-valor
text(x = 10, y = 0.28, labels = "p < 0.001", cex = 0.55)

# ============================================
# Título geral
# ============================================
mtext("Cumulative Incidence of TB Recurrence by Social Vulnerabilities (≥15 years)", outer = TRUE, cex = 1.2, line = 1)




# Restaurar as margens
par(old_par)
dev.off()



## -------------------------------------------------------------------------------------------------
excel_0417_subset <- subset(excel_0417, age_atTB1 >= 15)


## -------------------------------------------------------------------------------------------------
# Salvar configuração atual
old_par <- par(no.readonly = TRUE)

# Ajustar margem para caber as informações
par(mar = c(8, 6, 4, 2) + 0.1)

# --- HIV ---
# Plotar o gráfico vazio
plot(0, 0,
     xlim = c(0, 12),
     ylim = c(0, 0.3),
     xlab = "",
     ylab = "Cumulative Incidence",
     main = "Cumulative Incidence of TB Recurrence by HIV Status (≥15 years)",
     type = "n",
     xaxt = "n",
     yaxt = "n"
)

# Eixo Y (com números menores)
axis(2, at = seq(0, 0.3, by = 0.05), las = 1, cex.axis = 0.6)

# Plotar curvas
lines(cif_hiv$`0 1`$time, cif_hiv$`0 1`$est, col = "black", lty = 1, lwd = 2.5)  # HIV-negative
lines(cif_hiv$`1 1`$time, cif_hiv$`1 1`$est, col = "blue", lty = 1, lwd = 2.5)    # HIV-positive

# Legenda
legend("topleft",
       legend = c("HIV-negative", "HIV-positive"),
       col = c("black", "blue"),
       lty = 1,
       lwd = 2.5,
       cex = 0.7,
       bty = "n")

# Eixo X
axis(1, at = 0:12, labels = FALSE)
mtext(0:12, side = 1, at = 0:12, line = 1, cex = 0.6)
mtext("Time (years)", side = 1, line = 2.4, cex = 0.6)

# --- Número at risk ---
# Definir pontos para mostrar
time_points <- c(0, 5, 10)

# Cálculo do número at risk com banco filtrado
at_risk_hiv_neg <- sapply(time_points, function(t) sum(excel_0417_subset$time_years >= t & excel_0417_subset$hiv_atTB1 == 0, na.rm = TRUE))
at_risk_hiv_pos <- sapply(time_points, function(t) sum(excel_0417_subset$time_years >= t & excel_0417_subset$hiv_atTB1 == 1, na.rm = TRUE))

# Escrever "Number at risk" e grupos
mtext("Number at risk", side = 1, at = -0.5, line = 3.8, adj = 1, cex = 0.7)
mtext("HIV-negative", side = 1, at = -0.5, line = 4.8, adj = 1, cex = 0.7)
mtext("HIV-positive", side = 1, at = -0.5, line = 5.8, adj = 1, cex = 0.7)

# Números at risk
mtext(at_risk_hiv_neg, side = 1, at = time_points, line = 4.8, cex = 0.7)
mtext(at_risk_hiv_pos, side = 1, at = time_points, line = 5.8, cex = 0.7)

# p-valor
text(x = 10, y = 0.28, labels = "p < 0.001", cex = 0.6)

# Restaurar margens anteriores
par(old_par)




## -------------------------------------------------------------------------------------------------
# Filtrar apenas crianças (< 15 anos)
excel_0417_child <- subset(excel_0417, age_atTB1 < 15)

# Salvar configuração atual
old_par <- par(no.readonly = TRUE)

# Ajustar margem
par(mar = c(8, 6, 4, 2) + 0.1)

# --- HIV - Crianças ---
# Plotar o gráfico vazio
plot(0, 0,
     xlim = c(0, 10),    # Até 10 anos!
     ylim = c(0, 0.3),
     xlab = "",
     ylab = "Cumulative Incidence",
     main = "Cumulative Incidence of TB Recurrence by HIV Status (<15 years)",
     type = "n",
     xaxt = "n",
     yaxt = "n"
)

# Eixo Y
axis(2, at = seq(0, 0.3, by = 0.05), las = 1, cex.axis = 0.6)

# Plotar curvas (usa mesmo objeto cif_hiv se já estiver correto)
lines(cif_hiv$`0 1`$time, cif_hiv$`0 1`$est, col = "black", lty = 1, lwd = 2.5)  # HIV-negative
lines(cif_hiv$`1 1`$time, cif_hiv$`1 1`$est, col = "red", lty = 1, lwd = 2.5)    # HIV-positive

# Legenda
legend("topleft",
       legend = c("HIV-negative", "HIV-positive"),
       col = c("black", "red"),
       lty = 1,
       lwd = 2.5,
       cex = 0.7,
       bty = "n")

# Eixo X (0 a 10 anos agora)
axis(1, at = 0:10, labels = FALSE)
mtext(0:10, side = 1, at = 0:10, line = 1, cex = 0.6)
mtext("Time (years)", side = 1, line = 2.4, cex = 0.6)

# Número at risk
time_points <- c(0, 5, 10)

# Calcular com o subset de crianças
at_risk_hiv_neg <- sapply(time_points, function(t) sum(excel_0417_child$time_years >= t & excel_0417_child$hiv_atTB1 == 0, na.rm = TRUE))
at_risk_hiv_pos <- sapply(time_points, function(t) sum(excel_0417_child$time_years >= t & excel_0417_child$hiv_atTB1 == 1, na.rm = TRUE))

# Escrever "Number at risk" e grupos
mtext("Number at risk", side = 1, at = -0.5, line = 3.8, adj = 1, cex = 0.7)
mtext("HIV-negative", side = 1, at = -0.5, line = 4.8, adj = 1, cex = 0.7)
mtext("HIV-positive", side = 1, at = -0.5, line = 5.8, adj = 1, cex = 0.7)

# Números para cada grupo
mtext(at_risk_hiv_neg, side = 1, at = time_points, line = 4.8, cex = 0.7)
mtext(at_risk_hiv_pos, side = 1, at = time_points, line = 5.8, cex = 0.7)

# p-valor
text(x = 8.5, y = 0.28, labels = "p < 0.001", cex = 0.6)

# Restaurar margens
par(old_par)

# ---------------------


### Especial Curves
names(cif_total)
str(cif_total[[1]])


################################

## ===== TABELA POR INTERVALO: Taxa (/1.000 PY), IC95%, % do total e ΔCIF =====
library(cmprsk)
library(survival)
library(dplyr)

stopifnot(exists("excel_0417"),
          all(c("_t","event_type") %in% names(excel_0417)))

# tempo em anos
excel_0417$time_years <- excel_0417$`_t` / 365

## ---------- Utilitários ----------
# CIF(t) para recorrência (evento==1), right-continuous
.cif_rec_fun <- local({
  ci <- cmprsk::cuminc(ftime = excel_0417$time_years,
                       fstatus = excel_0417$event_type, cencode = 0)
  # componente costuma ser "1 1" quando não há 'group'
  nm <- if ("1 1" %in% names(ci)) "1 1" else "1"
  ci_rec <- ci[[nm]]
  function(t_years){
    approx(x = ci_rec$time, y = ci_rec$est,
           xout = t_years, method = "constant", f = 0, rule = 2)$y
  }
})

# monta tabela por janelas (a, b] em DIAS
interval_table <- function(cuts_days, labels){
  stopifnot(length(cuts_days) == length(labels) + 1)
  
  t_event <- excel_0417$`_t`       # dias até evento/censura
  status  <- excel_0417$event_type # 0=cens, 1=rec, 2=óbito
  total_rec <- sum(status == 1, na.rm = TRUE)
  
  out <- vector("list", length(labels))
  for(i in seq_along(labels)){
    a <- cuts_days[i]
    b <- cuts_days[i+1]
    # pessoa-tempo no intervalo: min(t, b) - a, truncado no mínimo 0
    time_days <- pmax(0, pmin(t_event, b) - a)
    py <- sum(time_days/365, na.rm = TRUE)
    
    # eventos de recorrência que ocorrem dentro de (a, b]
    nevent <- sum(status == 1 & t_event > a & t_event <= b, na.rm = TRUE)
    
    # taxa e IC95% (Poisson)
    rate  <- if(py > 0) nevent/py * 1000 else NA_real_
    lower <- if(nevent > 0) qchisq(0.025, 2*nevent)/(2*py)*1000 else 0
    upper <- if(nevent > 0) qchisq(0.975, 2*(nevent+1))/(2*py)*1000 else NA_real_
    
    out[[i]] <- data.frame(
      Interval                = labels[i],
      PY                      = round(py, 1),
      Recurrences_n           = nevent,
      Rate_per_1000PY         = round(rate, 1),
      Rate95CI                = ifelse(is.na(upper),
                                       sprintf("%.1f–NA", round(lower,1)),
                                       sprintf("%.1f–%.1f", round(lower,1), round(upper,1))),
      Pct_of_all_recurrences  = round(nevent/total_rec*100, 1),
      stringsAsFactors = FALSE
    )
  }
  bind_rows(out)
}

# adiciona ΔCIF por janela (em p.p.), usando CIF(t)
add_delta_cif <- function(tab, cuts_days){
  cif_at <- function(ddays){
    .cif_rec_fun(ddays/365)
  }
  left  <- head(cuts_days, -1)
  right <- tail(cuts_days, -1)
  dCIF  <- (cif_at(right) - cif_at(left)) * 100
  tab$Delta_CIF_pp <- round(dCIF, 2)
  tab
}

# constrói tabela FINAL (com checagens e linha total)
build_piecewise_table <- function(){
  # Partições exaustivas, mutuamente exclusivas: (a,b]
  cuts_days <- c(0, 90, 365, 730, 1825, Inf)  # ≤3m, 3–12m, 1–2a, 2–5a, >5a
  labels    <- c("≤3 months", "3–12 months", "1–2 years", "2–5 years", ">5 years")
  
  tab <- interval_table(cuts_days, labels) |>
    add_delta_cif(cuts_days)
  
  # Checagens
  total_rec <- sum(excel_0417$event_type == 1, na.rm = TRUE)
  sum_rec   <- sum(tab$Recurrences_n, na.rm = TRUE)
  if(sum_rec != total_rec){
    warning(sprintf("Soma dos eventos nos intervalos = %d, mas total de recorrências = %d.",
                    sum_rec, total_rec))
  }
  pct_sum <- sum(tab$Pct_of_all_recurrences, na.rm = TRUE)
  if(abs(pct_sum - 100) > 0.5){
    warning(sprintf("Soma dos percentuais = %.1f%% (pode haver arredondamento ou janelas).", pct_sum))
  }
  
  # Linha total (PY total sobre a união das janelas)
  # Observação: como as janelas cobrem todo o seguimento, PY_total é soma dos PY por janela
  PY_total <- round(sum(tab$PY, na.rm = TRUE), 1)
  Rate_all <- (sum_rec / (PY_total/1000))  # por 1.000 PY
  CIF_final <- .cif_rec_fun(max(excel_0417$time_years, na.rm = TRUE)) * 100
  
  total_row <- data.frame(
    Interval               = "Total",
    PY                     = PY_total,
    Recurrences_n          = sum_rec,
    Rate_per_1000PY        = round(Rate_all, 1),
    Rate95CI               = "",
    Pct_of_all_recurrences = round(100*sum_rec/total_rec, 1), # deve dar 100.0
    Delta_CIF_pp           = round(CIF_final, 2),             # CIF geral ao fim do seguimento
    stringsAsFactors = FALSE
  )
  
  # Formatar a coluna de taxa com IC junto (se quiser em uma só coluna)
  tab$Rate_with_CI <- sprintf("%.1f [%s]", tab$Rate_per_1000PY, tab$Rate95CI)
  total_row$Rate_with_CI <- sprintf("%.1f", total_row$Rate_per_1000PY)
  
  # Ordenar e selecionar colunas finais
  tab_final <- bind_rows(tab, total_row) |>
    select(Interval, PY, Recurrences_n,
           Rate_with_CI, Pct_of_all_recurrences, Delta_CIF_pp)
  names(tab_final) <- c("Time to Recurrence (interval)",
                        "PY", "Recurrences (n)",
                        "Rate (/1,000 PY) [95% CI]",
                        "% of all recurrences", "ΔCIF (p.p.)")
  tab_final
}

## ---- Rodar e inspecionar
tabela_piecewise <- build_piecewise_table()
print(tabela_piecewise, row.names = FALSE)

###################################


## ================================
## Gráficos por intervalo e CIF FG
## ================================
## Requer: excel_0417 com colunas `_t` (dias) e `event_type` (0,1,2)

# Pacotes
library(cmprsk)
library(survival)
library(dplyr)
library(ggplot2)
# (opcional, para combinar painéis)
suppressWarnings(suppressMessages(require(patchwork)))

stopifnot(exists("excel_0417"),
          all(c("_t","event_type") %in% names(excel_0417)))

# Tempo em anos
excel_0417$time_years <- excel_0417$`_t`/365

# ---------- Definição das janelas (a, b] ----------
max_t_days <- max(excel_0417$`_t`, na.rm = TRUE)
cuts_days  <- c(0, 90, 365, 730, 1825, max_t_days)  # ≤3m, 3–12m, 1–2a, 2–5a, >5a
labels_int <- c("≤3 months","3–12 months","1–2 years","2–5 years",">5 years")

# ---------- Funções utilitárias ----------
# Tabela por janelas: PY, N, taxa (/1000 PY) e IC95% Poisson
interval_table <- function(cuts_days, labels){
  t_event <- excel_0417$`_t`
  status  <- excel_0417$event_type
  total_rec <- sum(status == 1, na.rm = TRUE)
  
  out <- lapply(seq_along(labels), function(i){
    a <- cuts_days[i]; b <- cuts_days[i+1]
    # pessoa-tempo no intervalo: min(t, b) - a, truncado em 0
    time_days <- pmax(0, pmin(t_event, b) - a)
    py <- sum(time_days/365, na.rm = TRUE)
    # eventos dentro de (a, b]
    nevent <- sum(status == 1 & t_event > a & t_event <= b, na.rm = TRUE)
    # taxa e IC exato de Poisson
    rate  <- if(py > 0) nevent/py * 1000 else NA_real_
    lower <- if(nevent > 0) qchisq(0.025, 2*nevent)/(2*py)*1000 else 0
    upper <- if(nevent > 0) qchisq(0.975, 2*(nevent+1))/(2*py)*1000 else NA_real_
    data.frame(
      interval = labels[i],
      PY = py,
      n = nevent,
      rate = rate,
      lower = lower,
      upper = upper,
      pct_all = nevent/total_rec*100,
      stringsAsFactors = FALSE
    )
  })
  bind_rows(out)
}

# ΔCIF por janela (p.p.) com Fine–Gray
delta_cif_by_window <- function(cuts_days){
  ci <- cmprsk::cuminc(ftime = excel_0417$time_years,
                       fstatus = excel_0417$event_type, cencode = 0)
  nm <- if ("1 1" %in% names(ci)) "1 1" else "1"
  ci_rec <- ci[[nm]]
  F_at <- function(t_years){
    approx(x = ci_rec$time, y = ci_rec$est,
           xout = t_years, method = "constant", f = 0, rule = 2)$y
  }
  left  <- head(cuts_days, -1) / 365
  right <- tail(cuts_days, -1) / 365
  dCIF  <- (F_at(right) - F_at(left)) * 100
  list(delta = dCIF, ci_obj = ci_rec)
}

# ---------- Construir dados para plots ----------
tab <- interval_table(cuts_days, labels_int)
dc  <- delta_cif_by_window(cuts_days)
tab$delta_cif <- dc$delta
# Ordenar fator na ordem desejada
tab$interval <- factor(tab$interval, levels = labels_int)

# Linha total (para referência, não será usada nos gráficos por intervalo)
total_row <- data.frame(
  interval = factor("Total", levels = c(levels(tab$interval), "Total")),
  PY = sum(tab$PY), n = sum(tab$n),
  rate = sum(tab$n)/sum(tab$PY)*1000,
  lower = NA_real_, upper = NA_real_,
  pct_all = 100, delta_cif = sum(tab$delta_cif)
)

# ---------- PLOT (A): Barras de taxa com IC95% ----------
tab_plot <- tab %>%
  mutate(rate_lab = sprintf("%.1f", round(rate,1)))

p_rate <- ggplot(tab_plot, aes(x = interval, y = rate)) +
  geom_col(width = 0.7) +
  geom_errorbar(aes(ymin = lower, ymax = upper), width = 0.15) +
  geom_text(aes(label = rate_lab), vjust = -0.6, size = 3.5) +
  labs(x = "Time since cure (interval)",
       y = "Incidence rate (/1,000 PY)",
       title = "A. Interval-specific incidence of first TB recurrence",
       subtitle = "Bars show rate; whiskers show 95% Poisson CI") +
  coord_cartesian(ylim = c(0, max(tab_plot$upper, na.rm = TRUE)*1.15)) +
  theme_minimal(base_size = 12)

# ---------- PLOT (B): Curva CIF (Fine–Gray) com marcadores de cortes ----------
# Dados da CIF ao longo do tempo (anos)
cif_df <- data.frame(
  time_years = dc$ci_obj$time,
  cif_pct    = dc$ci_obj$est * 100
)

# Pontos nos limites direitos de cada janela
cut_right_years <- tail(cuts_days, -1) / 365
marks <- data.frame(
  x = cut_right_years,
  y = approx(cif_df$time_years, cif_df$cif_pct,
             xout = cut_right_years, method = "constant", f = 0, rule = 2)$y,
  lab = paste0("+", sprintf("%.2f", round(tab$delta_cif,2)), " p.p."),
  interval = labels_int
)

p_cif <- ggplot(cif_df, aes(x = time_years, y = cif_pct)) +
  geom_step(linewidth = 0.9) +
  geom_point(data = marks, aes(x = x, y = y), size = 2) +
  ggrepel::geom_label_repel(
    data = marks,
    aes(x = x, y = y, label = lab),
    size = 3, label.size = 0.2, min.segment.length = 0.1,
    box.padding = 0.25, max.overlaps = Inf
  ) +
  labs(x = "Years since cure",
       y = "Cumulative incidence of first TB recurrence (%)",
       title = "B. Fine–Gray cumulative incidence curve",
       subtitle = "Labels indicate ΔCIF within each interval") +
  theme_minimal(base_size = 12)

# ---------- Figura combinada (A sobre B) ----------
if ("package:patchwork" %in% search() || require(patchwork, quietly = TRUE)) {
  fig_combined <- p_rate / p_cif + plot_layout(heights = c(1, 1.1)) +
    plot_annotation(title = "First TB recurrence: interval rates and cumulative incidence")
  print(fig_combined)
} else {
  # Se patchwork não estiver disponível, imprime separadas:
  print(p_rate); print(p_cif)
}

# ---------- (Opcional) salvar em arquivo ----------
ggsave("figure_interval_rates.png", p_rate, width = 7, height = 4.5, dpi = 300)
ggsave("figure_cif_curve.png", p_cif, width = 7, height = 4.5, dpi = 300)
if (exists("fig_combined")) ggsave("figure_combined.png", fig_combined, width = 7, height = 8.5, dpi = 300)


