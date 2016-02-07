import Control.Monad

-----------
-- LISTS --
-----------
data List a = Cons a (List a) | Nil deriving (Show)

fromList :: List a -> [a]
fromList Nil = []
fromList (Cons x xs) = x:(fromList xs)

splitWith :: (a -> Bool) -> [a] -> [[a]]
splitWith _ [] = [[]]
splitWith pred xs = 
    let (first, second) = break pred xs
        (nfirst, nsecond) = break (not . pred) second
    in  case first of 
                [] -> nfirst : splitWith pred nsecond
                _  -> first : splitWith pred second

testOne = [1,2,3,4,4,4,1,2,3,4,5,6,7,1,2,2,2,2]
testTwo = "I'm a happy string. YEAH! Oh YEAH,hhAAAhhhAHAH"

-----------
-- TREES --
-----------
data Tree a = Node a (Tree a) (Tree a) | Empty deriving (Show)

simpleTree = (Node 4 (Node 2 Empty Empty) (Node 3 (Node 2 (Node 3 Empty Empty) Empty) Empty))
twoTree = (Node "x" Empty (Node "y" Empty Empty))

depth :: Tree a -> Int
depth Empty = 0
depth (Node _ Empty Empty) = 1 
depth (Node _ Empty rs) = 1 + depth rs
depth (Node _ ls Empty) = 1 + depth ls 
depth (Node _ ls rs) = 1 + max (depth ls) (depth rs)

-----------------
-- CONVEX HULL --
-----------------
data Direction = DRight | DLeft | DStraight deriving (Show)
data Point2D = Point2D { x :: Double
                       , y :: Double
                       } deriving (Show)

dotProduct v1 v2 = (x v1) * (x v2) + (y v1) * (y v2) 

calcTurn :: Point2D -> Point2D -> Point2D -> Direction
calcTurn a b c
    | dotProd > 0 = DLeft
    | dotProd < 0 = DRight
    | dotProd == 0 = DStraight
    where dotProd = 
            dotProduct (Point2D (x a - x b) (y a - y b)) (Point2D (x c -  x b) (y c - y b))

calcTurnList :: [Point2D] -> [Direction]
calcTurnList [] = []
calcTurnList (_:_:[]) = []
calcTurnList (_:[]) = []
calcTurnList (x:y:z:xs) = (calcTurn x y z):(calcTurnList (y:z:xs))

p1 = Point2D 1 0
p2 = Point2D 0 1
p3 = Point2D 0 0
p4 = Point2D (-1) 0
p5 = Point2D 0 (-1)
p6 = Point2D 0.5 0.5
p7 = Point2D (-0.75) 0.3
p8 = Point2D 0.23 (-0.8)

--------------------
-- SAFE FUNCTIONS --
--------------------
safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead (x:_) = Just x

safeTail :: [a] -> Maybe [a]
safeTail [] = Nothing
safeTail (x:[]) = Nothing
safeTail (_:xs) = Just xs

safeLast :: [a] -> Maybe a
safeLast = safeHead . reverse

safeInit :: [a] -> Maybe [a]
safeInit [] = Nothing
safeInit (x:[]) = Nothing
safeInit xs = Just (init xs)

------------
-- OTHERS --
------------
toPalindrome :: [a] -> [a]
toPalindrome xs = xs ++ (reverse xs)

main = interact firstWord
    where firstWord input = show (length (input)) ++ "\n"
