import qualified Usuario as Usuario
import Data.List
import System.IO
import Data.Map as Map 
import Data.List
import Data.List.Split (splitOn)




-- INCOMPLETO E NAO TESTADO
getListaDeUsuarios :: IO([Usuario.Usuario])
getListaDeUsuarios = do
    arquivo <- readFile "dados/usuarios.txt"
    let lista = ((Data.List.map ( splitOn ",") (lines arquivo)))
    let lista_usuarios = ((Data.List.map constroiUsuario lista))
    return lista_usuarios


-- INCOMPLETO E NAO TESTADO
constroiUsuario :: [String] -> Usuario.Usuario
constroiUsuario lista = Usuario.Usuario {
    Usuario.nome = lista !! 0,
    Usuario.cpf = lista !! 1,
    Usuario.email = lista !! 2,
    Usuario.telefone = lista !! 3,
    Usuario.senha = lista !! 4
}

