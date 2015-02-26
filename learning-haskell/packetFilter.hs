-- |
-- Implements a very simple Firewall that filters packets based on a rulebase of
-- rules matching the source and dest hosts and the payload of the packet.
-- The Firewall produces a log of its activity.
-- |
module Main where

data Entry = Log { count :: Int, msg :: String } deriving Eq

logMsg :: String -> Writer [Entry] ()
logMsg s = tell [Log 1 s]

filterOne :: [Rule] -> Packet -> Writer [Entry] (Maybe Packet)
filterOne rules packet = do
    rule <- return (match rules packet)
    case rule of
        Nothing -> do
            logMsg $ "Dropping unmatched packet: " ++ (show packet)
            return Nothing
        (Just r) -> do
            when (logIt r) $ logMsg ("Match: " ++ (show r) ++ " <=> " ++ (show packet))
            case r of (Rule Accept _ _) -> return $ Just packet
                      (Rule Reject _ _) -> return Nothing
