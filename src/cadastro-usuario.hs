
main :: IO()

main = do
    putStr ("Digite seu usuário: ")
    login <- getLine
    putStrLn("Digite sua senha(Ela deve conter pelo menos 1 caracter especial dentro os listados [*, !, @, /, #]")
    senha <- getLine
    let loginCadastrado = fst (cadastraUsuario login senha)
    if null loginCadastrado 
        then print("Algo deu errado :'( Tente novamente")
        else print ("Usuario cadastrado! Bem vindo " ++ loginCadastrado)
     

cadastraUsuario :: String -> String -> (String, String)
cadastraUsuario login senha
            | validaCadastro login senha = (login, senha)
            | otherwise = ("", "")


-- Função que vai ser responsável por validar o cadastro do Usuário
-- Login não pode ser vazio
-- Senha não pode ser vazia
-- senha possui 6 ou mais caracteres
validaCadastro :: String -> String -> Bool
validaCadastro "" senha = False
validaCadastro login "" = False
validaCadastro login senha = 
    if length senha <= 6
        then False
        else not (null (filter (`elem` ['*', '!', '@', '/', '#']) senha))
            -- Filtra só os elementos especiais
            -- Vê se a lista é vazia ou não
            -- Procedimento : Pra cada caracter de senha, ele verifica se ele caracter está na lista passada.
            -- Se isso for verdade, esse valor é adicionado numa nova lista através do filter.
            -- Caso seja falso para todos os caracteres, a lista será vazia e portanto o "return" será False
            


   


    