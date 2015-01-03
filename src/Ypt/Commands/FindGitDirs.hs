{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# OPTIONS_GHC -fno-warn-type-defaults #-}
module Ypt.Commands.FindGitDirs
    ( main
    -- for hspec:
    , in'
    )
where

import Prelude hiding (FilePath, error)
import qualified Prelude as P
import System.Directory
import Filesystem.Path
import Filesystem.Path.CurrentOS
import Shelly
import Data.List.Split
import Data.List.Utils
import qualified Data.Text as T
import Control.Exception (catch, SomeException, toException)
import Ypt.Types
import qualified System.FilePath.Posix as FPP
import GHC.IO.Exception
import Control.Exception (throwIO)

main :: [String] -> IO ()
main []     = getCurrentDirectory >>= findGitDirs . fromText . T.pack
main (x:[]) = findGitDirs . fromText $ T.pack x
main (_:xs) = errorMsg $ TooManyArgs "find-git-dirs" xs

isGit :: FilePath -> Bool
isGit p = (filename p) == (fromText $ T.pack ".git")

getDirsR' :: P.FilePath -> IO [P.FilePath]
getDirsR' p = do
    xs <- catch (catch (getDirectoryContents p) iOErrHandler) allHandler
    let xs' = [FPP.combine p x | x <- xs, not (in' x [".", ".."]) ]
    children <- mapM getDirsR' xs'
    return $ xs' ++ P.concat children
  where
    allHandler :: SomeException -> IO [P.FilePath]
    allHandler ex = warn (Exception (toException ex)) >> return []

    iOErrHandler :: IOError -> IO [P.FilePath]
    iOErrHandler (IOError { ioe_type = InappropriateType }) = return []
    iOErrHandler ex = throwIO ex

getDirsR :: FilePath -> IO [FilePath]
getDirsR p = do
    xs <- getDirsR' (encodeString p)
    return $ map decodeString xs

in' :: Eq a => a -> [a] -> Bool
in' x xs = any (x ==) xs

getGitDirs :: FilePath -> IO [FilePath]
getGitDirs p = do
    dirs <- getDirsR p
    return [ parent x | x <- filter isGit dirs ]

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
