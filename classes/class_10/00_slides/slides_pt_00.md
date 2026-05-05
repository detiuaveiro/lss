---
title: Análise, Visualização e Comunicação de Dados
subtitle: Laboratórios de Sistemas e Serviços
author: Mário Antunes
institute: Universidade de Aveiro
date: 2026
colorlinks: true
highlight-style: tango
toc: true
toc-title: "Índice"
mainfont: Noto Sans
sansfont: Noto Sans
monofont: Noto Sans Mono
header-includes:
 - \usetheme[sectionpage=progressbar,numbering=fraction,progressbar=frametitle]{metropolis}
---

# Dos Dados ao Conhecimento

## A jornada dos dados brutos ao conhecimento acionável.

* **Dados:** Factos ou observações discretas e objetivas.
* **Informação:** Dados processados para serem úteis; responde a "Quem, Quê, Onde, Quando".
* **Conhecimento:** Aplicação de dados e informação; responde a "Como".
* **Sabedoria:** Compreensão avaliada; responde a "Porquê".

## A Pirâmide DIKW

![Pirâmide DIKW](figures/dikw_pt.png){ width=512px }

* À medida que subimos na pirâmide, o **significado** e o **valor** aumentam.
* Como engenheiros, construímos sistemas que automatizam esta transformação.

## A Pipeline de Ciência de Dados I

Um fluxo de trabalho padrão para tirar partido dos dados.

1.  **Recolha:** Obter dados de sensores, APIs ou bases de dados.
2.  **Limpeza:** Lidar com valores em falta, ruído e outliers.
3.  **Exploração (EDA):** Compreender as propriedades estatísticas dos dados.
4.  **Análise:** Construir modelos ou realizar consultas complexas.
5.  **Visualização:** Comunicar os resultados de forma eficaz.

## A Pipeline de Ciência de Dados II

* **Iteração:** A pipeline não é linear; muitas vezes volta-se à limpeza após a exploração.
* **Automação:** Usar scripts (Python) e pipelines para tornar o processo repetível.
* **Qualidade:** "Lixo à entrada, lixo à saída" – a fase de limpeza é a mais crítica.

# Carregamento e Manipulação de Dados

## O Conceito de DataFrame I

Um DataFrame é a estrutura de dados central na ciência de dados moderna.

* **Modelo Conceptual:** Uma folha de cálculo em memória ou uma tabela SQL.
* **Eixo 0:** Linhas (Amostras/Observações).
* **Eixo 1:** Colunas (Variáveis/Características).
* **Índice:** Rótulos únicos para identificar as linhas.

## O Conceito de DataFrame II

* **Homogeneidade:** Cada coluna geralmente contém um único tipo de dados (Int, Float, String).
* **Alinhamento:** Os dados são alinhados automaticamente com base em rótulos durante as operações.
* **Bibliotecas:** Usado por Pandas (Python), Polars (Python/Rust) e Spark (Big Data).

## Ferramentas: Pandas vs. Polars

| Característica | **Pandas** | **Polars** |
| :--- | :--- | :--- |
| Backend | Python / C | **Rust** |
| Threading | Single-threaded | **Multi-threaded** |
| Avaliação | Eager (Imediata) | **Lazy (Preguiçosa)** |
| Memória | Muitas cópias | Eficiente (Arrow) |

* Use **Pandas** para conjuntos de dados pequenos e compatibilidade.
* Use **Polars** para desempenho e conjuntos de dados massivos.

# Limpeza de Dados

## Valores em Falta (Imputação)

Dados do mundo real são "sujos" e muitas vezes contêm buracos (`NaN`, `Null`).

* **Drop:** Remover linhas com quaisquer valores em falta.
* **Fill (Constante):** Substituir por zero ou uma string padrão.
* **Fill (Estatístico):** Substituir pela Média, Mediana ou Moda.
* **Média:** Bom para distribuições normais.
* **Mediana:** Melhor quando existem outliers.

## Deteção de Outliers com IQR

Outliers são valores extremos que podem enviesar a sua análise.

* **O Método do Box Plot:** Usa quartis para definir o intervalo "normal".
* **IQR:** $Q3 - Q1$.
* **Limite Inferior:** $Q1 - 1.5 \times IQR$
* **Limite Superior:** $Q3 + 1.5 \times IQR$

---

![Outliers no Box Plot](figures/03_boxplot.pdf){ width=256px }

## Escalonamento de Dados (Scaling)

Garantir que todas as variáveis têm um intervalo semelhante.

* **Normalização:** Escalar dados para $[0, 1]$.
  * $$X_{norm} = \frac{X - X_{min}}{X_{max} - X_{min}}$$
* **Padronização:** Centrar os dados na Média=0 com Desvio Padrão=1.
  * $$Z = \frac{X - \mu}{\sigma}$$

# Análise Exploratória de Dados (EDA)

## Estatística Descritiva

Resumir os dados com alguns números.

* **Média / Mediana / Moda:** Tendência central.
* **Variância / Desvio Padrão:** Dispersão.
* **Quartis:** Marcadores de 25%, 50%, 75%.

## Correlação (Pearson)

Medir a relação linear entre duas variáveis.

* **Intervalo:** $[-1, +1]$.
* **+1:** Relação linear positiva perfeita.
* **-1:** Relação linear negativa perfeita.
* **0:** Nenhuma relação linear.
* **Aviso:** "Correlação não implica causalidade."

# Visualização de Dados

## O Poder dos Visuais

O cérebro humano está otimizado para o reconhecimento de padrões em imagens.

* **Matplotlib:** O motor de baixo nível; controlo infinito.
* **Seaborn:** Visualização estatística de alto nível; excelentes predefinições.

## Escolher o Gráfico Certo

* **Distribuição:** Histograma ou KDE.
* **Comparação:** Gráfico de Barras ou Box Plot.
* **Relação:** Gráfico de Dispersão ou Gráfico de Linhas.
* **Densidade:** Violin Plot (Box Plot + KDE).

---

![Comparação de Gráficos](figures/04_violinplot.pdf){ width=256px }

## Exportação: Raster vs. Vetor

* **Raster (.PNG, .JPG):** Grelha de píxeis. Perde qualidade ao fazer zoom. Bom para web.
* **Vetor (.PDF, .SVG):** Caminhos matemáticos. Escalabilidade infinita. Essencial para **Artigos Académicos**.

# Comunicação e Partilha de Dados

## A Camada de Comunicação

Documentação e APIs são como partilhamos o conhecimento.

* **Markdown:** Para documentação técnica (READMEs).
* **LaTeX:** Para relatórios académicos formais.
* **Jupyter:** Para relatórios interativos (Notebooks).

## Partilhar Dados: Serialização para Troca

* **Serialização:** Converter um objeto num fluxo de bytes (JSON/Protobuf).
* **Esquemas (Schemas):** Um contrato (acordo) entre produtor e consumidor.
* **Metadados:** Unidades, origem e timestamps (ISO 8601).

## Partilhar Dados: APIs Web e IoT

* **APIs REST:** O padrão para serviços web (HTTP GET/POST + JSON).
* **MQTT:** Protocolo leve para IoT (Publish/Subscribe).
* **WebSockets:** Comunicação em tempo real, full-duplex.

# Sumário

## Sumário

* **DIKW:** Dados são a matéria-prima; Conhecimento é o objetivo.
* **Pipeline:** Limpeza e EDA são as fases mais críticas.
* **Ferramentas:** Domine Pandas/Polars para análise e Seaborn para visualização.
* **Partilha:** Use formatos padrão, esquemas e APIs para comunicar resultados.
* **Jupyter:** O laboratório para experimentação e storytelling.
