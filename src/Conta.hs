module Conta where 

import Data.List.Split (splitOn)



data TipoConta = Corrente | Poupanca | Carteira deriving (Show, Eq, Read)

data Conta = Conta {contaNome :: String, contaCodigo :: String, saldoConta :: Double, tipoConta :: TipoConta, descricao :: String} deriving (Show, Read)

instance Eq Conta where
    c1 == c2 = (==) (contaCodigo c1) (contaCodigo c2)

type InformacaoConta = (String, Double)

data CategoriaTransacao = Transferencia
data Transacao = Transacao {valorTransacao :: Double, categoriaReceita :: CategoriaTransacao, dataTransacao :: String, contaOrigem:: Conta , contaDestino :: Conta}


--ENTRADA 
-- Usuario {login = "raphael", senha = "111", contas = ["Nubank|001|1300.0|Corrente|Conta do Nubank","Inter|002|1200.0|Poupança|Conta do Inter"]}
--Usuario> let c1 = Conta { contaNome = "BB", contaCodigo = "01", saldoConta = 30, tipoConta = Corrente, descricao = "Banco do Brasil"}
-- *Usuario> let c2 = Conta { contaNome = "Nubank", contaCodigo = "10", saldoConta = 50, tipoConta = Corrente, descricao = "Roxinho"}
-- *Usuario> let usuario = Usuario {login = "henriqueln", senha="123456", contas = [c1,c2]}
-- *Usuario> let novoUsuario = realizaTransacao usuario c2 c1 40
-- *Usuario> let usuario = Usuario {login = "henriqueln", senha="123456", contas = [c1,c2]}
-- *Usuario> novoUsuario 
-- Usuario {login = "henriqueln", senha = "123456", contas = [Conta {contaNome = "BB", contaCodigo = "01", saldoConta = 70.0, tipoConta = Corrente, descricao = "Banco do Brasil"},Conta {contaNome = "Nubank", contaCodigo = "10", saldoConta = 10.0, tipoConta = Corrente, descricao = "Roxinho"}]}
    


--["Nubank|001|120|Corrente|Conta do Nubank", "InterSA|002|200|Poupanca|Conta Do Inter"] 
encontraConta :: [String] -> String -> Int -> Conta
encontraConta contas codigoConta i = do
    if (i < length contas)
        then do
            let c = Data.List.Split.splitOn "|" (contas !! i) -- ["Nubank","001","120","Corrente","Conta do Nubank"]
            if ((c !! 1) == codigoConta)
                then Conta {
                    contaNome = c !! 0,
                    contaCodigo = c !! 1,
                    saldoConta = read (c !! 2),
                    tipoConta = read (c !! 3),
                    descricao = c !! 4
                } 
                else encontraConta contas codigoConta (i + 1)
        else 
            Conta {
                    contaNome = "Nada",
                    contaCodigo = "Nada",
                    saldoConta = 0,
                    tipoConta = Corrente,
                    descricao = "Nada"
                } 
  

    
    --data Usuario = Usuario {login :: String, senha :: String, contas :: [Conta]} deriving (Eq, Show, Read)
-- Pega o valor de uma determinada conta dentro da lista de conta, altera e retorna uma nova lista.
alterarValorConta :: Conta -> [Conta] -> [Conta]
alterarValorConta contaParaAlterar = map (\c -> if c == contaParaAlterar then contaParaAlterar else c)


-- verificarSaldo :: Usuario -> [InformacaoConta]
-- verificarSaldo usuario = map (\conta -> (contaNome conta, saldoConta conta)) (contas usuario)