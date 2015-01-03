import System.Environment
import Ypt.Types
import qualified Ypt.Commands.FindGitDirs as FGD


dispatchCommand :: [String] -> IO ()
dispatchCommand []                   = errorMsg MissingCommand

dispatchCommand ("find-git-dirs":xs) = FGD.main xs

dispatchCommand (x:_)                = errorMsg $ CmdNotFound x

main :: IO ()
main = getArgs >>= dispatchCommand
