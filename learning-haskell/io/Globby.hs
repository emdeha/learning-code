{-
    Glob Patterns Implmentation.

    - Matching starts and the string's beginning and finishes at its end.
        Example:
            'foo' matches only foo and not Ffoo or something alike.
    - Most literal characters match themselves.
        Example:
            'foo' matches the string foo and nothing else. There's no hidden 
            context here.
    - '*' -- matches anything.
    -   Example:
    -       'bar*' matches bar followed by any string of characters.
    - '?' -- matches any single character.
        Example:
    -       'alma??.c' matches, for example, almaCr.c
    - '[chars]' -- match any character in this class.
        - '!' -- negates it.
        - '-' in a '[...]' -- defines a range of characters.
        - Character classes can't be empty -- allows '[]abc]'
            Example:
                'pic.[pP][!nN][a-f]' matches pic.(p|P)(anything different than nN)(a to f)
-}
module Globby
    (
      (%=),
      getAfterClass,
      getClass
    ) where

(%=) :: String -> String -> Bool
(%=) pattern str = matchesGlob pattern str

matchesGlob :: String -> String -> Bool
matchesGlob "" ""   = True
matchesGlob ['*'] _ = True
matchesGlob "" _    = False
matchesGlob _ ""    = False

matchesGlob ('?':ps) (x:xs) = matchesGlob ps xs

matchesGlob pat@('*':p:ps) (x:xs)
    | and [p == x, not $ isPattern x] = matchesGlob ps xs
    | otherwise                       = matchesGlob pat xs

matchesGlob ('[':ps) (x:xs) =
    if isInClass x ps
    then matchesGlob (getAfterClass ps) xs
    else False

matchesGlob (p:ps) (x:xs)
    | p == x      = matchesGlob ps xs
    | otherwise   = False


isPattern x = or [x == y | y <- ['?', '*', '[', ']']]

isInClass :: Char -> String -> Bool
isInClass x ps =
    if head ps == '!'
    then not $ x `elem` (getClass $ tail ps)
    else x `elem` getClass ps

getClass :: String -> String
getClass pat = getClass' pat 0
    where 
        getClass' [] _ = error "unterminated character class"
        getClass' [_] _ = []
        getClass' (x:y:cl) cnt
            | y == '-'  = [x..(head cl)] ++ getClass' (tail cl) (cnt+1)
            | otherwise = 
                if or [x /= ']', cnt == 0]
                then x : (getClass' (y:cl) (cnt+1))
                else []

getAfterClass :: String -> String
getAfterClass pat = getAfterClass' pat 0
    where 
        getAfterClass' "" _ = error "non terminated character class"
        getAfterClass' (p:ps) cnt
            | p == ']'  = 
                    if cnt == 0 
                    then getAfterClass' ps (cnt+1)
                    else ps
            | otherwise = getAfterClass' ps (cnt+1)
