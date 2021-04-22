import System.IO
import System.Directory

main :: IO()
main = do
    menuInicial

    inputOpcao <- getLine
    let opcao = head inputOpcao

    if opcao == 'L' then do
        -- LOGIN
        putStr ("\n" ++ "Login: ")
        login <- getLine
        putStr ("Senha: ")
        senha <- getLine

        putStr ("\n" ++ "Login" ++ "\n\n")

    else if opcao == 'C' then do
        -- CADASTRAR
        putStr ("\n" ++ "Digite seu usuário: ")
        login <- getLine
        putStrLn("\n" ++ "Digite sua senha:" ++ "\n "++"(Ela deve conter pelo menos 1 caracter especial dentro os listados [*, !, @, /, #]")
        senha <- getLine
    
        cadastraUsuario login senha

    else if opcao == 'S' then do
        putStr ("\n" ++ "Ate logo!" ++ "\n\n")

    else do
        -- ERROR
        putStrLn ("\nDigite algo valido!\n")
        main

-- Função que apresenta o menu inicial
menuInicial :: IO ()
menuInicial = do 
    putStr("Bem vindo!\n\nSelecione uma das opções:\n\n  (L) Login\n  (C) Cadastrar usuário\n  (S) Sair\n \nOpção> ")

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
            putStrLn "\nCadastro realizado com sucesso\n"
        else putStrLn "\nCadastro não realizado\n"

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
