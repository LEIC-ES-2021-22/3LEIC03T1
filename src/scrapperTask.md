# Scrapper Implementation Flow

## Objetivo Inicial.
Enviar para o catalogo o nome do livro que pesquisamos URL
https://catalogo.up.pt/F/?func=bor-info&request=Nome+Do+Livro

**em network_router.dart temos exemplos de requests a serem feitos.

- Pesquisar por < !-- filename: short-a-body-->
- Informação: 
    - 1º td: número do livro na pesquisa (nao usamos, provavelmente)
    - 2º td: Select row (nao usamos, provavelmente)
    - 3º td: Autor
    - 4º td: Título
    - 5º td: Ano
    - 6º td: Tipo de documento (eg. Livro, não usamos)
    - 7º td: Exemplares ( não usamos )
    - 8º td: Google Books com imagem, isbn, link google, 
    - 9º td: Image
    - 10º td: objeto digital

## Passos para o parse:

### Controller
- Vai ter a funcão principal
de parse, recebe a resposta http por argumento
e retorna uma promisse com o conjunto
dos livros (Future<Set<Book>>)

(ver em parser_exams.dart o exemplo parseExams)

### Creator
- Vai ter a função que extrai
os livros. Recebe o state da app (para ter 
acesso à cookie de sessão) e o parser especifico
Esta função cria o conjunto dos livros 
a partir da função criada no controller de parse

(ver extractExams em action_creators.dart)

Esta função sera depois chamada numa outra função
que da dispatch às novas informações e sort

(ver getUserExams)

-----------------------
### Passos de login na app
ver network_router, basicamente criar uma funcao
igual mas com diferente url, que direciona 
para o catalogo

criar um action (action_creator) que 
recebe as informações do user e faz o login
no catalogo. Depois guarda a sessão e o 
estado do login no catalogo

dessa funcao recebemos a sessão que iremos
guardar no state da app (ainda estou a ver
isso)

provavelmente teremos de fazer uma funcao como a
relogin para o catalogo
