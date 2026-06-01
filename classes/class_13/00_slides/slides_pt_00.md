---
title: Ethics, Privacy, and Regulation in Informatics
---

# Ética em Informática

## O Impacto da Recolha e Partilha de Dados {.allowframebreaks}

* **Data is Power**: Na era digital, "Dinheiro é uma coisa, mas dados são poder". Os dados moldam o discurso público, influenciam mercados e governam comportamentos individuais.
* **Consequências no Mundo Real**:
  * **Manipulação Política**: Empresas de análise de dados (ex: Cambridge Analytica) usaram dados pessoais para construir perfis psicográficos, fazendo *micro-targeting* de eleitores e influenciando potencialmente resultados democráticos como o Brexit e as eleições presidenciais dos EUA em 2016.
  * **Fraude Financeira**: Dados vazados ou mal geridos podem levar ao roubo de identidade e perdas financeiras graves, onde as instituições frequentemente descartam responsabilidade culpando os utilizadores por "phishing" ou negligência, apesar de vulnerabilidades sistémicas.
* **O Imperativo Ético**: Como *developers*, devemos reconhecer que por trás de cada *data point* existe um ser humano com direitos fundamentais. Decisões de software impactam vidas, segurança e dignidade.

\begin{center}
\begin{tikzpicture}[scale=0.7, transform shape, >=Stealth, 
    box/.style={draw, fill=blue!10, rounded corners, text width=2.5cm, align=center, font=\scriptsize, minimum height=1cm},
    impact/.style={draw, fill=red!10, rounded corners, text width=2.5cm, align=center, font=\scriptsize, minimum height=1cm}]
    
    \node[box] (data) at (0,0) {Dados Brutos /\\Atividade do User};
    \node[box] (profile) at (3.5,0) {Mapeamento\\Psicográfico};
    \node[box] (target) at (7,0) {Publicidade de\\Micro-Targeting};
    \node[impact] (impact) at (10.5,0) {Impacto Real\\(Eleições / Fraude)};
    
    \draw[->, thick] (data) -- (profile);
    \draw[->, thick] (profile) -- (target);
    \draw[->, thick] (target) -- (impact);
\end{tikzpicture}
\end{center}

## Identificação Indireta {.allowframebreaks}

* **O Mito dos Dados "Anónimos"**: Remover identificadores diretos (como nomes, IDs ou emails) é frequentemente insuficiente para proteger a identidade individual.
* **Definição**: Uma pessoa é "identificável" se puder ser distinguida não apenas diretamente, mas **indiretamente** combinando fatores como localização, idade, género, código postal ou características físicas.
* **Quase-Identificadores**: Atributos que não identificam unicamente alguém por si só, mas que o fazem quando cruzados com outras bases de dados.
* **Riscos de Reidentificação**:
  * Estudos mostram que **87%** da população dos EUA poderia ser identificada de forma única usando apenas três *data points*: **Código Postal, Data de Nascimento e Sexo**.
  * **Exemplo**: O *dataset* do "Netflix Prize" foi anonimizado ao remover nomes. No entanto, investigadores reidentificaram utilizadores específicos e expuseram o seu histórico privado de classificações de filmes cruzando dados (*cross-referencing*) com perfis públicos do IMDb.
* **Lição**: Assumam sempre que os dados podem ser reassociados. Com o aumento do poder computacional, o termo "anonimizado" deve ser tratado com extremo ceticismo técnico.

\begin{center}
\begin{tikzpicture}[scale=0.75, transform shape, >=Stealth,
    table/.style={draw, fill=gray!10, rounded corners, text width=3.3cm, font=\scriptsize, align=center, minimum height=1.2cm},
    process/.style={draw, fill=yellow!20, circle, inner sep=2pt, font=\scriptsize, align=center, minimum size=1.6cm},
    alert/.style={draw, fill=red!10, rounded corners, text width=3.3cm, font=\scriptsize, align=center, minimum height=1.2cm}]
    
    \node[table] (anon) at (0,0) {Dataset Anonimizado\\(Netflix: Zip, DOB, Sexo, Classificações)};
    \node[table] (public) at (4.5,0) {Dataset Público\\(IMDb: Nome, Classificações Públicas)};
    \node[process] (link) at (2.25,-1.8) {Ataque de\\Ligação};
    \node[alert] (result) at (2.25,-3.6) {Perfil Identificado\\(Nome ligado a\\Histórico Privado)};
    
    \draw[->, thick] (anon) -- (link);
    \draw[->, thick] (public) -- (link);
    \draw[->, thick] (link) -- (result);
