# Tendência do tratamento adequado (Mann-Kendall e inclinação de Sen)
# Calcula a tabela anual a partir da base e salva em data/processed/
# Gestantes diagnosticadas durante o pré-natal, por ano de notificação, 2015-2024
# (2025 fica de fora por ser ano incompleto)

# install.packages(c("dplyr", "Kendall", "trend"))
library(dplyr)
library(Kendall)
library(trend)

col_momento    <- "ANTSIFIL_N"   # momento do diagnóstico (1 = durante o pré-natal)
col_tratamento <- "TRA_ESQUEM"   # 1 = adequado | 2 = inadequado | 3 = não realizado | 9 = ignorado

if (!exists("sifilis_pi")) {
  base <- readRDS("data/raw/sifilis_congenita_2015_2025.rds")
  sifilis_pi <- base %>% filter(substr(as.character(ID_MN_RESI), 1, 2) == "22")
}

# Ano de notificação: NU_ANO, ou o ano de DT_NOTIFIC se NU_ANO não existir
ano_notif <- if ("NU_ANO" %in% names(sifilis_pi)) {
  as.integer(as.character(sifilis_pi$NU_ANO))
} else {
  as.integer(format(as.Date(sifilis_pi$DT_NOTIFIC), "%Y"))
}

# 1) Tabela anual: % de tratamento adequado (exclui ausentes e ignorados)
dados <- sifilis_pi %>%
  mutate(ano = ano_notif,
         momento = as.character(.data[[col_momento]]),
         trat    = as.character(.data[[col_tratamento]])) %>%
  filter(momento == "1", trat %in% c("1", "2", "3"), ano %in% 2015:2024) %>%
  group_by(ano) %>%
  summarise(n_total = n(), n_adequado = sum(trat == "1"), .groups = "drop") %>%
  mutate(pct_adequado = round(n_adequado / n_total * 100, 1))

# IC 95% (Wilson) para cada ano
ic <- mapply(function(x, n) prop.test(x, n, correct = FALSE)$conf.int * 100,
             dados$n_adequado, dados$n_total)
dados$ic_inf <- round(ic[1, ], 1)
dados$ic_sup <- round(ic[2, ], 1)

print(as.data.frame(dados))   # esperado: 1,9 (2015) ... 7,1 (2024)

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
write.csv(dados %>% select(ano, pct_adequado, n_adequado, n_total, ic_inf, ic_sup),
          "data/processed/tratamento_adequado_por_ano.csv", row.names = FALSE)

# 2) Testes de tendência
mk   <- MannKendall(dados$pct_adequado)
sens <- sens.slope(dados$pct_adequado)

cat("Mann-Kendall: tau =", round(as.numeric(mk$tau), 2),
    "| p =", round(as.numeric(mk$sl), 3), "\n")
cat("Inclinação de Sen:", round(as.numeric(sens$estimates), 2),
    "ponto percentual por ano\n")
# Esperado: tau = 0,42; p ≈ 0,11; Sen = +0,47 p.p./ano
