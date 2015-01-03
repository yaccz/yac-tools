module FindGitDirsSpec (spec) where

import Test.Hspec
import Ypt.Commands.FindGitDirs
import Filesystem.Path.CurrentOS

spec :: Spec
spec = do
    describe "in'" $ do
        it "works" $ do
            in' "b" ["a","b","c"] `shouldBe` True
            in' "d" ["a","b","c"] `shouldBe` False

    describe "isGit" $ do
        it "works" $ do
            isGit (decodeString "/foo/bar.git") `shouldBe` False
            isGit (decodeString "/foo/bar/.git") `shouldBe` True
