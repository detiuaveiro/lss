---
title: Análise, Visualização e Comunicação de Dados
---

# Exercícios

## Exercício 1: A Pirâmide DIKW

Explique, usando um exemplo prático de uma estação meteorológica IoT, a diferença entre:
1.  **Dados (Data)**
2.  **Informação (Information)**
3.  **Conhecimento (Knowledge)**
4.  **Sabedoria (Wisdom)**

---

## Exercício 2: Carregamento e Manipulação de Dados

Usando o ficheiro `dataset/iris.csv` (ou qualquer outro dataset disponível no repositório):

1.  Carregue o dataset usando o **Pandas**.
2.  Mostre as primeiras 5 linhas e os nomes das colunas.
3.  Calcule a média e o desvio padrão de uma das colunas numéricas.
4.  Filtre os dados para mostrar apenas as linhas onde uma variável específica está acima de um determinado limite.

---

## Exercício 3: Lidar com Dados em Falta

Tem as seguintes leituras de sensores com valores em falta:
`[22.1, 23.5, NaN, 22.8, 23.0, NaN, 24.2]`

1.  Calcule a **Média** dos dados disponíveis.
2.  Substitua os valores `NaN` pela Média (Imputação).
3.  Porque é que usar a **Mediana** poderia ser melhor se os dados tivessem outliers extremos?

---

## Exercício 4: Visualização de Dados

Usando **Seaborn** ou **Matplotlib**:

1.  Crie um **Histograma** de uma variável numérica para ver a sua distribuição.
2.  Crie um **Gráfico de Dispersão** entre duas variáveis numéricas para ver se estão correlacionadas.
3.  Crie um **Box Plot** para comparar uma variável numérica entre diferentes categorias.
4.  Guarde os seus gráficos como `.pdf` (Vetor) e `.png` (Raster). Compare a qualidade ao fazer zoom.

---

## Exercício 5: Correlação

1.  O que nos diz um coeficiente de correlação de **-0,85** sobre a relação entre duas variáveis?
2.  É possível que duas variáveis tenham uma relação forte mas uma correlação de Pearson zero?

---

## Exercício 6: Comunicação e Partilha de Dados

1.  Qual é a diferença entre **Serialização** e **Desserialização**?
2.  Porque é que um **Esquema (Schema)** é importante ao partilhar dados entre diferentes sistemas?
3.  Faça a correspondência entre o protocolo e a sua descrição:
    *   **REST**
    *   **MQTT**
    *   **WebSockets**
    
    A. Modelo Publish/Subscribe para IoT.
    B. Pedido/resposta padrão usando HTTP.
    C. Comunicação em tempo real, full-duplex.
4.  Porque deve usar o formato **ISO 8601** para timestamps?
