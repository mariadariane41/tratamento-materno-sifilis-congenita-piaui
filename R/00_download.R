# Download dos dados de sífilis congênita (SINAN/DataSUS), 2015-2025
# Saída: data/raw/sifilis_congenita_2015_2025.rds (ignorado pelo Git: microdados)
# Execute a partir da raiz do repositório.

pacotes <- c("RCurl", "read.dbc", "dplyr", "purrr", "stringr")
instalar <- pacotes[!pacotes %in% installed.packages()[, "Package"]]
if (length(instalar) > 0) install.packages(instalar)

library(RCurl)
library(read.dbc)
library(dplyr)
library(purrr)
library(stringr)

anos <- 2015:2025
sufixos_ano <- sprintf("%02d", anos %% 100)  # "15", "16", ..., "25"
pasta_prelim <- "ftp://ftp.datasus.gov.br/dissemin/publicos/SINAN/DADOS/PRELIM/"

# 1) Listar os arquivos disponíveis no FTP
arqs <- tryCatch(
  strsplit(getURL(pasta_prelim, dirlistonly = TRUE, ftp.use.epsv = FALSE), "\r\n")[[1]],
  error = function(e) character(0)
)
arqs <- arqs[arqs != ""]
if (length(arqs) == 0) {
  stop("Não foi possível listar a pasta PRELIM. Verifique a conexão com o FTP do DataSUS.")
}

# Arquivos de sífilis congênita começam com "SIFC" (ex.: SIFCBR15.dbc)
candidatos <- tibble(arquivo = arqs[str_detect(arqs, regex("^SIFC", ignore_case = TRUE))]) %>%
  mutate(sufixo_ano = str_extract(arquivo, "\\d{2}(?=\\.dbc$)")) %>%
  filter(sufixo_ano %in% sufixos_ano) %>%
  distinct(sufixo_ano, .keep_all = TRUE) %>%
  arrange(sufixo_ano)

print(candidatos)  # confira os nomes antes de baixar

anos_faltando <- setdiff(sufixos_ano, candidatos$sufixo_ano)
if (length(anos_faltando) > 0) {
  message("Anos sem arquivo encontrado (pode ser ano ainda não publicado): 20",
          paste(anos_faltando, collapse = ", 20"))
}

# 2) Baixar e ler cada .dbc
baixar_ler_dbc <- function(arquivo) {
  destino <- file.path(tempdir(), arquivo)
  message("Baixando: ", arquivo)
  download.file(paste0(pasta_prelim, arquivo), destino, mode = "wb", quiet = TRUE)
  read.dbc(destino)
}
bases <- map(candidatos$arquivo, baixar_ler_dbc)

# 3) Empilhar (bind_rows lida com colunas que mudam entre anos)
sifilis_congenita <- bind_rows(bases, .id = "arquivo_origem")
dim(sifilis_congenita)

# 4) Salvar para não precisar baixar de novo
dir.create("data/raw", recursive = TRUE, showWarnings = FALSE)
saveRDS(sifilis_congenita, "data/raw/sifilis_congenita_2015_2025.rds")
