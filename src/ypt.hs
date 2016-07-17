import System.Environment
import Ypt.Types
import qualified Ypt.Commands.FindGitDirs as FGD
import qualified Ypt.Commands.Addrinfo as AI


dispatchCommand :: [String] -> IO ()
dispatchCommand []                   = errorMsg MissingCommand

dispatchCommand ("find-git-dirs":xs) = FGD.main xs
dispatchCommand ("addrinfo":xs)      = AI.main xs

dispatchCommand (x:_)                = errorMsg $ CmdNotFound x

main :: IO ()
main = getArgs >>= dispatchCommand
