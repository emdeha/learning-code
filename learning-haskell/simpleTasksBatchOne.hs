import qualified Data.Map as Map
import qualified Data.Set as Set
import Data.List
import Data.Char

data Grade = A | B | C | D | F deriving Show

grade :: Int -> Maybe Grade
grade score 
    | score <= 59 = Just F
    | score >= 60 && score <= 69 = Just D
    | score >= 70 && score <= 79 = Just C
    | score >= 80 && score <= 89 = Just B
    | score >= 90 && score <= 100 = Just A    
    | otherwise = Nothing

getGrade :: Int -> IO ()
getGrade score = case grade score of Just gradeLetter -> print gradeLetter
                                     Nothing -> print "Bad input"
---------------------------------
    -----------------------------
---------------------------------
getCola :: IO ()
getCola = do
    print "Choose beverage: " 
    print "1- Cola, 2- Water, 3- Sprite"
    choice <- getChar
    chooseBeverage [choice] 

chooseBeverage :: [Char] -> IO ()
chooseBeverage choice
    | choice == "1" = putStrLn $ "Cola."
    | choice == "2" = putStrLn $ "Water."
    | choice == "3" = putStrLn $ "Sprite."
    | otherwise = putStrLn $ "Error, choice invalid"
---------------------------------
    -----------------------------
---------------------------------
inputNumber :: Int -> IO ()
inputNumber acc = do
    print acc
    print "Enter number other than 5"
    numStr <- getLine
    let num = read numStr
    checkNumber num $ acc

checkNumber :: Int -> Int -> IO ()
checkNumber num acc 
    | num == 5  = print "Hey! You weren't supposed to enter 5!"
    | acc >= 10 = print "You were more patient than me! You win!"
    | otherwise = inputNumber $ acc+1
---------------------------------
    -----------------------------
---------------------------------
type Person = (String, Int)

start :: IO ()
start = inputPancakes [("", 0)]

inputPancakes :: [Person] -> IO ()
inputPancakes people 
    | length people >= 5 = do
            print "Most pancakes: "
            let maxPancakes = maximum $ map snd $ init people
            print $ [ person | person <- init people,
                               snd person == maxPancakes ] 
            print "Min pancakes: "
            print $ minimum $ map snd $ init people
    | otherwise = do
            print "Input person: "
            personName <- getLine
            pancakesStr <- getLine
            let pancakes = read pancakesStr
            inputPancakes $ [(personName, pancakes)] ++ people
---------------------------------
    -----------------------------
---------------------------------
capital :: String -> String
capital "" = "Empty String, whoops!"
capital all@(x:xs) = "The first letter of '" ++ all ++ "' is " ++ [x]
---------------------------------
    -----------------------------
---------------------------------
bmiTell :: (RealFloat a) => a -> a -> String
bmiTell weight height
    | bmi <= skinny = "You're underweight"
    | bmi <= normal = "You're normal"
    | bmi <= fat    = "You're fat"
    | otherwise     = "You're too fat"
    where bmi = weight / height ^ 2
          skinny = 18.5
          normal = 25.0
          fat = 30.0
---------------------------------
    -----------------------------
---------------------------------
initials :: String -> String -> String
initials firstName lastName = [f] ++ ". " ++ [l] ++ "."
    where (f:_) = firstName
          (l:_) = lastName

initials' :: String -> String -> String
initials' (f:fs) (l:ls) = [f] ++ ". " ++ [l] ++ "."

initials'' :: String -> String
initials'' fullName =
    initials' (takeWhile (\x -> x /= ' ') fullName) 
              (dropWhile (\x -> x == ' ') fullName)
---------------------------------
---------- Recursion ------------
---------------------------------
maximum' :: (Ord a) => [a] -> a
maximum' [] = error "Trying to compute the max of empty list"
maximum' [x] = x
maximum' (x:xs) 
    | x > maxTail = x
    | otherwise = maxTail
    where maxTail = maximum' xs

maximum'' :: (Ord a) => [a] -> a
maximum'' [] = error "Trying to compute the max of empty list"
maximum'' [x] = x
maximum'' (x:xs) = max x (maximum'' xs)

