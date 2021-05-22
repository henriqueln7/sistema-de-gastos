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
	string_concat("usuario(", StringFinal, Resposta).



%Regra responsável por validar a senha(Se está conforme o esperado, com tamanho e caracter especial)
%Recebo a senha como uma lista já com cada "caracter" da senha(esses caracteres são átomos)
validaSenha(Senha) :- checaCaracterEspecial(Senha), checaTamanho(Senha).
checaTamanho(Senha) :- length(Senha, R), R > 5.
checaCaracterEspecial([H|T]) :- member(H, [*, !, @, /, #]); checaCaracterEspecial(T).


%Transforma a String criada no StringUser em um átomo
/*
ENTRADA --- criaUserAtomo("usuario(nicolas, senha2, [])")
SAIDA --- R = 'usuario(nicolas,senha2,[])'
*/
criaUserAtomo(StringUser, R) :- 
	atom_string(R,StringUser).


%Regra responsável por validar se o usuario existe. 
%Ainda tá dando erro quando o usuario n existe(retorna uma excessão), mas tô considerando que por agora a gente só vai cadastrar usuarios diferentes, então a gente pode ignorar isso por enquanto
validaLogin(Usuario) :- criaUserAtomo(Usuario, User), leUsuarios(L), verificaLogin(User, L).

verificaLogin(User, [H|T]) :- User == H; verificaLogin(User, T). 


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
adicionaConta(Nome, Senha, Conta, NovoUser) :- usuario(Nome, Senha,Contas), append([Conta], Contas, NovasContas), NovoUser = usuario(Nome, Senha, NovasContas).