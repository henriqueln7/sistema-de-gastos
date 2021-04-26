module Auxiliar where

import qualified Usuario as Usuario
import qualified Banco as Banco
import Data.List
import System.IO
import Data.Map as Map 
import Data.List
import Data.List.Split (splitOn)


{-
raphael,111,Nubank 120,Itau 300, Bradesco 50
nicolas,222,Inter 200                            -- LISTA INICIAL NO dados/usuarios.txt
henrique,333,Pan 300
vh,444,Santander 400
-}
{-
[["raphael","111","Nubank 120"],
["nicolas","222","Inter 200"],      -- APOS EXECUTAR A LINHA 32
["henrique","333","Pan 300"],
["vh","444","Santander 400"]]
-}

{-SAIDA DA FUNCAO
[Usuario {login = "raphael", senha = "111", bancos = ["Nubank 120","Itau 300"," Bradesco 50"]},
Usuario {login = "nicolas", senha = "222", bancos = ["Inter 200"]},
Usuario {login = "henrique", senha = "333", bancos = ["Pan 300"]},
Usuario {login = "vh", senha = "444", bancos = ["Santander 400"]}]
-}
getListaDeUsuarios :: String -> [Usuario.Usuario]
getListaDeUsuarios arquivo = do
    let lista = ((Data.List.map ( splitOn ",") (lines arquivo)))
    let lista_usuarios = ((Data.List.map constroiUsuario lista))
    lista_usuarios   

-- String inicial ["raphael","senhaDeRaphael","Nubank 120", "Inter 200"]
constroiUsuario :: [String] -> Usuario.Usuario
constroiUsuario lista = Usuario.Usuario {
    Usuario.login = lista !! 0,
    Usuario.senha = lista !! 1,
    Usuario.bancos = (getListaDeBancos (Data.List.drop 2 lista))
}
 
 {-
 ["Nubank 120", "Inter SA 200"]   EXEMPLO DE ENTRADA


[Banco {nome = "Nubank", saldo = 120.0},    SAIDA
 Banco {nome = "Inter SA", saldo = 200.0}]
-}
getListaDeBancos :: [String] -> [Banco.Banco]
getListaDeBancos arquivo = (Data.List.map constroiBanco (Data.List.map ( splitOn " ") (arquivo)))

constroiBanco :: [String] -> Banco.Banco
constroiBanco lista = Banco.Banco {
    Banco.nome = Data.List.intercalate " " (Data.List.take ((length lista) - 1) lista),
    Banco.saldo = (read (last lista))
}

-- "user2" "nubank" "120" [["user1","senha"],["user2","senha"],["user3","senha"]]           ENTRADA
-- [["user1","senha"],["user2","senha","nubank 120"],["user3","senha"]]                     SAIDA
adicionaBanco :: String -> String -> String -> [[String]] -> [[String]]
adicionaBanco login banco saldo [] = []
adicionaBanco login banco saldo (h:t) = 
    if (h !! 0 == login)
        then do [h ++ [(banco ++ " " ++ saldo)]] ++ adicionaBanco login banco saldo t
        else [h] ++ adicionaBanco login banco saldo t

{- Recebe uma lista de lista de string e tranforma em uma string
[["user1","senha"],["user2","senha","nubank 120"],["user3","senha"]]                   ENTRADA

user1,senha
user2,senha,nubank 120                                                                 SAIDA
user3,senha                      -}
tranformaListaEmString :: [[String]] -> String 
tranformaListaEmString [] = ""
tranformaListaEmString (h:t) = intercalate "," h ++ "\n" ++ tranformaListaEmString t




verificaSaldoTotal :: String -> [Usuario.Usuario] -> Float 
verificaSaldoTotal login (h:t) = 
    if login == Usuario.login h
        then Usuario.getSaldoTotal h
        else verificaSaldoTotal login t
    