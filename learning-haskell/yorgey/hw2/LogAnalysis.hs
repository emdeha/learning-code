{-# OPTIONS_GHC -Wall #-}
module LogAnalysis where

import Log


types :: [String]
types = ["E", "I", "W"]

-- | Parses an individual line from the log file
--  TODO: Refactor and fix the following bad parses:
--          E 10 <msg>
--          [EIW] <msg>
--          [EIW]<msg>
--          [IW] <sev><msg>
parseMessage :: String -> LogMessage
parseMessage [] = Unknown []
parseMessage msg =
    let (t, rest) = firstBy ' ' msg
    in  if any (==t) types
        then createMsg t rest
        else Unknown msg
  where createMsg :: String -> String -> LogMessage
        createMsg "E" str = 
            let (sev, str') = firstBy ' ' str
                (ts, str'') = firstBy ' ' str'
            in  LogMessage (Error (read sev)) (read ts) (tail str'')
        createMsg t' str =
            let (ts, str') = firstBy ' ' str
            in  case t' of
                    "I" -> LogMessage Info (read ts) (tail str')
                    "W" -> LogMessage Warning (read ts) (tail str')
                    _   -> Unknown msg

        firstBy :: Char -> String -> (String, String)
        firstBy dm = span (/=dm) . dropWhile (==dm)

-- | Parses each line in @file@ into a log message
parse :: String -> [LogMessage]
parse file = map parseMessage $ lines file


-- | Inserts a new @LogMessage@ into an existing @MessageTree@ producing a new
--   @MessageTree@.
--   If the @LogMessage@ is @Unknown@ it returns the @MessageTree@ unchanged.
insert :: LogMessage -> MessageTree -> MessageTree
insert (Unknown _) tree = tree
insert msg Leaf = (Node Leaf msg Leaf)
insert _ (Node _ (Unknown _) _) = error $ "Borked MessageTree"
insert msg tree@(Node left curr@(LogMessage _ ts' _) right) =
    case msg of 
        (Unknown _)         -> tree
        (LogMessage _ ts _) ->
                if ts < ts' 
                then (Node (insert msg left) curr right)
                else (Node left curr (insert msg right))


-- | Builds up a @MessageTree@ containing @msgs@
build :: [LogMessage] -> MessageTree
build = foldr insert Leaf


-- | Produces a sorted list of @LogMessage@ from a built @MessageTree@
inOrder :: MessageTree -> [LogMessage]
inOrder Leaf = []
inOrder (Node Leaf msg Leaf) = [msg]
inOrder (Node left msg Leaf) = inOrder left ++ [msg]
inOrder (Node Leaf msg right) = msg : inOrder right
inOrder (Node left msg right) = inOrder left ++ [msg] ++ inOrder right


-- | Takes an unsorted list of @LogMessages@ and returns a list of errors with
--   severity 50 or greater sorted by timestamp.
whatWentWrong :: [LogMessage] -> [String]
whatWentWrong = map getMsg . filter severe . inOrder . build
  where severe (Unknown _)        = error "Borked message list"
        severe (LogMessage t _ _) = 
                case t of 
                    (Error sev) -> sev >= 50
                    _           -> False
  
        getMsg (Unknown _)          = error "Borked message list"
        getMsg (LogMessage _ _ msg) = msg
