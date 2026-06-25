# Análise de Dados e Visualização

## Introdução

A capacidade de transformar dados brutos em conhecimento acionável é uma das competências mais valiosas da engenharia moderna. No contexto de sistemas e serviços, a análise de dados não se resume à aplicação de algoritmos estatísticos, mas engloba todo um ciclo de vida — desde a recolha e a limpeza até a comunicação dos resultados. Este processo é frequentemente modelado pela **Pirâmide DIKW** (Dados, Informação, Conhecimento, Sabedoria), que descreve a ascensão da abstração: os dados são sinais brutos, a informação é a estrutura aplicada, o conhecimento é a síntese dessa informação e a sabedoria é a compreensão profunda do "porquê".

---

## Parte 1: A Pipeline de Ciência de Dados

O fluxo de trabalho para a extração de valor a partir de dados não é linear, mas sim um processo iterativo. A qualidade do resultado final é estritamente dependente da qualidade dos dados de entrada — um princípio conhecido como *Garbage In, Garbage Out* (GIGO).

### Etapas do Fluxo de Trabalho

1.  **Recolha:** Obtenção de dados a partir de diversas fontes, como sensores IoT, APIs REST ou bases de dados SQL.
2.  **Limpeza (*Data Cleaning*):** Tratamento de valores em falta, remoção de ruído e deteção de *outliers*. Esta é a fase mais consumidora de tempo e a mais crítica para a fiabilidade do modelo.
3.  **Exploração (EDA):** a Análise Exploratória de Dados (*Exploratory Data Analysis*) visa compreender as propriedades estatísticas, distribuições e correlações inerentes ao conjunto de dados.
4.  **Análise e Modelagem:** Aplicação de técnicas estatísticas ou modelos de *Machine Learning* para identificar padrões ou prever comportamentos.
5.  **Visualização e Comunicação:** Tradução de resultados técnicos em representações visuais compreensíveis para a tomada de decisão.

```{=latex}
\begin{center}
\begin{tikzpicture}[
    node distance=0.4cm,
    block/.style={draw, rectangle, minimum width=1.8cm, minimum height=0.8cm, align=center, font=\sffamily\tiny},
    arrow/.style={-stealth, thick}
]
    % Nodes
    \node (collect) [block, fill=blue!10] {Recolha};
    \node (clean) [block, fill=blue!20, right=of collect] {Limpeza};
    \node (eda) [block, fill=blue!30, right=of clean] {Exploração\\(EDA)};
    \node (analyze) [block, fill=blue!40, right=of eda] {Análise};
    \node (vis) [block, fill=blue!50, right=of analyze] {Visualização};

    % Forward Flow
    \draw [arrow] (collect) -- (clean);
    \draw [arrow] (clean) -- (eda);
    \draw [arrow] (eda) -- (analyze);
    \draw [arrow] (analyze) -- (vis);

    % Feedback Loop
    \draw [arrow] (eda.south) -- ++(0,-0.4) -- ++(-2.2cm,0) -- (clean.south);
    \node [below=0.5cm of clean, font=\tiny\itshape] {Ciclo de Refinamento};
\end{tikzpicture}
\end{center}
```

---

## Parte 2: Manipulação de Dados com DataFrames

A estrutura central para a análise de dados moderna é o **DataFrame**. Conceptualmente, um DataFrame assemelha-se a uma tabela SQL ou a uma folha de cálculo, organizada em dois eixos: o **Eixo 0** (linhas/observações) e o **Eixo 1** (colunas/variáveis).

### Ferramentas de Processamento: Pandas vs. Polars

A escolha da biblioteca de manipulação de dados depende da escala do problema e dos requisitos de performance:

*   **Pandas:** A biblioteca padrão da indústria. É extremamente versátil e possui um ecossistema vasto, mas é predominantemente *single-threaded* e consome muita memória devido a cópias frequentes de dados.
*   **Polars:** Uma alternativa moderna escrita em **Rust**. Utiliza a especificação *Apache Arrow* para memória eficiente e é nativamente *multi-threaded*. Além disso, implementa a **Avaliação Preguiçosa (*Lazy Evaluation*)**, onde as operações são otimizadas por um planeador antes de serem executadas, resultando num desempenho significativamente superior em conjuntos de dados massivos.

