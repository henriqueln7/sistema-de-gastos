import Auxiliar as Auxiliar
import Usuario as Usuario
import Banco as Banco
import CadastroUsuario as CadastroUsuario
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
			
			if Auxiliar.existeLogin login arquivo
				then 
					if Auxiliar.verificaSenha login senha arquivo
						then 
							do
							putStrLn ("Bem vindo " ++ login ++ "!\n")
							menuUsuario (Auxiliar.toUpperCase login) 
						else 
							do
							putStrLn "Senha incorreta. Tente novamente\n"
							menuLogin
				else 
					do
					putStrLn "Usuario não existe. Tente novamente com outro login\n"
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
				else CadastroUsuario.cadastraUsuario login senha
			
			menuLogin
			
			
	else if (toUpperCase opcao) == "S"
		then do
			putStrLn "Ate logo!\n"

	else 
		do
			putStrLn "Opcao invalida!\n"
			menuLogin


menuUsuario :: String -> IO()
menuUsuario login = do
	putStr ("Selecione uma das opções:\n\n" ++ 
		"  (1) Registar conta de banco\n" ++ 
		"  (2) Registrar cartao de credito\n" ++ 
		"  (3) Verificar saldo total\n" ++ 
		"  (4) Definir metas\n" ++ 
		"  (5) Gerar extrato\n" ++ 
		"  (6) Realizar transação\n" ++ 
		"  (7) Sair\n\n" ++
		"Opção> ")

	opcao <- getLine 

	if (opcao) == "1"
		then do
			
			putStr "\nNome do banco: "
			nome <- getLine 
			putStr "Saldo: "
			saldo <- getLine

			arquivo <- readFile "dados/usuarios.txt"
			
			let lista = ((Data.List.map ( splitOn ",") (lines arquivo)))
			let lista_nova = (Auxiliar.adicionaBanco login nome saldo lista)

			let string_nova = Auxiliar.tranformaListaEmString lista_nova

			removeFile "dados/usuarios.txt"
			writeFile "dados/usuarios.txt" string_nova

			menuUsuario login

	else if (opcao) == "2"
		then do

			putStrLn "NAO IMPLEMENTADO"

			menuUsuario login

	else if (opcao) == "3"
		then do
			
			
			arquivo <- readFile "dados/usuarios.txt"
   			let usuarios = Auxiliar.getListaDeUsuarios arquivo
			let saldo = Auxiliar.verificaSaldoTotal login usuarios

			putStrLn ("Seu saldo é de R$ " ++ (show saldo) ++ "\n")
			
			menuUsuario login

	else if (opcao) == "4"
		then do
			putStrLn "NAO IMPLEMENTADO"

			menuUsuario login

	else if (opcao) == "5"
		then do
			putStrLn "NAO IMPLEMENTADO"

			menuUsuario login

	else if (opcao) == "6"
		then do
			putStrLn "NÃO IMPLEMENTADO!\n"

	else if (opcao) == "7"
		then do
			putStrLn "Até Logo!\n"

	else 
		do
			putStrLn "Opcao invalida!\n"
			menuUsuario login

-------------------------------------------------------------------------------------