---
title: Projecto 02
---

# Projetos

Formem grupos de dois ou três alunos (excecionalmente, os projetos podem ser feitos individualmente) e selecionem **um** dos seguintes projetos. Todos os projetos serão submetidos via **eLearning** num único ficheiro comprimido (ZIP), seguindo uma estrutura de repositório padrão.

O ficheiro ZIP deve conter todos os scripts relevantes, ficheiros de configuração, um `docker-compose.yml` e um `README.md` com instruções sobre como implementar o projeto. Deve também conter um relatório do projeto em formato `PDF`.

Este é um projeto de quatro semanas (data limite: 22/06/2026). Têm até ao final desta semana para notificar o vosso professor (por e-mail) sobre os elementos do grupo e o tema escolhido (a lista de temas pode ser encontrada [aqui](#temas)).

Não se esqueçam de contactar o vosso professor em caso de dúvidas. Instruções adicionais poderão ser adicionadas.

## Temas

### 1. Sistema de Monitorização Ambiental IoT
* **Descrição:** Simular múltiplos sensores IoT (temperatura, humidade, qualidade do ar) que publicam dados via **MQTT** para um broker central. Um serviço coletor deve armazenar estes dados numa base de dados relacional. Utilizem o **Grafana** (ou um frontend personalizado) para visualizar as tendências históricas e o estado atual de cada sensor. Toda a solução deve ser orquestrada com Docker Compose.
* **Tópicos Principais:** Docker Compose, MQTT (Mosquitto), Persistência SQL, Visualização de Dados.

### 2. Quadro de Tarefas Colaborativo em Tempo Real
* **Descrição:** Construir uma aplicação de gestão de tarefas estilo Kanban onde múltiplos utilizadores podem adicionar, mover e editar tarefas em tempo real. Utilizem **WebSockets** para sincronizar o estado entre todos os clientes ligados instantaneamente. Todas as alterações devem ser persistidas numa base de dados (SQL ou NoSQL) para garantir que os dados não se percam quando os contentores forem reiniciados.
* **Tópicos Principais:** WebSockets, Persistência em Base de Dados, Sincronização de Frontend, Docker Compose.

### 3. Plataforma de Analítica de Finanças Pessoais
* **Descrição:** Criar uma API RESTful para acompanhamento de despesas e receitas pessoais. O sistema deve suportar categorização e múltiplas contas. O frontend deve apresentar gráficos interativos (ex., utilizando **Chart.js** ou **D3.js**) para visualizar padrões de gastos, orçamentos mensais e saúde financeira.
* **Tópicos Principais:** FastAPI/REST, Base de Dados Relacional (MariaDB/Postgres), Gráficos/Visualização, Docker Compose.

### 4. Gestor de Biblioteca de Media com Metadados Automatizados
* **Descrição:** Construir um gestor de biblioteca digital para filmes ou livros. Quando um utilizador adiciona um título, o backend procura metadados ricos (cartazes, classificações, sinopses) numa **API REST externa** (ex., TMDB ou Google Books). Armazene a biblioteca numa base de dados e forneça uma galeria visual com filtros.
* **Tópicos Principais:** Integração de APIs Externas, SQL, Metadados Multimédia, Docker.

### 5. Plataforma de Leilões Online em Tempo Real
* **Descrição:** Implementar um sistema de licitações onde os utilizadores podem participar em leilões ao vivo. Utilizem **WebSockets** para transmitir novas licitações para todos os participantes imediatamente. O sistema deve lidar com a concorrência de licitações utilizando um broker de mensagens (como o Redis) e persistir os resultados finais numa base de dados.
* **Tópicos Principais:** WebSockets, Redis (Pub/Sub), SQL, Transações Atómicas.

### 6. Plataforma de Leilões Online em Tempo Real
* **Descrição:** Implementar um sistema de licitações onde os utilizadores podem participar em leilões ao vivo. Utilizem **WebSockets** para transmitir novas licitações para todos os participantes imediatamente. O sistema deve lidar com a concorrência de licitações utilizando um broker de mensagens e persistir os resultados finais numa base de dados.
* **Tópicos Principais:** WebSockets, Redis (Pub/Sub), SQL, Transações Atómicas.
