# Programação Web

## Introdução

A programação para a Web é um domínio multidisciplinar que evoluiu de simples documentos estáticos para aplicações ricas e interativas que rivalizam com o software nativo de desktop. No centro desta evolução está o JavaScript, a única linguagem de programação que corre nativamente em todos os browsers modernos. Ao contrário do desenvolvimento tradicional, a programação web exige uma compreensão profunda da interação entre o cliente (o browser do utilizador) e o servidor, bem como da natureza assíncrona das redes.

Este capítulo explora os fundamentos do JavaScript moderno, os paradigmas de execução baseados em eventos, e como as frameworks e tecnologias de backend se articulam para criar sistemas complexos e escaláveis. Veremos como o browser interpreta o código, como gerir dados de forma assíncrona e como orquestrar múltiplos serviços utilizando ferramentas de contentorização.

## Fundamentos do JavaScript

O JavaScript (JS) é frequentemente subestimado, sendo por vezes confundido com linguagens de scripting simples. No entanto, é uma linguagem de alto nível, multiparadigma e extremamente versátil. Uma das suas características mais marcantes é a tipagem dinâmica e fraca. Isto significa que as variáveis não estão ligadas a um tipo de dados específico; uma variável que armazena um número pode, linhas depois, armazenar uma string. Embora isto ofereça uma flexibilidade enorme, exige um cuidado redobrado por parte do programador para evitar erros em tempo de execução que não seriam permitidos em linguagens com tipagem estrita.

Outro pilar do JavaScript é a sua orientação a objetos baseada em protótipos. Diferente de linguagens como Java ou C++, onde os objetos são instanciados a partir de classes (moldes), no JavaScript os objetos herdam propriedades e métodos diretamente de outros objetos. Esta estrutura de "clonagem" e delegação permite uma gestão de memória eficiente e uma flexibilidade arquitetural única. Adicionalmente, o JavaScript é executado de forma *single-threaded*, possuindo uma única Pilha de Chamadas (*Call Stack*). Esta restrição significa que o motor do JavaScript só consegue executar uma tarefa de cada vez, o que torna a gestão de operações pesadas ou demoradas um desafio crítico para evitar o congelamento da interface do utilizador.

## Paradigmas de Programação e o Event Loop

A programação web rompe com o modelo sequencial ou procedimental clássico. Num script simples, a execução para e espera por um input do utilizador. No entanto, numa interface gráfica, o programa não pode parar; o utilizador deve poder interagir com botões, ver animações e carregar imagens em simultâneo. Por esta razão, a Web utiliza a **Programação Baseada em Eventos**.

Neste modelo, o programa entra num estado de escuta constante após a inicialização. Em vez de perguntar ativamente se algo aconteceu, o código define funções de resposta (*handlers*) que são disparadas pelo browser quando ocorre uma interação física, como um clique no rato ou uma tecla premida no teclado. Este é o chamado "Princípio de Hollywood": não nos chame, nós chamamos-te.

### O Event Loop em Detalhe

Para gerir esta concorrência sem múltiplas threads, o JavaScript utiliza o **Event Loop**. Quando uma tarefa assíncrona é iniciada (como um `fetch` de dados ou um temporizador), o JavaScript delega esse trabalho às APIs do Browser (escritas em C++ e multi-threaded). Quando a tarefa termina, o resultado é colocado numa Fila de Callbacks. O Event Loop vigia constantemente a Pilha de Chamadas; assim que esta fica vazia, ele move o primeiro item da Fila para a Pilha, garantindo que o código principal nunca bloqueia enquanto espera pela rede ou pelo disco.

