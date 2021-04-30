module Auxiliar where

import Usuario
import Conta
import Data.Map as Map 
import Data.List
import Data.Char
import Data.List.Split (splitOn)
import Control.Exception
import System.IO.Error
import System.IO
import System.Directory


{-
raphael,111,Nubank|001|1300.0|CORRENTE|Conta do Nubank,Inter|002|1200.0|POUPANCA|Conta do Inter
nicolas,222,BB|001|2000.0|CORRENTE|Conta do BB                            -- LISTA INICIAL NO dados/usuarios.txt
henrique,333,Pan|001|1400.0|CORRENTE|Conta Pan
vh,444,Santander|001|4000.0|POUPANCA|Conta Santander
-}
{-
[["raphael","111","Nubank|001|1300.0|CORRENTE|Conta do Nubank","Inter|002|1200.0|POUPANCA|Conta do Inter"],
["nicolas","222","BB|001|2000.0|CORRENTE|Conta do BB"],      -- APOS EXECUTAR A LINHA 32
["henrique","333","Pan|001|1400.0|CORRENTE|Conta Pan"],
["vh","444","Santander|001|4000.0|POUPANCA|Conta Santander"]]
-}

{-SAIDA DA FUNCAO
[Usuario {login = "raphael", senha = "111", contas = ["Nubank|001|1300.0|CORRENTE|Conta do Nubank","Inter|002|1200.0|POUPANCA|Conta do Inter"]},
Usuario {login = "nicolas", senha = "222", contas = ["BB|001|2000.0|CORRENTE|Conta do BB"]},
Usuario {login = "henrique", senha = "333", contas = ["Pan|001|1400.0|CORRENTE|Conta Pan"]},
Usuario {login = "vh", senha = "444", contas = ["Santander|001|4000.0|POUPANCA|Conta Santander"]}]
-}
getListaDeUsuarios :: String -> [Usuario]
getListaDeUsuarios arquivo = do
    let lista = ((Data.List.map ( splitOn ",") (lines arquivo)))
    let lista_usuarios = ((Data.List.map constroiUsuario lista))
    lista_usuarios   


