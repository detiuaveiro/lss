---
title: Representação e Comunicação de Informação Digital II
---

# Introdução

## Comunicar Informação Técnica

Como engenheiro, escrever código é apenas metade do trabalho.

* A outra metade é **comunicar** o que esse código faz.
* Audiência: Outros programadores, gestores, clientes ou o seu eu futuro.
* Meio: Documentação, relatórios, teses ou apresentações.
* Objetivo: Usar ferramentas que permitam versionamento, automação e qualidade profissional.

## O Custo de Documentação Pobre I

O que acontece quando não documentamos?

* **Tempo Desperdiçado:** Programadores a gastar horas a tentar entender uma função.
* **Erros:** Mau uso de uma API porque a documentação era pouco clara.
* **Integração:** Novos membros da equipa a demorar meses em vez de semanas a serem produtivos.

## O Custo de Documentação Pobre II

* **Manutenção:** Voltar ao seu próprio código após 6 meses e não saber porque fez algo.
* **Dívida Técnica:** Código/docs pouco claros levam a hacks e soluções temporárias.
* **Silos:** O conhecimento fica preso na cabeça de uma única pessoa.

# Markdown

## O que é o Markdown?

Uma linguagem de marcação leve com sintaxe de formatação em texto simples.

* **Origem:** Criado por John Gruber em 2004.
* **Filosofia:** "Legibilidade, acima de tudo."
* **Formato:** Texto simples que pode ser convertido para muitos formatos (HTML, PDF, DOCX).
* **Uso:** GitHub (READMEs), Documentação (MkDocs, Sphinx), Notas académicas.

## Flavors de Markdown

O Markdown não é um padrão único, mas tem "sabores" (flavors):

* **CommonMark:** A tentativa de criar um padrão altamente compatível.
* **GitHub Flavored Markdown (GFM):** Adiciona tabelas, listas de tarefas e links automáticos.
* **Pandoc's Markdown:** O mais poderoso, adicionando citações, notas de rodapé e metadados.

## Sintaxe Markdown: Cabeçalhos

Usar o símbolo `#`:

* `# Título (H1)`
* `## Secção (H2)`
* `### Subsecção (H3)`
* `#### Sub-subsecção (H4)`

## Sintaxe Markdown: Ênfase

* `*itálico*` ou `_itálico_`
* `**negrito**` ou `__negrito__`
* `***negrito itálico***`
* `~~rasurado~~`

## Sintaxe Markdown: Listas I

**Listas Não Ordenadas:**
* Item 1
* Item 2
  * Sub-item 2.1
  * Sub-item 2.2

## Sintaxe Markdown: Listas II

**Listas Ordenadas:**
1. Primeiro passo
2. Segundo passo
3. Terceiro passo

## Sintaxe Markdown: Links e Imagens

* **Link:** `[Texto do Link](URL)`
  * `[Universidade de Aveiro](https://www.ua.pt)`
* **Imagem:** `![Texto Alt](Caminho/para/imagem)`
  * `![Logótipo do Curso](../../assets/logo.svg)`

## Sintaxe Markdown: Código

* **Inline:** Envolver com backticks: `` `print("Olá")` ``.
* **Blocos:** Usar três backticks com identificador de linguagem.

\```python
def hello():
    print("Olá Mundo")
\```

## Sintaxe Markdown: Tabelas e Tarefas (GFM)

| Tarefa  | Prioridade | Estado  |
|---------|------------|---------|
| Planear | Alta       | Feito   |
| Escrever| Média      | Ativo   |

-----

* **Listas de Tarefas:**
- [x] Completar Aula 09
- [x] Pesquisar Aula 10
- [ ] Escrever slides da Aula 10

## Diagramas em Markdown: Mermaid.js I

Muitas plataformas (GitHub, GitLab, Obsidian) suportam **Mermaid** para diagramas.

\```mermaid
graph TD
    A[Início] --> B{São dados?}
    B -- Sim --> C[Processar]
    B -- Não --> D[Fim]
\```

## Diagramas em Markdown: Mermaid.js II

O Mermaid suporta muitos tipos de diagramas:
* **Fluxogramas**
* **Diagramas de Sequência**
* **Gráficos de Gantt**
* **Diagramas de Classe**
* **Diagramas de Entidade-Relacionamento**

Permite manter os seus diagramas **versionados** juntamente com o seu código.

# LaTeX

## O que é o LaTeX?

Um sistema de composição de alta qualidade para documentação técnica e científica.

* **Foco:** Separar o conteúdo do estilo.
* **Força:** Notação matemática, citações e documentos grandes.
* **Motor:** Baseado em TeX, criado por Donald Knuth.
* **Padrão:** Usado para Teses de Mestrado, Dissertações de Doutoramento e Artigos Científicos.

## Básicos de LaTeX: Estrutura

```latex
\documentclass{article}
\usepackage[utf8]{inputenc}

\title{O Meu Relatório}
\author{Mário Antunes}

\begin{document}
\maketitle

