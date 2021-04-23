module CadastroUsuario where    

import System.IO
import System.Directory

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
