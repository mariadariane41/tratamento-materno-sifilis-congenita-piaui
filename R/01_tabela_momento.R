# Tabela 1: adequação do tratamento da sífilis materna por momento do diagnóstico
# Entrada: objeto `sifilis_pi` (casos de sífilis congênita, residentes no Piauí)
# Saídas: data/processed/adequacao_por_momento.csv e figures/tabela_momento.png

# install.packages(c("dplyr", "tidyr", "gt"))
library(dplyr)
library(tidyr)
library(gt)

# ------------------------------------------------------------
# 0) Colunas (nomes DBF do Dicionário de Dados SINAN NET v5.0, sífilis congênita)
#    ANTSIFIL_N = campo 39, Diagnóstico de sífilis materna (momento)
#    TRA_ESQUEM = campo 44, Esquema de tratamento materno
#    Confira com names(sifilis_pi) se os nomes estão iguais na sua base.
# ------------------------------------------------------------
col_momento    <- "ANTSIFIL_N"
col_tratamento <- "TRA_ESQUEM"

# Códigos (conforme o dicionário):
#   ANTSIFIL_N: 1 = durante o pré-natal | 2 = no momento do parto/curetagem |
#               3 = após o parto | 4 = não realizado | 9 = ignorado
#   TRA_ESQUEM: 1 = adequado | 2 = inadequado | 3 = não realizado | 9 = ignorado

# Se `sifilis_pi` ainda não existe, crie a partir da base nacional baixada
# (o arquivo SIFCBR cobre o Brasil todo; Piauí = código IBGE 22).
# ID_MN_RESI (município de residência) faz parte dos campos iniciais da ficha,
# que não estão neste dicionário: confira o nome com names(base).
if (!exists("sifilis_pi")) {
  base <- readRDS("data/raw/sifilis_congenita_2015_2025.rds")
  sifilis_pi <- base %>% filter(substr(as.character(ID_MN_RESI), 1, 2) == "22")
}

# ------------------------------------------------------------
# 1) Classificar e excluir ausentes/ignorados
# ------------------------------------------------------------
niveis_momento <- c("Durante o pré-natal", "Durante o parto/curetagem", "Após o parto")

dados <- sifilis_pi %>%
  transmute(
    momento = case_when(
      as.character(.data[[col_momento]]) == "1" ~ "Durante o pré-natal",
      as.character(.data[[col_momento]]) == "2" ~ "Durante o parto/curetagem",
      as.character(.data[[col_momento]]) == "3" ~ "Após o parto"
    ),
    tratamento = case_when(
      as.character(.data[[col_tratamento]]) == "1" ~ "Adequado",
      as.character(.data[[col_tratamento]]) == "2" ~ "Inadequado",
      as.character(.data[[col_tratamento]]) == "3" ~ "Não realizado"
    )
  ) %>%
  filter(!is.na(momento), !is.na(tratamento))   # exclui ausentes e ignorados

# ------------------------------------------------------------
# 2) Contagens e total por momento
# ------------------------------------------------------------
tab <- dados %>%
  count(momento, tratamento) %>%
  complete(momento = niveis_momento,
           tratamento = c("Adequado", "Inadequado", "Não realizado"),
           fill = list(n = 0)) %>%
  pivot_wider(names_from = tratamento, values_from = n) %>%
  mutate(Total = Adequado + Inadequado + `Não realizado`,
         momento = factor(momento, levels = niveis_momento)) %>%
  arrange(momento)

print(tab)   # confira: pré-natal deve dar 97 / 1265 / 265 / 1627

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("figures", showWarnings = FALSE)
write.csv(
  tab %>% rename(nao_realizado = `Não realizado`) %>%
    rename_with(tolower) %>% mutate(momento = as.character(momento)),
  "data/processed/adequacao_por_momento.csv", row.names = FALSE
)

# ------------------------------------------------------------
# 3) Tabela formatada "n (%)", percentuais dentro de cada momento
# ------------------------------------------------------------
tab_fmt <- tab %>%
  mutate(across(c(Adequado, Inadequado, `Não realizado`),
                ~ sprintf("%d (%.1f%%)", .x, .x / Total * 100)))

tabela <- gt(tab_fmt) %>%
  cols_label(momento = "Momento do diagnóstico") %>%
  cols_align(align = "center", columns = -momento) %>%
  tab_style(style = cell_text(weight = "bold"),
            locations = cells_column_labels()) %>%
  tab_style(style = cell_text(weight = "bold"),
            locations = cells_body(columns = Adequado)) %>%
  tab_style(style = cell_fill(color = "#E8EEF8"),
            locations = cells_body(columns = c(Adequado, Inadequado, `Não realizado`))) %>%
  tab_options(column_labels.background.color = "#DCE6F2") %>%
  tab_source_note("Percentuais calculados dentro de cada momento do diagnóstico.")

tabela

# Salvar como imagem (precisa do pacote webshot2: install.packages("webshot2"))
gtsave(tabela, "figures/tabela_momento.png", vwidth = 1100)
