module Usuario where

import System.IO ()

data Usuario = Usuario {nome :: String
,cpf :: String
,email :: String
,telefone :: String
,senha :: String
} deriving (Eq, Show, Read)


criaUsuario :: String -> String -> String -> String -> String -> Usuario
createUsuario nome cpf email telefone senha = (Usuario {nome = nome, cpf = cpf, email = email, telefone = telefone, senha = senha})



