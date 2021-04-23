import System.IO
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
		"  (E)xibir dados \n" ++ 
		"  (C) Cadastrar usuário\n" ++ 
		"  (S) Sair\n\n" ++
		"Opção> ")
	
	opcao <- getLine 

	if (toUpperCase opcao) == "E"
		then do
			
			putStr "\nLogin: "
	
			login <- getLine
			
			if existeLogin login
				then exibirUsuario login
				else putStrLn "Usuario não cadastrado"
			

			
	else if (toUpperCase opcao) == "C"
		then do
			
			putStr "\nLogin: "
			login <- getLine 

			putStrLn "\nA senha deve ter 6 ou mais caracteres e conter 1 caracter especial('*', '!', '@', '/', '#')"
			putStr "Senha: "
			senha <- getLine

			cadastraUsuario login senha

			
	else if (toUpperCase opcao) == "S"
		then do
			putStrLn "\nAte logo!"

	else 
		do
			putStrLn "\nOpcao invalida!\n"
			menuLogin






-- Recebe uma string e tranforma tudas as letras minusculas em maiusculas
toUpperCase :: String -> String
toUpperCase palavra = [toUpper x | x <- palavra]

----------------------------------------------------------------
--CadastroUsuario


-- Função que irá cadastrar o usuário num arquivo .txt, mantendo um registro dos usuarios cadastrados
cadastraUsuario :: String -> String -> IO ()
cadastraUsuario login senha = 
    if validaCadastro login senha
        then
            do
            file <- openFile "usuarios.txt" ReadMode
            content <- hGetContents file
            writeToFile login senha content
            hClose file

            removeFile "usuarios.txt"    
            renameFile "./usuariosCorreto.txt" "./usuarios.txt" 
            putStrLn "Cadastro realizado com sucesso"
        else putStrLn "Cadastro não realizado"

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

--Função que vai ser responsável por escrever os usuários em um arquivo
writeToFile :: String -> String -> String -> IO ()      
writeToFile login senha conteudo = do
    if (null conteudo)
        then writeFile "./usuariosCorreto.txt" ("Login: " ++ login ++ "\n" ++ "Senha: " ++ senha)
        else writeFile "./usuariosCorreto.txt" (conteudo ++ "\n" ++ "Login: " ++ login ++ "\n" ++ "Senha: " ++ senha)

-------------------------------------------------------------------------------------


--Auxiliar



--Retorna a lista de um usuário cadastrado no sistema
--Caso o usuário não esteja cadastrado ele retorna uma lista vazia
getListaLogin :: [[String]] -> String -> [[String]]
getListaLogin lista login = Data.List.filter (login `elem`) lista

existeLogin :: [String] -> Bool
existeLogin login = do
    let lista_usuarios = ((Data.List.map ( splitOn ",") (lines arquivo)))
    let lista_login = getListaLogin lista_usuarios login
    if null lista_login
        then True
        else False


exibirUsuario :: String -> [String]
exibirUsuario login = getListaLogin !! 0