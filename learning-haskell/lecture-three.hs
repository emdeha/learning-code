-----------------------------------------
-- The concurrent Curry, in a hurry,   --
-- was deceived, his eyes were blurry. --
-----------------------------------------
--max :: a -> a -> a


-- 
multThree :: (Num a) => a -> a -> a -> a
multThree x y z = x * y * z

--multThree 2 1 3 => (multThree 2) 1 3 => ((multThree 2) 1) 3
--multThree :: (Num a) => a -> (a -> (a -> a))

multTwoWithNine :: (Num a) => a -> (a -> a)
multTwoWithNine = (multThree 9) -- func :: a -> (a -> a)
multTwoWithNine' x y = multThree 9 x y

multWithEighteen :: (Num a) => a -> a
multWithEighteen = multTwoWithNine 2 -- func :: a -> a
multWithEighteen' x = multTwoWithNine 2 x
multWithEighteen'' x = multThree 9 2 x

--
compareWithHundred = compare 100

--filter (<3) [1,2,3]
--
-- filter :: (a -> Bool) -> [a] -> [a]
    --
--(<) => a -> (a -> Bool)
    --
--(<3) => (a -> Bool)

-- Simple HOFs
applyTwice :: (a -> a) -> a -> a
applyTwice f x = f (f x)

--applyTwice (++"HO") "HA"
--(++) :: [a] -> ([a] -> [a])
--
--(++"HO") :: ([a] -> [a])
--
--(++ (++ "HA" "HO") "HO")
--(++ "HAHO" "HO")
--("HAHOHO")
--
--applyTwice (*2) 2
--(*) :: (Num a) => a -> a -> a
--(*2) :: (Num a) => a -> a

--
zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' _ [] _ = []
zipWith' _ _ [] = []
zipWith' f (x:xs) (y:ys) = f x y : zipWith' f xs ys

--(+) :: (Num a) => a -> a -> a
--(1+1) :: (Num a) => a

--
flip' :: (a -> b -> c) -> (b -> a -> c)
flip' f = g
    where g x y = f y x

--------------------------------
-- Mapping Filters over Folds --
--------------------------------
map' :: (a -> b) -> [a] -> [b]
map' _ [] = []
map' f (x:xs) = f x : map' f xs

--(+) :: (Num a) => a -> a -> a
--(+3) :: (Num a) => (a -> a)
--
--map (+3) :: [a] -> [b]
--map (+3) [1,2,3] :: [b]
--[1,2,3]
--(1+3) : (2+3) : (3+3) => [4,5,6]
--
--map toUpper "abc"
--
--toUpper :: (a -> b)

--
filter' :: (a -> Bool) -> [a] -> [a]
filter' _ [] = []
filter' pred (x:xs) 
    | pred x    = x : filter' pred xs 
    | otherwise = filter' pred xs

--filter (>3) :: [a] -> [a]
--filter (>3) [1,2,3] :: [a]

--
map'' f ls = foldr appFunc [] ls
    where appFunc x acc = f x : acc

sum' ls = foldl (+) 0 ls

---------------------------------------
-- Trees Haskeller! Do you use them? --
---------------------------------------

type Node = String
type TreeElem = (Node, [Node])
type Tree = [TreeElem]
type Path = [Node]

-- only implementing TreeP
testTree :: Tree
testTree = [("S", ["i","m"]),("m",["p","l"]),("l",["e"])]

-- search the Tree by the kee
-- folds?
findByKee :: Node -> Tree -> TreeElem
findByKee kee [] = (kee,[])
findByKee kee ((k, val):xs)
    | kee == k  = (k, val)
    | otherwise = findByKee kee xs

-- find children (not grand children!)
children :: Node -> Tree -> [Node]
children kee tree = snd (findByKee kee tree)

-- check if a Node exists
hasNode :: Node -> Tree -> Bool
hasNode node tree = 
    not (null [x | x <- tree, 
                   fst x == node || elem node (snd x)])

hasNode' :: Node -> Tree -> Bool
hasNode' node tree = 
    lt node || rt node
    where
        lt x = elem x (map fst tree)
        rt x = elem x (concat (map snd tree))

-- check if the node has no successors
isLeaf :: Node -> Tree -> Bool
isLeaf node tree = null (children node tree)

