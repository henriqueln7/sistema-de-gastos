module Auxiliar where

import Usuario
import Conta
import System.IO
import Data.Map as Map 
import Data.List
import Data.Char
import Data.List.Split (splitOn)


{-
raphael,111,Nubank|001|1300.0|Corrente|Conta do Nubank,Inter|002|1200.0|Poupança|Conta do Inter
nicolas,222,BB|001|2000.0|Corrente|Conta do BB                            -- LISTA INICIAL NO dados/usuarios.txt
henrique,333,Pan|001|1400.0|Corrente|Conta Pan
vh,444,Santander|001|4000.0|Poupança|Conta Santander
-}
{-
[["raphael","111","Nubank|001|1300.0|Corrente|Conta do Nubank","Inter|002|1200.0|Poupança|Conta do Inter"],
["nicolas","222","BB|001|2000.0|Corrente|Conta do BB"],      -- APOS EXECUTAR A LINHA 32
["henrique","333","Pan|001|1400.0|Corrente|Conta Pan"],
["vh","444","Santander|001|4000.0|Poupança|Conta Santander"]]
-}

{-SAIDA DA FUNCAO
[Usuario {login = "raphael", senha = "111", contas = ["Nubank|001|1300.0|Corrente|Conta do Nubank","Inter|002|1200.0|Poupança|Conta do Inter"]},
Usuario {login = "nicolas", senha = "222", contas = ["BB|001|2000.0|Corrente|Conta do BB"]},
Usuario {login = "henrique", senha = "333", contas = ["Pan|001|1400.0|Corrente|Conta Pan"]},
Usuario {login = "vh", senha = "444", contas = ["Santander|001|4000.0|Poupança|Conta Santander"]}]
-}
getListaDeUsuarios :: String -> [Usuario]
getListaDeUsuarios arquivo = do
    let lista = ((Data.List.map ( splitOn ",") (lines arquivo)))
    let lista_usuarios = ((Data.List.map constroiUsuario lista))
    lista_usuarios   


-- [Usuario {login = "raphael", senha = "111", contas = ["Nubank|001|1300.0|Corrente|Conta do Nubank","Inter|002|1200.0|Poupança|Conta do Inter"]},
-- Usuario {login = "nicolas", senha = "222", contas = ["BB|001|2000.0|Corrente|Conta do BB"]},
-- Usuario {login = "henrique", senha = "333", contas = ["Pan|001|1400.0|Corrente|Conta Pan"]},
-- Usuario {login = "vh", senha = "444", contas = ["Santander|001|4000.0|Poupança|Conta Santander"]}
--Ainda dando erro

-- getUsuario :: [Usuario] -> String -> Usuario
-- getUsuario usuarios login = 
--     Data.List.filter (\usuario -> (login usuario) == login) usuarios

-- String inicial ["raphael","senhaDeRaphael","Nubank 120", "Inter 200"]
constroiUsuario :: [String] -> Usuario
constroiUsuario lista = Usuario.Usuario {
    Usuario.login = lista !! 0,
    Usuario.senha = lista !! 1,
    Usuario.contas = (getListaContas (Data.List.drop 2 lista))
}



--Retorna uma lista que contém a lista do usuário determinado no login
--ENTRADA: getListaLogin [[user1, senha1], [user2, senha2]] user1
--SAÌDA: [[user1, senha1]]
getListaLogin :: [[String]] -> String -> [[String]]
getListaLogin lista login = Data.List.filter (login `elem`) lista



--Verifica se um usuário*(login dele) está cadastrado ou não
existeLogin :: String -> String -> Bool
existeLogin login arquivo = do
    let lista_usuarios = ((Data.List.map ( splitOn ",") (lines arquivo)))
    let lista_login = getListaLogin lista_usuarios (toUpperCase login)
    if Data.List.null lista_login
        then False
        else True



-- verifica se a senha de um determinado login esta correta ou nao
verificaSenha :: String -> String -> String -> Bool 
verificaSenha login senha arquivo = do
    let lista_usuarios = ((Data.List.map ( splitOn ",") (lines arquivo)))
    let lista_login = getListaLogin lista_usuarios (toUpperCase login)
    if (lista_login !! 0) !! 1 == senha
        then True 
        else False




-- Recebe uma string e tranforma tudas as letras minusculas em maiusculas
toUpperCase :: String -> String
toUpperCase palavra = [toUpper x | x <- palavra]        



 
 {-
 ["Nubank|001|120|Corrente|Conta do Nubank", "InterSA|002|200|Poupanca|Conta Do Inter"] 
 []  EXEMPLO DE ENTRADA
 


[Conta {nomeConta = "Nubank",contaCodigo="001", saldoConta=120.0, tipoConta=Corrente, descricao="Conta do Nubank"},    SAIDA
 Conta {nomeConta = "InterSa",contaCodigo="002", saldoConta=200.0, tipoConta=Poupanca, descricao="Conta do Inter"}]
-}
getListaContas :: [String] -> [Conta]
-- getListaContas arquivo = (Data.List.map constroiConta(Data.List.map ( splitOn ",") (arquivo)))
getListaContas arquivo = Data.List.map constroiConta arquivo

constroiConta :: String -> Conta
constroiConta lista = do 
    let listaConta = Data.List.Split.splitOn "|" lista in
        Conta {
            contaNome = listaConta !! 0,
            contaCodigo = listaConta !! 1,
            saldoConta = read (listaConta !! 2),
            tipoConta = read (listaConta !! 3),
            descricao = listaConta !! 4
        }




-- "user2" "nubank" "120" [["user1","senha"],["user2","senha"],["user3","senha"]]           ENTRADA
-- [["user1","senha"],["user2","senha","nubank 120"],["user3","senha"]]                     SAIDA
adicionaConta :: String -> Conta -> [[String]] -> [[String]]
adicionaConta login conta [] = []
adicionaConta login conta (h:t) = 
    if (h !! 0 == login)
        then do [h ++ [(contaNome conta ++ "|" ++ contaCodigo conta ++ "|" ++ show (saldoConta conta) ++ "|" ++ show (tipoConta conta) ++ "|" ++ descricao conta)]] ++ adicionaConta login conta t
        else [h] ++ adicionaConta login conta t


{- Recebe uma lista de lista de string e tranforma em uma string
[["user1","senha"],["user2","senha","nubank 120"],["user3","senha"]]                   ENTRADA

user1,senha
user2,senha,nubank 120                                                                 SAIDA
user3,senha                      -}
tranformaListaEmString :: [[String]] -> String 
tranformaListaEmString [] = ""
tranformaListaEmString (h:t) = intercalate "," h ++ "\n" ++ tranformaListaEmString t



-- Verifica Saldo total das contas de um Usuario
verificaSaldoTotal :: String -> [Usuario] -> Double 
verificaSaldoTotal login (h:t) = 
    if login == Usuario.login h
        then Usuario.getSaldoTotal h
        else verificaSaldoTotal login t
    