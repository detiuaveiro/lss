---
title: Data Analysis, Visualization, and Communication
---

# Exercises

## Exercise 1: The DIKW Pyramid

Explain, using a practical example from an IoT weather station, the difference between:
1.  **Data**
2.  **Information**
3.  **Knowledge**
4.  **Wisdom**

---

## Exercise 2: Data Loading and Manipulation

Using the `dataset/iris.csv` file (or any other dataset available in the repository):

1.  Load the dataset using **Pandas**.
2.  Display the first 5 rows and the column names.
3.  Calculate the mean and standard deviation of one of the numerical columns.
4.  Filter the data to show only rows where a specific variable is above a certain threshold.

---

## Exercise 3: Handling Missing Data

You have the following sensor readings with missing values:
`[22.1, 23.5, NaN, 22.8, 23.0, NaN, 24.2]`

1.  Calculate the **Mean** of the available data.
2.  Replace the `NaN` values with the Mean (Imputation).
3.  Why might using the **Median** be better if the data had extreme outliers?

---

## Exercise 4: Data Visualization

Using **Seaborn** or **Matplotlib**:

1.  Create a **Histogram** of a numerical variable to see its distribution.
2.  Create a **Scatter Plot** between two numerical variables to see if they are correlated.
3.  Create a **Box Plot** to compare a numerical variable across different categories.
4.  Save your plots as `.pdf` (Vector) and `.png` (Raster). Compare the quality when zooming in.

---

## Exercise 5: Correlation

1.  What does a correlation coefficient of **-0.85** tell you about the relationship between two variables?
2.  Is it possible for two variables to have a strong relationship but zero Pearson correlation?

---

## Exercise 6: Data Communication and Sharing

1.  What is the difference between **Serialization** and **Deserialization**?
2.  Why is a **Schema** important when sharing data between different systems?
3.  Match the protocol to its description:
    *   **REST**
    *   **MQTT**
    *   **WebSockets**
    
    A. Publish/Subscribe model for IoT.
    B. Standard request/response using HTTP.
    C. Real-time, full-duplex communication.
4.  Why should you use **ISO 8601** for timestamps?