-- get parent of node
getParent :: Node -> Tree -> Node
getParent _ [] = ""
getParent node tree@((k, elems):xs)
    | hasNode node tree = 
          if elem node elems then k else getParent node xs
    | otherwise         = ""

-- get predecessors of node
getPredecessors :: Node -> Tree -> [Node]
getPredecessors "" _ = []
getPredecessors node tree = parent : (getPredecessors parent tree)
    where parent = getParent node tree

-- get root of tree
getRoot :: Tree -> Node
getRoot [] = "" 
getRoot tree@((k,elem):xs)
    | hasNode k tree && getParent k tree == "" = k
    | otherwise                                = getRoot xs

-- get leaves of node
getLeaves :: Node -> Tree -> [Node]
getLeaves "" _ = []
getLeaves node tree = 
    concat (leaves : (map (\x -> getLeaves x tree) leaves))
    where leaves = children node tree

-- get paths from parent
getPaths :: Node -> Tree -> [Path]
getPaths node tree
    | isLeaf node tree = [[node]]
    | otherwise        = 
        map (\x -> (node:x)) 
            (concat 
                (map (\x -> getPaths x tree) (children node tree)))

-- get height of tree
getHeight :: Tree -> Int
getHeight tree = (foldr1 max (map length (getPaths (getRoot tree) tree)))

--------------------------
-- Recursive Trees FTW! --
--------------------------

-- Explain binary search trees
data TreeR a = Empty |
               Node a (TreeR a) (TreeR a)

type Entry = (String, String)
type PhoneBook = (TreeR Entry)

--         "5"
--   "2"      "8"
--          "6"  "10"
--                 "20"
--               ""
--               [[[2],5,[[6],8,[10,20]]]]
--
linearize :: (TreeR a) -> [a]
linearize Empty = []
linearize (Node root left right) = linearize left ++ [root] ++ linearize right


leaves :: (TreeR a) -> [a]
leaves (Node root Empty Empty) = [root]
leaves (Node root left right) = leaves left ++ leaves right

height :: (TreeR a) -> Integer
height Empty = 0
height (Node _ left right) = 1 + max (height left) (height right)

-- find entry in phonebook by key
find :: String -> PhoneBook -> String
find _ Empty = ""
find key (Node (n, p) left right)
    | key == n = p
    | key > n  = find key right
    | key < n  = find key left

-- >(v_v)<
--   o o

-- insert entry in phonebook
insert :: Entry -> PhoneBook -> PhoneBook
insert entry Empty = (Node entry Empty Empty)
insert entry phoneBook@(Node (n, p) left right)
    | fst entry > n   = Node (n, p) left (insert entry right)
    | fst entry < n   = Node (n, p) (insert entry left) right
    | otherwise       = phoneBook

-- remove entry from phonebook
remove :: String -> PhoneBook -> PhoneBook

remove _ Empty = Empty                 
remove _ (Node _ Empty Empty) = Empty

remove _ (Node _ left Empty) = left
remove _ (Node _ Empty right) = right

remove entry (Node root left right)
    | entry < fst root = Node root (remove entry left) right
    | entry > fst root = Node root left (remove entry right)

    | otherwise        = Node key left (remove (fst key) right)
                            where key = findMin right
                         

findMin :: (TreeR a) -> a
findMin (Node root Empty _) = root
findMin (Node _    left  _) = findMin left

samplePhoneBook = insert ("Ivan", "333") $
                  insert ("Rosen", "444") $
                  insert ("Miroslav", "777") $
                  insert ("Nikolay", "999") $
                  insert ("Asen", "444") $
                  insert ("Ivan", "555") Empty

instance (Show a) => Show (TreeR a) where
    show Empty = "[]"
    show (Node root left right) = "[" ++ show root ++ " " ++ show left ++ " " ++ show right ++ "]"

-- [1,1,2,3,45,1,2]
findCount :: (Num a, Eq a) => a -> [a] -> Int
findCount num ls = length (filter (==num) ls)

findAllCounts :: (Num a, Eq a) => [a] -> [(a, Int)]
findAllCounts ls = map (\x -> (x, findCount x ls)) ls

mostFrequent :: (Num a, Eq a) => [a] -> Int
mostFrequent ls = head (filter (
    where maxCount = (maximum (map snd (findAllCounts ls)))
    
simpleLS = [1,1,2,3,45,1,2]
