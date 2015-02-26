infiniteStream :: Int -> [Int]
infiniteStream start = [start] ++ infiniteStream (start + 1)

digitsSum :: Int -> Int
digitsSum 0 = 0
digitsSum number = number `mod` 10 + digitsSum (number `div` 10)

sumOfDigitsStream :: Int -> [Int]
sumOfDigitsStream start = map (\x -> digitsSum x) (infiniteStream start)

binary :: Int -> String
binary 0 = ""
binary number = binary (number `div` 2) ++ show (number `mod` 2)

streamOfBinaryRepresentation :: Int -> [String]
streamOfBinaryRepresentation start = map (\x -> binary x) (infiniteStream start)

isIncreasing :: (Ord a) => [a] -> Bool
isIncreasing [_] = True 
isIncreasing (x:xs)
    | (head xs) > x = isIncreasing xs
    | otherwise = False

isDecreasing :: (Ord a) => [a] -> Bool
isDecreasing [_] = True
isDecreasing (x:xs) 
    | (head xs) < x = isDecreasing xs
    | otherwise = False

substring :: String -> String -> Bool
substring "" _ = True
substring _ "" = False
substring str (x:xs)
    | x == head str = substring (tail str) xs
    | otherwise = substring str xs

group' :: (Eq a) => [a] -> [[a]]
group' [] = []
group' l@(x:xs) =
    [ takeWhile (\item -> x == item) l ] ++ group' (dropWhile (\item -> x == item) l)

-- Fitness Owner
type Person = (String, Double)

getAsInName :: String -> Double
getAsInName [] = 0
getAsInName (x:xs)
    | x == 'a' = 1 + getAsInName xs
    | otherwise = getAsInName xs

score :: Person -> Double
score dude = getAsInName (fst dude) * sqrt (snd dude)

fitnessOwner :: [Person] -> Double
fitnessOwner dudes =
    sum $ map score dudes
