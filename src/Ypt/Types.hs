{-# LANGUAGE OverloadedStrings #-}
module Ypt.Types
    ( UserMessage
    , GitMessage (..)
    , GenericMessage (..)
    , errorMsg
    , warn
    )
where

import Formatting
import Data.Text.Lazy (Text, unpack)
import System.IO
import Control.Exception (SomeException)

class UserMessage a where
    showMsg :: a -> String
    showMsg = unpack . showMsgT

    showMsgT :: a -> Text

    errorMsg :: a -> b
    errorMsg = error . showMsg

    warn :: a -> IO ()
    warn x = hPutStrLn stderr $ showMsg x

type CommandName = String
type Args = [String]

data GenericMessage
    = CmdNotFound CommandName
    | MissingCommand
    | TooManyArgs CommandName Args
    | Exception SomeException
    | SkippingSymlink FilePath

instance UserMessage GenericMessage where
    showMsgT (CmdNotFound x) =
        format ("Command " % string % " not found") x
    showMsgT MissingCommand = "Missing subcommand"
    showMsgT (TooManyArgs x xs) =
        format ("Too many arguments " % shown % " for command " % shown)
               xs
               x

    showMsgT (Exception x) =
        format (shown) x

    showMsgT (SkippingSymlink x) =
        format ("Skipping symlink: " % string) x

type GitRemoteV = [String]

data GitMessage = UnexpectedGRVParse GitRemoteV

instance UserMessage GitMessage where
    showMsgT (UnexpectedGRVParse x) =
        format ("Unexpected git remote -v parse" % shown) x