\end{tikzpicture}
\end{center}

# RGPD (GDPR) e Garantia de Privacidade

## O que é o RGPD? {.allowframebreaks}

* **Regulamento (UE) 2016/679**: O Regulamento Geral sobre a Proteção de Dados (RGPD/GDPR), em vigor desde 25 de maio de 2018.
* **Filosofia Central**: A privacidade é um **direito humano fundamental**, não um luxo. O utilizador é proprietário dos seus dados; as organizações são meras guardiãs temporárias.
* **Âmbito de Aplicação**:
  * **Âmbito Material**: Aplica-se ao tratamento de dados pessoais por meios total ou parcialmente automatizados, ou manual estruturado.
  * **Âmbito Territorial (Alcance Extraterritorial)**: Aplica-se a *qualquer* entidade que processe dados de residentes da UE, independentemente de onde o processamento ocorra (ex: um serviço de cloud baseado nos EUA que vise utilizadores na UE deve cumprir integralmente o RGPD).

\begin{center}
\begin{tikzpicture}[scale=0.72, transform shape, >=Stealth,
    block/.style={draw, fill=blue!10, rounded corners, text width=2.8cm, font=\scriptsize, align=center, minimum height=0.9cm},
    decision/.style={draw, fill=yellow!15, diamond, aspect=1.8, text width=2.1cm, font=\tiny, align=center, inner sep=0pt},
    yesno/.style={font=\tiny\bfseries, color=blue!80!black}]
    
    \node[block] (data) at (0, 2.3) {Tratamento de Dados Pessoais\\(Âmbito Material)};
    
    \node[decision] (estab) at (0, 0.8) {Estabelecimento\\na UE?};
    \node[decision] (target) at (3.5, 0.8) {Oferta de Bens /\\Serviços à UE?};
    \node[decision] (monitor) at (7, 0.8) {Monitorização de\\Users da UE?};
    
    \node[block, fill=green!15] (applies) at (3.5, -1.2) {RGPD APLICA-SE\\(Âmbito Territorial)};
    \node[block, fill=red!15] (noapply) at (7, -1.2) {Fora do Âmbito do RGPD};
    
    \draw[->, thick] (data.south) -- (estab.north);
    
    \draw[->, thick] (estab) -- node[above, yesno] {Não} (target);
    \draw[->, thick] (target) -- node[above, yesno] {Não} (monitor);
    \draw[->, thick] (monitor.south) -- node[left, yesno] {Não} (noapply.north);
    
    \draw[->, thick] (estab.south) |- node[left, yesno, pos=0.3] {Sim} (applies.west);
    \draw[->, thick] (target.south) -- node[left, yesno] {Sim} (applies.north);
    \draw[->, thick] (monitor.south) |- node[right, yesno, pos=0.3] {Sim} (applies.east);
\end{tikzpicture}
\end{center}

## O Nível de Privacidade que Devemos Fornecer {.allowframebreaks}

Os *developers* devem garantir que os sistemas aderem estritamente a estes **6 + 1 princípios chave**:

1. **Liceidade, Lealdade e Transparência**: Sem processamento oculto. Utilizadores devem saber exatamente como e porquê os seus dados são tratados através de políticas claras.
2. **Limitação da Finalidade**: Dados recolhidos para o "Projeto A" não podem ser reutilizados para o "Projeto B" ou perfis de anúncios sem novo consentimento explícito.
3. **Minimização dos Dados**: Recolher apenas o estritamente necessário. Não pedir o número de telefone quando apenas o email é necessário.
4. **Exatidão**: Os dados devem estar corretos e atualizados, oferecendo interfaces de fácil acesso para os utilizadores retificarem incorreções.
5. **Limitação da Conservação**: Apagar dados quando deixarem de ser necessários. Criar rotinas automáticas de eliminação para contas expiradas.
6. **Integridade e Confidencialidade**: Garantir a segurança física e lógica contra acessos não autorizados, perda ou vazamento através de encriptação, controlo de acessos e hashing robusto (ex: bcrypt).
7. **Responsabilidade (Accountability)**: O responsável pelo tratamento (*controller*) deve ser capaz de *demonstrar* a conformidade através de documentação técnica detalhada e logs de auditoria.

