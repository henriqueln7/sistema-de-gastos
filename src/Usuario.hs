module Usuario where


data Usuario = Usuario {login :: String, senha :: String, bancos :: [Banco]} deriving (Eq, Show, Read)


        
