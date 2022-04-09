# Scrapper Implementation Flow

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
