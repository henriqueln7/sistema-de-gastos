:- module(conta, [criaConta/6,
               getNomeConta/2,
               getCodigoConta/2,
               getSaldoConta/2,
               getTipoConta/2,
               getDescricao/2,
               criaStringConta/5,
               listarContas/1,
               getContaPeloCodigo/3,
               existeConta/2]).
% Módulo de Conta

criaConta(NomeConta, Codigo, Saldo, Tipo, Descricao, C) :- C = [[NomeConta, Codigo, Saldo, Tipo, Descricao]].

%Cada Conta é uma lista que contem Nome, Codigo, Saldo, Tipo e Descricao
getNomeConta(Conta, Nome) :- nth0(0, Conta, Nome).
getCodigoConta(Conta, Codigo) :- nth0(1, Conta, Codigo).
getSaldoConta(Conta, Saldo) :- nth0(2, Conta, Saldo).
getTipoConta(Conta, Tipo) :- nth0(3, Conta, Tipo).
getDescricao(Conta, Descricao) :- nth0(4, Conta, Descricao).


criaStringConta(Nome, Codigo, Saldo, Tipo, Descricao) :-
	write("Nome da conta: "), write(Nome),nl,
	write("Código da conta: "), write(Codigo),nl,
	write("Saldo: "), write(Saldo),nl,
	write("Tipo da conta: "), write(Tipo),nl,
	write("Descricao da conta: "), write(Descricao),nl.


listarContas([]).
listarContas([H|T]) :- 
	getNomeConta(H, Nome),
	getCodigoConta(H, Codigo),
	getSaldoConta(H, Saldo),
	getTipoConta(H, Tipo),
	getDescricao(H, Descricao),
	criaStringConta(Nome, Codigo, Saldo, Tipo, Descricao), nl,
	listarContas(T).

%Recebe a lista de contas do usuário e vai retornar a conta com o código requerido
getContaPeloCodigo([H|T], CodigoConta, Conta) :-
	getCodigoConta(H, Codigo),
	(Codigo == CodigoConta -> Conta = H;
		getContaPeloCodigo(T, CodigoConta, Conta)).

existeConta([H|T], CodigoConta) :-
	getCodigoConta(H, Codigo),
	Codigo == CodigoConta;
	existeConta(T, CodigoConta).
	