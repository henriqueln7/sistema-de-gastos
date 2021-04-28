module Usuario where
import Banco  
import Conta


data Usuario = Usuario {login :: String, senha :: String, contas :: [Conta]} deriving (Eq, Show, Read)


getSaldoTotal :: Usuario -> Double 
getSaldoTotal user = sum (map saldoConta (contas user))

realizaTransacao :: Usuario -> Conta -> Conta -> Double -> Usuario
realizaTransacao usuario contaOrigem contaDestino valor = let novaContaOrigem = contaOrigem {saldoConta = saldoConta contaOrigem - valor}
                                                              novaContaDestino = contaDestino {saldoConta = saldoConta contaDestino + valor}
                                                          in
                                                              usuario {contas = alterarValoresContas (novaContaOrigem, novaContaDestino) (contas usuario)}

-- Pega o valor de uma determinada conta dentro da lista de conta, altera e retorna uma nova lista.
alterarValoresContas :: (Conta, Conta) -> [Conta] -> [Conta]
alterarValoresContas (contaOrigem, contaDestino) contas = map (\conta -> if conta == contaOrigem  then contaOrigem else if conta == contaDestino then contaDestino else conta) contas







