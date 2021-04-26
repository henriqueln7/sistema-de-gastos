data TipoConta = Corrente | Poupanca | Carteira deriving (Show, Eq)

data Conta = Conta {contaNome :: String, contaCodigo :: String, saldoConta :: Double, tipoConta :: TipoConta, descricao :: String} deriving (Show)

instance Eq Conta where
    c1 == c2 = (==) (contaCodigo c1) (contaCodigo c2)

data CartaoCredito = CartaoCredito {cartaoNome :: String, cartaoLimite :: Float, dataVencimento :: String, cvv :: String} deriving (Eq, Show, Read)

-- Por enquanto esse usuário é praticamente uma imitação do usuário que existe em Usuario.hs. Coloquei aqui apenas para fins de discussões sobre como devemos representar o usuário :)
data Usuario = Usuario {login :: String, senha :: String, contas :: [Conta], cartoesCredito :: [CartaoCredito]} deriving (Show)

type InformacaoConta = (String, Double)

verificarSaldo :: Usuario -> [InformacaoConta]
verificarSaldo usuario = map (\conta -> (contaNome conta, saldoConta conta)) (contas usuario)

data CategoriaReceita = Emprestimo | Investimento | Salario | OutrasReceitas
data TransacaoReceita = TransacaoReceita {valorTransacaoReceita :: Double, categoriaReceita :: CategoriaReceita, dataReceita :: String, contaDestino :: Conta}

-- Aqui ainda tá duplicando a conta dentro de usuário :(
registrarReceita :: TransacaoReceita -> Usuario ->  Usuario
registrarReceita TransacaoReceita {valorTransacaoReceita = valor, contaDestino = contaDestino} usuario = usuario {contas = alterarValorConta (contaDestino {saldoConta = saldoConta contaDestino + valor}) (contas usuario) }

-- Pega o valor de uma determinada conta dentro da lista de conta, altera e retorna uma nova lista.
alterarValorConta :: Conta -> [Conta] -> [Conta]
alterarValorConta contaParaAlterar = map (\c -> if c == contaParaAlterar then contaParaAlterar else c)