```{=latex}
\begin{center}
\begin{tikzpicture}[
    node distance=1.5cm,
    block/.style={draw, rectangle, minimum width=2.5cm, minimum height=1cm, align=center, font=\sffamily\tiny},
    stack/.style={fill=blue!10},
    queue/.style={fill=green!10},
    api/.style={fill=orange!10},
    arrow/.style={-stealth, thick}
]
    % Call Stack
    \node (stack) [block, stack] {Pilha de Chamadas\\(Call Stack)};
    \node (stack_label) [below=0.1cm of stack, font=\tiny\itshape] {LIFO - Execução Síncrona};

    % Web APIs
    \node (api) [block, api, right=3.5cm of stack] {Web APIs / Browser\\(Threads C++)};
    \node [below=0.1cm of api, font=\tiny\itshape] {Fetch, Timers, DOM};

    % Callback Queue
    \node (queue) [block, queue, below=2.5cm of api] {Fila de Callbacks\\(Task Queue)};
    \node [below=0.1cm of queue, font=\tiny\itshape] {FIFO - Tarefas Prontas};

    % Event Loop
    \node (loop) [circle, draw, line width=1pt, minimum size=1.5cm, left=1.8cm of queue] {Event Loop};

    % Connections
    \draw [arrow] (stack.east) -- (api.west) node[midway, above, font=\tiny] {Delegar};
    \draw [arrow] (api.south) -- (queue.north) node[midway, right, font=\tiny] {Concluir};
    \draw [arrow] (queue.west) -- (loop.east);
    
    % Path going around to avoid overlap
    \draw [arrow] (loop.west) -- ++(-2.5cm, 0) |- (stack.west)
        node[near end, left, font=\tiny, text width=1.5cm, align=right] {Mover se\\Pilha Vazia};

\end{tikzpicture}
\end{center}
```

## JavaScript no Browser e o DOM

A interação entre o JavaScript e a página web ocorre através do **Document Object Model (DOM)**. O browser transforma o texto HTML estático numa estrutura de objetos em memória RAM. O JavaScript não edita ficheiros; ele manipula estes objetos. Quando uma propriedade de um objeto DOM é alterada via código, o motor de renderização deteta a mudança e redesenha a parte correspondente do ecrã quase instantaneamente.

A estratégia de carregamento dos scripts é fundamental para a performance. Como o HTML é analisado de cima para baixo, um script pesado colocado no cabeçalho pode bloquear a visualização da página. A prática moderna recomenda o uso do atributo `defer`, que permite descarregar o ficheiro em paralelo com a análise do HTML, executando-o apenas quando a estrutura da página está pronta, mas antes de ser apresentada ao utilizador.

## Comunicação Assíncrona e em Tempo Real

A Web moderna depende da capacidade de trocar dados sem recarregar a página. A **Fetch API** permite realizar pedidos HTTP assíncronos. Utilizando a sintaxe `async/await`, os programadores podem escrever código que parece sequencial mas que, na realidade, liberta a thread principal enquanto aguarda pela resposta do servidor. Isto garante que a interface permanece fluida e responsiva mesmo em ligações lentas.

Para cenários que exigem interatividade instantânea, como chats ou dashboards financeiros, o modelo tradicional de pedido-resposta do HTTP é insuficiente devido à latência de criar novas ligações. Nestes casos, utilizam-se os **WebSockets**. Ao contrário do HTTP, que é bidirecional mas alternado (*half-duplex*), os WebSockets estabelecem um canal de comunicação persistente e *full-duplex* sobre uma única ligação TCP, permitindo que o servidor envie dados ao cliente assim que estes estejam disponíveis, sem necessidade de o cliente perguntar.

## Depuração e Ferramentas de Desenvolvimento

Ao contrário de linguagens compiladas como C++ ou Rust, onde muitos erros são detetados antes mesmo de o programa correr, o JavaScript é uma linguagem interpretada (ou compilada via JIT). Isto significa que os erros ocorrem em tempo de execução (*runtime*). Uma aplicação web pode carregar perfeitamente e funcionar durante minutos, vindo a "crashar" apenas quando o fluxo de execução atinge uma linha específica com um bug, por exemplo, ao clicar num botão raramente utilizado. Esta característica torna a depuração uma competência essencial para qualquer programador web.

