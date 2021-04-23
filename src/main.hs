import Auxiliar as Auxiliar
import Usuario as Usuario
import Banco as Banco
import System.IO
import System.Directory
import Data.Char
import Data.List
import Data.List.Split (splitOn)




main :: IO ()
main = do
	putStrLn "Bem Vindo!\n"
	menuLogin

-- Menu que vai ser exibido na hora de fazer o cadastrou ou login
menuLogin :: IO()
menuLogin = do
	putStr ("Selecione uma das opções:\n\n" ++ 
		"  (L) Fazer login \n" ++ 
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

			arquivo <- readFile "dados/usuarios.txt"
			
			if existeLogin login arquivo
				then 
					if verificaSenha login senha arquivo
						then fazerLogin login 
						else putStrLn "Senha incorreta. Tente novamente\n"
				else putStrLn "Usuario não existe. Tente novamente com outro login\n"
			
			menuLogin

			
	else if (toUpperCase opcao) == "C"
		then do
			
			putStrLn "\nCrie um login e uma senha\nA senha deve ter 6 ou mais caracteres e conter 1 caracter especial('*', '!', '@', '/', '#')"
			
			putStr "\nLogin: "
			login <- getLine 
			putStr "Senha: "
			senha <- getLine

			arquivo <- readFile "dados/usuarios.txt"
			
			if existeLogin login arquivo
				then 
					do
					putStrLn "Login ja cadastrado. Tente novamente com outro login\n"
					menuLogin
				else cadastraUsuario login senha
			
			menuLogin
			
			
	else if (toUpperCase opcao) == "S"
		then do
			putStrLn "\nAte logo!"

	else 
		do
			putStrLn "Opcao invalida!\n"
			menuLogin


fazerLogin :: String -> IO()
fazerLogin login = do
	putStrLn "NAO IMPLEMENTADO\n"



----------------------------------------------------------------
--CadastroUsuario

-- Função que irá cadastrar o usuário num arquivo .txt, mantendo um registro dos usuarios cadastrados
cadastraUsuario :: String -> String -> IO ()
cadastraUsuario login senha = 
    if validaCadastro login senha
        then
            do
            appendFile "dados/usuarios.txt" ((toUpperCase login) ++ "," ++ senha ++ "\n")
            putStrLn "Cadastro realizado com sucesso\n"
			
        else 
			do
			putStrLn "Nao foi possivel realizar o cadastro. Tente novamente\n"
			

-- -- Função que vai ser responsável por validar o cadastro do Usuário
-- -- Login não pode ser vazio
-- -- Senha não pode ser vazia
-- -- senha possui 6 ou mais caracteres
validaCadastro :: String -> String -> Bool
validaCadastro "" senha = False
validaCadastro login "" = False
validaCadastro login senha = 
    if length senha <= 6
        then False
        else not (null (filter (`elem` ['*', '!', '@', '/', '#']) senha))





carregaUsuarios :: IO([Usuario.Usuario])
carregaUsuarios = Auxiliar.getListaDeUsuarios 






-------------------------------------------------------------------------------------


--Auxiliar



--Retorna a lista de um usuário cadastrado no sistema
--Caso o usuário não esteja cadastrado ele retorna uma lista vazia
getListaLogin :: [[String]] -> String -> [[String]]
getListaLogin lista login = Data.List.filter (login `elem`) lista

existeLogin :: String -> String -> Bool
existeLogin login arquivo = do
    let lista_usuarios = ((Data.List.map ( splitOn ",") (lines arquivo)))
    let lista_login = getListaLogin lista_usuarios (toUpperCase login)
    if null lista_login
        then False
        else True

-- verifica se a senha de um determinado login esta correta ou nao
verificaSenha :: String -> String -> String -> Bool 
verificaSenha login senha arquivo = do
	let lista_usuarios = ((Data.List.map ( splitOn ",") (lines arquivo)))
	let lista_login = getListaLogin lista_usuarios (toUpperCase login)
	if (lista_login !! 0) !! 1 == senha
		then True 
		else False


exibirUsuario :: String -> String -> [String]
exibirUsuario login arquivo = do
	let lista_login = getListaLogin ((Data.List.map ( splitOn ",") (lines arquivo))) login
	head lista_login



-- Recebe uma string e tranforma tudas as letras minusculas em maiusculas
toUpperCase :: String -> String
toUpperCase palavra = [toUpper x | x <- palavra]