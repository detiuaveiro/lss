---
title: Representation and Communication of Digital Information II
---

# Introduction

## Communicating Technical Information

As an engineer, writing code is only half of the job.

* The other half is **communicating** what that code does.
* Audience: Other developers, managers, clients, or your future self.
* Medium: Documentation, reports, theses, or presentations.
* Objective: Use tools that allow for versioning, automation, and professional quality.

## The Cost of Poor Documentation I

What happens when we don't document?

* **Wasted Time:** Developers spending hours trying to understand a function.
* **Errors:** Misusing an API because the documentation was unclear.
* **Onboarding:** New team members taking months instead of weeks to be productive.

## The Cost of Poor Documentation II

* **Maintenance:** Returning to your own code after 6 months and not knowing why you did something.
* **Technical Debt:** Unclear code/docs lead to hacks and workarounds.
* **Silos:** Knowledge is trapped in one person's head.

# Markdown

## What is Markdown?

A lightweight markup language with plain-text-formatting syntax.

* **Origin:** Created by John Gruber in 2004.
* **Philosophy:** "Readability, above all else."
* **Format:** Plain text that can be converted to many formats (HTML, PDF, DOCX).
* **Usage:** GitHub (READMEs), Documentation (MkDocs, Sphinx), Academic notes.

## Markdown Flavors

Markdown is not a single standard, but has "flavors":

* **CommonMark:** The attempt to create a highly compatible standard.
* **GitHub Flavored Markdown (GFM):** Adds tables, task lists, and autolinks.
* **Pandoc's Markdown:** The most powerful, adding citations, footnotes, and metadata.

## Markdown Syntax: Headers

Use the `#` symbol:

* `# Title (H1)`
* `## Section (H2)`
* `### Subsection (H3)`
* `#### Sub-subsection (H4)`

## Markdown Syntax: Emphasis

* `*italic*` or `_italic_`
* `**bold**` or `__bold__`
* `***bold italic***`
* `~~strikethrough~~`

## Markdown Syntax: Lists I

**Unordered Lists:**
* Item 1
* Item 2
  * Sub-item 2.1
  * Sub-item 2.2

## Markdown Syntax: Lists II

**Ordered Lists:**
1. First step
2. Second step
3. Third step

## Markdown Syntax: Links and Images

* **Link:** `[Link Text](URL)`
  * `[University of Aveiro](https://www.ua.pt)`
* **Image:** `![Alt Text](Path/to/image)`
  * `![Course Logo](../../assets/logo.svg)`

## Markdown Syntax: Code

* **Inline:** Surround with backticks: `` `print("Hello")` ``.
* **Blocks:** Use triple backticks with language identifier.

\```python
def hello():
    print("Hello World")
\```

## Markdown Syntax: Tables and Tasks (GFM)

| Task | Priority | Status |
|------|----------|--------|
| Plan | High     | Done   |
| Write| Medium   | Active |

-----

* **Task Lists:**
- [x] Complete Class 09
- [x] Research Class 10
- [ ] Write Class 10 slides

## Diagrams in Markdown: Mermaid.js I

Many platforms (GitHub, GitLab, Obsidian) support **Mermaid** for diagrams.

\```mermaid
graph TD
    A[Start] --> B{Is it data?}
    B -- Yes --> C[Process]
    B -- No --> D[End]
\```

## Diagrams in Markdown: Mermaid.js II

Mermaid supports many diagram types:
* **Flowcharts**
* **Sequence Diagrams**
* **Gantt Charts**
* **Class Diagrams**
* **Entity Relationship Diagrams**

It allows you to keep your diagrams **version-controlled** alongside your code.

# LaTeX

## What is LaTeX?

A high-quality typesetting system for technical and scientific documentation.

* **Focus:** Separating content from style.
* **Strength:** Mathematical notation, citations, and large documents.
* **Engine:** Based on TeX, created by Donald Knuth.
* **Standard:** Used for MSc Theses, PhD Dissertations, and Scientific Papers.

## LaTeX Basics: Structure

```latex
\documentclass{article}
\usepackage[utf8]{inputenc}

\title{My Report}
\author{Mário Antunes}

\begin{document}
\maketitle