### Código Prático: Pandas vs. Polars

Abaixo encontra-se a comparação prática de como carregar um dataset, filtrar linhas, selecionar colunas e calcular uma agregação usando Pandas e Polars.

#### Em Pandas (Eager):
```python
import pandas as pd

# Carregar dados
df = pd.read_csv("sensor_data.csv")

# Filtrar e agregar
df_filtered = df[df["temperatura"] > 25.0]
result = df_filtered[["sensor_id", "temperatura"]].groupby("sensor_id").mean()
print(result)
```

#### Em Polars (Lazy):
```python
import polars as pl

# Criar uma query preguiçosa
query = (
    pl.scan_csv("sensor_data.csv")
    .filter(pl.col("temperatura") > 25.0)
    .group_by("sensor_id")
    .agg(pl.col("temperatura").mean().alias("temp_media"))
)

# Executar a query otimizada
result = query.collect()
print(result)
```

---

## Parte 3: Limpeza e Pré-processamento

Dados do mundo real são inerentemente "sujos". A limpeza de dados visa garantir que a análise não seja enviesada por anomalias.

### Imputação de Valores em Falta

Quando existem lacunas nos dados (`NaN` ou `Null`), as estratégias comuns são:
*   **Remoção (*Drop*):** Eliminar a observação. Recomendado apenas se a perda de dados for insignificante.
*   **Imputação Constante:** Substituir por um valor neutro ou padrão.
*   **Imputação Estatística:** Utilizar a **Média** (para distribuições normais) ou a **Mediana** (quando existem *outliers* que distorcem a média).

### Deteção de Outliers via IQR

Um *outlier* é um valor extremo que pode distorcer a análise estatística. O método do **Intervalo Interquartílico (IQR)** define a normalidade com base nos quartis $Q1$ (25%) e $Q3$ (75%):
$$\text{IQR} = Q3 - Q1$$
Os limites de normalidade são definidos como:
$$\text{Limite Inferior} = Q1 - 1.5 \times \text{IQR}$$
$$\text{Limite Superior} = Q3 + 1.5 \times \text{IQR}$$

### Escalonamento de Dados (*Scaling*)

Para que variáveis com diferentes unidades (ex: Temperatura em °C e Pressão em Pa) sejam comparáveis, aplicam-se técnicas de escalonamento:
*   **Normalização:** Escala os dados para o intervalo $[0, 1]$.
    $$X_{\text{norm}} = \frac{X - X_{\min}}{X_{\max} - X_{\min}}$$
*   **Padronização (Z-Score):** Centra os dados na média $\mu = 0$ com desvio padrão $\sigma = 1$.
    $$Z = \frac{X - \mu}{\sigma}$$

### Código Prático: Limpeza e Escalonamento (Pandas)

O seguinte script Python implementa o tratamento de valores em falta, a filtragem de *outliers* usando o IQR e a padronização Z-Score usando Pandas:

```python
import pandas as pd
import numpy as np

# DataFrame de teste
data = {'valor': [10.2, 12.1, np.nan, 11.5, 9.8, 100.5, 11.0, 10.9]}
df = pd.DataFrame(data)

# 1. Imputação de Valores em Falta (Mediana)
mediana = df['valor'].median()
df['valor'] = df['valor'].fillna(mediana)

# 2. Deteção e Remoção de Outliers via IQR
Q1 = df['valor'].quantile(0.25)
Q3 = df['valor'].quantile(0.75)
IQR = Q3 - Q1

limite_inferior = Q1 - 1.5 * IQR
limite_superior = Q3 + 1.5 * IQR

# Filtrar outliers (exclui o valor extremo 100.5)
df_clean = df[(df['valor'] >= limite_inferior) & (df['valor'] <= limite_superior)].copy()

# 3. Escalonamento: Padronização (Z-Score)
media = df_clean['valor'].mean()
desvio = df_clean['valor'].std()
df_clean['valor_zscore'] = (df_clean['valor'] - media) / desvio
print(df_clean)
```

