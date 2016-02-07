import qualified Data.Foldable as F
import Data.Monoid

data Tree a = Empty | Node a (Tree a) (Tree a) deriving (Show, Read, Eq)

data Direction = L | R deriving (Show)
type Directions = [Direction]

data Crumb a = LeftCrumb a (Tree a) | RightCrumb a (Tree a) deriving (Show) 
type Breadcrumbs a = [Crumb a]
type Zipper a = (Tree a, Breadcrumbs a)

instance F.Foldable Tree where
    foldMap f Empty = mempty
    foldMap f (Node x left right) = F.foldMap f left `mappend`
                                    f x              `mappend`
                                    F.foldMap f right

goLeft :: Zipper a -> Maybe (Zipper a)
goLeft (Node x l r, bs) = Just (l, LeftCrumb x r:bs)
goLeft (Empty, _) = Nothing

goRight :: Zipper a -> Maybe (Zipper a)
goRight (Node x l r, bs) = Just (r, RightCrumb x l:bs)
goRight (Empty, _) = Nothing

goUp :: Zipper a -> Maybe (Zipper a)
goUp (t, LeftCrumb x r:bs) = Just (Node x t r, bs)
goUp (t, RightCrumb x l:bs) = Just (Node x l t, bs)
goUp (_, []) = Nothing

elemAt :: Directions -> Tree a -> a
elemAt (L:ds) (Node x l r) = elemAt ds l
elemAt (R:ds) (Node x l r) = elemAt ds r
elemAt [] (Node x _ _) = x

modify :: (a -> a) -> Zipper a -> Zipper a
modify f (Node x l r, bs) = (Node (f x) l r, bs)
modify f (Empty, bs) = (Empty, bs)   

attach :: Tree a -> Zipper a -> Zipper a
attach t (_, bs) = (t, bs)

goTop :: Zipper a -> Maybe (Zipper a)
goTop (t,[]) = Just (t,[])
goTop z = goUp z >>= goTop

x -: f = f x

testTree = Node 5
            (Node 3
                (Node 1 Empty Empty)
                (Node 6 Empty Empty)
            )
            (Node 9
                (Node 8 Empty Empty)
                (Node 10 Empty Empty)
            )

freeTree :: Tree Char
freeTree =
    Node 'P' 
        (Node 'O'
            (Node 'L'
                (Node 'N' Empty Empty)
                (Node 'T' Empty Empty)
            )
            (Node 'Y'
                (Node 'S' Empty Empty)
                (Node 'A' Empty Empty)
            )
        )
        (Node 'L'
            (Node 'W'
                (Node 'C' Empty Empty)
                (Node 'R' Empty Empty)
            )
            (Node 'A'
                (Node 'A' Empty Empty)
                (Node 'C' Empty Empty)
            )  
        )
