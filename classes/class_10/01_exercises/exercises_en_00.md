---
title: Representation and Communication of Digital Information II
---

# Exercises

## Exercise 1: Markdown Basics

Create a file named `report.md` that includes the following elements:
1.  A main title and two sub-sections.
2.  A list of "Tasks for today" with at least 3 items.
3.  A block of Python code that prints "Hello, Pandoc!".
4.  A table with two columns: `Feature` and `Benefit`.
5.  A link to the University of Aveiro website.

-----

## Exercise 2: LaTeX Mathematics

Create a small LaTeX file named `math.tex` (or use an online editor like Overleaf) to typeset the following formulas:
1.  The quadratic formula: $x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}$
2.  The definition of a derivative: $f'(x) = \lim_{h \to 0} \frac{f(x+h) - f(x)}{h}$
3.  Maxwell's Equations (just one of them, e.g., Gauss's Law): $\nabla \cdot \mathbf{E} = \frac{\rho}{\varepsilon_0}$

-----

## Exercise 3: Using Pandoc for Conversion

In this exercise, you will use Pandoc to convert documents between formats.
(Ensure `pandoc` and a LaTeX engine like `lualatex` or `pdftex` are installed).

1.  Convert your `report.md` from Exercise 1 into an HTML file:
    ```bash
    $ pandoc report.md -o report.html
    ```
2.  Convert the same `report.md` into a PDF file:
    ```bash
    $ pandoc report.md -o report.pdf
    ```
3.  Convert the `report.md` into a LaTeX source file:
    ```bash
    $ pandoc report.md -o report.tex
    ```

-----

## Exercise 4: Python Docstrings

1.  Create a Python script named `math_tools.py`.
2.  Define a function `fibonacci(n)` that calculates the n-th Fibonacci number.
3.  Add a high-quality "Google-style" or "Numpy-style" docstring to the function, including:
    *   A summary of what it does.
    *   Descriptions of the arguments.
    *   Description of the return value.
    *   An example of usage.

-----

## Exercise 5: Document Automation (Challenge)

Create a `Makefile` in a new directory that:
1.  Finds all `.md` files in the directory.
2.  Has a rule to convert each `.md` file into a `.pdf` using `pandoc`.
3.  Has a `clean` rule to remove all generated PDFs.
4.  Test it by running `make` and then `make clean`.