\section{Introduction}
Hello world!
\end{document}
```

## LaTeX Basics: Document Classes

The `\documentclass{...}` defines the overall layout:

* **article:** For short reports or papers.
* **report:** For longer documents with chapters (like an MSc Thesis).
* **book:** For full-length books.
* **beamer:** For creating presentation slides.

## Beamer: Presentations in LaTeX

Beamer allows you to create PDF slides using LaTeX syntax.

* **Frames:** Each slide is a `\begin{frame} ... \end{frame}`.
* **Themes:** Professional, academic looks (e.g., `Warsaw`, `Madrid`).
* **Overlays:** Control when content appears (e.g., `\pause`).
* **Consistency:** The math and code in your slides will look identical to your paper/thesis.

## LaTeX Basics: Packages

Packages extend LaTeX's capabilities:

* **graphicx:** For including images (`\includegraphics`).
* **hyperref:** For clickable links and cross-references.
* **geometry:** For changing page margins.
* **amsmath:** For advanced mathematical symbols.
* **biblatex:** For managing bibliographies.

## LaTeX Basics: Mathematics I

LaTeX is the industry standard for writing math.

* **Inline:** $E = mc^2$.
* **Display:** 
  $$\int_{a}^{b} f(x) dx$$

## LaTeX Basics: Mathematics II

* **Fractions:** `\frac{numerator}{denominator}`
* **Sums:** `\sum_{i=0}^{n} x_i`
* **Greek Letters:** `\alpha, \beta, \gamma, \pi`
* **Sub/Superscripts:** `x_i, x^2`
* **Matrices:** `\begin{pmatrix} a & b \\ c & d \end{pmatrix}`

## Citations with BibTeX/BibLaTeX

Managing references manually is a nightmare.

1.  Create a `.bib` file with your references.
    ```bibtex
    @article{einstein1905,
      author = {Albert Einstein},
      title = {On the Electrodynamics of Moving Bodies},
      journal = {Annalen der Physik},
      year = {1905}
    }
    ```
2.  Cite it: `Einstein showed that \cite{einstein1905}...`

# Pandoc

## The "Swiss-army knife" of Documents

Pandoc is a command-line tool to convert files from one markup format into another.

* **Input:** Markdown, LaTeX, HTML, DOCX, EPUB.
* **Output:** PDF, HTML, LaTeX, Slides (Beamer/RevealJS), DOCX.
* **Command:** `pandoc input.md -o output.pdf`

## How Pandoc Works I

1. **Reader:** Parses the input (e.g., Markdown).
2. **Intermediate Representation:** Converts to an internal "AST" (Abstract Syntax Tree).
3. **Writer:** Generates the output (e.g., PDF via LaTeX).

## How Pandoc Works II: Metadata

* **YAML Metadata:** Use a `config.yml` or a block at the top of the `.md`.
* It controls titles, authors, dates, and template variables.
* **Templates:** You can provide your own LaTeX or HTML template to control every detail of the output.

## Pandoc Filters

Pandoc's power can be extended using **filters**.

* Filters are small scripts that modify the document's internal AST before it is written.
* **Types:** Python filters (`panflute`), Lua filters (built-in).
* **Usage:**
  * Automatically number figures.
  * Transform table formats.
  * Inject custom LaTeX for specific blocks.

# Useful Documents

## The Modern CV

* **Format:** Keep it simple, searchable, and professional.
* **Tools:** Use LaTeX templates (e.g., `moderncv`) or Markdown + Pandoc.
* **Key Sections:** Education, Experience, Skills, Projects.
* **Pro Tip:** Keep your CV in a Git repository and generate multiple versions (e.g., detailed vs 1-page).

## The MSc Thesis: Typical Structure

1.  **Front Matter:** Title, Abstract, Acknowledgments, ToC.
2.  **Introduction:** Motivation, Problem, Objectives, Contributions.
3.  **State of the Art:** Literature review and comparison.
4.  **Proposed Solution/Methodology:** Architecture, design, and implementation.
5.  **Evaluation:** Experimental setup, results, and discussion.
6.  **Conclusion:** Summary and Future Work.
7.  **Back Matter:** Bibliography, Appendices.

## MSc Thesis: The "Contribution"

The most important part of your thesis is your original contribution.

* It's not just "building a system".
* It's "solving a problem" or "improving a process" using engineering principles.
* You must clearly state **what is new** in your work.

## Project Reports

* **Executive Summary:** For busy managers.
* **Methodology:** How you did it.
* **Findings:** What you discovered.
* **Recommendations:** What should be done next.
* **Automation:** Use a `Makefile` to generate reports from Markdown.

## Python Documentation I: Tools

* **Sphinx:** The industry standard for Python docs.
* **MkDocs:** Modern, fast, and uses Markdown.
* **Docstrings:** Write documentation inside your code.

## Python Documentation II: Docstrings

```python
def calculate_area(radius: float) -> float:
    """Calculates the area of a circle.
    
    Args:
        radius: The radius of the circle (must be positive).
        
    Returns:
        The calculated area.
        
    Raises:
        ValueError: If radius is negative.
    """
    if radius < 0:
        raise ValueError("Radius cannot be negative")
    return 3.14159 * (radius ** 2)
```

# Summary

## Summary

* **Communication:** Is a core engineering skill.
* **Markdown:** For daily notes, READMEs, and quick reports.
* **LaTeX:** For formal academic and high-quality technical documents.
* **Pandoc:** To bridge all formats and automate your workflow.
* **Consistency:** Use professional templates and version control for everything.
