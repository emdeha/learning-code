import Data.List

length' :: [a] -> Int
length' l = sum [1 | _ <- l]

length'' :: [a] -> Int
length'' = sum . map (const 1)

reverseDigits :: Int -> Int
reverseDigits n = helper 0 n
  where helper res curr
          | curr == 0 = res
          | otherwise = helper (res * 10 + curr `mod` 10) (curr `div` 10)

listDigits :: Int -> [Int]
listDigits = helper []
  where helper ls n
          | n < 10    = n : ls
          | otherwise = helper ((n `mod` 10) : ls) (n `div` 10)

elem' :: Eq a => a -> [a] -> Bool
elem' _ [] = False
elem' a (x:xs)
  | a == x    = True
  | otherwise = elem' a xs

elem'' :: Eq a => a -> [a] -> Bool
elem'' a = foldr (\n _ -> a == n) False

map' :: (a -> b) -> [a] -> [b]
map' _ [] = []
map' f (x:xs) = f x : map' f xs

map'' :: (a -> b) -> [a] -> [b]
map'' f = foldr (\x acc -> f x : acc) []

filter' :: (a -> Bool) -> [a] -> [a]
filter' p [] = []
filter' p (x:xs) = if p x then x : filter' p xs else filter' p xs

filter'' :: (a -> Bool) -> [a] -> [a]
filter'' p = foldr (\x acc -> if p x then x : acc else acc) []

intersection :: Eq a => [a] -> [a] -> [a]
intersection l1 l2 = [x | x <- l1, elem' x l2]

union' :: Eq a => [a] -> [a] -> [a]
union' l1 l2 = l1 ++ [x | x <- l2, not $ elem' x l2]

neg :: [Int] -> [Int]
neg = map (negate . abs)

neg' :: [Int] -> [Int]
neg' = map $ (*) (-1) . abs

minElem :: Ord a => [a] -> a
minElem = foldr1 min

head' :: [a] -> a
head' (x:xs) = x

tail' :: [a] -> [a]
tail' (x:xs) = xs
