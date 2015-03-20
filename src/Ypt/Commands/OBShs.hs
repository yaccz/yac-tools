{-# LANGUAGE OverloadedStrings #-}
module Ypt.Commands.OBShs
    ( main
    )
where

import Data.Monoid
import Data.Text (pack, unpack)
import System.FilePath.Glob
import Turtle hiding (match)
import Turtle.Shell
import Ypt.Types

src :: Text
src = "devel:languages:haskell"

dst :: Text
dst = "home:yac:branches:" <> src

main :: [String] -> IO ()
main xs = rmain $ map pack xs

rmain :: [Text] -> IO ()
rmain [] = errorMsg MissingCommand
rmain ("br"  :xs) = mapM_ branch xs
rmain ("ln"  :xs) = mapM_ link xs
rmain ("bump":xs) = mapM_ bump xs
rmain ("mk"  :xs) = mapM_ make xs
rmain xs = errorMsg $ InvalidCommand "obshs" $ map unpack xs

type Package = Text

osc :: [Text] -> IO ExitCode
osc xs = proc "osc" xs empty

branch :: Package -> IO ExitCode
branch p = osc ["branch", src, p, dst]

link :: Package -> IO ExitCode
link p = osc ["linkpac", src, p, dst]

bump :: Package -> IO ExitCode
bump p = do
    branch p
    sleep 1.0
    osc ["co", p]
    cd $ fromText p
    mv (expandGlob "*.spec") "s"
    proc "cabal-rpm" ["spec", dropGhc p] empty
    shell $ "diff -bur s " <> p <> ".spec | vim -"
    osc ["rm", "_service"]
    osc ["rm", expandGlob "*gz"]
    osc ["service", "localrun", "download_files"]
    osc ["add", expandGlob "*gz"]
    shell "spec-cleaner -i *spec"
    rm "s"
    osc ["ci", "-m", "version bump"]

expandGlob pat = match (compile pat) pwd

dropGhc :: Text -> Text
dropGhc = take 4

make :: Package -> IO ExitCode
make p = do
    mkdir p
    cd p
    proc "cabal-rpm" ["spec", dropGhc p] empty
    cd ".."

    osc ["add", p]
    osc ["ci", "-m", "new pkg"]

    cd p
    osc ["service", "localrun", "download_files"]
    osc ["add", expandGlob "*gz"]
    osc ["ci", "-m", "add tarball"]
    cd ".."
