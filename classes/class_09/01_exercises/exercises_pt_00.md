---
title: Representação e Comunicação de Informação Digital I
---

# Exercícios

## Exercício 1: Processamento de Dados Não Estruturados (Logs)

Neste exercício, usará ferramentas Unix para extrair informação de um log de sistema.
Assuma que tem um ficheiro chamado `access.log` com o seguinte conteúdo:
```text
192.168.1.1 - - [20/Apr/2026:10:00:01] "GET /index.html" 200
192.168.1.5 - - [20/Apr/2026:10:00:05] "GET /images/logo.png" 200
192.168.1.1 - - [20/Apr/2026:10:00:10] "GET /contact.html" 200
192.168.1.10 - - [20/Apr/2026:10:00:15] "GET /admin" 403
192.168.1.1 - - [20/Apr/2026:10:00:20] "GET /index.html" 200
192.168.1.5 - - [20/Apr/2026:10:00:25] "GET /about.html" 200
```

1.  Use o `grep` para encontrar todas as entradas com o código de estado `403` (Forbidden).
2.  Use o `awk` para imprimir apenas os endereços IP (a primeira coluna).
3.  Combine o `awk`, `sort`, e `uniq` para contar quantos pedidos cada endereço IP fez.
4.  Use o `sed` para substituir todas as ocorrências de `GET` por `POST` no output.

-----

## Exercício 2: Processamento de JSON com `jq`

O `jq` é uma ferramenta poderosa para fatiar e transformar dados JSON.
Crie um ficheiro chamado `data.json` com o seguinte conteúdo:
```json
[
  {"id": 1, "name": "Alice", "role": "admin", "active": true},
  {"id": 2, "name": "Bob", "role": "user", "active": false},
  {"id": 3, "name": "Charlie", "role": "user", "active": true},
  {"id": 4, "name": "David", "role": "admin", "active": true}
]
```

1.  Use o `jq` para formatar (prettify) o output JSON.
2.  Extraia apenas o primeiro elemento do array.
3.  Extraia o `name` de todos os utilizadores.
4.  Filtre os utilizadores para mostrar apenas os que estão ativos (`active`).
5.  Filtre os utilizadores para mostrar apenas os que têm o papel de `admin` e estão ativos.

-----

## Exercício 3: Trabalhar com Dados CSV

O CSV é o padrão para dados tabulares. Crie um ficheiro `students.csv`:
```csv
id,name,grade,city
1,Alice,18,Aveiro
2,Bob,14,Porto
3,Charlie,16,Aveiro
4,David,10,Coimbra
```

1.  Use `column -s, -t students.csv` para ver o CSV num formato de tabela legível.
2.  Use o `awk` (com `-F,`) para imprimir apenas os nomes e as notas dos alunos.
3.  Use o `grep` para encontrar alunos de `Aveiro`.
4.  Calcule a nota média usando uma combinação de `awk` e aritmética.

-----

## Exercício 4: Serialização em Python

Neste exercício, escreverá um script Python para converter dados entre formatos.

1.  Crie um script Python `convert.py` que:
    *   Lê o ficheiro `students.csv` criado no Exercício 3.
    *   Converte os dados numa lista de dicionários.
    *   Guarda os dados num novo ficheiro chamado `students.json`.
2.  Adicione funcionalidade ao script para também guardar os dados como um ficheiro `YAML` (requer `PyYAML`).

-----

## Exercício 5: Formatação e Interoperabilidade

1.  Observe o seguinte trecho YAML:
    ```yaml
    server:
      host: 127.0.0.1
      port: 8080
      debug: true
      endpoints:
        - /api/v1
        - /api/v2
    ```
2.  Tente representar a mesma informação em formato JSON.
3.  Discussão: Qual formato é mais fácil de ler? Qual é mais fácil de escrever? Qual usaria para uma API web?