```{=latex}
\begin{center}
\begin{tikzpicture}[
    node distance=0.5cm,
    box/.style={draw, rectangle, minimum width=2.2cm, minimum height=1cm, align=center, font=\sffamily\tiny},
    arrow/.style={-stealth, thick}
]
    \node (raw) [box, fill=red!10] {Dados Brutos \\ \tiny{Ruído, NaNs, Outliers}};
    \node (clean) [box, fill=yellow!10, right=of raw] {Limpeza \\ \tiny{Imputação, IQR}};
    \node (scale) [box, fill=green!10, right=of clean] {Escalonamento \\ \tiny{Normalização, Z-Score}};
    \node (final) [box, fill=blue!10, right=of scale] {Dados Prontos \\ \tiny{Para Análise}};

    \draw [arrow] (raw) -- (clean);
    \draw [arrow] (clean) -- (scale);
    \draw [arrow] (scale) -- (final);
\end{tikzpicture}
\end{center}
```

---

## Parte 4: Análise Exploratória e Visualização

### Estatística Descritiva e Correlação

A EDA utiliza estatísticas básicas para resumir o comportamento dos dados. A **Correlação de Pearson** é utilizada para medir a força da relação linear entre duas variáveis, variando entre $-1$ e $+1$. É fundamental recordar que **correlação não implica causalidade**.

### Princípios de Visualização

A escolha do gráfico deve alinhar-se com o objetivo da análise:
*   **Distribuição:** Histogramas ou KDE (*Kernel Density Estimation*).
*   **Comparação:** Gráficos de barras ou *Box Plots*.
*   **Relação:** Gráficos de dispersão (*Scatter Plots*).
*   **Densidade e Distribuição:** *Violin Plots*, que combinam a visão de quartis do *Box Plot* com a densidade do KDE.

### Formatos de Exportação

Para a comunicação de resultados, a escolha do formato é crítica:
*   **Raster ($\text{.PNG, .JPG}$):** Compostos por píxeis. Perdem qualidade ao fazer zoom. Ideais para a web.
*   **Vetor ($\text{.PDF, .SVG}$):** Compostos por caminhos matemáticos. Escalabilidade infinita sem perda de qualidade. Obrigatórios para publicações académicas.

```{=latex}
\begin{center}
\begin{tikzpicture}[
    node distance=1.3cm,
    box/.style={draw, rectangle, minimum width=2.2cm, minimum height=1cm, align=center, font=\sffamily\tiny},
    arrow/.style={-stealth, thick}
]
    \node (data) [box, fill=blue!10] {Dataset};
    \node (viz) [box, fill=green!10, right=1.3cm of data] {Visualização \\ \tiny{Matplotlib / Seaborn}};
    \node (insight) [box, fill=yellow!10, right=1.3cm of viz] {Insight \\ \tiny{Padrões, Tendências}};

    \draw [arrow] (data) -- (viz);
    \draw [arrow] (viz) -- (insight);
    \draw [arrow] (insight.south) -- ++(0,-0.5) -- ++(-7cm,0) -- (data.south) node[midway, below, font=\tiny] {Refinamento da Pergunta};
\end{tikzpicture}
\end{center}
```

---

## Parte 5: Comunicação e Partilha de Dados

### Documentação Técnica

A partilha de conhecimento requer formatos que equilibrem a legibilidade humana e a processabilidade por máquinas. O **Markdown** é o padrão para documentação técnica, enquanto o **LaTeX** é utilizado para relatórios formais. O ambiente **Jupyter Notebook** é a ferramenta ideal para a experimentação, pois permite a coexistência de código, visualizações e texto explicativo (*storytelling* de dados).

### Contratos de Dados e APIs

A troca de informação entre sistemas é regida por **Esquemas (*Schemas*)**, que atuam como contratos entre o produtor e o consumidor dos dados.
*   **APIs REST:** Utilizam HTTP e JSON para a partilha de recursos.
*   **MQTT:** Ideal para IoT, utilizando o modelo *Publish/Subscribe* para reduzir o *overhead* de rede.
*   **WebSockets:** Permitem a comunicação bidirecional em tempo real.

---

## Recursos Adicionais

*   **Análise de Dados:** [Pandas Documentation](https://pandas.pydata.org/docs/).
*   **High Performance Data:** [Polars Documentation](https://pola-rs.github.io/polars/).
*   **Visualização:** [Seaborn Gallery](https://seaborn.pydata.org/examples/index.html).
*   **Sinais e Processamento:** [Scikit-Learn Preprocessing](https://scikit-learn.org/stable/preprocessing/).
