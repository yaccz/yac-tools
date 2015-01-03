{-# LANGUAGE OverloadedStrings #-}
module Ypt.Types
    ( UserMessage
    , GitMessage (..)
    , GenericMessage (..)
    , errorMsg
    )
where

import Formatting
import Data.Text.Lazy (Text)

class UserMessage a where
    showMsg :: a -> String

    showMsgT :: a -> Text
    showMsg = show . showMsgT

    errorMsg :: a -> b
    errorMsg = error . showMsg

type CommandName = String
type Args = [String]

data GenericMessage
    = CmdNotFound CommandName
    | MissingCommand
    | TooManyArgs CommandName Args

instance UserMessage GenericMessage where
    showMsgT (CmdNotFound x) =
        format ("Command " % string % " not found") x
    showMsgT MissingCommand = "Missing subcommand"
    showMsgT (TooManyArgs x xs) =
        format ("Too many arguments " % shown % " for command " % shown)
               xs
               x




type GitRemoteV = [String]

data GitMessage = UnexpectedGRVParse GitRemoteV

instance UserMessage GitMessage where
    showMsgT (UnexpectedGRVParse x) =
        format ("Unexpected git remote -v parse" % shown) x