\begin{center}
\begin{tikzpicture}[scale=0.72, transform shape, >=Stealth,
    hub/.style={draw, fill=blue!20, circle, text width=2.2cm, font=\scriptsize\bfseries, align=center, minimum size=2.2cm},
    spoke/.style={draw, fill=blue!5, rounded corners, text width=2.4cm, font=\tiny, align=center, minimum height=0.9cm}]
    
    \node[hub] (core) at (0,0) {Princípios\\do RGPD};
    
    \node[spoke] (p1) at (0, 2.4) {1. Liceidade, Lealdade\\e Transparência};
    \node[spoke] (p2) at (3.0, 1.2) {2. Limitação\\da Finalidade};
    \node[spoke] (p3) at (3.0, -1.2) {3. Minimização\\dos Dados};
    \node[spoke] (p4) at (0, -2.4) {4. Exatidão};
    \node[spoke] (p5) at (-3.0, -1.2) {5. Limitação\\da Conservação};
    \node[spoke] (p6) at (-3.0, 1.2) {6. Integridade e\\Confidencialidade};
    
    \draw[<->, thick, blue!60] (core) -- (p1);
    \draw[<->, thick, blue!60] (core) -- (p2);
    \draw[<->, thick, blue!60] (core) -- (p3);
    \draw[<->, thick, blue!60] (core) -- (p4);
    \draw[<->, thick, blue!60] (core) -- (p5);
    \draw[<->, thick, blue!60] (core) -- (p6);
    
    \node[draw=red, text=red!80!black, fill=red!5, font=\scriptsize\bfseries, rounded corners, below=3.1cm of core] (accNode) {7. Accountability (Responsabilidade)};
\end{tikzpicture}
\end{center}

## Privacy by Design & Default {.allowframebreaks}

* **By Design**: Medidas de privacidade devem ser embutidas na própria arquitetura do software desde o início, não adicionadas como um remendo (*patch*) posterior.
    * *Os 7 Princípios Fundacionais*: Proativo, preventivo, predefinição, embutido no design, funcionalidade total (soma positiva), segurança de ponta a ponta e respeito pela privacidade.
* **By Default**: As definições de privacidade mais estritas aplicam-se automaticamente sem intervenção do utilizador (ex: o perfil de rede social deve ser privado por defeito, e a partilha de localização deve ser sempre opt-in).
* **Responsabilidade (Accountability)**: O responsável pelo tratamento (*controller*) deve manter logs detalhados e documentação técnica que permitam demonstrar a conformidade perante as autoridades a qualquer momento.

\begin{center}
\begin{tikzpicture}[scale=0.72, transform shape, >=Stealth,
    box/.style={draw, fill=blue!10, rounded corners, text width=3.8cm, font=\scriptsize, align=center, minimum height=1.1cm},
    title/.style={font=\small\bfseries, color=blue!80!black}]
    
    \node[title] at (0, 0.8) {Privacy by Design};
    \node[box] (d1) at (0, 0) {Integrado no Ciclo de Vida\\(Requisitos $\rightarrow$ Design $\rightarrow$ Código)};
    \node[box] (d2) at (0, -1.5) {Funcionalidade Total\\(Soma-Positiva: Sem Trade-offs)};
    \node[box] (d3) at (0, -3.0) {Segurança Ponta-a-Ponta\\(Proteção Contínua)};
    
    \node[title] at (5, 0.8) {Privacy by Default};
    \node[box] (df1) at (5, 0) {Definições Mais Estritas\\Aplicadas Automaticamente};
    \node[box] (df2) at (5, -1.5) {Minimização de Dados\\por Defeito};
    \node[box] (df3) at (5, -3.0) {Opção do Utilizador\\para Partilhar Mais};
    
    \draw[dashed, thick, gray] (2.5, 1) -- (2.5, -3.8);
\end{tikzpicture}
\end{center}

# AI Act Europeu

## Visão Geral do AI Act {.allowframebreaks}

