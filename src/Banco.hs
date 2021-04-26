module Banco where

data Banco = Banco {nome :: String, saldo :: Float} deriving (Eq, Show, Read)


somaSaldoDeBancos :: [Banco] -> Float
somaSaldoDeBancos [] = 0
somaSaldoDeBancos (h:t) = saldo h + somaSaldoDeBancos t
        



