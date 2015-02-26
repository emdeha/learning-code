-- Dividing text into words and lines.
-- First, lets separate a given Plain Text into words without whitespace characters.
-- ['\n', '\t', ' ']
--
import Data.List
import Data.Char

maryKate = "Mary-Kate ate a cake. Hey Kate, are you at the lake?\n" ++
           "Mary-Kate met the fake. Hey Kate, are you with your mate?\n" ++ 
           "Mary-Kate found a date. Hey Kate, where did you sleep last night?"

whitespaceChars = ['\n', '\t', ' ']

dropLeadingWhitespace :: String -> String
dropLeadingWhitespace [] = []
dropLeadingWhitespace str@(x:xs)
    | x `elem` whitespaceChars = xs
    | otherwise                = str

getWords :: String -> [String]
getWords []   = []
getWords text =
    takeWhile isNotWhitespace text : getWords (dropLeadingWhitespace dropPrevWord)
    where isNotWhitespace ch = ch `notElem` whitespaceChars
          dropPrevWord = dropWhile isNotWhitespace text

type Line = [String]

getLine' :: [String] -> Int -> Line
getLine' (w:[]) len = w : ["\n"]
getLine' (w:xs) len
    | length w < len = w : " " : getLine' xs (len - (length w + 1))
    | otherwise      = ["\n"]

getRest :: [String] -> Int -> Line
getRest (w:[]) len = [w]
getRest (w:xs) len
    | length w >= len = w:xs
    | otherwise       = getRest xs (len - (length w + 1))

getLines :: String -> Int -> Line
getLines [] len   = []
getLines text len
    | length text < len = [text]
    | otherwise         = [concat $ getLine' words len] ++ 
                          getLines (intercalate " " (getRest words len)) len
            where words = getWords text

-------------------------------------
-- Proof of functions by induction --
-------------------------------------
-- **
-- sum (doubleAll xs) = 2 * sum xs
-- **
-- length (xs ++ ys) = length xs + length ys
-- **
-- reverse (xs ++ ys) = reverse ys ++ reverse xs
-- **

----------
-- HOFs --
----------
-- MAP
double :: (Num a) => a -> a
double n = 2 * n
-- map double [1,2,3]
-- map toUpper "I'm a pony"
-- map digitToInt "123"
toInt :: String -> Int
toInt ls = read ls
-- map toInt ["123","345"]

-- FILTER
-- filter odd [1,2,3,4]
-- map (filter odd) [[1,2,3],[4,5,6]]

-- ZIP_WITH
-- zip [1,2,3] [4,5,6]
-- zipWith (+) [1,2,3] [4,5,6]
-- zipWith (<=) [1,2,3,4] [4,5,6]
-- zipWith (\x y -> (x,y)) [1,2,3,4] [4,5,6]

-- FOLDR1, FOLDR
-- without fold
mySum :: [Int] -> Int
mySum []     = 0
mySum (x:xs) = x + mySum xs

flatten :: [[a]] -> [a]
flatten []     = []
flatten (x:xs) = x ++ flatten xs

-- with foldr/foldr1
mySum' :: [Int] -> Int
mySum' ls = foldr (+) 0 ls

flatten' :: [[a]] -> [a]
flatten' ls = foldr (++) [] ls

-- function composition
-- tup = (1,[1,2,3])
-- sum . snd $ tup
-- length . filter (>0) $ [1,2,3,-1,2,-3,-3,0]
lenPos :: [Int] -> Int
lenPos ls = length . filter (>0) $ ls
-- map lenPos [[1,2,3],[-2,-3],[0,0,1]]
reverseSnd :: (Int,String) -> (Int,String)
reverseSnd tup = (fst tup, reverse . snd $ tup)
-- map reverseSnd [(1,"IAM"),(2,"pony"),(3,"S@d")]

-- lambdas
-- function currying
-- partial application of operators
-- map (+4) [1,2,3]

----------
-- Data --
----------
-- ARRAY
---- contiguous in memory
-- RECORD
---- (name, a) -> a can be of any type
---- may implement
-- SET
---- Elements with identical types
-- LINKED LIST
---- Linked elements
-- STACK
---- Last in last out
---- may implement
-- QUEUE
---- First in first out
---- may implement
-- TREE
---- Interesting!
---- may implement
