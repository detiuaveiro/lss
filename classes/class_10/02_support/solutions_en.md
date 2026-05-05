# Solutions for Class 10 Exercises

## Exercise 1: The DIKW Pyramid
*   **Data:** `25.4` (Raw number from sensor).
*   **Information:** "The temperature in the greenhouse is 25.4°C at 10:00 AM." (Context added).
*   **Knowledge:** "If the temperature exceeds 25°C, the ventilation system must be activated to protect the plants." (Application).
*   **Wisdom:** "We should switch to heat-resistant crops because the average greenhouse temperature has risen by 2°C over the last 5 years." (Evaluated understanding/Strategic decision).

---

## Exercise 2: Data Loading and Manipulation
```python
import pandas as pd

# 1. Load
df = pd.read_csv('../../dataset/iris.csv')

# 2. Display
print(df.head())
print(df.columns)

# 3. Stats
print(f"Mean: {df['sepal_length'].mean()}")
print(f"Std: {df['sepal_length'].std()}")

# 4. Filter
filtered = df[df['sepal_length'] > 5.0]
```

---

## Exercise 3: Handling Missing Data
1.  Available: `22.1, 23.5, 22.8, 23.0, 24.2`. Sum = `115.6`. Count = `5`. Mean = `23.12`.
2.  `[22.1, 23.5, 23.12, 22.8, 23.0, 23.12, 24.2]`.
3.  The Median is robust to outliers. If one reading was `100.0` (error), it would drastically change the Mean but hardly affect the Median.

---

## Exercise 4: Data Visualization
```python
import seaborn as sns
import matplotlib.pyplot as plt

df = sns.load_dataset('iris')

# Histogram
sns.histplot(data=df, x='sepal_length', kde=True)
plt.savefig('hist.pdf') # Vector
plt.savefig('hist.png') # Raster

# Scatter
sns.scatterplot(data=df, x='sepal_length', y='sepal_width', hue='species')

# Box Plot
sns.boxplot(data=df, x='species', y='petal_length')
```

---

## Exercise 5: Correlation
1.  A strong negative linear relationship. As one variable increases, the other decreases consistently.
2.  A "cloud" of points with no discernible pattern or slope.
3.  Yes. Pearson correlation only measures **linear** relationships. A perfect U-shape (parabolic) relationship has a strong pattern but a Pearson correlation of zero.

---

## Exercise 6: Data Communication and Sharing
1.  **Serialization** is the process of converting an in-memory object (like a list or dictionary) into a stream of bytes or a string (like JSON) for storage or transmission. **Deserialization** is the reverse process: reconstructing the object from the bytes or string.
2.  A schema acts as a **contract**. It ensures both teams agree on the data structure, types, and constraints, which prevents "breaking changes" and parsing errors.
3.  
    *   **REST**: B
    *   **MQTT**: A
    *   **WebSockets**: C
4.  ISO 8601 is **unambiguous** and **sortable**. Local formats like `04/05/26` can be confused (is it May 4th or April 5th?) and do not include timezone information (the `Z` or `+HH:MM` offset), which is critical for global systems.
