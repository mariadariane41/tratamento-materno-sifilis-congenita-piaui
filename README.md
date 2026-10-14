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

O teste de Mann-K
