module Usuario where
import qualified Banco as Banco


data Usuario = Usuario {login :: String, senha :: String, bancos :: [Banco.Banco]} deriving (Eq, Show, Read)


getSaldoTotal :: Usuario -> Float 
getSaldoTotal user = sum (getListaDeSaldos (bancos user))

getListaDeSaldos :: [Banco.Banco] -> [Float] 
getListaDeSaldos [] = []
getListaDeSaldos (h:t) = Banco.saldo h : getListaDeSaldos t







