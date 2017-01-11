data Boolean = Falsy | Truthy
  deriving (Show, Eq, Ord)

isEven :: (Integral a) => a -> Boolean
isEven x = if x `mod` 2 == 0 then Truthy else Falsy

data FailingDouble = Success Double | Fail
  deriving (Show)

divide :: Double -> Double -> FailingDouble
divide _ 0 = Fail
divide a b = Success $ a / b

data Day = Monday | Tuesday | Wednesday | Thirsday | Friday | Saturday | Sunday
  deriving (Show, Eq, Ord, Enum, Bounded)

isWeekend :: Day -> Bool
isWeekend Saturday = True
isWeekend Sunday = True
isWeekend _ = False

isWeekend' :: Day -> Bool
isWeekend' day
  | day == Sunday || day == Saturday = True
  | otherwise                        = False

isWeekend'' :: Day -> Bool
isWeekend'' = (> Friday)

data Student = Person { fn :: String, name :: String, examsLeft :: Int }
  deriving Show

rejectStudents :: [Student] -> [Student]
rejectStudents = filter $ (> 3) . examsLeft


data Tree a = Empty | Node a (Tree a) (Tree a)
  deriving Show

tree = (Node 10
    (Node 5 Empty (Node 8 Empty Empty))
    (Node 20
      (Node 17 (Node 15 Empty Empty) Empty)
      (Node 30 (Node 25 Empty Empty) (Node 40 Empty Empty))))

isLeaf :: Tree a -> Bool
isLeaf (Node _ Empty Empty) = True
isLeaf _ = False

root :: Tree a -> Maybe a
root Empty = Nothing
root (Node x _ _) = Just x

left :: Tree a -> Tree a
left Empty = Empty
left (Node _ l _) = l

right :: Tree a -> Tree a
right Empty = Empty
right (Node _ _ r) = r

leaf :: a -> Tree a
leaf x = Node x Empty Empty

inOrder :: Tree a -> [a]
inOrder Empty = []
inOrder (Node a l r) = inOrder l ++ [a] ++ inOrder r

insert :: (Ord a) => a -> Tree a -> Tree a
insert a Empty = leaf a
insert a (Node x l r)
  | a <= x    = Node x (insert a l) r
  | otherwise = Node x l (insert a r)