* **Abordagem Baseada no Risco**: O AI Act categoriza os sistemas de Inteligência Artificial com base no risco potencial que representam para a segurança, meios de subsistência e direitos fundamentais.
* **As 4 Categorias de Risco**:
  * **Risco Inaceitável**: Banido de imediato (ex: *social scoring*, manipulação comportamental cognitiva e identificação biométrica remota em tempo real em espaços públicos pelas forças de segurança, com poucas exceções).
  * **Risco Elevado**: Permitido mas estritamente regulado (ex: IA na educação, triagem de currículos para emprego, infraestruturas críticas, diagnóstico médico).
  * **Risco Limitado**: Obrigações de transparência (ex: *chatbots* devem revelar que são IA).
  * **Risco Mínimo**: Não regulado (ex: filtros de *spam*).

\begin{center}
\begin{tikzpicture}[scale=0.72, transform shape, >=Stealth,
    label/.style={font=\scriptsize, align=left, text width=5cm}]
    
    % Desenhar as camadas como trapezoides
    \draw[fill=red!40, draw=red] (-0.6, 1.8) -- (0.6, 1.8) -- (0.3, 2.7) -- (-0.3, 2.7) -- cycle;
    \node[white, font=\scriptsize\bfseries] at (0, 2.25) {Inaceitável};
    
    \draw[fill=orange!40, draw=orange] (-1.5, 0.8) -- (1.5, 0.8) -- (1.1, 1.7) -- (-1.1, 1.7) -- cycle;
    \node[white, font=\scriptsize\bfseries] at (0, 1.25) {Risco Elevado};
    
    \draw[fill=yellow!50, draw=yellow!80!black] (-2.5, -0.2) -- (2.5, -0.2) -- (2.0, 0.7) -- (-2.0, 0.7) -- cycle;
    \node[black, font=\scriptsize\bfseries] at (0, 0.25) {Risco Limitado};
    
    \draw[fill=green!40, draw=green] (-3.5, -1.2) -- (3.5, -1.2) -- (3.0, -0.3) -- (-3.0, -0.3) -- cycle;
    \node[white, font=\scriptsize\bfseries] at (0, -0.75) {Risco Mínimo};
    
    % Descrições de texto
    \node[label, anchor=west] at (3.8, 2.25) {\textbf{Proibido}: Pontuação social, biometria em tempo real (com exceções)};
    \node[label, anchor=west] at (3.8, 1.25) {\textbf{Regulado}: IA na saúde, triagem de CVs, infraestruturas críticas};
    \node[label, anchor=west] at (3.8, 0.25) {\textbf{Transparência}: Chatbots, deepfakes, conteúdos gerados por IA};
    \node[label, anchor=west] at (3.8, -0.75) {\textbf{Não Regulado}: Filtros de spam, videojogos, analítica básica};
\end{tikzpicture}
\end{center}

## Privacidade e Auditabilidade em IA {.allowframebreaks}

* **Relação com a Privacidade**: Sistemas de IA de alto risco devem correr sobre dados de treino de alta qualidade, representativos e imparciais para evitar discriminações. Devem aderir aos princípios do RGPD, como a governança e segurança de dados.
* **Requisitos de Auditabilidade**:
  * **Logging**: Os sistemas devem registar eventos de funcionamento automaticamente (*logs*) para rastrear a sua operação e detetar vieses ou falhas em tempo real.
  * **Documentação Técnica**: Os *developers* devem construir e manter documentação detalhada sobre a arquitetura do algoritmo, o processo de treino e critérios de validação.
  * **Supervisão Humana**: Desenhar sistemas para permitir supervisão por pessoas naturais, que podem intervir, corrigir ou anular decisões:
    1. *Human-in-the-loop (HITL)*: Intervenção e aprovação humana ativa em cada decisão.
    2. *Human-on-the-loop (HOTL)*: Monitorização ativa com capacidade de override técnico.
    3. *Human-in-command (HIC)*: Supervisão geral sobre a aplicação e desativação do sistema.

