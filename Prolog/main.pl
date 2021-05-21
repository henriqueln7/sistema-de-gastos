:- use_module(library(readutil)).

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

(validaLogin(Login,Senha) ->
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

Opção> "); write("Login ou senha incorretos, tente novamente"), menu("L")),nl,halt.

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
					   write(R3),
					   (validaLogin(R3) -> write("Usuario já cadastrado"); 
					   		writeln(Str, R3),
					   		close(Str), nl,
							write("Usuario Cadastrado"),nl, 
							menuInicial); 
		nl, write("Não foi possivel completar seu cadastro(Usuario ou senha já existem)"),nl, menu("C")).
	
criaStringUser(Login, Senha, Resposta) :- 
	atom_string(Login, L), 
	atom_string(Senha, S), 
	string_concat(L, ",", R), 
	string_concat(R, S, StringLoginSenha), 
	string_concat(StringLoginSenha, ",[])", StringFinal), 
	string_concat("usuario(", StringFinal, Resposta).


%Recebo a senha como uma lista já
validaSenha(Senha) :- checaCaracterEspecial(Senha), checaTamanho(Senha).
checaTamanho(Senha) :- length(Senha, R), R > 5.
checaCaracterEspecial([H|T]) :- member(H, [*, !, @, /, #]); checaCaracterEspecial(T). 

%Le uma entrada e transforma em um string
lerEntrada(Entrada):- read_line_to_codes(user_input, E), atom_string(E,Entrada).

%Le uma entrada e converte para numero
lerNumero(Numero) :- read_line_to_codes(user_input, E), atom_string(E,R), atom_number(R,Numero).

%Testando formas de instanciar o usuario, com 3(Login, Senha, Contas) parametros e so com 2(Login, Senha)
:- dynamic(usuario/3).
usuario(Nome, Senha, User) :- User = usuario(Nome, Senha, []).
usuario(Nome, Senha, Conta, User) :- User = usuario(Nome, Senha, [Conta]).

%Ainda não testado
adicionaConta(Nome, Senha, Conta, NovoUser) :- usuario(Nome, Senha,Contas), append([Conta], Contas, NovasContas), NovoUser = usuario(Nome, Senha, NovasContas).

/*
ENTRADA --- criaUserAtomo(nicolas, senha2)
SAIDA --- 'usuario(nicolas,senha2,[])'
*/
criaUserAtomo(StringUser, R) :- 
	atom_string(R,StringUser).

validaLogin(Usuario) :- criaUserAtomo(Usuario, User), leUsuarios(L), verificaLogin(User, L).

verificaLogin(_, []) :- false.
verificaLogin(User, [H|T]) :- User == H; verificaLogin(User, T). 


printErro(Login, Senha) :- (validaLogin(Login, Senha) -> write("Usuario já existe"); write("usuario n existe")).


leUsuarios(R):-
	open('dados/usuarios.txt',read,Str),
	read_users(Str,Usuarios),
	close(Str),
	R = Usuarios.

read_users(Stream,[]):-
	at_end_of_stream(Stream).

read_users(Stream,[X|L]):-
	\+  at_end_of_stream(Stream),
	read(Stream,X),
	read_users(Stream,L).