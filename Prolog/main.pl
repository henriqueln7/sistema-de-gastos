:- use_module(library(readutil)).

main :- menuInicial, halt.

banner :-write("
░██████╗░░█████╗░░██████╗████████╗███████╗  ███╗░░░███╗███████╗███╗░░██╗░█████╗░░██████╗
██╔════╝░██╔══██╗██╔════╝╚══██╔══╝██╔════╝  ████╗░████║██╔════╝████╗░██║██╔══██╗██╔════╝
██║░░██╗░███████║╚█████╗░░░░██║░░░█████╗░░  ██╔████╔██║█████╗░░██╔██╗██║██║░░██║╚█████╗░
██║░░╚██╗██╔══██║░╚═══██╗░░░██║░░░██╔══╝░░  ██║╚██╔╝██║██╔══╝░░██║╚████║██║░░██║░╚═══██╗
╚██████╔╝██║░░██║██████╔╝░░░██║░░░███████╗  ██║░╚═╝░██║███████╗██║░╚███║╚█████╔╝██████╔╝
░╚═════╝░╚═╝░░╚═╝╚═════╝░░░░╚═╝░░░╚══════╝  ╚═╝░░░░░╚═╝╚══════╝╚═╝░░╚══╝░╚════╝░╚═════╝░
").

menuInicial :-tty_clear,
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
menu("L") :- 
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

Opção> "),nl,halt.

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
	write("Conta: "),
	lerEntrada(Conta),
	usuario(Login, Senha,Conta, User),
	open('dados/usuarios.txt',append, Str),
	writeln(Str, User),
	close(Str),nl,halt.



listaUsuarios(R) :- R is [].




%Le uma entrada e transforma em um string
lerEntrada(Entrada):- read_line_to_codes(user_input, E), atom_string(E,Entrada).

%Le uma entrada e converte para numero
lerNumero(Numero) :- read_line_to_codes(user_input, E), atom_string(E,R), atom_number(R,Numero).

:- dynamic(usuario/3).
usuario(Nome, Senha, User) :- User = usuario(Nome, Senha, []).
usuario(Nome, Senha, Conta, User) :- User = usuario(Nome, Senha, [Conta]).

adicionaConta(Nome, Senha, Conta, NovoUser) :- usuario(Nome, Senha,Contas), append([Conta], Contas, NovasContas), NovoUser = usuario(Nome, Senha, NovasContas).

