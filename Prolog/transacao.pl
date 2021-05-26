:- module(transacao, [
    criaTransferencia/6, 
    geraExtrato/1, 
    pegaTransacoes/4,
    getLoginTransacao/2,
    getTipoTransacao/2,
    getCodigoOrigemTransacao/2,
    getCodigoDestinoTransacao/2,
    getValorTransacao/2,
    criaStringTransferencias/1,
    realizaTransacao/4,
    sacar/3,
    depositar/3]).

:- use_module(persistencia).
:- use_module(auxiliar).
:- use_module(usuario).
:- use_module(conta).

%Cria a String da Transação que vai ser guardada
criaTransferencia(Login, Tipo, CodigoContaOrigem, CodigoContaDestino, ValorTransacao, Resposta) :-
	transformaStringParaSalvar(Tipo, Tipo2), % Auxiliar
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


%EXTRATO
%Gera o extrato com todas as transações realizadas por um usuário
geraExtrato(Login) :- 
	leTransferencias(Transferencias), % Persistencia
	pegaTransacoes(Login, Transferencias,[], Resposta),
	(Resposta == [] -> nl,write("*Você ainda não realizou transações!"),nl;
	criaStringTransferencias(Resposta)).

%Pega todas as transações feitas por um usuário
pegaTransacoes(_, [], ListaIntermediaria, Resposta) :- Resposta = ListaIntermediaria.
pegaTransacoes(Login,[H|T],ListaIntermediaria, Resposta) :-
	getLoginTransacao(H, L),
	atom_string(L, StringLogin),
	(Login == StringLogin -> inserir_final(ListaIntermediaria, H, Lista), pegaTransacoes(Login, T, Lista, Resposta);
		pegaTransacoes(Login, T, ListaIntermediaria,Resposta)).

%Pegando os "atributos" de uma transacao
getLoginTransacao(transacao(Login,_,_,_,_), Login).
getTipoTransacao(transacao(_,Tipo,_,_,_), Tipo).
getCodigoOrigemTransacao(transacao(_,_,CodigoOrigem,_,_), CodigoOrigem).
getCodigoDestinoTransacao(transacao(_,_,_,CodigoDestino,_), CodigoDestino).
getValorTransacao(transacao(_,_,_,_,Valor), Valor).

%Cria a String com as transferências que vão ser exibidas no Extrato
criaStringTransferencias([]).
criaStringTransferencias([H|T]) :-
	getTipoTransacao(H, Tipo),
	getCodigoOrigemTransacao(H, CodigoOrigem),
	getCodigoDestinoTransacao(H, CodigoDestino),
	getValorTransacao(H, Valor),
	nl,write("Tipo de transação: "), write(Tipo), nl,
	(Tipo == "TRANSFERENCIA" -> 
		write("Código da conta de origem: "), write(CodigoOrigem),nl,
		write("Código da conta de destino: "), write(CodigoDestino), nl, 
		write("Valor da Transferência: "), write(Valor),nl,nl;
		write("Código da conta: "), write(CodigoOrigem),nl,
		write("Valor do Depósito: "), write(Valor),nl,nl),
	criaStringTransferencias(T).

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

%SAQUE

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
			salvaTransacao(Login, "SAQUE", CodigoConta, "-2", ValorSaque));
			nl,write("Conta inválida, tente novamente!")).
        

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