:- module(meta, [criaMeta/5,
               cadastraMeta/5,
               criaStringMeta/3,
               getLoginMeta/2,
               getValoresMeta/2,
               getDescricaoMeta/2,
			   getValorAlcancaMeta/2,
			   getValorGuardarMeta/2,
			   getCarteiraMeta/2,
			   pegaMetasUser/4,
			   exibirMetasUsuario/1,
			   listaMetas/1,
			   exibeMeta/4]).

:- use_module(persistencia).
:- use_module(auxiliar).

criaMeta(DescricaoMeta, ValorAlcancar, ValorPraGuardar, Carteira, M) :- M = [DescricaoMeta, ValorAlcancar, ValorPraGuardar, Carteira].

cadastraMeta(Login, DescricaoMeta, ValorAlcancar, ValorPraGuardar, Carteira) :-
	criaMeta(DescricaoMeta, ValorAlcancar, ValorPraGuardar, Carteira, Meta),
	criaStringMeta(Login, Meta, MetaString),
	salvaMeta(MetaString).

/*
	ENTRADA -> Victor [DescricaoMeta, ValorAlcancar, ValorPraGuardar, Carteira]
	SAIDA -> meta(Victor,[DescricaoMeta, ValorAlcancar, ValorPraGuardar, Carteira]).
*/
criaStringMeta(Login, Meta, Resposta) :-
	term_to_atom(Meta, MetaAtomo),
	string_concat(Login, ",", L), 							% Victor,
	string_concat(L, MetaAtomo, StringLoginMeta),			% Victor,[DescricaoMeta, ValorAlcancar, ValorPraGuardar, Carteira]
	string_concat(StringLoginMeta, ").", StringFinal), 		% Victor,[DescricaoMeta, ValorAlcancar, ValorPraGuardar, Carteira]).
	string_concat("meta(", StringFinal, Resposta).			% meta(Victor,[DescricaoMeta, ValorAlcancar, ValorPraGuardar, Carteira]).


%Pega os "atributos" iniciais da meta(Login e Valores(Descricao, ValorAlcançar, ValorGuardar, Carteira))
getLoginMeta(meta(Login,_), Login).
getValoresMeta(meta(_,Valores), Valores).

%Pegando os "atributos" da meta
getDescricaoMeta([Descricao,_,_,_], Descricao).
getValorAlcancaMeta([_,ValorAlcancar,_,_], ValorAlcancar).
getValorGuardarMeta([_,_,ValorGuardar,_], ValorGuardar).
getCarteiraMeta([_,_,_,Carteira], Carteira).

%Pega as metas de um usuário específico
pegaMetasUser(_, [], ListaIntermediaria, Resposta) :- Resposta = ListaIntermediaria.
pegaMetasUser(Login,[H|T],ListaIntermediaria, Resposta) :-
	getLoginMeta(H, L),
	atom_string(L, StringLogin),
	(Login == StringLogin -> inserir_final(ListaIntermediaria, H, Lista), pegaMetasUser(Login, T, Lista, Resposta);
		pegaMetasUser(Login, T, ListaIntermediaria,Resposta)).

%Exibe as metas do usuário 
exibirMetasUsuario(Login) :-
	leMetas(Metas),
	pegaMetasUser(Login, Metas,[], MetasUsuario),
	nl,write("---------#METAS#----------"),nl,
	(MetasUsuario == [] -> nl,write("*Você ainda não possui metas!"),nl;
	listaMetas(MetasUsuario)).

%Pega todas as metas do usuário para serem exibidas
listaMetas([]).
listaMetas([H|T]):-
	getValoresMeta(H, Valores),
	getDescricaoMeta(Valores, Descricao),
	getValorAlcancaMeta(Valores, ValorAlcancar),
	getValorGuardarMeta(Valores, ValorGuardar),
	getCarteiraMeta(Valores, Carteira),
	exibeMeta(Descricao, ValorAlcancar, ValorGuardar, Carteira),nl,
	listaMetas(T).

%Forma que as metas seão exibidas
exibeMeta(Descricao, ValorAlcancar, ValorGuardar, Carteira) :-
	write("Descricao da meta: "), write(Descricao),nl,
	write("Valor a ser alcançado: "), write(ValorAlcancar),nl,
	write("Aporte mensal: "), write(ValorGuardar),nl,
	write("Quanto você já tem guardado: "), write(Carteira),nl.