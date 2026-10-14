# Mapa de casos de sífilis congênita por município de residência, Piauí, 2015-2025
# Entrada: `sifilis_pi` (casos com residência no PI) ou a base bruta em data/raw/
# Saída: figures/mapa_casos_municipio.png

# install.packages(c("dplyr", "sf", "ggplot2", "ggrepel", "jsonlite"))
library(dplyr)
library(sf)
library(ggplot2)
library(ggrepel)
library(jsonlite)

if (!exists("sifilis_pi")) {
  base <- readRDS("data/raw/sifilis_congenita_2015_2025.rds")
  sifilis_pi <- base %>% filter(substr(as.character(ID_MN_RESI), 1, 2) == "22")
}

# 1) Casos por município de residência (código IBGE de 6 dígitos no SINAN)
casos <- sifilis_pi %>%
  mutate(cod6 = substr(as.character(ID_MN_RESI), 1, 6)) %>%
  count(cod6, name = "casos")

# 2) Malha municipal do Piauí: baixa automaticamente do IBGE
options(timeout = 300)

baixar_malha_pi <- function() {
  # Opção 1: API de malhas do IBGE (GeoJSON) + API de localidades (nomes)
  malha <- tryCatch({
    url <- paste0("https://servicodados.ibge.gov.br/api/v3/malhas/estados/22",
                  "?formato=application/vnd.geo+json&qualidade=minima",
                  "&intrarregiao=municipio")
    arq <- tempfile(fileext = ".geojson")
    download.file(url, arq, mode = "wb", quiet = TRUE)
    m <- sf::st_read(arq, quiet = TRUE) %>% sf::st_make_valid()
    nomes <- fromJSON("https://servicodados.ibge.gov.br/api/v1/localidades/estados/22/municipios")
    nomes <- data.frame(codarea = as.character(nomes$id), name_muni = nomes$nome)
    m %>%
      mutate(codarea = as.character(codarea)) %>%
      left_join(nomes, by = "codarea") %>%
      mutate(cod6 = substr(codarea, 1, 6))
  }, error = function(e) {
    message("API do IBGE falhou (", conditionMessage(e), "). Tentando o shapefile do FTP...")
    NULL
  })
  if (!is.null(malha)) return(malha)

  # Opção 2: shapefile zipado no servidor de arquivos do IBGE
  url_zip <- paste0("https://geoftp.ibge.gov.br/organizacao_do_territorio/",
                    "malhas_territoriais/malhas_municipais/municipio_2022/UFs/PI/",
                    "PI_Municipios_2022.zip")
  zip_local <- tempfile(fileext = ".zip")
  download.file(url_zip, zip_local, mode = "wb", quiet = TRUE)
  pasta <- file.path(tempdir(), "malha_pi")
  unzip(zip_local, exdir = pasta)
  shp <- list.files(pasta, pattern = "\\.shp$", full.names = TRUE, recursive = TRUE)[1]
  sf::st_read(shp, quiet = TRUE) %>%
    sf::st_make_valid() %>%
    mutate(cod6 = substr(as.character(CD_MUN), 1, 6), name_muni = NM_MUN)
}

malha <- baixar_malha_pi()

mapa <- malha %>%
  left_join(casos, by = "cod6") %>%
  mutate(
    casos  = coalesce(casos, 0L),
    classe = cut(casos,
                 breaks = c(-Inf, 0, 5, 10, 20, 50, 100, Inf),
                 labels = c("0", "1–5", "6–10", "11–20", "21–50", "51–100", ">100"))
  )

# Salva a tabela de casos por município (todos os municípios)
dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
mapa %>%
  st_drop_geometry() %>%
  select(municipio = name_muni, cod_ibge6 = cod6, casos) %>%
  arrange(desc(casos)) %>%
  write.csv("data/processed/casos_por_municipio.csv", row.names = FALSE)

# 3) Rótulos: 6 municípios com mais casos
rotulos <- mapa %>%
  slice_max(casos, n = 6, with_ties = FALSE) %>%
  mutate(rotulo = paste0(name_muni, " (", casos, ")"))
pts <- suppressWarnings(st_point_on_surface(rotulos))
rotulos <- bind_cols(rotulos, as.data.frame(st_coordinates(pts)))

cores <- c("0" = "#F2F2F2", "1–5" = "#FEEDC0", "6–10" = "#FDD380",
           "11–20" = "#FBA54E", "21–50" = "#F06C2E",
           "51–100" = "#C6381B", ">100" = "#7A0C13")

# 4) Gráfico
g <- ggplot(mapa) +
  geom_sf(aes(fill = classe), color = "grey50", linewidth = 0.1) +
  geom_label_repel(
    data = st_drop_geometry(rotulos),
    aes(x = X, y = Y, label = rotulo),
    nudge_x = 3, direction = "y", hjust = 0,
    segment.size = 0.3, min.segment.length = 0,
    size = 4, label.size = 0.25, label.padding = 0.2
  ) +
  scale_fill_manual(values = cores, drop = FALSE, name = "Casos\n(2015–2025)") +
  scale_x_continuous(expand = expansion(mult = c(0.02, 0.55))) +
  labs(
    title = "Sífilis congênita no Piauí, 2015–2025",
    subtitle = "Casos por município de residência",
    caption = paste0("n = ", nrow(sifilis_pi), " casos com residência no PI. Fonte: SINAN/DataSUS.")
  ) +
  theme_void(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 22),
    plot.caption = element_text(color = "grey40", hjust = 1),
    legend.position = c(0.85, 0.25),
    legend.title = element_text(face = "bold"),
    plot.margin = margin(10, 10, 10, 10)
  )

dir.create("figures", showWarnings = FALSE)
ggsave("figures/mapa_casos_municipio.png", g, width = 9, height = 9, dpi = 300, bg = "white")
