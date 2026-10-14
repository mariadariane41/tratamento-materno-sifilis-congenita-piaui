# Análise do Tratamento Materno da Sífilis em Casos de Sífilis Congênita no Piauí (2015–2025)

## Sobre o projeto

Este projeto analisa a adequação do tratamento materno nos casos notificados de sífilis congênita no estado do Piauí, utilizando dados do Sistema de Informação de Agravos de Notificação (SINAN), disponibilizados pelo DATASUS.

O estudo investiga se o diagnóstico da sífilis durante o pré-natal é acompanhado pela realização do tratamento materno adequado, além de analisar a evolução temporal dessa proporção.

A pesquisa foi desenvolvida em R, aplicando métodos estatísticos descritivos e não paramétricos.

## Objetivo

Analisar a adequação do tratamento materno segundo o momento do diagnóstico e investigar a tendência temporal da proporção de tratamentos adequados entre as mães diagnosticadas durante o pré-natal.

## Fonte dos dados

- **Fonte:** SINAN/DATASUS
- **Abrangência geográfica:** Piauí
- **Período geral:** 2015–2025
- **Período da análise temporal:** 2015–2024
- **Tipo de estudo:** observacional, retrospectivo, descritivo e quantitativo

Os dados correspondem a notificações de casos de sífilis congênita, não à totalidade das gestantes com sífilis no estado.

## Metodologia

### 1. Tratamento e organização dos dados

Os dados foram importados e organizados utilizando R. Foram selecionadas variáveis relacionadas ao ano da notificação, ao momento do diagnóstico materno e à classificação do tratamento.

Os registros ignorados ou sem informação válida foram tratados conforme os critérios definidos para cada análise.

### 2. Análise descritiva

Foram calculadas frequências absolutas e relativas dos tratamentos adequados, inadequados e não realizados, segundo o momento do diagnóstico materno.

Essa etapa permitiu descrever a distribuição do tratamento nos registros analisados.

### 3. Análise da tendência temporal

A análise temporal considerou os anos de 2015 a 2024 e as mães cujo diagnóstico foi registrado durante o pré-natal. O ano de 2025 foi excluído dessa etapa por poder apresentar dados incompletos.

Para cada ano, calculou-se a proporção de tratamentos adequados entre os registros válidos de tratamento.

#### Teste de Mann-Kendall

O teste não paramétrico de Mann-Kendall foi utilizado para avaliar a existência de uma tendência monotônica nos percentuais anuais de tratamento adequado.

- **Hipótese nula (H₀):** não há evidência de tendência monotônica.
- **Hipótese alternativa (H₁):** existe uma tendência monotônica.

Foi adotado nível de significância de 5%.

#### Inclinação de Sen

A inclinação de Sen foi utilizada para estimar a direção e a magnitude da tendência temporal, expressa em pontos percentuais por ano.

O teste de Mann-Kendall avalia a evidência estatística de tendência, enquanto a inclinação de Sen estima a variação anual típica da série.

## Resultados

### Tratamento materno segundo o momento do diagnóstico

A análise descritiva identificou elevada frequência de tratamento inadequado ou não realizado nos registros de sífilis congênita analisados.

Entre as mães diagnosticadas durante o pré-natal, 5,9% receberam tratamento adequado na análise descritiva correspondente.

Esse resultado evidencia que o diagnóstico durante o pré-natal não garante, por si só, a realização do tratamento materno adequado.

### Evolução temporal do tratamento adequado

Os percentuais anuais de tratamento adequado entre as mães diagnosticadas durante o pré-natal foram:

| Ano | Tratamento adequado |
|---|---:|
| 2015 | 1,9% |
| 2016 | 2,4% |
| 2017 | 4,4% |
| 2018 | 6,2% |
| 2019 | 10,7% |
| 2020 | 8,2% |
| 2021 | 4,7% |
| 2022 | 8,0% |
| 2023 | 5,4% |
| 2024 | 7,1% |

