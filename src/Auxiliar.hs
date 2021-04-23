import qualified Usuario as Usuario
import Data.List
import System.IO
import Data.Map as Map 
import Data.Listc
import Data.List.Split (splitOn)




-- INCOMPLETO E NAO TESTADO
{-
raphael,111,Nubank 120,Itau 300, Bradesco 50
nicolas,222,Inter 200                            -- LISTA INICIAL NO dados/usuarios.txt
henrique,333,Pan 300
vh,444,Santander 400
-}
{-
[["raphael","111","Nubank 120"],
["nicolas","222","Inter 200"],      -- APOS EXECUTAR A LINHA 34
["henrique","333","Pan 300"],
["vh","444","Santander 400"]]
-}

{-SAIDA DA FUNCAO
[Usuario {login = "raphael", senha = "111", bancos = ["Nubank 120","Itau 300"," Bradesco 50"]},
Usuario {login = "nicolas", senha = "222", bancos = ["Inter 200"]},
Usuario {login = "henrique", senha = "333", bancos = ["Pan 300"]},
Usuario {login = "vh", senha = "444", bancos = ["Santander 400"]}]
-}
getListaDeUsuarios :: IO([Usuario.Usuario])
getListaDeUsuarios = do
    arquivo <- readFile "dados/usuarios.txt"
    let lista = ((Data.List.map ( splitOn ",") (lines arquivo)))
    let lista_usuarios = ((Data.List.map constroiUsuario lista))
    return lista_usuarios

constroiUsuario :: [String] -> Usuario.Usuario
constroiUsuario lista = Usuario.Usuario {
    Usuario.login = lista !! 0,
    Usuario.senha = lista !! 1,
    Usuario.bancos = drop 2 lista
}



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
exibirUsuario login = getListaDeUsuarios !! 0
    
    
    