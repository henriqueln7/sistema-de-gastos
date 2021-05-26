:- module(auxiliar, [validaSenha/1,
					 checaTamanho/1,
					 getUsuario/3,
					 validaUsuario/3,
					 existeLogin/2,
					 lerEntrada/1,
					 lerNumero/1,
					 transformaStringParaSalvar/2,
					 inserir_final/3]).
:- use_module(conta).
:- use_module(usuario).
:- use_module(persistencia).
:- use_module(meta).
:- use_module(transacao).


%Regra responsável por validar a senha(Se está conforme o esperado, com tamanho e caracter especial)
%Recebo a senha como uma lista já com cada "caracter" da senha(esses caracteres são átomos)
validaSenha(Senha) :- checaTamanho(Senha).
checaTamanho(Senha) :- length(Senha, R), R > 5.

getUsuario(_, [], _):- false.
getUsuario(Login, [H|T], R) :- 
	getLogin(H, L), atom_string(L, StringLogin), 
	Login == StringLogin, R = H; 
	getUsuario(Login, T, R). 

%Validar o usuario na hora do Login
validaUsuario(Login, Senha, [H|T]) :- 
	getLogin(H, L), atom_string(L, StringLogin), 
	getSenha(H,S), atom_string(S, StringSenha),
	Login == StringLogin, Senha == StringSenha; validaUsuario(Login,Senha,T).

%Regra responsável por validar se o login já existe. 
%Ainda tá dando erro quando o usuario n existe(retorna uma excessão), mas tô considerando que por agora a gente só vai cadastrar usuarios diferentes, então a gente pode ignorar isso por enquanto
existeLogin(Login, [H|T]) :- getLogin(H, L), L == Login; existeLogin(Login, T). 


%Le uma entrada e transforma em um string
lerEntrada(Entrada):- read_line_to_codes(user_input, E), atom_string(E,Entrada).

%Le uma entrada e converte para numero
lerNumero(Numero) :- read_line_to_codes(user_input, E), atom_string(E,R), atom_number(R,Numero).


transformaStringParaSalvar(String, R):-
	string_concat("""", String, S1),
	string_concat(S1, """", R).


inserir_final([], Y, [Y]).         % Se a lista estava vazia, o resultado é [Y]
inserir_final([I|R], Y, [I|R1]) :- % Senão, o primeiro elemento é igual, e o resto é obtido
    inserir_final(R, Y, R1). 