\begin{center}
\begin{tikzpicture}[scale=0.75, transform shape, >=Stealth,
    box/.style={draw, fill=blue!10, rounded corners, text width=2.4cm, font=\scriptsize, align=center, minimum height=1cm},
    system/.style={draw, fill=purple!10, rounded corners, text width=2.2cm, font=\scriptsize\bfseries, align=center, minimum height=1cm},
    log/.style={draw, fill=gray!15, rounded corners, text width=2.2cm, font=\scriptsize, align=center, minimum height=1cm}]
    
    \node[box] (input) at (0, 0) {Dados de Treino\\de Alta Qualidade};
    \node[system] (ai) at (3.2, 0) {Sistema de IA\\(Risco Elevado)};
    \node[box] (human) at (3.2, 1.8) {Supervisão Humana\\(HITL / HOTL)};
    \node[box] (output) at (6.4, 0) {Decisão\\Conforme};
    \node[log] (logs) at (3.2, -1.8) {Logs Auditoria\\e Doc. Técnica};
    
    \draw[->, thick] (input) -- (ai);
    \draw[->, thick] (ai) -- (output);
    \draw[<->, thick] (ai) -- (human);
    \draw[->, thick] (ai) -- (logs);
    \draw[->, thick, dashed] (human) -| (logs);
\end{tikzpicture}
\end{center}

# Como nos Protegermos e aos Nossos Utilizadores

## Garantir Proteção: Medidas Técnicas {.allowframebreaks}

* **Pseudonimização**: Tratamento de dados de forma a que estes já não possam ser atribuídos a um titular específico sem informação adicional (chaves), que deve ser mantida separada e protegida.
* **Anonimização**: Remoção irreversível de todos os identificadores diretos e indiretos.
  * *Nota Legal*: Dados verdadeiramente anonimizados caem completamente fora do âmbito do RGPD. No entanto, provar matematicamente a irreversibilidade da anonimização (ex: contra futuros ataques de ligação) é extremamente difícil.
* **Encriptação**: O padrão de segurança obrigatório para dados sensíveis:
  * *Em Trânsito*: Dados que viajam na rede (TLS 1.3).
  * *Em Repouso*: Dados armazenados em discos ou bases de dados (AES-256).

\begin{center}
\begin{tikzpicture}[scale=0.72, transform shape, >=Stealth,
    data/.style={draw, fill=gray!10, rounded corners, text width=2.4cm, font=\scriptsize, align=center, minimum height=1cm},
    proc/.style={draw, fill=blue!15, rounded corners, text width=2.6cm, font=\scriptsize, align=center, minimum height=1cm},
    key/.style={draw, fill=yellow!15, circle, font=\tiny, align=center, inner sep=1pt}]
    
    \node[data] (raw) at (0, 0) {Dados Brutos\\(ID Direta:\\Nome, Email)};
    
    \node[proc] (pseudo) at (3.8, 1.2) {Pseudonimização\\(Tokenização / Hash)};
    \node[data, fill=green!10] (pdata) at (7.8, 1.2) {Dados Pseudonim.\\(Reversível com chave)};
    \node[key] (keyNode) at (5.8, 2.3) {Mapeamento\\de Chave Seguro};
    
    \node[proc] (anon) at (3.8, -1.2) {Anonimização\\(Agregação / Ruído)};
    \node[data, fill=green!15] (adata) at (7.8, -1.2) {Dados Anonimizados\\(Irreversível)};
    
    \draw[->, thick] (raw) |- (pseudo);
    \draw[->, thick] (raw) |- (anon);
    \draw[->, thick] (pseudo) -- (pdata);
    \draw[->, thick] (anon) -- (adata);
    \draw[->, thick, dashed] (keyNode) -| (pdata);
    \draw[->, thick, dashed] (keyNode) -| (pseudo);
\end{tikzpicture}
\end{center}

## Garantir Proteção: Medidas de Processo {.allowframebreaks}

* **Avaliação de Impacto sobre a Proteção de Dados (DPIA/AIPD)**:
  * Obrigatória antes de iniciar qualquer projeto de tratamento com riscos elevados (ex: vigilância de espaços públicos, processamento em larga escala de dados de saúde).
  * **Os 4 Passos Essenciais**:
    1. **Descrever**: Documentar as operações de processamento e finalidades.
    2. **Avaliar**: Analisar a necessidade e proporcionalidade dos dados recolhidos.
    3. **Identificar**: Mapear os potenciais riscos para os direitos e liberdades.
    4. **Definir**: Estabelecer medidas técnicas e organizativas para mitigar os riscos.
