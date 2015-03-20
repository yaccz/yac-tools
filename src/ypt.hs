import System.Environment
import Ypt.Types
import qualified Ypt.Commands.FindGitDirs as FGD
import qualified Ypt.Commands.Addrinfo as AI
import qualified Ypt.Commands.OBShs as OBShs

dispatchCommand :: [String] -> IO ()
dispatchCommand []                   = errorMsg MissingCommand

dispatchCommand ("find-git-dirs":xs) = FGD.main xs
dispatchCommand ("addrinfo":xs)      = AI.main xs
dispatchCommand ("obshs":xs)         = OBShs.main xs

dispatchCommand (x:_)                = errorMsg $ CmdNotFound x

main :: IO ()
main = getArgs >>= dispatchCommand
