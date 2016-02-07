import Data.List

sumDigits :: Integer -> Integer
sumDigits n
    | n == 0    = 0
    | n > 0     = n `mod` 10 + sumDigits (n `quot` 10)
    | otherwise = -1

biggestDigit :: Integer -> Integer
biggestDigit n
    | n == 0    = 0
    | otherwise = max (n `mod` 10) (biggestDigit $ n `quot` 10)

gcd' :: Integer -> Integer -> Integer
gcd' n k
    | k == 0    = n
    | otherwise = gcd' k (n `mod` k)

productEven :: Integer -> Integer -> Integer
productEven a b = product . filter even $ [a..b]

isIncreasing :: String -> Bool
isIncreasing [] = True
isIncreasing (x:y:xs) = (x < y) && isIncreasing xs

countChar :: Char -> String -> Int
countChar ch = foldl (\acc x -> if x == ch then acc + 1 else acc) 0

removeFirst :: Int -> Char -> String -> String
removeFirst 0 _ str  = str
removeFirst _ _ []   = []
removeFirst n ch str = 
    let cleanStr = takeWhile (/=ch) str
        dirtyStr = dropWhile (/=ch) str
    in cleanStr ++ (removeFirst (n-1) ch (tail dirtyStr))

insertSorted :: Char -> String -> String
insertSorted ch sortedStr =
    let less = takeWhile (<ch) sortedStr
        more = dropWhile (<ch) sortedStr
    in less ++ [ch] ++ more

append :: String -> String -> String
append first second = first ++ second

replace :: Char -> Char -> String -> String
replace _ _ [] = []
replace oldCh newCh str = 
    let before = takeWhile (/=oldCh) str
        after  = dropWhile (/=oldCh) str
    in before ++ [newCh] ++ replace oldCh newCh (tail after)
    
sum' [] = 0
sum' (x:xs) = x + sum' xs

sum'' l = foldl (\acc x -> acc + x) 0 l
