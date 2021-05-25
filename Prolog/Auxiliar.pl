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
	term_to_atom(Meta, MetaAtomo),
	string_concat(Login, ",", L), 							% Victor,
	string_concat(L, MetaAtomo, StringLoginMeta),			 	% Victor,[DescricaoMeta, ValorAlcancar, ValorPraGuardar, Carteira]
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

% Salva uma meta no arquivo .txt
salvaMeta(Meta) :-
	open('dados/metas.txt',append,Stream),
	write(Stream, Meta),
	write(Stream, "\n"),
	close(Stream).	

%Salva uma lista de usuarios no .txt
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

criaMeta(DescricaoMeta, ValorAlcancar, ValorPraGuardar, Carteira, M) :- M = [DescricaoMeta, ValorAlcancar, ValorPraGuardar, Carteira].

cadastraMeta(Login, DescricaoMeta, ValorAlcancar, ValorPraGuardar, Carteira) :-
	criaMeta(DescricaoMeta, ValorAlcancar, ValorPraGuardar, Carteira, Meta),
	criaStringMeta(Login, Meta, MetaString),
	salvaMeta(MetaString).

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


%Recebe a lista de contas do usuário e vai retornar a conta com o código requerido
getContaPeloCodigo([H|T], CodigoConta, Conta) :-
	getCodigoConta(H, Codigo),
	(Codigo == CodigoConta -> Conta = H;
		getContaPeloCodigo(T, CodigoConta, Conta)).

existeConta([H|T], CodigoConta) :-
	getCodigoConta(H, Codigo),
	Codigo == CodigoConta;
	existeConta(T, CodigoConta).


%TRANSAÇÃO ENTRE CONTAS
realizaTransacao(Login, ValorTransacao, CodigoOrigem, CodigoDestino) :-
	leUsuarios(Usuarios),
	getUsuario(Login, Usuarios, User),
	getSenha(User, Senha),
	getContas(User, ContasUser),
	
	(existeConta(ContasUser, CodigoOrigem), existeConta(ContasUser, CodigoDestino) ->
		getContaPeloCodigo(ContasUser, CodigoOrigem, ContaOrigem),
		getNomeConta(ContaOrigem, NomeContaOrigem),
		getTipoConta(ContaOrigem, TipoOrigem),
		getDescricao(ContaOrigem, DescricaoOrigem),

		getContaPeloCodigo(ContasUser, CodigoDestino, ContaDestino),
		getNomeConta(ContaDestino, NomeContaDestino),
		getTipoConta(ContaDestino, TipoDestino),
		getDescricao(ContaDestino, DescricaoDestino),

		getSaldoConta(ContaOrigem, SaldoOrigem),
		getSaldoConta(ContaDestino, SaldoDestino),

		delete(ContasUser, ContaOrigem, ContasUserSemContaOrigem),
		delete(ContasUserSemContaOrigem, ContaDestino, ContasUserSemContaDestinoEOrigem),
		(ValorTransacao > SaldoOrigem -> write("Saldo insuficiente!");
			SaldoOrigem2 is SaldoOrigem - ValorTransacao, 
			SaldoDestino2 is SaldoDestino + ValorTransacao,
			ContaOrigemNova = [NomeContaOrigem, CodigoOrigem, SaldoOrigem2, TipoOrigem, DescricaoOrigem],
			ContaDestinoNova = [NomeContaDestino, CodigoDestino, SaldoDestino2, TipoDestino, DescricaoDestino],
			append([ContaOrigemNova], [ContaDestinoNova], ContasUserIntermediario),
			append(ContasUserSemContaDestinoEOrigem, ContasUserIntermediario, ContasUsuario),
			criaUserComContas(Login, Senha, ContasUsuario, UserFinal),
			delete(Usuarios, User, UsuariosNovos),
			delete(UsuariosNovos, end_of_file,UsuariosSemEndFile),
			append([UserFinal], UsuariosSemEndFile, UsuariosFinais),
			delete_file('dados/usuarios.txt'),
			salva(UsuariosFinais),
			write("Transferencia efetuada com sucesso!"),
			salvaTransacao(Login, "TRANSFERENCIA", CodigoOrigem, CodigoDestino, ValorTransacao)); 
			write("Conta de Origem ou Destino inválida, tente novamente!"),nl).


criaTransferencia(Login, Tipo, CodigoContaOrigem, CodigoContaDestino, ValorTransacao, Resposta) :-
	transformaStringParaSalvar(Tipo, Tipo2),
	string_concat("transacao(", Login, S),
	string_concat(S, "," ,Str),
	string_concat(Str, Tipo2, S0),
	string_concat(S0, ",", S1),
	string_concat(S1, CodigoContaOrigem, S2),
	string_concat(S2, ",", S3),
	string_concat(S3, CodigoContaDestino, S4),
	string_concat(S4, ",", S5),
	string_concat(S5, ValorTransacao, S6),
	string_concat(S6, ").", R),
	string_to_atom(R, Resposta).

salvaTransacao(Login, Tipo, CodigoOrigem, CodigoDestino, ValorTransacao):-
	criaTransferencia(Login, Tipo, CodigoOrigem, CodigoDestino, ValorTransacao, Transacao),
	open('dados/transferencias.txt',append,Stream),
	write(Stream, Transacao),
	write(Stream, "\n"),
	close(Stream).


