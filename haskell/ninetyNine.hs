import qualified System.Random as R
import Control.Monad
import Data.List

-------------------
-- LIST PROBLEMS --
-------------------
myLast :: [a] -> a
myLast [x] = x
myLast (_:xs) = myLast xs

myButLast :: [a] -> a
myButLast [x,_] = x
myButLast (_:xs) = myButLast xs

elemAt :: [a] -> Int -> a
elemAt [] n = error "past list bounds"
elemAt (x:xs) 1 = x
elemAt (x:xs) n = elemAt xs (n-1)

myLength :: [a] -> Int
myLength = foldl (\acc _ -> acc + 1) 0

myReverse :: [a] -> [a]
myReverse list = myReverse' list []
    where myReverse' [] reversed = reversed
          myReverse' (x:xs) reversed = myReverse' xs (x:reversed)

isPalindrome :: Eq a => [a] -> Bool
isPalindrome ls = 
    let splitLs = splitAt ((genericLength ls) `div` 2) ls
    in  and $ zipWith (==) (fst splitLs) (reverse . snd $ splitLs)

data NestedList a = Elem a | List [NestedList a] deriving (Show)

flatten :: (NestedList a) -> [a]
flatten (List []) = []   
flatten (Elem a) = [a]
flatten (List ls) = foldl (\acc x -> acc ++ flatten x) [] ls

compress :: Eq a => [a] -> [a]
compress [] = []
compress (x:xs) = x:(compress $ dropWhile (==x) xs)

pack :: Eq a => [a] -> [[a]]
pack [] = []
pack (x:xs) = (x:(takeWhile (==x) xs)):(pack $ dropWhile (==x) xs)

encode :: Eq a => [a] -> [(Int,a)]
encode [] = []
encode ls = map (\x -> (length x, head x)) $ pack ls

------------------------
-- MORE LIST PROBLEMS --
------------------------
data EncodedVal a = Multiple Int a | Single a deriving Show

cleanEncode :: Eq a => [a] -> [(EncodedVal a)]
cleanEncode [] = [] 
cleanEncode ls = map encodeFunc $ pack ls
    where encodeFunc innerLs
            | length innerLs == 1 = Single $ head innerLs
            | otherwise           = Multiple (length innerLs) (head innerLs)

cleanDecode :: [(EncodedVal a)] -> [a]
cleanDecode [] = []
cleanDecode ls = concatMap decodeFunc ls
    where decodeFunc (Single x) = [x]
          decodeFunc (Multiple n x) = replicate n x

encodeHelper :: Eq a => [a] -> Int -> [(EncodedVal a)]
encodeHelper []     _ = []
encodeHelper (x:[]) n
    | n == 1    = [(Single x)]
    | otherwise = [(Multiple n x)]
encodeHelper (x:y:xs) n
    | x == y    = encodeHelper (y:xs) (n+1)
    | otherwise = 
        let encodedVal = if n == 1 then Single x else (Multiple n x)
        in encodedVal:(encodeHelper (y:xs) 1)

encodeWP :: Eq a => [a] -> [(EncodedVal a)]
encodeWP ls = encodeHelper ls 1

dupli :: [a] -> [a]
dupli [] = []
dupli (x:xs) = (x:[x]) ++ dupli xs

repli :: [a] -> Int -> [a]
repli l n = concatMap (replicate n) l

dropEvery :: [a] -> Int -> [a]
dropEvery [] _ = []
dropEvery l n = 
    let (first, second) = splitAt (n-1) l
        rest = if length second > 1 then tail second else second
    in  first ++ (dropEvery rest n)

split :: [a] -> Int -> ([a],[a])
split xs 0 = ([], xs)
split (x:xs) n = (x:(fst restSplit), snd restSplit) 
    where restSplit = split xs (n-1)

slice :: [a] -> Int -> Int -> [a]
slice ls i k = 
    let sndSplit = snd $ splitAt (i-1) ls
    in  fst $ splitAt (k-i+1) sndSplit

slice' ls i k | i > 0 = take (k-i+1) $ drop (i-1) ls

posRot :: [a] -> Int -> [a]
posRot ls n = 
    let rest = drop n ls
        first = take n ls
    in  rest ++ first

rotate :: [a] -> Int -> [a]
rotate ls n = if n >= 0 then posRot ls n else posRot ls $ (length ls) + n 

removeAt :: Int -> [a] -> (a,[a])
removeAt 1 (x:xs) = (x,xs)
removeAt n (x:xs) =
    let (fst, snd) = removeAt (n-1) xs
    in  (fst, x:snd)

-----------------------------
-- EVEN MORE LIST PROBLEMS --
-----------------------------
insertAt :: String -> String -> Int -> String
insertAt inE (_:xs) 1 = inE ++ xs
insertAt inE (x:xs) pos = x:(insertAt inE xs (pos-1))

range :: Int -> Int -> [Int]
range a b = [a..b]

range' :: Int -> Int -> [Int]
range' a b
    | b > a     = a:(range (a+1) b)
    | otherwise = [b]

range'' :: Int -> Int -> [Int]
range'' a b = enumFromTo a b

rndSelect :: [a] -> Int -> IO [a]
rndSelect str n = do
    gen <- R.getStdGen
    return $ take n [str !! x | x <- R.randomRs (0, (length str) - 1) gen]

diffSelect :: Int -> Int -> IO [Int]
diffSelect n set = do
    gen <- R.getStdGen
    return $ take n $ R.randomRs (0,set) gen

diffSelect' :: Int -> [a] -> IO [a]
diffSelect' _ [] = error "not enough elements in the list"
diffSelect' n xs = do 
    r <- R.randomRIO (0,(length xs)-1) 
    let remaining = take r xs ++ drop (r+1) xs 
    rest <- diffSelect' (n-1) remaining
    return ((xs!!r) : rest)

rndPermu :: [a] -> IO [a]
rndPermu ls = diffSelect' (length ls) ls

combinations :: Int -> [a] -> [[a]]
combinations 0 _ = [[]]
combinations _ [] = []
combinations n (x:xs) = (map (x:) (combinations (n-1) xs)) ++ (combinations n xs)

-- clever but pretty slow and memory-consuming
combinations' :: (Eq a, Ord a) => Int -> [a] -> [[a]]
combinations' n xs = 
    let perm = permutations xs
    in  sort $ filter isSuc $ nub . map (take n) $ perm
        where isSuc ls = and $ zipWith (<=) ls (drop 1 ls)

--group3 :: [[a]] -> [[[a]]]
--group3 l = 
--    let first = combinations 2 l
--        second = combinations 3 (l \\ first)
--        third = combinations 4 (l \\ second)
--    in  first ++ second ++ third
--
--listToGroup = ["aldo","beat","carla","david","evi","flip","gary","hugo","ida"]

------------------------
-- ARITMETIC PROBLEMS --
------------------------
isPrime :: Int -> Bool
isPrime n = and $ [n `mod` x /= 0 | x <- [2..(n`div`2)]]

coprime :: Int -> Int -> Bool
coprime n m = gcd n m == 1

totient :: Int -> Int
totient n
    | n == 1    = 1
    | otherwise = length . filter (\tf -> tf == True) $ [coprime x n | x <- [1..n]]
