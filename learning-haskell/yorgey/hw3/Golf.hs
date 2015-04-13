{-# OPTIONS_GHC -Wall #-}
module Golf where

import Data.List (intercalate)


-- | Generates a list of lists where each sublist contains the @n@-th elements
--   of @ls@.
skips :: [a] -> [[a]]
skips ls = go 0
  where go n 
            | n >= length ls = []
            | otherwise      = 
                let zipped = zip ls (cycle $ (replicate n False) ++ [True])
                in  foldr (\(a,b) acc -> if b then a:acc else acc) [] zipped : go (n+1)

-- | Find the local maxima of a list
localMaxima :: [Integer] -> [Integer]
localMaxima []       = []
localMaxima (_:[])   = []
localMaxima (_:_:[]) = []
localMaxima (x:rest@(y:z:_)) = 
    (if all (<y) [x,z] then [y] else []) ++ (localMaxima rest)

-- | Outputs the histogram of a list of Integers
histogram :: [Integer] -> String
histogram ls = 
    let freqs = map (\x -> filter (==x) ls) possible
        hist = getLines freqs
    in  (intercalate "\n" hist) ++ end
  where end = "\n==========\n0123456789\n"
        possible = [0,1,2,3,4,5,6,7,8,9]

getLines :: [[a]] -> [String]
getLines fr
    | all null fr = []
    | otherwise      = 
            getLines fr' ++ [map frToStr fr]
          where fr' = map subtr fr

                subtr []  = []
                subtr l@(_:xs) = if null l then [] else xs

                frToStr x = if null x then ' ' else '*'
