import System.IO
import System.Directory


-- main :: IO()

-- main = do
--     putStr ("Digite seu usuário: ")
--     login <- getLine
--     putStrLn("Digite sua senha(Ela deve conter pelo menos 1 caracter especial dentro os listados [*, !, @, /, #]")
--     senha <- getLine
    

--     file <- openFile "usuarios.txt" ReadMode
--     content <- hGetContents file
--     writeToFile login senha content
--     hClose file;

    
--     removeFile "usuarios.txt"    
--     renameFile "./usuariosCorreto.txt" "./usuarios.txt" 



-- cadastraUsuario :: String -> String -> IO()
-- cadastraUsuario login senha  = 
--     if validaCadastro login senha
--         then writeFile login senha
--         else putStrLn "Não foi possível realizar seu cadastro"        


-- -- Função que vai ser responsável por validar o cadastro do Usuário
-- -- Login não pode ser vazio
-- -- Senha não pode ser vazia
-- -- senha possui 6 ou mais caracteres
-- validaCadastro :: String -> String -> Bool
-- validaCadastro "" senha = False
-- validaCadastro login "" = False
-- validaCadastro login senha = 
--     if length senha <= 6
--         then False
--         else not (null (filter (`elem` ['*', '!', '@', '/', '#']) senha))
--             -- Filtra só os elementos especiais
--             -- Vê se a lista é vazia ou não
--             -- Procedimento : Pra cada caracter de senha, ele verifica se ele caracter está na lista passada.
--             -- Se isso for verdade, esse valor é adicionado numa nova lista através do filter.
--             -- Caso seja falso para todos os caracteres, a lista será vazia e portanto o "return" será False
            

-- --Função que vai ser responsável por guardar os usuários em um arquivo
-- writeToFile :: String -> String -> String -> IO ()      
-- writeToFile login senha conteudo = do
--     if (null conteudo)
--         then writeFile "./usuariosCorreto.txt" ("Login: " ++ login ++ "\n" ++ "Senha: " ++ senha)
--         else writeFile "./usuariosCorreto.txt" (conteudo ++ "\n" ++ "Login: " ++ login ++ "\n" ++ "Senha: " ++ senha)



main :: IO()
main = do
    putStr ("Digite seu usuário: ")
    login <- getLine
    putStrLn("Digite sua senha:" ++ "\n "++"(Ela deve conter pelo menos 1 caracter especial dentro os listados [*, !, @, /, #]")
    senha <- getLine

    file <- openFile "usuarios.txt" ReadMode
    content <- hGetContents file
    writeToFile login senha content
    hClose file;

    
    removeFile "usuarios.txt"    
    renameFile "./usuariosCorreto.txt" "./usuarios.txt" 


    

    

cadastraUsuario :: String -> String -> IO()
cadastraUsuario login senha  = 
    if validaCadastro login senha
        then writeFile login senha
        else putStrLn "Não foi possível realizar seu cadastro"        


validaCadastro :: String -> String -> Bool
validaCadastro "" senha = False
validaCadastro login "" = False
validaCadastro login senha = 
    if length senha <= 6
        then False
        else not (null (filter (`elem` ['*', '!', '@', '/', '#']) senha))


writeToFile :: String -> String -> String -> IO ()      
writeToFile login senha conteudo = do
    if (null conteudo)
        then writeFile "./usuariosCorreto.txt" ("Login: " ++ login ++ "\n" ++ "Senha: " ++ senha)
        else writeFile "./usuariosCorreto.txt" (conteudo ++ "\n" ++ "Login: " ++ login ++ "\n" ++ "Senha: " ++ senha)
