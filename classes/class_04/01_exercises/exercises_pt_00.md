---
title: Página Web & Publicação
---

# Exercícios

## Guia Prático: Construir & Publicar uma Página Web Estática

**Motivação & Contexto:**  
Neste exercício, você irá construir um site de portfólio pessoal do zero, aprendendo os fundamentos de HTML, CSS e publicação. O objetivo é entender como páginas web modernas são estruturadas, estilizadas e servidas ao mundo. Ao final, você terá um site que pode personalizar e publicar usando ferramentas profissionais.

---

## Instalar Software Necessário (Debian/Ubuntu)

Precisamos configurar nosso sistema Debian (ou baseado em Debian, como Ubuntu). Será necessário um editor de texto, Docker e o plugin 'compose'.

1.  **Atualizar listas de pacotes:** Abra um terminal e execute:

    ```bash
    sudo apt update; sudo apt full-upgrade -y
    sudo apt autoremove -y
    sudo apt autoclean
    ```

2.  **Instalar um editor de texto:** Recomendamos Zed ou Visual Studio Code pelas funcionalidades. [Alunos usando `WSL` podem instalar Zed/VSCode no Windows e conectar à VM.]

    ```bash
    sudo apt install flatpak -y
    flatpak remote-add --if-not-exists flathub \
    https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak --user install flathub dev.zed.Zed -y
    # OU
    flatpak --user install flathub com.visualstudio.code -y
    ```

---

## Exercício 01: Página HTML Minimalista

**Objetivo:** Criar uma página web básica e experimentar com HTML e CSS.

1. Crie uma pasta para seu projeto (ex: `ex01`).
2. Crie um arquivo `index.html` com um esqueleto HTML5 mínimo:
   - Dica: Use `<!DOCTYPE html>`, `<html>`, `<head>`, `<body>`.
   - Adicione um título e um parágrafo curto.
