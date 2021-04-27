module Conta where 



data TipoConta = Corrente | Poupanca | Carteira deriving (Show, Eq, Read)

data Conta = Conta {contaNome :: String, contaCodigo :: String, saldoConta :: Double, tipoConta :: TipoConta, descricao :: String} deriving (Show, Read)

instance Eq Conta where
    c1 == c2 = (==) (contaCodigo c1) (contaCodigo c2)

type InformacaoConta = (String, Double)

data CategoriaTransacao = Transferencia
data Transacao = Transacao {valorTransacao :: Double, categoriaReceita :: CategoriaTransacao, dataTransacao :: String, contaOrigem:: Conta , contaDestino :: Conta}

-- Aqui ainda tá duplicando a conta dentro de usuário :(

-- Pega o valor de uma determinada conta dentro da lista de conta, altera e retorna uma nova lista.
alterarValorConta :: Conta -> [Conta] -> [Conta]
alterarValorConta contaParaAlterar = map (\c -> if c == contaParaAlterar then contaParaAlterar else c)


-- verificarSaldo :: Usuario -> [InformacaoConta]
-- verificarSaldo usuario = map (\conta -> (contaNome conta, saldoConta conta)) (contas usuario)