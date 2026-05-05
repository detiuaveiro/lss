---
title: Representação e Armazenamento de Informação Digital
---

# Exercícios

## Exercício 1: Identificar a Estrutura de Dados

Para cada uma das seguintes fontes de dados, classifique-as como **Estruturadas**, **Semi-estruturadas** ou **Não Estruturadas**:

1.  Uma tabela de base de dados relacional contendo notas de alunos.
2.  Uma coleção de ficheiros MP3 de um podcast.
3.  Um ficheiro `config.yaml` para um servidor web.
4.  Um PDF digitalizado de uma carta escrita à mão.
5.  Uma resposta JSON de uma API meteorológica.
6.  Uma folha de Excel contendo uma lista de produtos.

---

## Exercício 2: Codificação de Caracteres

1.  Quantos bytes ocupa a string "Hello!" em ASCII?
2.  Quantos bytes ocupa a string "Hello!" em UTF-8?
3.  Porque é que o UTF-8 é preferido em relação ao ASCII para aplicações modernas?
4.  O que acontece se tentar guardar o caracter "ç" num ficheiro codificado como ASCII puro?

---

## Exercício 3: Processamento de Dados Não Estruturados (Logs)

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

1.  Use o `grep` para encontrar todas as entradas com o código de estado `403`.
2.  Use o `awk` para imprimir apenas os endereços IP (a primeira coluna).
3.  Combine `awk`, `sort` e `uniq -c` para contar quantos pedidos cada endereço IP fez.
4.  Use o `sed` para substituir todas as ocorrências de `GET` por `POST` no output.

---

## Exercício 4: JSON, XML e YAML

1.  Converta o seguinte snippet XML num objeto JSON válido:
    ```xml
    <sensor id="DHT11">
        <location>Sala 101</location>
        <readings>
            <reading timestamp="2026-05-01T12:00:00">25.5</reading>
        </readings>
    </sensor>
    ```
2.  Represente a mesma informação em formato YAML.
3.  Use a sintaxe do `jq` para extrair a `location` do seu objeto JSON.

---

## Exercício 5: Processamento de CSV

Tem um ficheiro CSV `students.csv` com o seguinte conteúdo:
```csv
id,name,grade,city
1,Alice,18,Aveiro
2,"Bob, Smith",14,Porto
3,Charlie,16,Aveiro
```

1.  Na linha 2, porque é que o campo do nome está entre aspas duplas?
2.  Use o `awk` (com `-F,`) para imprimir apenas os nomes e as notas.
3.  Calcule a nota média usando o `awk`.

---

## Exercício 6: Python e Pydantic

1.  Escreva um script Python que leia um ficheiro JSON contendo uma lista de utilizadores e os valide usando um modelo Pydantic com `id` (int), `name` (str) e `email` (EmailStr).
2.  O que acontece se um dos emails no JSON for inválido?
