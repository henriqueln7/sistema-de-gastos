import Auxiliar
import Usuario
import Conta
import CadastroUsuario
import System.IO
import System.Directory
import Data.Char
import Data.List
import Data.List.Split (splitOn)
import Data.Maybe
import Control.Exception


main :: IO ()
main = do
	putStrLn "\n"
	putStrLn ("░██████╗░░█████╗░░██████╗████████╗███████╗  ███╗░░░███╗███████╗███╗░░██╗░█████╗░░██████╗")
	putStrLn ("██╔════╝░██╔══██╗██╔════╝╚══██╔══╝██╔════╝  ████╗░████║██╔════╝████╗░██║██╔══██╗██╔════╝")
	putStrLn ("██║░░██╗░███████║╚█████╗░░░░██║░░░█████╗░░  ██╔████╔██║█████╗░░██╔██╗██║██║░░██║╚█████╗░")
	putStrLn ("██║░░╚██╗██╔══██║░╚═══██╗░░░██║░░░██╔══╝░░  ██║╚██╔╝██║██╔══╝░░██║╚████║██║░░██║░╚═══██╗")
	putStrLn ("╚██████╔╝██║░░██║██████╔╝░░░██║░░░███████╗  ██║░╚═╝░██║███████╗██║░╚███║╚█████╔╝██████╔╝")
	putStrLn ("░╚═════╝░╚═╝░░╚═╝╚═════╝░░░░╚═╝░░░╚══════╝  ╚═╝░░░░░╚═╝╚══════╝╚═╝░░╚══╝░╚════╝░╚═════╝░")

        putStrLn "\nBem Vindo ao Gaste Menos!\n"
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

	if toUpperCase opcao == "L"
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


	else if toUpperCase opcao == "C"
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


	else if toUpperCase opcao == "S"
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
			"  (2) Visualizar Contas\n" ++
			"  (3) Definir meta\n" ++
			"  (4) Exibir metas\n" ++
			"  (5) Gerar extrato\n" ++
			"  (6) Realizar transação\n" ++
			"  (7) Depositar na conta\n" ++
			"  (8) Retirar dinheiro da conta\n" ++
			"  (9) Sair\n\n" ++
			"Opção> ")

	opcao <- getLine

	if (opcao) == "1"
		then do

			putStr "\nNome do conta: "
			nomeConta <- getLine
			putStr "Codigo da Conta: "
			codigo <- getLine
			putStr "Saldo: "
			saldo <- getLine
			putStr "Tipo da Conta: "
			tipoConta <- getLine
			putStr "Descrição da Conta: "
			descricao <- getLine

			arquivo <- readFile "dados/usuarios.txt"
			
			catch (Auxiliar.cadastraConta login arquivo nomeConta codigo saldo (Auxiliar.toUpperCase tipoConta) descricao) (Auxiliar.tratarErro arquivo)                
			
			menuUsuario login

	else if (opcao) == "2"
		then do
				
			arquivo <- readFile "dados/usuarios.txt"
			let usuarios = Auxiliar.getListaDeUsuarios arquivo
			let contas_usuario = Auxiliar.getContasUsuario login arquivo
			let saldo = Auxiliar.verificaSaldoTotal login usuarios
			
			mapM_ putStrLn (map Auxiliar.printaConta contas_usuario )
                        
			putStrLn ("\nSeu saldo é de R$ " ++ (show saldo) ++ "\n")

			menuUsuario login

	else if (opcao) == "3" 
		then do
			putStr "\nDescrição da meta: "
			descricaoMeta <- getLine
			putStr "\nValor a ser alcançado: "
			valorAlcancar <- getLine
			putStrLn "Quanto você irá guardar por mês: "
			valorPraGuardar <- getLine
			putStr "Você já possui algum valor guardado? Digite 0 caso não possua nad "
			carteira <- getLine


			let meses = Auxiliar.calculaMeses (read valorAlcancar) (read valorPraGuardar) (read carteira)
			
			if (meses == 0)
				then do
					putStrLn "\nHomi, tu já tem o dinheiro, gasta logo!\n"
				else do
					appendFile "dados/metas.txt" (login ++ "," ++ descricaoMeta ++ " | " ++ carteira ++ " | " ++ valorPraGuardar ++ " | " ++ valorAlcancar ++ " | " ++ (show meses) ++ "\n")
					putStrLn "\nMeta adicionada\n"                    

			

			menuUsuario login

	else if (opcao) == "4"
		then do
                        
			arquivo <- readFile "dados/metas.txt"
			
			let metas = Auxiliar.exibeMetas login arquivo

			if (null metas)	
				then putStrLn "\nVocê não possui metas!\n"
				else putStrLn metas

			menuUsuario login
			

	else if (opcao) == "5"
		then do
			
			extrato <- Auxiliar.geraExtrato login

			if (null extrato) then 
				putStrLn "\nNão há extrato disponível! Faça alguma transferência antes :D\n"            
			else
				mapM_ putStrLn extrato
			
			menuUsuario login

	else if (opcao) == "6"
		then do
			putStr "\nDigite o valor da transação: "
			valor <- getLine
			putStr "Código da conta de origem: "
			codigoOrigem <- getLine
			putStr "Código da conta de destino: "
			codigoDestino <- getLine
			
			arquivo <- readFile "dados/usuarios.txt"

			let contas = Auxiliar.getContasUsuario login arquivo
			
			if null contas
				then putStr "\nTá querendo tirar dinheiro de onde não tem??\n"
				else do
					let contaOrigem = Conta.encontraConta contas codigoOrigem
					let contaDestino = Conta.encontraConta contas codigoDestino
					let user = Auxiliar.getUsuario (Auxiliar.getListaDeUsuarios arquivo) login

					if (null user)
						then putStrLn "\nUsuário não cadastrado(O que você pensa que está fazendo??)"
						else do
							let transferencia = Transferencia {
								usuario = (user !! 0),
								contaOrigem = contaOrigem,
								contaDestino = contaDestino,
								valor = read valor
							}
							let usuarios = Auxiliar.getListaDeUsuarios arquivo
							
							let usuarios_modificados = Data.List.delete ((Auxiliar.getUsuario usuarios login) !! 0) usuarios
							let usuario_com_transferencia = Usuario.realizaTransacao transferencia


							if Data.Maybe.isNothing usuario_com_transferencia then
								putStrLn "\nVocê não possui saldo suficiente nessa conta para realizar essa transferência :/\n"
							else
								do
								Auxiliar.persisteUsuarios (usuarios_modificados ++ [Data.Maybe.fromJust usuario_com_transferencia])
								
								Auxiliar.persisteTransferencia transferencia
								putStrLn "\nTransferência efetuada com sucesso!\n"
                            
			menuUsuario login


	else if (opcao) == "7"
		then do
			

			putStr "\nDigite o código da conta que você vai fazer o deposito: "
			codigo <- getLine
			putStr "Digite o valor a ser depositado: "
			valor <- getLine

			arquivo <- readFile "dados/usuarios.txt"

			Auxiliar.depositaNaContaDoUsuario login codigo valor arquivo

			menuUsuario login

	else if (opcao) == "8"
		then do
			

			putStr "\nDigite o código da conta que você vai fazer a retirada: "
			codigo <- getLine
			putStr "Digite o valor a ser retirado: "
			valor <- getLine

			arquivo <- readFile "dados/usuarios.txt"

			Auxiliar.retiraDaContaDoUsuario login codigo valor arquivo

			menuUsuario login

	else if (opcao) == "9"
		then do
			putStrLn("\nAte Logo " ++ Data.List.map toLower login ++ "!\n")
			menuLogin

	else do 
		putStrLn "Opcao invalida!\n"
		menuUsuario login


                                
-------------------------------------------------------------------------------------