-- [Usuario {login = "raphael", senha = "111", contas = ["Nubank|001|1300.0|CORRENTE|Conta do Nubank","Inter|002|1200.0|POUPANCA|Conta do Inter"]},
-- Usuario {login = "nicolas", senha = "222", contas = ["BB|001|2000.0|CORRENTE|Conta do BB"]},
-- Usuario {login = "henrique", senha = "333", contas = ["Pan|001|1400.0|CORRENTE|Conta Pan"]},
-- Usuario {login = "vh", senha = "444", contas = ["Santander|001|4000.0|POUPANCA|Conta Santander"]}

getUsuario :: [Usuario] -> String -> [Usuario]
getUsuario usuarios loginParaEncontrar = 
    Data.List.filter (\usuario -> (login usuario) == loginParaEncontrar) usuarios


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


--[ENTRADA]
-- getContasUsuario "nicolasmnl" conteúdo do arquivo   

-- [SAÌDA]   
-- ["Inter|01|1200.0|CORRENTE|Conta do Inter","Nubank|02|13000.0|CORRENTE|Conta do Nubank de nicolas"]      

--Retorna as contas de um Usuario no formato de String
getContasUsuario :: String -> String -> [String]
getContasUsuario login arquivo = do
    let lista_usuarios = (Data.List.map ( splitOn ",") (lines arquivo))
    let contasUser = getContasUsuarioAuxiliar lista_usuarios (toUpperCase login) 0
    contasUser

getContasUsuarioAuxiliar :: [[String]] -> String -> Int -> [String]
getContasUsuarioAuxiliar lista_usuarios login i = do
    if(i < length lista_usuarios)
        then 
            if ((lista_usuarios !! i) !! 0) == login
                then do
                    let contasUser = Data.List.drop 2 (lista_usuarios !! i)
                    contasUser
                else
                    getContasUsuarioAuxiliar lista_usuarios login (i+1)
        else
 
            [""]
{-
["Nubank|001|120|CORRENTE|Conta do Nubank", "InterSA|002|200|Poupanca|Conta Do Inter"] 
[]  EXEMPLO DE ENTRADA
 

[Conta {nomeConta = "Nubank",contaCodigo="001", saldoConta=120.0, tipoConta=CORRENTE, descricao="Conta do Nubank"},    SAIDA
 Conta {nomeConta = "InterSa",contaCodigo="002", saldoConta=200.0, tipoConta=Poupanca, descricao="Conta do Inter"}]
-}
getListaContas :: [String] -> [Conta]
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


cadastraConta :: String -> String -> String -> String -> String -> String -> String -> IO()
cadastraConta login arquivo nomeConta codigo saldo tipoConta descricao = do
        
        let lista_usuarios = Data.List.map ( splitOn ",") (lines arquivo)
        let conta = Conta {contaNome = nomeConta, contaCodigo = codigo, saldoConta = read saldo, tipoConta = read tipoConta, descricao = descricao}
        let lista_usuarios_com_contas = adicionaConta login conta lista_usuarios

        let string_nova = tranformaListaEmString lista_usuarios_com_contas

        removeFile "dados/usuarios.txt"                      
        writeFile "dados/usuarios.txt" string_nova

        putStrLn "\nConta cadastrada com sucesso.\n"


tratarErro :: String -> SomeException -> IO ()
tratarErro arquivo _ = do
        
        removeFile "dados/usuarios.txt"                      
        writeFile "dados/usuarios.txt" arquivo

        putStrLn "\nNao foi possivel cadastrar a conta, tente novamente.\n"


-- "user2" "Conta" [["user1","senha"],["user2","senha"],["user3","senha"]]           ENTRADA
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

    
calculaMeses :: Double -> Double -> Double -> Int
calculaMeses valorAlcancar valorGuardar carteira = do
    if(valorGuardar >= valorAlcancar)
        then 0
        else ceiling ((valorAlcancar - carteira)/valorGuardar)



-- Verifica Saldo total das contas de um Usuario
verificaSaldoTotal :: String -> [Usuario] -> Double 
verificaSaldoTotal login (h:t) = 
    if login == Usuario.login h
        then Usuario.getSaldoTotal h
        else verificaSaldoTotal login t


exibeMetas :: String -> String -> String
exibeMetas login arquivo =
    let lista_metas_geral = ((Data.List.map ( splitOn ",") (lines arquivo)))    
        lista_metas_filtrada = Data.List.filter (\meta -> head meta == login) lista_metas_geral
        metas_do_usuario = Data.List.map removeLoginDaLista lista_metas_filtrada
        string_final = transformaListaDeMetasEmString metas_do_usuario
    in string_final

removeLoginDaLista :: [String] -> [String]
removeLoginDaLista (h:t) = splitOn " | " (t !! 0)


transformaListaDeMetasEmString :: [[String]] -> String
transformaListaDeMetasEmString [] = ""
transformaListaDeMetasEmString (h:t) = "\nMeta: " ++ (h !! 0) ++ "\n\n * Voce ja possui: R$ " ++ (h !! 1) ++ "\n * Valor a ser guardado todo mes: R$ " ++ (h !! 2) ++ "\n * Valor a ser alcancado: R$ " ++ (h !! 3) ++ "\n * Tempo para a meta ser alcancada: " ++ (h !! 4) ++ " meses\n\n" ++ transformaListaDeMetasEmString t


persisteUsuarios :: [Usuario] -> IO()
persisteUsuarios usuarios = do 
    removeFile "dados/usuarios.txt"
    let usuarios_correto = intercalate "\n" (Data.List.map constroiStringdeUsuario usuarios)
    writeFile "dados/usuarios.txt" usuarios_correto
--NICOLASMNL,123456*,Inter|01|1200.0|CORRENTE|Conta do Inter,Nubank|02|13000.0|CORRENTE|Conta do Nubank de nicolas

constroiStringdeUsuario :: Usuario -> String
constroiStringdeUsuario Usuario{login=login, senha=senha, contas=contas} =
    (toUpperCase login) ++ "," ++ senha ++ "," ++ constroiStringDeContas contas

constroiStringDeContas :: [Conta] -> String
constroiStringDeContas contas = intercalate "," (Data.List.map constroiStringDeConta contas)

constroiStringDeConta :: Conta -> String
constroiStringDeConta Conta{contaNome=contaNome,contaCodigo=contaCodigo, saldoConta=saldoConta, tipoConta=tipoConta,descricao=descricao} = contaNome ++ "|" ++ contaCodigo ++ "|" ++ show saldoConta ++ "|" ++ show tipoConta ++ "|" ++ descricao



persisteTransferencia :: Transferencia -> IO()
persisteTransferencia transferencia = 
    appendFile "dados/transferencias.txt" ((login (usuario transferencia)) ++ "," ++ (contaCodigo (contaOrigem transferencia)) ++ "," ++(contaCodigo (contaDestino transferencia)) ++ "," ++ (show (valor transferencia)) ++ "\n")

    -- [["NICOLASMNL","01","02","200.0"],["NICOLASMNL","01","02","2000.0"]]

geraExtrato :: String -> IO [String]
geraExtrato login = do  
    arquivo <- readFile "dados/transferencias.txt"
    let lista_transferencias = ((Data.List.map ( splitOn ",") (lines arquivo)))

    let transferencias = Data.List.filter (\l -> head l == login) lista_transferencias -- [Transferencia]
    return (Data.List.map printaTransferenciasBonita transferencias)


--    ["NICOLASMNL","01","02","200.0"]
printaTransferenciasBonita :: [String] -> String
printaTransferenciasBonita transferencias =
    "\nUsuario: " ++ (transferencias !! 0) ++ "\nCódigo da Conta de Origem: " ++ (transferencias !! 1)  ++ "\nCódigo da Conta de Destino: " ++ (transferencias !! 2) ++ "\nValor da Transferência: " ++ (transferencias !! 3) ++ "\n"



-- "Inter|01|1200.0|CORRENTE|Conta do Inter"  
printaConta :: String -> String
printaConta conta = let c = splitOn "|" conta in 
    "\nNome da Conta: " ++ (c !! 0) ++ "\nCódigo da Conta: " ++ (c !! 1) ++ "\nSaldo: " ++ (c !! 2) ++"\nTipo da Conta: " ++ (c !! 3) ++"\nDescrição da conta: " ++ (c !! 4)