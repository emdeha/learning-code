{-# OPTIONS_GHC -Wall #-}
module Folding where

import Data.List


-- | fun1
fun1 :: [Integer] -> Integer
fun1 []  = 1
fun1 (x:xs)
    | even x    = (x-2) * fun1 xs
    | otherwise = fun1 xs

-- | idiomatic fun1
fun1' :: [Integer] -> Integer
fun1' = product . map (subtract 2) . filter even


-- | fun2
fun2 :: Integer -> Integer
fun2 1 = 0
fun2 n | even n    = n + fun2 (n `div` 2)
       | otherwise = fun2 (3 * n + 1)

-- | idiomatic fun2
fun2' :: Integer -> Integer
fun2' = sum . filter even . takeWhile (/=1) . iterate cont
  where cont n = if even n then n `div` 2 else 3 * n + 1


---- | Folding with trees
--data Tree a = Leaf
--            | Node Integer (Tree a) a (Tree a)
--  deriving (Show, Eq)
--
---- | Generates a balanced binary tree from a list of values
--foldTree :: [a] -> Tree a
--foldTree = foldr insert
--  where insert :: a -> Tree a -> Tree a
--        insert = go 0
--          where go _ a Leaf = Node 0 Leaf a Leaf
--                go n a (Node depth left elem right)
--                    | n - depth <= 1 = (Node (n+1) (go n a left) elem right)
--                    | otherwise      = (Node (n+1) left elem (go n a right))


-- | More folds
--
-- | Returns True iff there are an odd number of True values contained
--   in the input list.
xor :: [Bool] -> Bool
xor [] = False
xor (a:as) = foldr (\x acc -> (x || acc) && (not (x && acc))) a as

-- | Implements map as a fold
map' :: (a -> b) -> [a] -> [b]
map' f = foldr ((:) . f) []

-- | Implements foldl as foldr
myFoldl :: (a -> b -> a) -> a -> [b] -> a
myFoldl f base xs = foldr (\x g acc -> g (f acc x)) id xs base


-- | Finding primes
--
-- | Given an Integer n, generates all odd prime numbers up to 2n + 2.
sieveSundaram :: Integer -> [Integer]
sieveSundaram n =
    let bad = map mult . filter isBad $ cartProd nums nums
    in  map multFinal $ nums \\ bad
  where nums = [1..n]
        mult (i,j) = i + j + 2*i*j
        multFinal x = x * 2 + 1
        isBad (i,j) = i <= j && mult (i,j) <= n

cartProd :: [a] -> [b] -> [(a,b)]
cartProd xs ys = [ (x,y) | x <- xs, y <- ys ]