transformaStringParaSalvar(String, R):-
	string_concat("""", String, S1),
	string_concat(S1, """", R).

%DEPOSITO

%Quando for depósito, a conta destino é -1, e o tipo é DEPOSITO
depositar(Login, CodigoConta, ValorDeposito) :-
	leUsuarios(Usuarios),
	getUsuario(Login, Usuarios, User),
	getSenha(User, Senha),
	getContas(User, ContasUser),

	(existeConta(ContasUser, CodigoConta) -> 
		getContaPeloCodigo(ContasUser, CodigoConta, Conta),
		getSaldoConta(Conta, Saldo),

		getNomeConta(Conta, NomeConta),
		getTipoConta(Conta, Tipo),
		getDescricao(Conta, Descricao),
		Saldo2 is Saldo + ValorDeposito,
		ContaNova = [NomeConta, CodigoConta, Saldo2, Tipo, Descricao],
		delete(ContasUser, Conta, ContasNovo),
		append(ContasNovo, [ContaNova], ContasUsuario),
		criaUserComContas(Login, Senha, ContasUsuario, UserFinal),
		delete(Usuarios, User, UsuariosNovos),
		delete(UsuariosNovos, end_of_file,UsuariosSemEndFile),
		append([UserFinal], UsuariosSemEndFile, UsuariosFinais),
		delete_file('dados/usuarios.txt'),
		salva(UsuariosFinais),
		write("-----------------------"),
		nl,write("Depósito de R$ "), write(ValorDeposito), write(" realizado com sucesso!"),nl,
		write("-----------------------"),
		salvaTransacao(Login, "DEPOSITO", CodigoConta, "-1", ValorDeposito);
		write("Conta inválida, tente novamente!")).

%SAQUE ===NÃO TESTADO===

%Quando for sacar, a conta destino é -2 e o tipo é SAQUE
sacar(Login, CodigoConta, ValorSaque) :-
	leUsuarios(Usuarios),
	getUsuario(Login, Usuarios, User),
	getSenha(User, Senha),
	getContas(User, ContasUser),

	(existeConta(ContasUser, CodigoConta) -> 
		getContaPeloCodigo(ContasUser, CodigoConta, Conta),
		getSaldoConta(Conta, Saldo),
		getNomeConta(Conta, NomeConta),
		getTipoConta(Conta, Tipo),
		getDescricao(Conta, Descricao),
		(ValorSaque > Saldo -> write("Saldo insuficiente!");
			Saldo2 is Saldo - ValorSaque,
			ContaNova = [NomeConta, CodigoConta, Saldo2, Tipo, Descricao],
			delete(ContasUser, Conta, ContasNovo),
			append(ContasNovo, [ContaNova], ContasUsuario),
			criaUserComContas(Login, Senha, ContasUsuario, UserFinal),
			delete(Usuarios, User, UsuariosNovos),
			delete(UsuariosNovos, end_of_file,UsuariosSemEndFile),
			append([UserFinal], UsuariosSemEndFile, UsuariosFinais),
			delete_file('dados/usuarios.txt'),
			salva(UsuariosFinais),
			write("-----------------------"),
			nl,write("Saque de R$ "), write(ValorSaque), write(" realizado com sucesso!"),nl,
			write("-----------------------"),
			salvaTransacao(Login, "SAQUE", CodigoConta, "-2", ValorSaque);
			write("Conta inválida, tente novamente!"))).

%EXTRATO
getLoginTransacao(transacao(Login,_,_,_,_), Login).
getTipoTransacao(transacao(_,Tipo,_,_,_), Tipo).
getCodigoOrigemTransacao(transacao(_,_,CodigoOrigem,_,_), CodigoOrigem).
getCodigoOrigemTransacao(transacao(_,_,_,CodigoDestino,_), CodigoDestino).
getValorTransacao(transacao(_,_,_,_,Valor), Valor).

leTransferencias(R):-
	open('dados/transferencias.txt',read,Str),
	read_transferencias(Str,Transferencias),
	close(Str),
	delete(Transferencias, end_of_file, NewTransferencias),
	R = NewTransferencias.

read_transferencias(Stream,[]):-
	at_end_of_stream(Stream).

read_transferencias(Stream,[X|L]):-
	\+  at_end_of_stream(Stream),
	read(Stream,X),
	read_transferencias(Stream,L).


geraExtrato(Login) :- 
	leTransferencias(Transferencias),
	pegaTransacoes(Login, Transferencias,[], Resposta),
	criaStringTransferencias(Resposta).

pegaTransacoes(_, [], ListaIntermediaria, Resposta) :- Resposta = ListaIntermediaria.
pegaTransacoes(Login,[H|T],ListaIntermediaria, Resposta) :-
	getLoginTransacao(H, L),
	atom_string(L, StringLogin),
	(Login == StringLogin -> inserir_final(ListaIntermediaria, H, Lista), pegaTransacoes(Login, T, Lista, Resposta);
		pegaTransacoes(Login, T, ListaIntermediaria,Resposta)).


inserir_final([], Y, [Y]).         % Se a lista estava vazia, o resultado é [Y]
inserir_final([I|R], Y, [I|R1]) :- % Senão, o primeiro elemento é igual, e o resto é obtido
    inserir_final(R, Y, R1). 

criaStringTransferencias([]).
criaStringTransferencias([H|T]) :-
	getTipoTransacao(H, Tipo),
	getCodigoOrigemTransacao(H, CodigoOrigem),
	getCodigoOrigemTransacao(H, CodigoDestino),
	getValorTransacao(H, Valor),
	nl,write("Tipo de transação: "), write(Tipo), nl,
	(Tipo == "TRANSFERENCIA" -> 
		write("Código da conta de origem: "), write(CodigoOrigem),nl,
		write("Código da conta de destino: "), write(CodigoDestino), nl, 
		write("Valor da Transferência: "), write(Valor),nl,nl;
		write("Código da conta: "), write(CodigoOrigem),nl,
		write("Valor do Depósito: "), write(Valor),nl,nl),
	criaStringTransferencias(T).