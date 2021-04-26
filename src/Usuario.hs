module Usuario where
import qualified Banco as Banco


data Usuario = Usuario {login :: String, senha :: String, bancos :: [Banco.Banco]} deriving (Eq, Show, Read)


getSaldoTotal :: Usuario -> Float 
getSaldoTotal user = Banco.somaSaldoDeBancos (bancos user)








