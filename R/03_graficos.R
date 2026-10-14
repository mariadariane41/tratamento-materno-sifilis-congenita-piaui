# Gráficos do trabalho a partir das tabelas agregadas
# install.packages(c("ggplot2", "tidyr", "dplyr", "scales"))
library(ggplot2)
library(tidyr)
library(dplyr)

dir.create("figures", showWarnings = FALSE)

# 1) Tendência anual
ano <- read.csv("data/processed/tratamento_adequado_por_ano.csv")
g1 <- ggplot(ano, aes(ano, pct_adequado)) +
  geom_line(color = "#0e7c6b", linewidth = 1) +
  geom_point(color = "#0e7c6b", size = 2.5) +
  geom_text(aes(label = paste0(format(pct_adequado, decimal.mark = ","), "%")),
            vjust = -1, size = 3) +
  scale_x_continuous(breaks = ano$ano) +
  scale_y_continuous(limits = c(0, 12)) +
  labs(x = "Ano de notificação", y = "Tratamento adequado (%)",
       title = "Tratamento adequado entre gestantes diagnosticadas no pré-natal",
       caption = "Fonte: SINAN/DataSUS") +
  theme_minimal()
ggsave("figures/tendencia_anual.png", g1, width = 8, height = 4.5, dpi = 200)

# 2) Adequação por momento do diagnóstico
mom <- read.csv("data/processed/adequacao_por_momento.csv") |>
  select(-total) |>
  pivot_longer(-momento, names_to = "tratamento", values_to = "n")
g2 <- ggplot(mom, aes(momento, n, fill = tratamento)) +
  geom_col(position = "fill") +
  coord_flip() +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_manual(values = c(adequado = "#0e7c6b", inadequado = "#b3261e",
                               nao_realizado = "#aab6bb")) +
  labs(x = NULL, y = "Proporção", fill = NULL, caption = "Fonte: SINAN/DataSUS") +
  theme_minimal()
ggsave("figures/adequacao_por_momento.png", g2, width = 8, height = 3.5, dpi = 200)

# 3) Municípios com mais casos
mun <- read.csv("data/processed/casos_por_municipio.csv") |>
  slice_max(casos, n = 6, with_ties = FALSE)
g3 <- ggplot(mun, aes(reorder(municipio, casos), casos)) +
  geom_col(fill = "#b3261e") +
  coord_flip() +
  labs(x = NULL, y = "Casos (2015-2025)",
       caption = "Números absolutos, sem ajuste por população. Fonte: SINAN/DataSUS") +
  theme_minimal()
ggsave("figures/casos_por_municipio.png", g3, width = 7, height = 3.5, dpi = 200)
