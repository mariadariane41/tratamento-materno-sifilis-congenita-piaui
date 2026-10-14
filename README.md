# Dados

## Fonte
Sistema de Informação de Agravos de Notificação (SINAN), disponibilizado pelo DATASUS: casos notificados de **sífilis congênita** em residentes do Piauí, de 2015 a julho de 2025 (n = 3.812).

## O que está neste repositório
Apenas **tabelas agregadas** em `processed/`, extraídas dos resultados do trabalho. Os microdados do SINAN não estão aqui.

| Arquivo | Conteúdo |
|---|---|
| `adequacao_por_momento.csv` | Tratamento materno (adequado, inadequado, não realizado) por momento do diagnóstico. Ausentes e ignorados excluídos. |
| `tratamento_adequado_por_ano.csv` | % de tratamento adequado por ano de notificação, entre gestantes diagnosticadas durante o pré-natal (2015–2024), com contagens e IC 95% (Wilson). Gerado por `R/02_tendencia.R`. |
| `casos_por_municipio.csv` | Casos por município de residência (2015–2025), todos os municípios. Números absolutos, sem ajuste por população. Gerado por `R/04_mapa_municipios.R`. |

## Definição de tratamento adequado
Campo `TRA_ESQUEM` (esquema de tratamento materno), conforme o Dicionário de Dados SINAN NET v5.0: tratamento realizado de acordo com o esquema preconizado para a fase clínica da sífilis, iniciado a mais de 30 dias antes do parto, com títulos que baixaram como esperado ou permaneceram baixos e parceiro tratado concomitantemente à gestante.

Momento do diagnóstico: campo `ANTSIFIL_N` (1 = pré-natal, 2 = parto/curetagem, 3 = após o parto).

## Como obter os dados brutos
Execute `R/00_download.R`. O script lista a pasta PRELIM do FTP do DataSUS, baixa os arquivos de sífilis congênita (prefixo `SIFC`) de 2015 a 2025, empilha e salva em `data/raw/sifilis_congenita_2015_2025.rds`.

A pasta `data/raw/` está no `.gitignore`: os microdados **não** são versionados.
