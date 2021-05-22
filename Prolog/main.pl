:- use_module(library(readutil)).
:- include('Auxiliar.pl').

%Preciso fazer ainda
%	*Checagem se já existe Login na base na hora de cadastrar um usuario
main :- menuInicial, halt.
   
banner :-write("
░██████╗░░█████╗░░██████╗████████╗███████╗  ███╗░░░███╗███████╗███╗░░██╗░█████╗░░██████╗
██╔════╝░██╔══██╗██╔════╝╚══██╔══╝██╔════╝  ████╗░████║██╔════╝████╗░██║██╔══██╗██╔════╝
██║░░██╗░███████║╚█████╗░░░░██║░░░█████╗░░  ██╔████╔██║█████╗░░██╔██╗██║██║░░██║╚█████╗░
██║░░╚██╗██╔══██║░╚═══██╗░░░██║░░░██╔══╝░░  ██║╚██╔╝██║██╔══╝░░██║╚████║██║░░██║░╚═══██╗
╚██████╔╝██║░░██║██████╔╝░░░██║░░░███████╗  ██║░╚═╝░██║███████╗██║░╚███║╚█████╔╝██████╔╝
░╚═════╝░╚═╝░░╚═╝╚═════╝░░░░╚═╝░░░╚══════╝  ╚═╝░░░░░╚═╝╚══════╝╚═╝░░╚══╝░╚════╝░╚═════╝░
").

menuInicial :-nl,
	banner,
	write("
Selecione uma das opções abaixo: 

(L) Fazer login 
(C) Cadastrar usuário 
(S) Sair 

Opção> "),
	lerEntrada(Opcao),
	(Opcao =:= "S" -> write("Até Logo!"),nl, !; menu(Opcao)),
	halt.


%Menu Usuario.
menu("L") :- write("Login: "), lerEntrada(Login), write("Senha: "), lerEntrada(Senha), 
	criaStringUser(Login, Senha,User),
	criaUserAtomo(User, U),

(validaLogin(U) ->
	write("
Selecione uma das opções:

(1) Registrar conta de banco
(2) Visualizar contas
(3) Definir metas
(4) Exibir metas
(5) Gerar extrato
(6) Realizar Transação
(7) Depositar na conta
(8) Realizar saque
(9) Sair

Opção> "),
	lerNumero(Entrada), 
	menu(Entrada); 
	write("Login ou senha incorretos, tente novamente"), menu("L")),nl,halt.

%Tivemos alguns problemas com os caracteres especiais, ai decidimos tirar por enquanto
%Menu Cadastro Usuario.
menu("C") :-
	write("
Crie um login e uma senha
A senha deve ter 6 ou mais caracteres e conter 1 caracter especial('*', '!', '@', '/', '#')\n"
),
	write("\nLogin: "), 
	lerEntrada(Login), 
	write("Senha: "), 
	lerEntrada(Senha),
	string_to_atom(Senha, AtomoSenha),
	atom_chars(AtomoSenha,L),
	criaStringUser(Login, Senha, Usuario),
	(validaSenha(L) -> open('dados/usuarios.txt',append, Str),
					   string_concat("'", Usuario, R1),
					   string_concat(R1, "'", R2),
					   string_concat(R2, ".", R3),
					   writeln(Str, R3),
					   close(Str),
					   write("Cadastro efetuado com sucesso"),
					   menuInicial;
		nl, write("Não foi possivel completar seu cadastro"),nl, menu("C")).


%Essa parte vai ser responsável por cada opção disponível para o usuário, definidos no menu("L"). 
% Podemos adicionar aquela função de adicionar dinheiro numa meta como sugerido por Everton para que no futuro ela possa ser eliminada(quando o dinheiro for alcançado)
menu(1):- write("Registrar conta de banco").

menu(2) :- write("Visualizar contas").

menu(3) :- write("Definir metas").

menu(4) :- write("Exibir metas").

menu(5) :- write("Gerar extrato").

menu(6) :- write("Realizar Transação").

menu(7) :- write("Depositar na conta").

menu(8) :- write("Realizar saque").










