---
title: Ethics, Privacy, and Regulation in Informatics
---

# Ethics in Informatics

## The Impact of Collecting and Sharing Data {.allowframebreaks}

* **Data is Power**: In the digital age, "Money is one thing, but data is power". Data shapes public discourse, influences markets, and governs individual behaviors.
* **Real-world Consequences**:
    * **Political Manipulation**: Data analytics firms (e.g., Cambridge Analytica) have used personal data to construct psychographic profiles, allowing them to micro-target voters and potentially influence democratic outcomes like the Brexit referendum and the 2016 US presidential election.
    * **Financial Fraud**: Leaked or mishandled data can lead to identity theft and severe financial loss. Financial institutions often shift liability by blaming users for "phishing" or negligence despite systemic security vulnerabilities in their own systems.
* **The Ethical Imperative**: As developers, we must recognize that behind every data point is a human being with fundamental rights. Software decisions can impact livelihoods, safety, and dignity.

\begin{center}
\begin{tikzpicture}[scale=0.7, transform shape, >=Stealth, 
    box/.style={draw, fill=blue!10, rounded corners, text width=2.5cm, align=center, font=\scriptsize, minimum height=1cm},
    impact/.style={draw, fill=red!10, rounded corners, text width=2.5cm, align=center, font=\scriptsize, minimum height=1cm}]
    
    \node[box] (data) at (0,0) {Raw User\\Activity / Data};
    \node[box] (profile) at (3.5,0) {Psychographic\\Profiling};
    \node[box] (target) at (7,0) {Micro-Targeted\\Advertising};
    \node[impact] (impact) at (10.5,0) {Real-World Impact\\(Elections / Fraud)};
    
    \draw[->, thick] (data) -- (profile);
    \draw[->, thick] (profile) -- (target);
    \draw[->, thick] (target) -- (impact);
\end{tikzpicture}
\end{center}

## Indirect Identification {.allowframebreaks}

* **The Myth of "Anonymous" Data**: Removing direct identifiers (like names, IDs, or emails) is often highly insufficient to protect individual identity.
* **Definition**: A person is "identifiable" if they can be distinguished not just directly, but **indirectly** by combining auxiliary factors like location, age, gender, zip code, or physical characteristics.
* **Quasi-Identifiers**: Attributes that do not uniquely identify a person on their own, but can do so when linked with other databases.
* **Re-identification Risks**:
    * Studies show that **87%** of the US population could be uniquely identified using only three data points: **Zip Code, Birth Date, and Sex**.
    * **Example**: The "Netflix Prize" dataset was anonymized by removing names. However, researchers re-identified specific users and uncovered their private movie viewing history by cross-referencing and linking anonymous movie ratings with public IMDb profiles.
* **Lesson**: Always assume data can be re-linked. As computational power increases, the term "anonymized" should be treated with extreme technical skepticism.

\begin{center}
\begin{tikzpicture}[scale=0.75, transform shape, >=Stealth,
    table/.style={draw, fill=gray!10, rounded corners, text width=3.3cm, font=\scriptsize, align=center, minimum height=1.2cm},
    process/.style={draw, fill=yellow!20, circle, inner sep=2pt, font=\scriptsize, align=center, minimum size=1.6cm},
    alert/.style={draw, fill=red!10, rounded corners, text width=3.3cm, font=\scriptsize, align=center, minimum height=1.2cm}]
    
    \node[table] (anon) at (0,0) {Anonymized Dataset\\(Netflix: Zip, DOB, Sex, Movie Ratings)};
    \node[table] (public) at (4.5,0) {Public Dataset\\(IMDb: Name, Public Ratings)};
    \node[process] (link) at (2.25,-1.8) {Linkage\\Attack};
    \node[alert] (result) at (2.25,-3.6) {Identified Profile\\(Name linked to\\Private History)};
    
    \draw[->, thick] (anon) -- (link);
    \draw[->, thick] (public) -- (link);
    \draw[->, thick] (link) -- (result);
\end{tikzpicture}
\end{center}

# RGPD (GDPR) and Privacy Assurance

## What is RGPD? {.allowframebreaks}

* **Regulation (EU) 2016/679**: The General Data Protection Regulation (RGPD/GDPR), which went into effect on May 25, 2018.
* **Core Philosophy**: Privacy is a **fundamental human right**, not a luxury. The user owns their data; organizations are merely temporary stewards.
* **Scope of Application**:
    * **Material Scope**: Applies to the processing of personal data wholly or partly by automated means, or structured manual filing systems.
    * **Territorial Scope (Extra-territorial Reach)**: Applies to *any* entity processing data of EU residents, regardless of where the processing takes place (e.g., a US-based cloud service targeting EU users must fully comply with GDPR).

