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
	(validaUsuario(Login, Senha, L) -> write("Bem vindo "), write(Login), nl, menuUsuario(Login);
	leUsuarios(L),
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
	getUsuario(Login, Usuarios, User), %Guarda em User o usuário que estava cadastrado no arquivo
	adicionaConta(Login, NomeConta,Codigo, Saldo, TipoConta, Descricao, UsuarioFinal),
	atom_string(U, UsuarioFinal),
	delete(Usuarios, User, UsuariosNovo),
	append([U], UsuariosNovo, UsuariosFinais),
	delete(UsuariosFinais, end_of_file,R),
	delete_file('dados/usuarios.txt'),
	salvaTodosUsuarios(R),
	write("Conta adicionada com sucesso"), menuUsuario(Login).

opcoesUsuario(Login, 2) :- write("NOT YET IMPLEMENTED!").

opcoesUsuario(Login, 3):-
	write("\nDescricao da meta: "),
	lerEntrada(DescricaoMeta),
	write("Valor a ser alcancado: "),
	lerEntrada(ValorAlcancar),
	write("Quanto ira guardar por mes: "),
	lerEntrada(ValorPraGuardar),
	write("Quanto ja possui guardado: "),
	lerEntrada(Carteira),
	cadastraMeta(Login, DescricaoMeta, ValorAlcancar, ValorPraGuardar, Carteira), nl, halt.

opcoesUsuario(Login, 4):- write("NOT YET IMPLEMENTED!").
opcoesUsuario(Login, 5):- write("NOT YET IMPLEMENTED!").

opcoesUsuario(Login, 6):- 
	write("\nDigite o valor da transação: "),
	lerEntrada(ValorTransacao),
	write("Código da conta de origem: "),
	lerEntrada(CodigoContaOrigem),
	write("Código da conta de destino: "),
	lerEntrada(CodigoContaDestino),
	
	%FALTA IMPLEMENTAR
	%realizarTransacao(Login, ValorTransacao, CodigoContaOrigem, CodigoContaDestino), nl, halt.

opcoesUsuario(Login, 7):- 
	write("\nDigite o código da conta que você vai fazer o deposito: "),
	lerEntrada(CodigoConta),
	write("Digite o valor a ser depositado: "),
	lerEntrada(ValorDeposito),

	%FALTA IMPLEMENTAR
	%depositar(Login, CodigoConta, ValorDeposito), nl, halt.

opcoesUsuario(Login, 8):- 
	write("\nDigite o código da conta que você vai fazer a retirada: "),
	lerEntrada(CodigoConta),
	write("Digite o valor a ser retirado: "),
	lerEntrada(ValorSaque),

	%FALTA IMPLEMENTAR
	%sacar(Login, CodigoConta, ValorSaque), nl, halt.

opcoesUsuario(Login, 9) :- write('Ate logo '), write(Login), menuInicial.
opcoesUsuario(Login, _) :- write("Opção Inválida, tente novamente.", menuUsuario(Login)).

