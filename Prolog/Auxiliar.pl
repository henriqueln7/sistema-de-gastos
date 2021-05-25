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

/*
	ENTRADA -> Victor [DescricaoMeta, ValorAlcancar, ValorPraGuardar, Carteira]
	SAIDA -> meta(Victor,[DescricaoMeta, ValorAlcancar, ValorPraGuardar, Carteira]).
*/
criaStringMeta(Login, Meta, Resposta) :-
	string_concat(Login, ",", L), 							% Victor,
	string_concat(L, Meta, StringLoginMeta),			 	% Victor,[DescricaoMeta, ValorAlcancar, ValorPraGuardar, Carteira]
	string_concat(StringLoginMeta, ").", StringFinal), 		% Victor,[DescricaoMeta, ValorAlcancar, ValorPraGuardar, Carteira]).
	string_concat("meta(", StringFinal, Resposta).			% meta(Victor,[DescricaoMeta, ValorAlcancar, ValorPraGuardar, Carteira]).

%Regra responsável por validar a senha(Se está conforme o esperado, com tamanho e caracter especial)
%Recebo a senha como uma lista já com cada "caracter" da senha(esses caracteres são átomos)
validaSenha(Senha) :- checaTamanho(Senha).
checaTamanho(Senha) :- length(Senha, R), R > 5.
checaCaracterEspecial([H|T]) :- member(H, [*, !, @, /, #]); checaCaracterEspecial(T).

%Transforma a String criada no StringUser em um átomo
	%leUsuarios(L),
/*
ENTRADA --- criaUserAtomo("usuario(nicolas, senha2, [])")
SAIDA --- R = 'usuario(nicolas,senha2,[])'
*/
criaUserAtomo(StringUser, R) :- 
	atom_string(R,StringUser).


%Regra responsável por validar se o login já existe. 
%Ainda tá dando erro quando o usuario n existe(retorna uma excessão), mas tô considerando que por agora a gente só vai cadastrar usuarios diferentes, então a gente pode ignorar isso por enquanto
existeLogin(Login, [H|T]) :- getLogin(H, L), L == Login; existeLogin(Login, T). 

%Validar o usuario na hora do Login
validaUsuario(Login, Senha, [H|T]) :- 
	getLogin(H, L), atom_string(L, StringLogin), 
	getSenha(H,S), atom_string(S, StringSenha),
	Login == StringLogin, Senha == StringSenha; validaUsuario(Login,Senha,T).


%Salva o usuário no arquivo .txt
salvaUsuario(Usuario):-
	open('dados/usuarios.txt',append,Stream),
	write(Stream, Usuario),
	write(Stream, "\n"),
	close(Stream).

salva([]).
salva([H|T]) :-
	(compound(H) -> 
		term_to_atom(H, User),
		atom_string(User, StringUser),
		string_concat(StringUser, ".", StringFinal),
		string_to_atom(StringFinal, UserFinal),
		salvaUsuario(UserFinal),
		salva(T); 
		
			atom_string(H, StringUser),
			string_concat(StringUser, ".", StringFinal),
			string_to_atom(StringFinal, UserFinal),
			salvaUsuario(UserFinal),
			salva(T)).


%Quase completo, tá dando um errinho que ainda n consegui ajeitar


%Lê os dados do arquivo usuarios.txt e retorna os usuarios na Lista R passada como parâmetro
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


%Le uma entrada e transforma em um string
lerEntrada(Entrada):- read_line_to_codes(user_input, E), atom_string(E,Entrada).

%Le uma entrada e converte para numero
lerNumero(Numero) :- read_line_to_codes(user_input, E), atom_string(E,R), atom_number(R,Numero).


%Ainda não testado
%adicionaConta(usuario(Login, Senha, Contas), Conta, NovoUser) :- append([Conta], Contas, NovasContas), NovoUser = usuario(Nome, Senha, NovasContas).


getLogin(usuario(Login,_,_), Login).
getSenha(usuario(_,Senha,_), Senha).
getContas(usuario(_,_,Contas), Contas).


getUsuario(_, [], _):- false.
getUsuario(Login, [H|T], R) :- 
	getLogin(H, L), atom_string(L, StringLogin), 
	Login == StringLogin, R = H; 
	getUsuario(Login, T, R). 


% transformaAtomEmString([], UserNovo, R) :- true.
% transformaAtomEmString([H|T], UserNovo, R) :-
% 	transformaAtomEmString(T, UserNovo, Aux),
% 	getLogin(H, Login1),
% 	getLogin(UserNovo, Login2)
% 	() -> R is UserNovo + Aux; R is H + Aux.

criaConta(NomeConta, Codigo, Saldo, Tipo, Descricao, C) :- C = [[NomeConta, Codigo, Saldo, Tipo, Descricao]].



salvaMeta(MetaString) :-
	open('dados/metas.txt', append, Stream),
	write(Stream, MetaString),
	write(Stream, "\n"),
	close(Stream).

criaMeta(DescricaoMeta, ValorAlcancar, ValorPraGuardar, Carteira, M) :- M = [DescricaoMeta, ValorAlcancar, ValorPraGuardar, Carteira].

calculaMeses(_, _, R) :- R = 0.

cadastraMeta(Login, DescricaoMeta, ValorAlcancar, ValorPraGuardar, Carteira) :-
	(ValorAlcancar <= ValorPraGuardar -> write('Você ja possui o valor a ser alcancado!')),!,
	CalculaMeses(ValorAlcancar, ValorPraGuardar, Meses), write("A meta sera alcancada em "), write(Meses), write("meses!"),
	criaMeta(DescricaoMeta, ValorAlcancar, ValorPraGuardar, Carteira, Meta),
	criaStringMeta(Login, Meta, MetaString),
	append(MetaString).

listarContasUsuario(Usuario, R) :-
	getContas(Usuario, Contas),
	listarContas(Contas, R).


listarContas([]).
listarContas([H|T]) :- 
	getNomeConta(H, Nome),
	getCodigoConta(H, Codigo),
	getSaldoConta(H, Saldo),
	getTipoConta(H, Tipo),
	getDescricao(H, Descricao),
	criaStringConta(Nome, Codigo, Saldo, Tipo, Descricao), nl,
	listarContas(T).
	


getNomeConta(Lista, Nome) :- nth0(0, Lista, Nome).
getCodigoConta(Lista, Codigo) :- nth0(1, Lista, Codigo).
getSaldoConta(Lista, Saldo) :- nth0(2, Lista, Saldo).
getTipoConta(Lista, Tipo) :- nth0(3, Lista, Tipo).
getDescricao(Lista, Descricao) :- nth0(4, Lista, Descricao).

criaStringConta(Nome, Codigo, Saldo, Tipo, Descricao) :-
	write("Nome da conta: "), write(Nome),nl,
	write("Código da conta: "), write(Codigo),nl,
	write("Saldo: "), write(Saldo),nl,
	write("Tipo da conta: "), write(Tipo),nl,
	write("Descricao da conta: "), write(Descricao),nl.