\section{Introdução}
Olá mundo!
\end{document}
```

## Básicos de LaTeX: Classes de Documento

O `\documentclass{...}` define o layout geral:

* **article:** Para relatórios curtos ou artigos.
* **report:** Para documentos mais longos com capítulos (como uma Tese).
* **book:** Para livros completos.
* **beamer:** Para criar slides de apresentação.

## Beamer: Apresentações em LaTeX

O Beamer permite criar slides em PDF usando a sintaxe LaTeX.

* **Frames:** Cada slide é um `\begin{frame} ... \end{frame}`.
* **Temas:** Aspetos profissionais e académicos (ex: `Warsaw`, `Madrid`).
* **Overlays:** Controlar quando o conteúdo aparece (ex: `\pause`).
* **Consistência:** A matemática e o código nos seus slides serão idênticos ao seu artigo/tese.

## Básicos de LaTeX: Pacotes

Os pacotes estendem as capacidades do LaTeX:

* **graphicx:** Para incluir imagens (`\includegraphics`).
* **hyperref:** Para links clicáveis e referências cruzadas.
* **geometry:** Para alterar as margens da página.
* **amsmath:** Para símbolos matemáticos avançados.
* **biblatex:** Para gerir bibliografias.

## Básicos de LaTeX: Matemática I

O LaTeX é o padrão da indústria para escrever matemática.

* **Inline:** $E = mc^2$.
* **Display:** 
  $$\int_{a}^{b} f(x) dx$$

## Básicos de LaTeX: Matemática II

* **Frações:** `\frac{numerador}{denominador}`
* **Somas:** `\sum_{i=0}^{n} x_i`
* **Letras Gregas:** `\alpha, \beta, \gamma, \pi`
* **Sub/Super-escritos:** `x_i, x^2`
* **Matrizes:** `\begin{pmatrix} a & b \\ c & d \end{pmatrix}`

## Citações com BibTeX/BibLaTeX

Gerir referências manualmente é um pesadelo.

1.  Crie um ficheiro `.bib` com as suas referências.
    ```bibtex
    @article{einstein1905,
      author = {Albert Einstein},
      title = {On the Electrodynamics of Moving Bodies},
      journal = {Annalen der Physik},
      year = {1905}
    }
    ```
2.  Cite-o: `Einstein mostrou que \cite{einstein1905}...`

# Pandoc

## A "faca suíça" dos Documentos

O Pandoc é uma ferramenta de linha de comandos para converter ficheiros de um formato de marcação para outro.

* **Entrada:** Markdown, LaTeX, HTML, DOCX, EPUB.
* **Saída:** PDF, HTML, LaTeX, Slides (Beamer/RevealJS), DOCX.
* **Comando:** `pandoc entrada.md -o saida.pdf`

## Como o Pandoc Funciona I

1. **Leitor (Reader):** Analisa a entrada (ex: Markdown).
2. **Representação Intermédia:** Converte para uma "AST" (Abstract Syntax Tree) interna.
3. **Escritor (Writer):** Gera a saída (ex: PDF via LaTeX).

## Como o Pandoc Funciona II: Metadados

* **Metadados YAML:** Use um `config.yml` ou um bloco no topo do `.md`.
* Controla títulos, autores, datas e variáveis de template.
* **Templates:** Pode fornecer o seu próprio template LaTeX ou HTML para controlar cada detalhe da saída.

## Filtros Pandoc

O poder do Pandoc pode ser estendido usando **filtros**.

* Filtros são pequenos scripts que modificam a AST interna do documento antes de ser escrita.
* **Tipos:** Filtros Python (`panflute`), filtros Lua (embutidos).
* **Uso:**
  * Numerar figuras automaticamente.
  * Transformar formatos de tabelas.
  * Injetar LaTeX personalizado para blocos específicos.

# Documentos Úteis

## O Currículo Moderno

* **Formato:** Simples, pesquisável e profissional.
* **Ferramentas:** Use templates LaTeX (ex: `moderncv`) ou Markdown + Pandoc.
* **Secções Chave:** Educação, Experiência, Competências, Projetos.
* **Dica:** Mantenha o seu CV num repositório Git e gere múltiplas versões (ex: detalhado vs 1 página).

## A Tese de Mestrado: Estrutura Típica

1.  **Pré-textuais:** Título, Resumo, Agradecimentos, Índice.
2.  **Introdução:** Motivação, Problema, Objetivos, Contribuições.
3.  **Estado da Arte:** Revisão da literatura e comparação.
4.  **Solução Proposta/Metodologia:** Arquitetura, design e implementação.
5.  **Avaliação:** Configuração experimental, resultados e discussão.
6.  **Conclusão:** Sumário e Trabalho Futuro.
7.  **Pós-textuais:** Bibliografia, Apêndices.

## Tese de Mestrado: A "Contribuição"

A parte mais importante da sua tese é a sua contribuição original.

* Não é apenas "construir um sistema".
* É "resolver um problema" ou "melhorar um processo" usando princípios de engenharia.
* Deve declarar claramente **o que há de novo** no seu trabalho.

## Relatórios de Projeto

* **Sumário Executivo:** Para gestores ocupados.
* **Metodologia:** Como o fez.
* **Resultados:** O que descobriu.
* **Recomendações:** O que deve ser feito a seguir.
* **Automação:** Use um `Makefile` para gerar relatórios a partir de Markdown.

## Documentação Python I: Ferramentas

* **Sphinx:** O padrão da indústria para docs Python.
* **MkDocs:** Moderno, rápido e usa Markdown.
* **Docstrings:** Escreva documentação dentro do seu código.

## Documentação Python II: Docstrings

```python
def calculate_area(radius: float) -> float:
    """Calcula a área de um círculo.
    
    Args:
        radius: O raio do círculo (deve ser positivo).
        
    Returns:
        A área calculada.
        
    Raises:
        ValueError: Se o raio for negativo.
    """
    if radius < 0:
        raise ValueError("O raio não pode ser negativo")
    return 3.14159 * (radius ** 2)
```

# Sumário

## Sumário

* **Comunicação:** É uma competência central de engenharia.
* **Markdown:** Para notas diárias, READMEs e relatórios rápidos.
* **LaTeX:** Para documentos académicos formais e técnicos de alta qualidade.
* **Pandoc:** Para ligar todos os formatos e automatizar o seu fluxo de trabalho.
* **Consistência:** Use templates profissionais e controlo de versões para tudo.
