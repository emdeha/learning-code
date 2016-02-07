maximum' :: (Ord a) => [a] -> a
maximum' [] = error "there's no maximum of an empty list!"
maximum' [x] = x
maximum' (x:xs)
    | x > maxTail = x
	| otherwise = maxTail
    where maxTail = maximum' xs

replicate' :: (Num i, Ord i) => i -> a -> [a]
replicate' n x
    | n <= 0 = []
    | otherwise = x:replicate' (n-1) x

take' :: (Num i, Ord i) => i -> [a] -> [a]
take' n _
	| n <= 0 = []
take' _ []   = []
take' n (x:xs) = x:take' (n-1) xs

reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x:xs) = reverse' xs ++ [x]

zip' :: [a] -> [a] -> [(a, a)]
zip' _ [] = []
zip' [] _ = []
zip' (x:xs) (y:ys) = [(x, y)] ++ zip' xs ys

elem' :: (Eq a) => a -> [a] -> Bool
elem' _ [] = False
elem' n (x:xs) 
    | n == x = True
    | otherwise = elem' n xs

quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x:xs) = 
    let smallerSorted = quicksort [a | a <- xs, a <= x]
        biggerSorted = quicksort [a | a <- xs, a > x]
    in smallerSorted ++ [x] ++ biggerSorted

zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' _ [] _ = []
zipWith' _ _ [] = []
zipWith' f (x:xs) (y:ys) = f x y : zipWith' f xs ys

flip' :: (a -> b -> c) -> (b -> a -> c)
flip' f y x = f x y

largestDivisible :: (Integral a) => a
largestDivisible = head (filter p [10000, 9999..])
    where p x = x `mod` 3829 == 0

isPrime :: (Integral a) => a -> Bool
isPrime a = 
    let halfNum = a `div` 2
        divisors = (filter checkDiv [halfNum, (halfNum - 1)..2])
        checkDiv x = a `mod` x == 0
    in divisors == []

find1001Prime :: Int -> Int -> Int
find1001Prime count num
    | isPrime num   = find1001Prime (count+1) (num+1) 
    | count == 1001 = num
    | otherwise     = find1001Prime (count) (num+1)

chain :: (Integral a) => a -> [a]
chain 1 = [1]
chain n 
    | even n = n:chain (n `div` 2)
    | odd n  = n:chain (n*3 + 1)

numLongChains :: Int
numLongChains = length (filter (\xs -> length xs > 15) (map chain [1..100]))

sum' :: (Num a) => [a] -> a
sum' xs = foldl(\acc x -> acc + x) 0 xs

elem'' :: (Eq a) => a -> [a] -> Bool
elem'' y ys = foldl(\acc x -> if x == y then True else acc) False ys

map' :: (a -> b) -> [a] -> [b]
map' f xs = foldr(\x acc -> f x : acc) [] xs
