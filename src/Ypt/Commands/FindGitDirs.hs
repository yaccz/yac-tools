{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# OPTIONS_GHC -fno-warn-type-defaults #-}
module Ypt.Commands.FindGitDirs
    ( main
    )
where

import Prelude hiding (FilePath, error)
import System.Directory
import Filesystem.Path
import Filesystem.Path.CurrentOS
import Shelly
import Data.List.Split
import Data.List.Utils
import qualified Data.Text as T
import Ypt.Types


main :: [String] -> IO ()
main []     = getCurrentDirectory >>= findGitDirs . fromText . T.pack
main (x:[]) = findGitDirs . fromText $ T.pack x
main (_:xs) = errorMsg $ TooManyArgs "find-git-dirs" xs

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
    gGRfL xs = errorMsg $ UnexpectedGRVParse xs

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
