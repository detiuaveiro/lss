---
title: Representação e Comunicação de Informação Digital II
---

# Exercícios

## Exercício 1: Básico de Markdown

Crie um ficheiro chamado `report.md` que inclua os seguintes elementos:
1.  Um título principal e duas sub-secções.
2.  Uma lista de "Tarefas para hoje" com pelo menos 3 itens.
3.  Um bloco de código Python que imprime "Olá, Pandoc!".
4.  Uma tabela com duas colunas: `Funcionalidade` e `Benefício`.
5.  Um link para o website da Universidade de Aveiro.

-----

## Exercício 2: Matemática em LaTeX

Crie um pequeno ficheiro LaTeX chamado `math.tex` (ou use um editor online como o Overleaf) para escrever as seguintes fórmulas:
1.  A fórmula resolvente: $x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}$
2.  A definição de derivada: $f'(x) = \lim_{h \to 0} \frac{f(x+h) - f(x)}{h}$
3.  Equações de Maxwell (apenas uma delas, ex: Lei de Gauss): $\nabla \cdot \mathbf{E} = \frac{\rho}{\varepsilon_0}$

-----

## Exercício 3: Usar o Pandoc para Conversão

Neste exercício, usará o Pandoc para converter documentos entre formatos.
(Certifique-se de que o `pandoc` e um motor LaTeX como `lualatex` ou `pdftex` estão instalados).

1.  Converta o seu `report.md` do Exercício 1 num ficheiro HTML:
    ```bash
    $ pandoc report.md -o report.html
    ```
2.  Converta o mesmo `report.md` num ficheiro PDF:
    ```bash
    $ pandoc report.md -o report.pdf
    ```
3.  Converta o `report.md` num ficheiro fonte LaTeX:
    ```bash
    $ pandoc report.md -o report.tex
    ```

-----

## Exercício 4: Docstrings em Python

1.  Crie um script Python chamado `math_tools.py`.
2.  Defina uma função `fibonacci(n)` que calcula o n-ésimo número de Fibonacci.
3.  Adicione uma docstring de alta qualidade (estilo Google ou Numpy) à função, incluindo:
    *   Um sumário do que faz.
    *   Descrições dos argumentos.
    *   Descrição do valor de retorno.
    *   Um exemplo de utilização.

-----

## Exercício 5: Automação de Documentos (Desafio)

Crie um `Makefile` num novo diretório que:
1.  Encontre todos os ficheiros `.md` no diretório.
2.  Tenha uma regra para converter cada ficheiro `.md` num `.pdf` usando o `pandoc`.
3.  Tenha uma regra `clean` para remover todos os PDFs gerados.
4.  Teste-o correndo `make` e depois `make clean`.