* **Gestão de Consentimento**: O consentimento sob o RGPD deve ser **livre, específico, informado e explícito**. Caixas pré-assinaladas ou cláusulas ocultas são legalmente inválidas. Deve ser tão fácil retirar o consentimento como o dar.

\begin{center}
\begin{tikzpicture}[scale=0.75, transform shape, >=Stealth,
    dpiastep/.style={draw, fill=blue!10, rounded corners, text width=2.6cm, font=\scriptsize, align=center, minimum height=1cm}]
    
    \node[dpiastep] (s1) at (0, 1.2) {1. Descrever\\o Tratamento};
    \node[dpiastep] (s2) at (3.6, 1.2) {2. Avaliar Necessidade\\e Proporcionalidade};
    \node[dpiastep] (s3) at (3.6, -1.2) {3. Identificar Riscos\\para os Direitos};
    \node[dpiastep] (s4) at (0, -1.2) {4. Definir Medidas\\de Mitigação};
    
    \draw[->, thick] (s1) -- (s2);
    \draw[->, thick] (s2) -- (s3);
    \draw[->, thick] (s3) -- (s4);
    \draw[->, thick] (s4) -- (s1);
\end{tikzpicture}
\end{center}

## Proteermo-nos (Como Profissionais) {.allowframebreaks}

* **Responsabilidade Clara**:
  * **Responsável pelo Tratamento (Controller)**: A entidade que determina as finalidades e meios do tratamento dos dados. Detém a responsabilidade jurídica última.
  * **Subcontratante (Processor)**: A entidade que trata os dados pessoais em nome e sob as instruções do responsável pelo tratamento.
  * *Dever do Programador*: Mesmo sob instruções, o programador deve alertar se as ordens violarem as leis de proteção de dados e garantir a segurança lógica do software.
* **Vigilância Contínua**:
  * Monitorizar riscos de reidentificação à medida que os volumes de dados crescem (*big data*).
  * Conhecer o enquadramento de **Transferências Internacionais de Dados** (ex: cláusulas contratuais-tipo - SCCs, e regimes de adequação ao guardar dados em servidores nos EUA).

\begin{center}
\begin{tikzpicture}[scale=0.72, transform shape, >=Stealth,
    actor/.style={draw, fill=blue!10, rounded corners, text width=3.2cm, font=\scriptsize, align=center, minimum height=1.1cm},
    user/.style={draw, fill=gray!10, circle, font=\scriptsize\bfseries, align=center, minimum size=1.5cm}]
    
    \node[user] (subject) at (0, 0) {Titular\\dos Dados\\(Utilizador)};
    \node[actor, fill=green!10] (controller) at (4, 1.2) {Responsável Tratamento\\(Define Meios e Fins)};
    \node[actor, fill=yellow!10] (processor) at (4, -1.2) {Subcontratante\\(Executa Trabalho Técnico)};
    
    \draw[->, thick] (subject) -- node[above, sloped, font=\tiny] {Consentimento / Dados} (controller);
    \draw[->, thick] (controller) -- node[right, font=\tiny] {Contrato / Instruções} (processor);
    \draw[->, thick, dashed] (processor) -- node[below, sloped, font=\tiny] {Tratamento Seguro} (subject);
    
    \node[draw=red, text=red!80!black, fill=red!5, font=\tiny, rounded corners, right=0.5cm of controller] (liab) {Responsabilidade Última};
    \draw[->, red, thick] (liab) -- (controller);
\end{tikzpicture}
\end{center}

## Recursos Adicionais

1. **Textos Legais Oficiais**:
  * [RGPD (UE 2016/679) Texto Completo](https://eur-lex.europa.eu/eli/reg/2016/679/oj)
  * [Texto do AI Act Europeu](https://artificialintelligenceact.eu/)
2. **Manuais**:
  * *[Handbook on European Data Protection Law](https://fra.europa.eu/en/publication/2018/handbook-european-data-protection-law-2018-edition)* (FRA/Conselho da Europa).
3. **Orientação Institucional**:
  * Contactos do *Data Protection Officer* (DPO) na tua instituição [aqui](https://www.ua.pt/pt/rgpd/page/24346)
  * CNPD (Comissão Nacional de Proteção de Dados) [diretrizes](https://www.cnpd.pt/cidadaos/direitos/).