3. Abra sua página em um navegador para verificar se funciona.
4. Adicione um arquivo CSS (`css/style.css`) e faça o link no HTML.
   - Dica: Altere a cor de fundo e a fonte.
   - Experimente usar uma fonte online (ex: [Google Fonts](https://fonts.google.com/)) via `@font-face` ou `<link>`.
5. Experimente estilos básicos (cores, fontes, layout).

---

## Exercício 02: Esqueleto de Portfólio & Mídia

**Objetivo:** Construir uma página de portfólio com estrutura semântica, mídia e publicar.

1. Crie uma pasta para seu portfólio (ex: `ex02`).
2. Construa o esqueleto da página de portfólio:
   - Use HTML semântico: `<header>`, `<nav>`, `<main>`, `<section>`, `<footer>`.
   - Adicione links de navegação para cada seção.
   - Dica: Use `<figure>` e `<img>` para uma foto de perfil. Experimente [placehold.co](https://placehold.co/) para imagens de placeholder.
3. Adicione seções:
   - Sobre Mim: Escreva uma breve biografia.
   - Projetos: Liste seus projetos (use `<ul>` ou `<article>`).
   - Mídia: Incorpore um vídeo e um áudio:
     - [Vídeo](https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4)
     - [Áudio](https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3)
   - Contato: Adicione um link mailto.
4. Estilize sua página com CSS para layout, cores e espaçamento.
5. Publique com Docker e Nginx:
   - Crie um arquivo `compose.yml`.
   - Use as normas mais recentes do Compose.
   - Monte a pasta do seu site como volume.
   - Dica: Veja a [documentação do Docker Compose](https://docs.docker.com/compose/).

---

## Exercício 03: Portfólio Multi-Página, Slideshow, Design Responsivo, SEO

**Objetivo:** Expandir seu portfólio para múltiplas páginas, adicionar slideshow, torná-lo responsivo e melhorar SEO.

1. Use uma estrutura plana (todas as páginas na mesma pasta: `index.html`, `projects.html`, `contact.html`).
2. Navegação:
   - Adicione links entre as páginas.
   - Dica: Use `<nav aria-label="Navegação principal">`.
3. Galeria de Projetos:
   - Use `<section>` e `<article>` para cada projeto.
   - Adicione um slideshow usando apenas HTML/CSS (toggles de rádio, sem JS).
   - Dica: [Exemplo de slideshow só com CSS](https://css-tricks.com/css-only-carousel/).
4. Sobre Mim:
   - Use `<figure>` e `<img>` para sua foto de perfil.
   - Escreva uma breve biografia.
5. Seção de Mídia:
   - Incorpore vídeo e áudio como no exercício 02.
6. Página de Contato:
   - Adicione um formulário de contato com campos para nome, email e mensagem.
   - Use `aria-label="Formulário de contato"` para acessibilidade.
   - Forneça um link mailto.
7. Design Responsivo (Avançado):
    - **Motivação:** Sites modernos devem ter boa aparência em todos os dispositivos—celulares, tablets e desktops. O design responsivo garante que seu site se adapte a diferentes tamanhos e orientações de tela.
    - **Como fazer:**
      - Sempre inclua a meta tag viewport no `<head>`:
        ```html
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        ```
      - Use media queries no CSS para alterar layout e estilos em telas menores:
        ```css
        @media (max-width: 600px) {
            header, main, footer {
                padding: 10px;
                margin: 8px;
                max-width: 100%;
            }
            nav a {
                display: block;
                margin: 8px 0;
            }
            img, video {
                max-width: 100%;
                height: auto;
            }
        }
        ```
      - Teste seu site redimensionando a janela do navegador ou usando emulação de dispositivos nas ferramentas de desenvolvedor.

8. Melhorias de SEO (Avançado):
    - **Motivação:** Search Engine Optimization (SEO) ajuda seu site a ser descoberto por mecanismos de busca e melhora a acessibilidade para usuários.
    - **Como fazer:**
      - Adicione meta tags ao `<head>` de cada página:
        ```html
        <meta name="description" content="Descreva sua página aqui.">
        <meta name="keywords" content="portfólio, desenvolvimento web, estudante">
        <meta name="author" content="Seu Nome">
        ```
      - Use tags HTML semânticas (`<header>`, `<nav>`, `<main>`, `<section>`, `<article>`, `<footer>`) para dar significado ao conteúdo.
      - Certifique-se de que todas as imagens tenham atributos `alt` descritivos.
      - Use títulos claros e descritivos (`<h1>`, `<h2>`, etc.).
      - Adicione atributos `aria-label` à navegação e formulários para acessibilidade:
        ```html
        <nav aria-label="Navegação principal">
            ...
        </nav>
        <form aria-label="Formulário de contato">
            ...
        </form>
        ```

9. Publique com Docker e Nginx:
   - Use um arquivo `compose.yml`.
   - Monte a pasta do seu site como volume.
   - Dica: Veja a [documentação do Docker Compose](https://docs.docker.com/compose/).

---

## Recursos

- [MDN Referência HTML](https://developer.mozilla.org/pt-BR/docs/Web/HTML)
- [MDN Referência CSS](https://developer.mozilla.org/pt-BR/docs/Web/CSS)
- [Google Fonts](https://fonts.google.com/)
- [Placehold.co](https://placehold.co/)
- [Documentação Docker Compose](https://docs.docker.com/compose/)
- [CSS Tricks: Carrossel só com CSS](https://css-tricks.com/css-only-carousel/)
- [MDN Design Responsivo](https://developer.mozilla.org/pt-BR/docs/Learn/CSS/CSS_layout/Responsive_Design)
- [MDN SEO Básico](https://developer.mozilla.org/pt-BR/docs/Glossary/SEO)
- [MDN Acessibilidade](https://developer.mozilla.org/pt-BR/docs/Web/Accessibility)

---

**Lembre-se:**

- Personalize seu conteúdo e experimente layout e estilos.
- Peça ajuda ou consulte a documentação se ficar preso!