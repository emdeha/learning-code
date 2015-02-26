import Data.List

myConcat :: [[a]] -> [a]
myConcat ls = foldr (++) [] ls

myTakeWhile :: (a -> Bool) -> [a] -> [a]
myTakeWhile _ [] = []
myTakeWhile pred (x:xs) = if pred x then x : myTakeWhile pred xs else []

myTakeWhile' :: (a -> Bool) -> [a] -> [a]
myTakeWhile' pred ls = foldr (\x acc -> if pred x then x : acc else []) [] ls

myGroupBy :: (a -> a -> Bool) -> [a] -> [[a]]
myGroupBy _ [] = []
myGroupBy pred (x:xs) = (x : takeWhile (pred x) xs) : myGroupBy pred (dropWhile (pred x) xs)

