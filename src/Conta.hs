data TipoConta = Corrente | Poupanca | Carteira deriving (Show)

data Conta = Conta {contaNome :: String, contaCodigo :: String, saldoConta :: Double, tipoConta :: TipoConta, descricao :: String} deriving (Show)

data CartaoCredito = CartaoCredito {cartaoNome :: String, cartaoLimite :: Float, dataVencimento :: String, cvv :: String} deriving (Eq, Show, Read)

data Usuario = Usuario {login :: String, senha :: String, contas :: [Conta], cartoesCredito :: [CartaoCredito]} deriving (Show)

type InformacaoConta = (String, Double)

verificarSaldo :: Usuario -> [InformacaoConta]
verificarSaldo usuario = map (\conta -> (contaNome conta, saldoConta conta)) (contas usuario)

data TipoTransacao = Receita | Despesa | Transferencia

-- ContaTransacao é em qual conta a operação está sendo realizada
-- data Transacao = Transacao {valorTransacao :: Double, dataTransacao :: String, contaTransacao :: Conta, tipoTransacao :: TipoTransacao}

data CategoriaReceita = Emprestimo | Investimento | Salario | OutrasReceitas
data TransacaoReceita = TransacaoReceita {valorTransacaoReceita :: Double, categoriaReceita :: CategoriaReceita, dataReceita :: String, contaDestino :: Conta}

registrarReceita :: TransacaoReceita -> Usuario ->  Usuario
registrarReceita TransacaoReceita {valorTransacaoReceita = valor, contaDestino = contaDestino} usuario = usuario {contas = contas usuario ++ [contaDestino {saldoConta = saldoConta contaDestino + valor}]}

-- registrarDespesa :: Transacao -> Conta
-- registrarDespesa transacao = let conta = contaTransacao transacao in conta {saldoConta = saldoConta conta - valorTransacao transacao}

-- registrarTransferencia :: Transacao -> Conta -> Conta -> (Conta, Conta)
-- registrarTransferencia transacao c1 c2 =
--   ( c1 {saldoConta = saldoConta c1 - valorTransacao transacao},
--     c2 {saldoConta = saldoConta c2 + valorTransacao transacao}
--   )