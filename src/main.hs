import Auxiliar as Auxiliar
import Usuario as Usuario
import Banco as Banco
import Conta as Conta
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
		"  (2) Verificar saldo total\n" ++ 
		"  (3) Definir metas\n" ++ 
		"  (4) Gerar extrato\n" ++ 
		"  (5) Realizar transação\n" ++ 
		"  (6) Sair\n\n" ++
		"Opção> ")

	opcao <- getLine 

	if (opcao) == "1"
		then do
			
			putStr "\nNome do conta: "
			nomeConta <- getLine 
			putStr "\nCodigo da Conta: "
			codigo <- getLine
			putStr "\nSaldo: "
			saldo <- getLine
			putStr "\nTipo da Conta: "
			tipoConta <- getLine
			putStr "\nDescrição da Conta: "
			descricao <- getLine

			arquivo <- readFile "dados/usuarios.txt"
			
			let lista_usuarios = ((Data.List.map ( splitOn ",") (lines arquivo)))
			let conta = Conta {contaNome = nomeConta, contaCodigo = codigo, saldoConta = read saldo, tipoConta = read tipoConta, descricao = descricao}
			let lista_usuarios_com_contas = (Auxiliar.adicionaConta login conta lista_usuarios)

			let string_nova = Auxiliar.tranformaListaEmString lista_usuarios_com_contas

			removeFile "dados/usuarios.txt"
			writeFile "dados/usuarios.txt" string_nova

			menuUsuario login

	else if (opcao) == "2"
		then do

			arquivo <- readFile "dados/usuarios.txt"
   			let usuarios = Auxiliar.getListaDeUsuarios arquivo
			let saldo = Auxiliar.verificaSaldoTotal login usuarios

			putStrLn ("Seu saldo é de R$ " ++ (show saldo) ++ "\n")
			
			menuUsuario login

	else if (opcao) == "3"
		then do
			putStrLn "NÃO IMPLEMENTADO"
			
			menuUsuario login
			
	else if (opcao) == "4"
		then do
			putStrLn "NAO IMPLEMENTADO"

			menuUsuario login

	else if (opcao) == "5"
		then do
			putStr "Digite o valor da transação: "
			valor <- getLine
			putStr "Código da conta de origem: "
			codigoOrigem <- getLine
			putStr "Código da conta de destino"
			codigoDestino <- getLine
			
			let contaOrigem = Conta.encontraConta contas contaOrigem
			let contaOrigem = Conta.encontraConta contas contaDestino

			
			menuUsuario login

	else if (opcao) == "6"
		then do
			putStrLn("\nAte Logo " ++ Data.List.map toLower login ++ "!\n") 
			menuLogin			

	else 
		do
			putStrLn "Opcao invalida!\n"
			menuUsuario login

-------------------------------------------------------------------------------------