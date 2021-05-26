:- module(persistencia, [leUsuarios/1,
               leMetas/1,
               leTransferencias/1,
               read_stream/2,
               salvaMeta/1,
               salvaUsuario/1,
               salvaTransacao/5,
               salva/1]).

:- use_module(transacao).

%LEITURA

%Lê os dados do arquivo usuarios.txt e retorna os usuarios na Lista R passada como parâmetro
leUsuarios(R):-
	open('dados/usuarios.txt',read,Str),
	read_stream(Str,Usuarios),
	close(Str),
	R = Usuarios.

leMetas(R) :- 
	open('dados/metas.txt',read,Str),
	read_stream(Str,Metas),
	close(Str),
	delete(Metas, end_of_file, NewMetas),
    R = NewMetas.

leTransferencias(R):-
	open('dados/transferencias.txt',read,Str),
	read_stream(Str,Transferencias),
	close(Str),
	delete(Transferencias, end_of_file, NewTransferencias),
	R = NewTransferencias.


read_stream(Stream,[]):-
	at_end_of_stream(Stream).

read_stream(Stream,[X|L]):-
	\+  at_end_of_stream(Stream),
	read(Stream,X),
	read_stream(Stream,L).


%SALVAR

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

%Salva uma transacao no banco(Transferencia,Deposito,Saque)
salvaTransacao(Login, Tipo, CodigoOrigem, CodigoDestino, ValorTransacao):-
	criaTransferencia(Login, Tipo, CodigoOrigem, CodigoDestino, ValorTransacao, Transacao),
	open('dados/transferencias.txt',append,Stream),
	write(Stream, Transacao),
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

