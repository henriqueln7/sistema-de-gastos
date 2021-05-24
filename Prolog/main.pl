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
	menu(Opcao),
	halt.
	


menu("S") :- write("Até Logo"),nl, !.

%Menu Login.
menu("L") :- 
	write("Login: "), 
	lerEntrada(Login), 
	write("Senha: "), 
	lerEntrada(Senha), 
	leUsuarios(L),
	(validaUsuario(Login, Senha, L) -> write("Bem vindo "), write(Login), nl, menuUsuario(Login);
		write("\nLogin ou senha incorretos, tente novamente.\n"),nl, menu("L")).

%Tivemos alguns problemas com os caracteres especiais, ai decidimos tirar por enquanto
%Menu Cadastro Usuario.
menu("C") :-
	write("
Crie um login e uma senha
A senha deve ter 6 ou mais caracteres e conter 1 caracter especial('*', '!', '@', '/', '#')\n"
),
	write("\nLogin: "), 
	lerEntrada(Login), 
	atom_string(AtomoLogin,Login), %Atomo Login é o Login mas no tipo Atomo

	write("Senha: "), 
	lerEntrada(Senha),
	string_to_atom(Senha, AtomoSenha), %Atomo Senha é o Senha mas no tipo Atomo
	atom_chars(AtomoSenha,ListaSenha), %Transformando a senha em uma lista para verificações
	
	criaStringUser(Login, Senha, Usuario), %Cria a string usuario(Login,Senha,[])
	
	leUsuarios(Usuarios),
	(existeLogin(AtomoLogin, Usuarios) -> write("Usuario já cadastrado, tente novamente!"), nl, menu("C");
		validaSenha(ListaSenha) -> salvaUsuario(Usuario),
								   write("Usuário cadastrado com sucesso"), menuInicial;
			write("Senha inválida, tente novamente"), nl,menu("C")).


menu(_) :- write("Opção invalida!"),nl, menuInicial.


%Essa parte vai ser responsável por cada opção disponível para o usuário, definidos no menuUsuario(Login). 
% Podemos adicionar aquela função de adicionar dinheiro numa meta como sugerido por Everton para que no futuro ela possa ser eliminada(quando o dinheiro for alcançado)
%O que precisamos fazer agora: Pegar o usuario correspondente cadastrado**


menuUsuario(Login) :-
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
	lerNumero(Opcao), 
	opcoesUsuario(Login, Opcao).


opcoesUsuario(Login, 1) :-
	write("\nNome da conta: "),
	lerEntrada(NomeConta),
	write("Codigo da Conta: "),
	lerEntrada(Codigo),
	write("Saldo: "),
	lerNumero(Saldo),
	write("Tipo da Conta: "),
	lerEntrada(TipoConta),
	write("Descrição da Conta: "),
	lerEntrada(Descricao),
	leUsuarios(Usuarios),
	getUsuario(Login, Usuarios, User),
	adicionaConta(Login, NomeConta,Codigo, Saldo, TipoConta, Descricao, UsuarioFinal),
	delete(Usuarios, User, UsuariosNovo),
	append([UsuarioFinal], UsuariosNovo, UsuariosFinais),
	salvaTodosUsuarios(UsuariosFinais).

opcoesUsuario(Login, 2) :- write("NOT YET IMPLEMENTED!").
opcoesUsuario(Login, 3):- write("NOT YET IMPLEMENTED!").
opcoesUsuario(Login, 4):- write("NOT YET IMPLEMENTED!").
opcoesUsuario(Login, 5):- write("NOT YET IMPLEMENTED!").
opcoesUsuario(Login, 6):- write("NOT YET IMPLEMENTED!").
opcoesUsuario(Login, 7):- write("NOT YET IMPLEMENTED!").
opcoesUsuario(Login, 8):- write("NOT YET IMPLEMENTED!").
opcoesUsuario(Login, 9) :- write('Ate logo '), write(Login), menuInicial.
opcoesUsuario(Login, _) :- write("Opção Inválida, tente novamente.", menuUsuario(Login)).










