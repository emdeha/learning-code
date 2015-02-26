import Control.Monad

module Logger
    ( Logger
    , Log
    , runLogger
    , record
    ) where

type Log = [String]

newtype Logger a = Logger { execLogger :: (a, Log) }

instance Monad Logger where
    return a = Logger (a, [])
    m >>= k = let (a, w) = execLogger m
                  n      = k a
                  (b, x) = execLogger n
              in  Logger (b, w ++ x)


-- Evaluates a logged action and returns both its result and log messages
runLogger :: Logger a -> (a, Log)
runLogger = execLogger

-- Logs a message
record :: String -> Logger ()
record s = Logger ((), [s])


globToRegex :: String -> Logger String
globToRegex cs =
    globToRegex' cs >>= \ds ->
    return ('^':ds)

globToRegex' :: String -> Logger String
globToRegex' "" = return "$"

globToRegex' ('?':cs) = do
    record "any"
    ds <- globToRegex' cs
    return ('.':ds)

globToRegex' ('*':cs) = do
    record "kleene star"
    ds <- globToRegex' cs
    return (".*" ++ ds)

globToRegex' ('[':'!':cs) =
    record "character class, negative" >>
    charClass cs >>= \ds ->
    return ("[^" ++ c : ds)
globToRegex' ('[':c:cs) =
    record "character class" >>
    charClass cs >>= \ds ->
    return ("[" ++ c : ds)
globToRegex' ('[':_) = 
    fail "unterminated char class"

globToRegex' (c:cs) = liftM2 (++) (escape c) (globToRegex' cs)


escape :: Char -> Logger String
escape c
    | c `elem` regexChars = record "escape" >> return ['\\', c]
    | otherwise           = return [c]
  where regexChars = "\\+()^$.{}]|"


charClass :: String -> Logger String
charClass (']':cs) = (']':) `liftM` globToRegex' cs
charClass (c:cs) = (c:) `liftM` charClass cs
