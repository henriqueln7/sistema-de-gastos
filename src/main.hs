import qualified Usuario as Usuario
import qualified Auxiliar as Auxiliar
import System.IO
import Data.Char
import Data.List


main :: IO ()
main = do
	putStrLn "Bem Vindo!\n"
	menuLogin

-- Menu que vai ser exibido na hora de fazer o cadastrou ou login
menuLogin :: IO()
menuLogin = do
	putStr ("Selecione uma das opções:\n\n" ++ 
		"  (L) Login\n" ++ 
		"  (C) Cadastrar usuário\n" ++ 
		"  (S) Sair\n\n" ++
		"Opção> ")
	
	opcao <- getLine 

	if (toUpperCase opcao) == "L"
		then do
			
			putStr "\nLogin: "
			login <- getLine
			putStr "Senha: "
			senha <- getLine

			fazerLogin login senha

			
	else if (toUpperCase opcao) == "C"
		then do
			
			putStr "\nNome completo: "
			nome <- getLine 
			putStr "Cpf: "
			cpf <- getLine 
			putStr "Email: "
			email <- getLine 
			putStr "Telefone: "
			telefone <- getLine 

			putStrLn "\nA senha deve ter 6 ou mais caracteres e conter 1 caracter especial"
			putStr "Senha: "
			senha <- getLine

			cadastraUsuario nome cpf email telefone senha

			
	else if (toUpperCase opcao) == "S"
		then do
			putStrLn "\nAte logo!"

	else 
		do
			putStrLn "\nOpcao invalida!\n"
			menuLogin

-- Menu que vai ser exibido apos o usuario fazer login
menuUsuario :: IO ()
menuUsuario = do
		putStr ("Selecione uma das opções:\n\n" ++ 
		"  (1) Registar conta de banco\n" ++ 
		"  (2) Registrar cartao de credito\n" ++ 
		"  (3) Verificar saldo total\n" ++ 
		"  (4) Definir metas\n" ++ 
		"  (5) Gerar extrato\n" ++ 
		"  (6) Sair\n\n" ++
		"Opção> ")

	opcao <- getLine 

	if (opcao) == "1"
		then do
			
	else if (opcao) == "2"
		then do
		
	else if (opcao) == "3"
		then do

	else if (opcao) == "4"
		then do

	else if (opcao) == "5"
		then do

	else if (opcao) == "6"
		then do
			putStrLn "\nAte logo!"

	else 
		do
			putStrLn "\nOpcao invalida!\n"
			menuUsuario

-- Faz o login do usuario no programa
fazerLogin :: String -> String -> IO ()
fazerLogin login senha = 
    if validaLogin login senha
        then
            do
            let nomeUsuario = buscaNomePorCpf login
            putStrLn ("Bem vindo " ++ nomeUsuario)
        else 
			putStrLn "Nao foi possivel fazer o login, tente novamente."

-- Verifica se o login e a senha sao validos
validaLogin :: String -> String -> Bool
validaLogin login senha =
	if Auxiliar.existeLogin (login ++ " " ++ senha)
		then True 
		else False


-- Função que irá cadastrar o usuário num arquivo .txt, mantendo um registro dos usuarios cadastrados
cadastraUsuario :: String -> String -> String -> String -> String -> IO ()
cadastraUsuario nome cpf email telefone senha = 
    if validaCadastro nome cpf email telefone senha
        then do
            writeFile "dados/logins.txt" (login ++ " " ++ senha ++ "\n")
			writeFile "dados/usuarios.txt" String
            putStrLn "Cadastro realizado com sucesso"
        else putStrLn "Cadastro não realizado"


-- -- Função que vai ser responsável por validar o cadastro do Usuário
-- -- Login não pode ser vazio
-- -- Senha não pode ser vazia
-- -- senha possui 6 ou mais caracteres
validaCadastro :: String -> String -> String -> String -> String -> Bool
validaCadastro "" cpf email telefone senha = False
validaCadastro nome "" email telefone senha = False
validaCadastro nome cpf "" telefone senha = False
validaCadastro nome cpf email "" senha = False
validaCadastro nome cpf email telefone "" = False

validaCadastro nome cpf email telefone senha = 
    if length senha <= 6
        then False
        else not (null (filter (`elem` ['*', '!', '@', '/', '#']) senha))

-- Recebe uma string e tranforma tudas as letras minusculas em maiusculas
toUpperCase :: String -> String
toUpperCase palavra = [toUpper x | x <- palavra]


