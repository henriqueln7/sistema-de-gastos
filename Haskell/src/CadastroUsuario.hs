module CadastroUsuario where

import Auxiliar
import System.IO
import System.Directory
import Data.Char

-- Função que irá cadastrar o usuário num arquivo .txt, mantendo um registro dos usuarios cadastrados
cadastraUsuario :: String -> String -> IO ()
cadastraUsuario login senha =
    if validaCadastro login senha
        then
            do
            appendFile "dados/usuarios.txt" (Auxiliar.toUpperCase login ++ "," ++ senha ++ "\n")
            putStrLn "Cadastro realizado com sucesso\n"

        else
            do
            putStrLn "Nao foi possivel realizar o cadastro. Tente novamente\n"


-- -- Função que vai ser responsável por validar o cadastro do Usuário
-- -- Login não pode ser vazio
-- -- Senha não pode ser vazia
-- -- senha possui 6 ou mais caracteres
validaCadastro :: String -> String -> Bool
validaCadastro "" senha = False
validaCadastro login "" = False
validaCadastro login senha = length senha > 6 && any (`elem` ['*', '!', '@', '/', '#']) senha

