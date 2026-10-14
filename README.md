# Tratamento materno adequado em gestantes diagnosticadas no pré-natal — sífilis congênita, Piauí, 2015–2025

Análise descritiva e de tendência da proporção de **tratamento materno adequado** entre mães com sífilis diagnosticada **durante o pré-natal**, a partir de casos notificados de sífilis congênita no Piauí (SINAN/DATASUS).

## Pergunta
Entre as gestantes que tiveram a sífilis diagnosticada no pré-natal e cujo filho foi notificado com sífilis congênita, qual a proporção que recebeu tratamento adequado e como essa proporção evoluiu entre 2015 e 2024?

## Fonte e população
- **Fonte:** Sistema de Informação de Agravos de Notificação (SINAN), via DATASUS (arquivos `SIFC`, pasta PRELIM do FTP).
- **População:** casos notificados de sífilis congênita em residentes do Piauí, de 2015 a julho de 2025 (n = 3.812).
- **Recorte da análise:** mães com diagnóstico durante o pré-natal (`ANTSIFIL_N` = 1) e esquema de tratamento válido (`TRA_ESQUEM` = 1, 2 ou 3), n = 1.614.
- **Data do download:** `13-10-2026` *(a base PRELIM é atualizada ao longo do tempo)*.

## Definições
- **Tratamento adequado** (`TRA_ESQUEM` = 1): tratamento completo com penicilina benzatina, em doses adequadas ao estágio clínico da sífilis, com início até 30 dias antes do parto (critério do Ministério da Saúde).
- **Não adequado:** tratamento inadequado (2) ou não realizado (3). Ausentes e ignorados foram excluídos.
- **Ano:** ano de notificação. 2025 é parcial (até julho) e fica fora do teste de tendência.

## Métodos
- Proporção anual de tratamento adequado com IC 95% de Wilson.
- **Tendência:** regressão logística binomial agrupada por ano (adequado × não adequado), com ano como variável numérica, 2015–2024. Resultado expresso em odds ratio por ano.
- **Sensibilidade:** Mann-Kendall e inclinação de Sen sobre os percentuais anuais (ignoram o tamanho de cada ano, por isso têm menos poder).

## Principais resultados
Entre as gestantes diagnosticadas durante o pré-natal, **5,9%** receberam tratamento adequado. A proporção aumentou ao longo do período, de 1,9% em 2015 para 7,1% em 2024, com pico de 10,7% em 2019. A regressão logística indicou tendência de aumento: **OR = 1,08 por ano (IC 95% 1,01–1,16; p = 0,019)**.

| Ano | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 |
|---|---|---|---|---|---|---|---|---|---|---|
| % adequado | 1,9 | 2,4 | 4,4 | 6,2 | 10,7 | 8,2 | 4,7 | 8,0 | 5,4 | 7,1 |

Na análise de sensibilidade sobre os percentuais anuais, o teste de Mann-Kendall **não foi significativo** (τ = 0,42; p = 0,108), com inclinação de Sen de +0,47 ponto percentual por ano. Esse teste não considera o número de casos de cada ano, o que explica a diferença para a regressão logística.

## Interpretação
Entre as mães diagnosticadas ainda no pré-natal, cujos filhos mesmo assim foram notificados com sífilis congênita, a grande maioria não teve tratamento adequado. Isso sugere falhas entre o diagnóstico e a conclusão do tratamento no acompanhamento pré-natal, embora o aumento de 1,9% para 7,1% mostre melhora gradual. Os dados não permitem identificar a causa (início tardio, esquema incompleto, entre outras).

## Estrutura do repositório

```
R/                      scripts numerados, executar na ordem
  00_download.R         baixa e empilha os arquivos SIFC (2015–2025)
  01_tabela_momento.R   tratamento materno por momento do diagnóstico (contexto)
  02_tendencia.R        % adequado por ano, IC 95% e testes de tendência
  03_graficos.R         gráficos a partir das tabelas agregadas
  04_mapa_municipios.R  casos por município de residência (contexto)
data/processed/         tabelas agregadas (CSV)
figures/                figuras geradas pelos scripts
docs/                   documentação adicional
```

Os microdados (`data/raw/`) **não são versionados** (`.gitignore`), por conterem campos potencialmente identificáveis.

## Como reproduzir
Execute a partir da raiz do repositório: `00` → `01` → `02` → `04` → `03`.
Pacotes: `RCurl`, `read.dbc`, `dplyr`, `tidyr`, `purrr`, `stringr`, `gt`, `Kendall`, `trend`, `ggplot2`, `scales`, `sf`, `ggrepel`, `jsonlite`.

## Tabelas
| Arquivo | Conteúdo |
|---|---|
| `tratamento_adequado_por_ano.csv` | Principal. % adequado por ano entre gestantes diagnosticadas no pré-natal, com contagens e IC 95% (Wilson). |
| `adequacao_por_momento.csv` | Contexto. Tratamento materno por momento do diagnóstico (pré-natal, parto/curetagem, após o parto). |
| `casos_por_municipio.csv` | Contexto. Casos por município de residência, em números absolutos. |

## Limitações
- A análise considera casos notificados de sífilis congênita, não todas as gestantes com sífilis.
- Registros ausentes ou ignorados foram excluídos.
