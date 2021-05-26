:- module(usuario, [
	criaStringUser/3,
	criaUserComContas/4,
	listarContasUsuario/2,
	getLogin/2,
	getSenha/2,
	getContas/2
]).

%Responsável por criar uma String que representa o usuario
/*
ENTRADA: criaStringUser(nicolas, senha1#, Resposta)
SAIDA: Resposta = "usuario(nicolas,senha1#)"
*/
criaStringUser(Login, Senha, Resposta) :- 
	atom_string(Login, L), 
	atom_string(Senha, S), 
	string_concat(L, ",", R), 
	string_concat(R, S, StringLoginSenha), 
	string_concat(StringLoginSenha, ",[])", StringFinal), 
	string_concat("usuario(", StringFinal, R4),
	string_concat(R4, ".", Resposta).


criaUserComContas(Login, Senha, Conta, Resposta) :- 
	string_concat(Login, ",", R), 
	string_concat(R, Senha, StringLoginSenha), 
	string_concat(StringLoginSenha, ",", StringLoginSenha2),
	term_to_atom(Conta, ContasAtomo),
	atom_string(ContasAtomo, C),
	string_concat(StringLoginSenha2, C, StringLoginSenhaContas),
	string_concat(StringLoginSenhaContas, ")", R4),
	string_concat("usuario(", R4, R5),
	atom_string(Resp, R5),
	Resposta = Resp.


listarContasUsuario(Usuario, R) :-
	getContas(Usuario, Contas),
	listarContas(Contas, R).

getLogin(usuario(Login,_,_), Login).
getSenha(usuario(_,Senha,_), Senha).
getContas(usuario(_,_,Contas), Contas).