Os percentuais apresentaram oscilações ao longo do período, com pico de 10,7% em 2019.

### Resultados dos testes de tendência

- **Mann-Kendall:** τ = 0,42
- **Valor de p:** 0,108
- **Inclinação de Sen:** +0,47 ponto percentual por ano
- **Nível de significância:** 5%

O teste de Mann-Kendall não identificou evidência estatística suficiente de tendência monotônica, pois o valor de p foi superior a 0,05.

A inclinação de Sen foi positiva, indicando aumento estimado de 0,47 ponto percentual por ano. Entretanto, essa estimativa não comprova, isoladamente, uma melhora estatisticamente significativa.

## Discussão

A elevada frequência de tratamentos inadequados ou não realizados entre os casos analisados aponta para uma questão relevante de saúde pública.

Embora o diagnóstico durante o pré-natal represente uma oportunidade para o tratamento oportuno, os resultados mostram que sua realização adequada não está garantida nos registros estudados.

A evolução temporal apresentou oscilações, e o teste de Mann-Kendall não encontrou evidência estatística suficiente de tendência monotônica ao nível de significância de 5%.

Os achados reforçam a importância de investigar fatores que possam dificultar a efetivação do tratamento adequado durante o acompanhamento pré-natal.

## Limitações

- A base contempla notificações de casos de sífilis congênita, não todas as gestantes com sífilis.
- A qualidade dos resultados depende da completude e da consistência das informações registradas.
- Os dados de 2025 podem ser parciais.
- Os percentuais anuais podem apresentar diferentes níveis de precisão devido aos diferentes tamanhos amostrais.
- O teste de Mann-Kendall aplicado aos percentuais anuais não considera diretamente o número de registros de cada ano.
- Os resultados não identificam as causas do tratamento inadequado ou não realizado e não permitem estabelecer relações causais.

## Tecnologias utilizadas

- **R:** tratamento, análise estatística e visualização dos dados.
- **tidyverse e dplyr:** manipulação de dados.
- **ggplot2:** elaboração de gráficos.
- **Kendall e trend:** análise de tendência temporal.
- **Git e GitHub:** versionamento e documentação do projeto.

## Estrutura do repositório

- `00_download.R`: obtenção dos dados.
- `01_tabela_momento.R`: análise do tratamento segundo o momento do diagnóstico.
- `02_tendencia.R`: análise temporal com Mann-Kendall e inclinação de Sen.
- `03_graficos.R`: elaboração das visualizações.
- `04_mapa_municipios.R`: visualização da distribuição municipal.
- `README.md`: documentação do projeto.

Os nomes e caminhos devem corresponder aos arquivos efetivamente disponíveis no repositório.

## Reprodutibilidade e privacidade

O repositório prioriza a divulgação de scripts, visualizações e resultados agregados. Os microdados não são disponibilizados no projeto.

A reprodução da análise depende da obtenção dos dados de fonte oficial e da execução dos scripts com os pacotes necessários.

## Conclusão

A análise identificou elevada frequência de tratamento materno inadequado ou não realizado nos casos notificados de sífilis congênita no Piauí.

Entre as mães diagnosticadas durante o pré-natal, os percentuais anuais de tratamento adequado oscilaram de 2015 a 2024. A inclinação de Sen indicou aumento estimado de 0,47 ponto percentual por ano, mas o teste de Mann-Kendall não apresentou evidência estatística suficiente de tendência monotônica ao nível de significância de 5%.

Os resultados reforçam a necessidade de investigar os fatores que dificultam a realização do tratamento materno adequado após o diagnóstico durante o pré-natal.

## Referências

- Ministério da Saúde — DATASUS.
- Sistema de Informação de Agravos de Notificação (SINAN).
- Ministério da Saúde — documentação e dicionário de dados de sífilis congênita.

---

*Projeto acadêmico de análise estatística aplicada à saúde pública.*
