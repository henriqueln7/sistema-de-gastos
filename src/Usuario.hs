module Usuario where
import Banco  
import Conta


data Usuario = Usuario {login :: String, senha :: String, contas :: [Conta]} deriving (Eq, Show, Read)


getSaldoTotal :: Usuario -> Double 
getSaldoTotal user = sum (map saldoConta (contas user))