\begin{center}
\begin{tikzpicture}[scale=0.72, transform shape, >=Stealth,
    block/.style={draw, fill=blue!10, rounded corners, text width=2.8cm, font=\scriptsize, align=center, minimum height=0.9cm},
    decision/.style={draw, fill=yellow!15, diamond, aspect=1.8, text width=2.1cm, font=\tiny, align=center, inner sep=0pt},
    yesno/.style={font=\tiny\bfseries, color=blue!80!black}]
    
    \node[block] (data) at (0, 2.3) {Processing of Personal Data\\(Material Scope)};
    
    \node[decision] (estab) at (0, 0.8) {Establishment\\in the EU?};
    \node[decision] (target) at (3.5, 0.8) {Offering Goods /\\Services to EU?};
    \node[decision] (monitor) at (7, 0.8) {Monitoring EU\\Users' Behavior?};
    
    \node[block, fill=green!15] (applies) at (3.5, -1.2) {GDPR APPLIES\\(Territorial Scope)};
    \node[block, fill=red!15] (noapply) at (7, -1.2) {GDPR Out of Scope};
    
    \draw[->, thick] (data.south) -- (estab.north);
    
    \draw[->, thick] (estab) -- node[above, yesno] {No} (target);
    \draw[->, thick] (target) -- node[above, yesno] {No} (monitor);
    \draw[->, thick] (monitor.south) -- node[left, yesno] {No} (noapply.north);
    
    \draw[->, thick] (estab.south) |- node[left, yesno, pos=0.3] {Yes} (applies.west);
    \draw[->, thick] (target.south) -- node[left, yesno] {Yes} (applies.north);
    \draw[->, thick] (monitor.south) |- node[right, yesno, pos=0.3] {Yes} (applies.east);
\end{tikzpicture}
\end{center}

## The Level of Privacy We Must Provide {.allowframebreaks}

Developers must ensure systems strictly adhere to these **6 + 1 key principles**:

1. **Lawfulness, Fairness, & Transparency**: No hidden processing. Users must know exactly how and why their data is processed via clear privacy policies.
2. **Purpose Limitation**: Data collected for "Project A" cannot be reused for "Project B" or ad profiling without obtaining new, specific consent.
3. **Data Minimization**: Collect only what is strictly necessary. Do not ask for phone numbers if you only require an email address.
4. **Accuracy**: Data must be correct and up-to-date, with easy-to-use self-service portals for users to rectify discrepancies.
5. **Storage Limitation**: Delete data when it is no longer needed. Implement automatic database purges for expired accounts.
6. **Integrity & Confidentiality**: Protect data against unauthorized access, loss, or leakage using encryption, strict access controls, and robust hashing (e.g., bcrypt).
7. **Accountability**: The controller must be able to *demonstrate* compliance through detailed technical documentation and audit logs.

\begin{center}
\begin{tikzpicture}[scale=0.72, transform shape, >=Stealth,
    hub/.style={draw, fill=blue!20, circle, text width=2.2cm, font=\scriptsize\bfseries, align=center, minimum size=2.2cm},
    spoke/.style={draw, fill=blue!5, rounded corners, text width=2.4cm, font=\tiny, align=center, minimum height=0.9cm}]
    
    \node[hub] (core) at (0,0) {GDPR Core\\Principles};
    
    \node[spoke] (p1) at (0, 2.4) {1. Lawfulness, Fairness\\\& Transparency};
    \node[spoke] (p2) at (3.0, 1.2) {2. Purpose\\Limitation};
    \node[spoke] (p3) at (3.0, -1.2) {3. Data\\Minimization};
    \node[spoke] (p4) at (0, -2.4) {4. Accuracy};
    \node[spoke] (p5) at (-3.0, -1.2) {5. Storage\\Limitation};
    \node[spoke] (p6) at (-3.0, 1.2) {6. Integrity \&\\Confidentiality};
    
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

* **By Design**: Privacy measures must be embedded directly into the architecture of the software from the very start, rather than added as a patch later.
    * *The 7 Foundational Principles*: Proactive, preventive, default settings, embedded design, full functionality (positive-sum), end-to-end security, and respect for user privacy.
* **By Default**: The strictest privacy settings should apply automatically without user intervention (e.g., a social media profile should be private by default, and location tracking should be opt-in).
* **Accountability**: The controller must maintain thorough logs and technical documentation to prove compliance to supervisory authorities at any time.

\begin{center}
\begin{tikzpicture}[scale=0.72, transform shape, >=Stealth,
    box/.style={draw, fill=blue!10, rounded corners, text width=3.8cm, font=\scriptsize, align=center, minimum height=1.1cm},
    title/.style={font=\small\bfseries, color=blue!80!black}]
    
    \node[title] at (0, 0.8) {Privacy by Design};
    \node[box] (d1) at (0, 0) {Embedded in Lifecycle\\(Requirements $\rightarrow$ Design $\rightarrow$ Code)};
    \node[box] (d2) at (0, -1.5) {Full Functionality\\(Positive-Sum: No Trade-offs)};
    \node[box] (d3) at (0, -3.0) {End-to-End Security\\(Lifecycle Protection)};
    
    \node[title] at (5, 0.8) {Privacy by Default};
    \node[box] (df1) at (5, 0) {Strictest Settings Apply\\Automatically};
    \node[box] (df2) at (5, -1.5) {Data Minimization\\by Default};
    \node[box] (df3) at (5, -3.0) {User Choice Needed\\to Share More};
    
    \draw[dashed, thick, gray] (2.5, 1) -- (2.5, -3.8);
\end{tikzpicture}
\end{center}

# European AI Act

## Overview of the AI Act {.allowframebreaks}

* **Risk-Based Approach**: The AI Act categorizes artificial intelligence systems based on the potential risk they pose to safety, livelihoods, and fundamental human rights.
* **The 4 Risk Categories**:
    * **Unacceptable Risk**: Immediate ban (e.g., social scoring, cognitive behavioral manipulation, and real-time remote biometric identification in public spaces by law enforcement, with minor exceptions).
    * **High Risk**: Permitted but strictly regulated (e.g., AI in education, CV screening for employment, critical infrastructure, healthcare diagnostics).
    * **Limited Risk**: Transparency obligations. Users must be explicitly informed they are interacting with AI (e.g., chatbots, deepfakes, AI-generated text).
    * **Minimal/No Risk**: Unregulated (e.g., standard spam filters, AI in video games).

\begin{center}
\begin{tikzpicture}[scale=0.72, transform shape, >=Stealth,
    label/.style={font=\scriptsize, align=left, text width=5cm}]
    
    % Draw the risk tiers as stacked trapezoids/rectangles
    \draw[fill=red!40, draw=red] (-0.6, 1.8) -- (0.6, 1.8) -- (0.3, 2.7) -- (-0.3, 2.7) -- cycle;
    \node[white, font=\scriptsize\bfseries] at (0, 2.25) {Unacceptable};
    
    \draw[fill=orange!40, draw=orange] (-1.5, 0.8) -- (1.5, 0.8) -- (1.1, 1.7) -- (-1.1, 1.7) -- cycle;
    \node[white, font=\scriptsize\bfseries] at (0, 1.25) {High Risk};
    
    \draw[fill=yellow!50, draw=yellow!80!black] (-2.5, -0.2) -- (2.5, -0.2) -- (2.0, 0.7) -- (-2.0, 0.7) -- cycle;
    \node[black, font=\scriptsize\bfseries] at (0, 0.25) {Limited Risk};
    
    \draw[fill=green!40, draw=green] (-3.5, -1.2) -- (3.5, -1.2) -- (3.0, -0.3) -- (-3.0, -0.3) -- cycle;
    \node[white, font=\scriptsize\bfseries] at (0, -0.75) {Minimal Risk};
    
    % Text descriptions
    \node[label, anchor=west] at (3.8, 2.25) {\textbf{Banned}: Social scoring, real-time biometrics (with exceptions)};
    \node[label, anchor=west] at (3.8, 1.25) {\textbf{Regulated}: AI in health, CV screening, critical infrastructure};
    \node[label, anchor=west] at (3.8, 0.25) {\textbf{Transparency}: Chatbots, deepfakes, AI-generated content};
    \node[label, anchor=west] at (3.8, -0.75) {\textbf{Unregulated}: Spam filters, gaming, basic analytics};
\end{tikzpicture}
\end{center}

## Privacy and Auditability in AI {.allowframebreaks}

* **Relation to Privacy**: High-risk AI systems must operate on high-quality, representative, and unbiased training data to prevent discrimination. They must adhere strictly to GDPR principles such as data governance and security.
* **Auditability Requirements**:
    * **Logging**: Systems must automatically record operational events (logs) to trace their functioning and detect potential biases or failures in real-time.
    * **Technical Documentation**: Developers must construct and maintain detailed documentation describing the algorithm's architecture, training process, and validation criteria.
    * **Human Oversight**: High-risk systems must be designed to accommodate direct human supervision to override or shut down decisions:
        1. *Human-in-the-loop (HITL)*: Active human approval for every decision.
        2. *Human-on-the-loop (HOTL)*: Active human monitoring with intervention capabilities.
        3. *Human-in-command (HIC)*: Oversight over the system's operational scope and lifecycle.

\begin{center}
\begin{tikzpicture}[scale=0.75, transform shape, >=Stealth,
    box/.style={draw, fill=blue!10, rounded corners, text width=2.4cm, font=\scriptsize, align=center, minimum height=1cm},
    system/.style={draw, fill=purple!10, rounded corners, text width=2.2cm, font=\scriptsize\bfseries, align=center, minimum height=1cm},
    log/.style={draw, fill=gray!15, rounded corners, text width=2.2cm, font=\scriptsize, align=center, minimum height=1cm}]
    
    \node[box] (input) at (0, 0) {High-Quality\\Training Data};
    \node[system] (ai) at (3.2, 0) {AI System\\(High Risk)};
    \node[box] (human) at (3.2, 1.8) {Human Oversight\\(HITL / HOTL)};
    \node[box] (output) at (6.4, 0) {Compliant\\Decision};
    \node[log] (logs) at (3.2, -1.8) {Audit Logs\\\& Tech Doc};
    
    \draw[->, thick] (input) -- (ai);
    \draw[->, thick] (ai) -- (output);
    \draw[<->, thick] (ai) -- (human);
    \draw[->, thick] (ai) -- (logs);
    \draw[->, thick, dashed] (human) -| (logs);
\end{tikzpicture}
\end{center}

# How to Protect Ourselves and Our Users

## Guaranteeing Protection: Technical Measures {.allowframebreaks}

* **Pseudonymization**: Reversible processing of data such that it can no longer be attributed to a specific subject without using auxiliary information (keys), which must be kept strictly separated and protected.
* **Anonymization**: Irreversible removal of all direct and indirect identifiers.
    * *Legal Note*: Truly anonymized data falls completely outside the scope of GDPR. However, mathematically proving complete, irreversible anonymity (e.g., against future linkage attacks) is extremely difficult.
* **Encryption**: The mandatory industry standard for sensitive data:
    * *In Transit*: Protecting data flowing over networks (TLS 1.3).
    * *At Rest*: Protecting stored files and databases (AES-256).

\begin{center}
\begin{tikzpicture}[scale=0.72, transform shape, >=Stealth,
    data/.style={draw, fill=gray!10, rounded corners, text width=2.4cm, font=\scriptsize, align=center, minimum height=1cm},
    proc/.style={draw, fill=blue!15, rounded corners, text width=2.6cm, font=\scriptsize, align=center, minimum height=1cm},
    key/.style={draw, fill=yellow!15, circle, font=\tiny, align=center, inner sep=1pt}]
    
    \node[data] (raw) at (0, 0) {Raw Data\\(Direct ID:\\Name, Email)};
    
    \node[proc] (pseudo) at (3.8, 1.2) {Pseudonymization\\(Tokenization / Hash)};
    \node[data, fill=green!10] (pdata) at (7.8, 1.2) {Pseudonymized Data\\(Reversible with key)};
    \node[key] (keyNode) at (5.8, 2.3) {Secure\\Key Map};
    
    \node[proc] (anon) at (3.8, -1.2) {Anonymization\\(Aggregation / Noise)};
    \node[data, fill=green!15] (adata) at (7.8, -1.2) {Anonymized Data\\(Irreversible)};
    
    \draw[->, thick] (raw) |- (pseudo);
    \draw[->, thick] (raw) |- (anon);
    \draw[->, thick] (pseudo) -- (pdata);
    \draw[->, thick] (anon) -- (adata);
    \draw[->, thick, dashed] (keyNode) -| (pdata);
    \draw[->, thick, dashed] (keyNode) -| (pseudo);
\end{tikzpicture}
\end{center}

## Guaranteeing Protection: Process Measures {.allowframebreaks}

* **Data Protection Impact Assessment (DPIA/AIPD)**:
    * Mandatory prior to launching any high-risk processing project (e.g., public space surveillance, large-scale health data processing).
    * **The 4 Essential Steps**:
        1. **Describe**: Document the processing operations and the purposes.
        2. **Assess**: Evaluate the necessity and proportionality of the data collected.
        3. **Identify**: Map out potential risks to user rights and freedoms.
        4. **Define**: Establish technical and organizational measures to mitigate identified risks.
* **Consent Management**: Under GDPR, consent must be **free, specific, informed, and explicit**. Pre-ticked checkboxes or hidden clauses in terms of service are legally invalid. Consent must be as easy to withdraw as it is to give.

\begin{center}
\begin{tikzpicture}[scale=0.75, transform shape, >=Stealth,
    dpiastep/.style={draw, fill=blue!10, rounded corners, text width=2.6cm, font=\scriptsize, align=center, minimum height=1cm}]
    
    \node[dpiastep] (s1) at (0, 1.2) {1. Describe\\Processing};
    \node[dpiastep] (s2) at (3.6, 1.2) {2. Assess Necessity\\\& Proportionality};
    \node[dpiastep] (s3) at (3.6, -1.2) {3. Identify Risks\\to Rights};
    \node[dpiastep] (s4) at (0, -1.2) {4. Define\\Mitigation Measures};
    
    \draw[->, thick] (s1) -- (s2);
    \draw[->, thick] (s2) -- (s3);
    \draw[->, thick] (s3) -- (s4);
    \draw[->, thick] (s4) -- (s1);
\end{tikzpicture}
\end{center}

## Protecting Ourselves (As Professionals) {.allowframebreaks}

* **Clear Liability Rules**:
    * **Controller (Responsável pelo Tratamento)**: The entity that determines the "why" and "how" of data processing. Bears ultimate legal liability under GDPR.
    * **Processor (Subcontratante)**: The entity that processes personal data on behalf of the controller. Handles technical implementation.
    * *Developer Duty*: Even if acting under instructions, developers must warn controllers if instructions violate data protection laws and ensure software is secure.
* **Continuous Vigilance**:
    * Monitor re-identification risks as datasets grow (big data linkages).
    * Maintain awareness of legal framework adjustments for **International Data Transfers** (e.g., standard contractual clauses - SCCs, and adequacy frameworks when using US-based servers).

\begin{center}
\begin{tikzpicture}[scale=0.72, transform shape, >=Stealth,
    actor/.style={draw, fill=blue!10, rounded corners, text width=3.2cm, font=\scriptsize, align=center, minimum height=1.1cm},
    user/.style={draw, fill=gray!10, circle, font=\scriptsize\bfseries, align=center, minimum size=1.5cm}]
    
    \node[user] (subject) at (0, 0) {Data\\Subject\\(User)};
    \node[actor, fill=green!10] (controller) at (4, 1.2) {Controller\\(Determines Purpose/Means)};
    \node[actor, fill=yellow!10] (processor) at (4, -1.2) {Processor\\(Executes Technical Work)};
    
    \draw[->, thick] (subject) -- node[above, sloped, font=\tiny] {Consent / Data} (controller);
    \draw[->, thick] (controller) -- node[right, font=\tiny] {Contract / Instructions} (processor);
    \draw[->, thick, dashed] (processor) -- node[below, sloped, font=\tiny] {Safe Processing} (subject);
    
    \node[draw=red, text=red!80!black, fill=red!5, font=\tiny, rounded corners, right=0.5cm of controller] (liab) {Ultimate Liability};
    \draw[->, red, thick] (liab) -- (controller);
\end{tikzpicture}
\end{center}

## Further Resources

1.  **Official Legal Texts**:
    * [GDPR (EU 2016/679) Full Text](https://eur-lex.europa.eu/eli/reg/2016/679/oj)
    * [European AI Act Text](https://artificialintelligenceact.eu/)
2.  **Handbooks**:
    * [*Handbook on European Data Protection Law*](https://fra.europa.eu/en/publication/2018/handbook-european-data-protection-law-2018-edition) (FRA/Council of Europe).
3.  **Institutional Guidance**:
    * Data Protection Officer (DPO) contacts at your institution [here](https://www.ua.pt/pt/rgpd/page/24346)
    * CNPD (Comissão Nacional de Proteção de Dados) [guidelines](https://www.cnpd.pt/cidadaos/direitos/).
