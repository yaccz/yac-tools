{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# OPTIONS_GHC -fno-warn-type-defaults #-}

import Prelude hiding (FilePath)
import System.Environment
import Formatting
import Data.Text.Lazy (Text)
import System.Directory
import Filesystem.Path
import Filesystem.Path.CurrentOS
import Shelly
import Data.List.Split
import Data.List.Utils
import qualified Data.Text as T
default (T.Text)

type CommandName = String
type Args = [String]
type ParsedGitRemoteV = [String]

data Message = CmdNotFound CommandName
             | MissingCommand
             | TooManyArgs CommandName Args
             | UnexpectedGRVParse ParsedGitRemoteV

errmsg :: Message -> a
errmsg m = error . show $ errmsg' m

errmsg' :: Message -> Text
errmsg' (CmdNotFound x) =
    format ("Command " % string % " not found") x
errmsg' MissingCommand = "Missing subcommand"
errmsg' (TooManyArgs x xs) =
    format ("Too many arguments " % shown % " for command " % shown)
           xs
           x
errmsg' (UnexpectedGRVParse xs) =
    format ("Unexpected git remote -v parse" % shown) xs

dispatchCommand :: [String] -> IO ()
dispatchCommand [] = errmsg MissingCommand
dispatchCommand ("find-git-dirs":xs) = main_findGitDirs xs
dispatchCommand (x:_) = errmsg $ CmdNotFound x

main_findGitDirs :: [String] -> IO ()
main_findGitDirs []     = getCurrentDirectory >>= findGitDirs . fromText . T.pack
main_findGitDirs (x:[]) = findGitDirs . fromText $ T.pack x
main_findGitDirs (_:xs) = errmsg $ TooManyArgs "find-git-dirs" xs

isGit :: FilePath -> Bool
isGit p = (filename p) == (fromText $ T.pack ".git")

getGitDirs :: FilePath -> IO [FilePath]
getGitDirs p = shelly $ do
    dirs <- findDirFilter (\_ -> shelly $ return True) p
    return $ map parent $ filter isGit dirs

type GitRemoteName = String
type GitRemoteUri  = String
type GitRemoteUriType = String
data GitRemote = GitRemote GitRemoteName GitRemoteUri GitRemoteUriType
    deriving (Show)

getGitRemotes :: FilePath -> IO [GitRemote]
getGitRemotes p = do
    xs <- raw_remotes p
    return
        $ map gGRfL
        $ map (filter (/= ""))
        $ map (splitOn " ")
        $ lines
        $ replace "\t" " "
        $ T.unpack xs

  where
    raw_remotes p' = shelly $ silently $ cd p' >> cmd "git" "remote" "-v"
    -- get Git Remote from List
    gGRfL (name:(uri:(type_:[]))) = GitRemote name uri type_
    gGRfL xs = errmsg $ UnexpectedGRVParse xs

findGitDirs :: FilePath -> IO ()
findGitDirs p = do
    gs <- getGitDirs p
    rs <- mapM getGitRemotes gs

    mapM_ printRemote $ zip gs rs

printRemote :: (FilePath, [GitRemote]) -> IO ()
printRemote (p, xs) = do
    putStrLn $ encodeString p
    mapM_ pRemote xs
    putStrLn ""
  where
    pRemote (GitRemote n u t) = putStrLn $ "\t" ++ join " " [n, u, t]

main :: IO ()
main = getArgs >>= dispatchCommand
