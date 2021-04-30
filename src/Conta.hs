module Conta where

import Data.List.Split (splitOn)
import Data.Maybe(fromJust)

data TipoConta = CORRENTE | POUPANCA | CARTEIRA deriving (Show, Eq, Read)

data Conta = Conta {contaNome :: String, contaCodigo :: String, saldoConta :: Double, tipoConta :: TipoConta, descricao :: String} deriving (Show, Read)

-- Duas contas serão iguais com a condição de terem a mesmo código. Nada mais importa para a igualdade.
instance Eq Conta where
    c1 == c2 = (==) (contaCodigo c1) (contaCodigo c2)



--ENTRADA 
--["Nubank|001|120|CORRENTE|Conta do Nubank", "InterSA|002|200|POUPANCA|Conta Do Inter"]
-- "001"

-- SAIDA
-- Conta {nomeConta="Nubank"...}
-- OBS: Caso não haja nenhuma conta com o código, uma exceção será lançada.
encontraConta :: [String] -> String -> Conta
encontraConta contas codigo = fromJust (encontraContaIter contas codigo 0)

encontraContaIter :: [String] -> String -> Int -> Maybe Conta
encontraContaIter contas codigoConta i
    | i >= length contas = Nothing
    | otherwise = let conta = splitOn "|" (contas !! i)
                    in if (conta !! 1) == codigoConta 
                            then Just Conta
                                { 
                                    contaNome = conta !! 0,
                                    contaCodigo = conta !! 1,
                                    saldoConta = read (conta !! 2),
                                    tipoConta = read (conta !! 3),
                                    descricao = conta !! 4
                                }
                        else encontraContaIter contas codigoConta (i + 1)


depositaNaConta :: Conta -> Double -> Conta
depositaNaConta c valor = Conta{contaNome = (contaNome c), contaCodigo = (contaCodigo c), saldoConta = ((saldoConta c) + valor), tipoConta = (tipoConta c), descricao = (descricao c)}

sacaDaConta :: Conta -> Double -> Conta
sacaDaConta c valor = Conta{contaNome = (contaNome c), contaCodigo = (contaCodigo c), saldoConta = ((saldoConta c) - valor), tipoConta = (tipoConta c), descricao = (descricao c)}

verificaValidadeDoSaque :: [Conta] -> Bool 
verificaValidadeDoSaque [] = True
verificaValidadeDoSaque (h:t) = 
    if saldoConta h < 0
        then False
        else verificaValidadeDoSaque t 

existeConta :: String -> [Conta] -> Bool 
existeConta codigo [] = False 
existeConta codigo (h:t) = 
    if contaCodigo h == codigo
        then True 
        else existeConta codigo t



