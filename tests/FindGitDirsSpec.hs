module FindGitDirsSpec (spec) where

import Test.Hspec
import Ypt.Commands.FindGitDirs

spec :: Spec
spec = do
    describe "in'" $ do
        it "works" $ do
            in' "b" ["a","b","c"] `shouldBe` True
            in' "d" ["a","b","c"] `shouldBe` False