O ecossistema web apresenta um desafio único: o código é escrito num editor (IDE) mas executado num ambiente diferente (o browser). Os browsers modernos, como o Chrome e o Firefox, incluem as **DevTools**, um conjunto de ferramentas integradas que permitem inspecionar o estado da aplicação em tempo real. Através do separador "Console", é possível visualizar erros e mensagens de log. No entanto, a depuração profissional vai além do simples uso de `console.log`. A utilização da palavra-chave `debugger` ou a definição de *breakpoints* no separador "Sources" permite pausar a execução do programa, inspecionar a Pilha de Chamadas e avançar linha a linha, observando como os valores das variáveis mudam a cada passo.

Para lidar com o facto de o browser executar frequentemente código minificado ou transpilado (como o código gerado a partir de TypeScript ou React), utilizam-se os **Source Maps**. Estes ficheiros mapeiam o código complexo em execução de volta aos ficheiros originais que o programador escreveu, permitindo que a depuração ocorra num contexto legível e familiar.

## Frameworks Frontend: React e Angular

À medida que as aplicações crescem, gerir o estado dos dados e a sua representação visual torna-se complexo. O principal desafio é garantir que a "Vista" (o que o utilizador vê) está sempre sincronizada com o "Estado" (os dados na memória). Frameworks como o **React** e o **Angular** surgiram para resolver este problema através da programação declarativa.

O React, desenvolvido pelo Facebook, foca-se na criação de componentes reutilizáveis. Utiliza um **DOM Virtual**, uma representação leve em memória que permite calcular as diferenças mínimas necessárias para atualizar o ecrã, otimizando o desempenho. Por outro lado, o Angular, mantido pela Google, é uma framework completa que impõe o uso de TypeScript. Introduz conceitos poderosos como a Injeção de Dependências e a ligação de dados bidirecional (*two-way data binding*), onde as alterações na interface atualizam os dados e vice-versa, de forma totalmente automática.

| Característica | **React** | **Angular** |
| :--- | :--- | :--- |
| **Abordagem** | Biblioteca focada na Vista | Framework completa "all-in-one" |
| **Linguagem** | JavaScript + JSX | **TypeScript** |
| **DOM** | Virtual DOM (Diferenciação) | DOM Real (Deteção de Alterações) |
| **Curva de Aprendizagem** | Média | Elevada |

## Backend e Orquestração com Docker

Embora o JavaScript tenha nascido no browser, tecnologias como o **Node.js** permitiram a sua expansão para o servidor. O Node.js utiliza o motor V8 do Chrome mas adiciona capacidades de interação com o sistema de ficheiros e redes. No ecossistema Python, o **FastAPI** destaca-se pela sua velocidade e pelo uso de dicas de tipo (*type hints*), gerando documentação interativa automaticamente.

A arquitetura moderna de aplicações web baseia-se na separação total entre o Frontend e o Backend. O Frontend é servido como conteúdo estático (HTML/JS), enquanto o Backend expõe uma API (geralmente RESTful). Para garantir que estas peças funcionam em harmonia, utiliza-se o **Docker Compose**. Esta ferramenta permite definir num único ficheiro YAML como os containers do servidor web, da API e da base de dados devem ser criados e como se devem ligar entre si. Um detalhe crítico na configuração de redes é que o JavaScript no browser corre na máquina do utilizador; assim, ele deve comunicar com o Backend através do endereço IP ou domínio exposto para o exterior, e não através dos nomes internos da rede Docker.

## Recursos Adicionais

Para aprofundar os conhecimentos em programação web moderna, recomendam-se as seguintes fontes:

- **[MDN Web Docs](https://developer.mozilla.org/pt-PT/):** A referência definitiva da Mozilla para HTML, CSS e JavaScript.
- **[JavaScript.info](https://javascript.info/):** Um tutorial abrangente que cobre desde os fundamentos até conceitos avançados da linguagem.
- **[React.dev](https://react.dev/):** Documentação oficial do React com exemplos interativos e guias de boas práticas.
- **[FastAPI Documentation](https://fastapi.tiangolo.com/):** Guia completo para a criação de APIs rápidas e modernas com Python.
- **[Docker Curriculum](https://docker-curriculum.com/):** Um guia prático para aprender Docker e orquestração de containers de raiz.
