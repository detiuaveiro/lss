# Soluções para os Exercícios da Aula 10

## Exercício 1: A Pirâmide DIKW
*   **Dados:** `25.4` (Número bruto do sensor).
*   **Informação:** "A temperatura na estufa é de 25.4°C às 10:00 AM." (Contexto adicionado).
*   **Conhecimento:** "Se a temperatura exceder os 25°C, o sistema de ventilação deve ser ativado para proteger as plantas." (Aplicação).
*   **Sabedoria:** "Devemos mudar para culturas resistentes ao calor porque a temperatura média da estufa subiu 2°C nos últimos 5 anos." (Decisão estratégica).

---

## Exercício 2: Carregamento e Manipulação de Dados
```python
import pandas as pd

# 1. Carregar
df = pd.read_csv('../../dataset/iris.csv')

# 2. Mostrar
print(df.head())
print(df.columns)

# 3. Estatísticas
print(f"Média: {df['sepal_length'].mean()}")
print(f"Desvio Padrão: {df['sepal_length'].std()}")

# 4. Filtrar
filtrado = df[df['sepal_length'] > 5.0]
```

---

## Exercício 3: Lidar com Dados em Falta
1.  Disponíveis: `22.1, 23.5, 22.8, 23.0, 24.2`. Soma = `115.6`. Contagem = `5`. Média = `23.12`.
2.  `[22.1, 23.5, 23.12, 22.8, 23.0, 23.12, 24.2]`.
3.  A Mediana é robusta a outliers. Se uma leitura fosse `100.0` (erro), alteraria drasticamente a Média, mas mal afetaria a Mediana.

---

## Exercício 4: Visualização de Dados
```python
import seaborn as sns
import matplotlib.pyplot as plt

df = sns.load_dataset('iris')

# Histograma
sns.histplot(data=df, x='sepal_length', kde=True)
plt.savefig('hist.pdf') # Vetor
plt.savefig('hist.png') # Raster

# Dispersão
sns.scatterplot(data=df, x='sepal_length', y='sepal_width', hue='species')

# Box Plot
sns.boxplot(data=df, x='species', y='petal_length')
```

---

## Exercício 5: Correlação
1.  Uma relação linear negativa forte. À medida que uma variável aumenta, a outra diminui consistentemente.
2.  Uma "nuvem" de pontos sem padrão ou inclinação discernível.
3.  Sim. A correlação de Pearson apenas mede relações **lineares**. Uma relação em forma de U perfeita tem um padrão forte mas uma correlação de Pearson de zero.

---

## Exercício 6: Comunicação e Partilha de Dados
1.  **Serialização** é o processo de converter um objeto em memória (como uma lista ou dicionário) num fluxo de bytes ou numa string (como JSON) para armazenamento ou transmissão. **Desserialização** é o processo inverso: reconstruir o objeto a partir dos bytes ou string.
2.  Um esquema atua como um **contrato**. Garante que ambas as equipas concordam com a estrutura de dados, tipos e restrições, o que evita erros de análise e alterações que quebrem o sistema.
3.  
    *   **REST**: B
    *   **MQTT**: A
    *   **WebSockets**: C
4.  O ISO 8601 é **inequívoco** e **ordenável**. Formatos locais como `04/05/26` podem ser confundidos (é 4 de maio ou 5 de abril?) e não incluem informação de fuso horário (o sufixo `Z` ou `+HH:MM`), o que é crítico para sistemas globais.
