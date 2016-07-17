module Ypt.Commands.Addrinfo
    ( main
    )
where

import Network.Socket
import Control.Lens

getAddrInfo' :: [String] -> IO [AddrInfo]
getAddrInfo' args = getAddrInfo hints host port
    where
        hints = Just defaultHints
        host  = args ^? ix 0
        port  = args ^? ix 1

main :: [String] -> IO ()
main xs = getAddrInfo' xs >>=  mapM_ print