replicate' :: (Num i, Ord i) => i -> a -> [a]
replicate' count num
    | count <= 0 = []
    | otherwise = num:replicate' (count - 1) num

take' :: (Num i, Ord i) => i -> [a] -> [a]
take' _ [] = []
take' count (x:xs)
    | count <= 0 = []
    | otherwise = x:take' (count-1) xs

reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x:xs) = (reverse' xs) ++ [x]

repeat' :: a -> [a]
repeat' num = num:repeat' num

zip' :: [a] -> [b] -> [(a,b)]
zip' [] _ = []
zip' _ [] = []
zip' (x:xs) (y:ys) = (x,y):zip' xs ys

elem' :: (Eq a) => a -> [a] -> Bool
elem' _ [] = False
elem' num (x:xs)
    | x == num = True
    | otherwise = elem' num xs

quicksort' :: (Ord a) => [a] -> [a]
quicksort' [] = []
quicksort' (x:xs) =
    let smallerSorted = quicksort' [a | a <- xs, a <= x]
        biggerSorted = quicksort' [a | a <- xs, a > x]
    in  smallerSorted ++ [x] ++ biggerSorted
---------------------------------
------------ HOFs ---------------
---------------------------------
applyTwice :: (a -> a) -> a -> a
applyTwice f x = f (f x)

zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' _ [] _ = []
zipWith' _ _ [] = []
zipWith' f (x:xs) (y:ys) = f x y :zipWith' f xs ys

flip' :: (a -> b -> c) -> b -> a -> c
flip' f y x = f x y

quicksort'' :: (Ord a) => [a] -> [a]
quicksort'' [] = []
quicksort'' (x:xs) =
    let smallerSorted = quicksort'' (filter (<=x) xs)
        biggerSorted = quicksort'' (filter (>x) xs)
    in  smallerSorted ++ [x] ++ biggerSorted

largestDivisible :: (Integral a) => a
largestDivisible = head (filter p [100000,99999..])
    where p x = x `mod` 3829 == 0

chain :: (Integral a) => a -> [a]
chain 1 = [1]
chain n
    | even n = n:chain (n `div` 2)
    | odd n  = n:chain (n*3 + 1)

numLongChains :: Int
numLongChains = length (filter isLong (map chain [1..100]))
    where isLong xs = length xs > 15

numLongChains' :: Int
numLongChains' = length (filter (\xs -> length xs > 15) (map chain [1..100]))

flip'' :: (a -> b -> c) -> b -> a -> c
flip'' f = (\x y -> f y x)

sum' :: (Num a) => [a] -> a
sum' = foldl (+) 0

reverse'' :: [a] -> [a]
reverse'' = foldl (\acc x -> x:acc) []

elem'' :: (Eq a) => a -> [a] -> Bool
elem'' num = foldl (\acc x -> if x == num then True else False) False 

map' :: (a -> b) -> [a] -> [b]
map' f xs = foldr (\x acc -> f x : acc) [] xs

maximum''' :: (Ord a) => [a] -> a
maximum''' = foldr1 (\x acc -> if x > acc then x else acc)

product' :: (Num a) => [a] -> a
product' = foldr1 (*)

filter' :: (a -> Bool) -> [a] -> [a]
filter' f = foldr (\x acc -> if f x then x:acc else acc) []

head' :: [a] -> a
head' = foldr1 (\x _ -> x)

last' :: [a] -> a
last' = foldl1 (\_ x -> x)

sqrtSums :: Int
sqrtSums = length (takeWhile (<1000) $ scanl1 (+) $ map sqrt [1..]) + 1

oddSquaresSum :: Integer
oddSquaresSum = sum . takeWhile (<10000) . filter odd . map (^2) $ [1..]

oddSquaresSum' :: Integer
oddSquaresSum' = 
    sum belowLimit
    where oddSquares = filter odd $ map (^2) [1..]
          belowLimit = takeWhile (<10000) oddSquares

oddSquaresSum'' :: Integer
oddSquaresSum'' =
    let oddSquares = filter odd $ map (^2) [1..]
        belowLimit = takeWhile (<10000) oddSquares
    in  sum belowLimit

intersperse' :: a -> [a] -> [a]
intersperse' delim (x:xs)
    | length xs == 0 = [x]
    | otherwise = x:delim:intersperse' delim xs

search :: (Eq a) => [a] -> [a] -> Bool
search needle haystack =
    let nlen = length needle
    in  foldl (\acc x -> if take nlen x == needle then True else acc) False (tails haystack)

encodeCaesar :: Int -> String -> String
encodeCaesar shift msg =
    let ords = map ord msg
        shifted = map (+ shift) ords
    in  map chr shifted

decodeCaesar :: Int -> String -> String
decodeCaesar shift msg = encodeCaesar (negate shift) msg
---------------------------------
------------ Maps ---------------
---------------------------------

phoneBook = 
    [("betty","555-2938")
    ,("susan","533-3421")
    ,("julia","903-3029")
    ,("julia","211-3030")
    ,("ivon","111-1111")
    ,("betty","123-1234")
    ,("betty","222-2222")
    ]

findKey :: (Eq k) => k -> [(k,v)] -> v
findKey key xs = snd . head . filter (\(k,v) -> key == k) $ xs

findKey' :: (Eq k) => k -> [(k,v)] -> Maybe v
findKey' key [] = Nothing
findKey' key ((k,v):xs) = if key == k
                             then Just v
                             else findKey' key xs

findKey'' :: (Eq k) => k -> [(k,v)] -> Maybe v
findKey'' key = foldr (\(k,v) acc -> if key == k then Just v else acc) Nothing

fromList' :: (Ord k) => [(k,v)] -> Map.Map k v
fromList' = foldr (\(k,v) acc -> Map.insert k v acc) Map.empty

phoneBookToMap :: (Ord k) => [(k,String)] -> Map.Map k String
phoneBookToMap xs = 
    Map.fromListWith (\number1 number2 -> number1 ++ ", " ++ number2) xs

phoneBookToMap' :: (Ord k) => [(k,a)] -> Map.Map k [a]
phoneBookToMap' xs = Map.fromListWith (++) $ map(\(k,v) -> (k,[v])) xs
---------------------------------
----- Types and Typeclasses -----
---------------------------------

-- simple types
data Point = Point Float Float deriving (Show)
data Shape = Circle Point Float | Rectangle Point Point deriving (Show)

surface :: Shape -> Float
surface (Circle _ r) = pi * r ^ 2
surface (Rectangle (Point x1 y1) (Point x2 y2)) = (abs $ x2 - x1) * (abs $ y2 - y1)

-- record syntax
data RecordPerson = RecordPerson { firstName :: String
                                 , lastName :: String
                                 , age :: Int
                                 } deriving (Show)

-- type parameters
data Vector a = Vector a a a deriving(Show)

vPlus :: (Num t) => Vector t -> Vector t -> Vector t
(Vector i j k) `vPlus` (Vector l m n) = Vector (i+l) (j+m) (k+n)

vMult :: (Num t) => Vector t -> t -> Vector t
(Vector i j k) `vMult` m = Vector (i*m) (j*m) (k*m)

vScalarMult :: (Num t) => Vector t -> Vector t -> t
(Vector i j k) `vScalarMult` (Vector l m n) = i*l + j*m + k*n

-- derived types
data Day = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday
           deriving (Eq, Ord, Show, Read, Bounded, Enum)

-- type synonyms
data LockerState = Taken | Free deriving (Show, Eq)
type Code = String
type LockerMap = Map.Map Int (LockerState, Code)

lockerLookup :: Int -> LockerMap -> Either String Code
lockerLookup lockerNumber map =
    case Map.lookup lockerNumber map of
        Nothing -> Left $ "Locker number " ++ show lockerNumber ++ " doesn't exist!"
        Just (state, code) -> if state /= Taken
                                then Right code
                                else Left $ "Locker " ++ show lockerNumber ++
                                            " is already taken!"

lockers :: LockerMap
lockers = Map.fromList
    [(100,(Taken,"sad"))
    ,(101,(Free,"asd"))
    ,(103,(Free,"ulk"))
    ,(105,(Free,"milk"))
    ,(109,(Taken,"silk"))
    ,(110,(Taken,"amore"))
    ]
