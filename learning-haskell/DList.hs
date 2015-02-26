import Data.Monoid

newtype DList a = DList {
        unDL :: [a] -> [a]
    }

instance Monoid (DList a) where
    mempty = empty
    mappend = append

append :: DList a -> DList a -> DList a
append xs ys = DList (unDL xs . unDL ys)

fromList :: [a] -> DList a
fromList xs = DList (xs ++)

toList :: DList a -> [a]
toList (DList xs) = xs []

empty :: DList a
empty = DList id

cons :: a -> DList a -> DList a
cons x (DList xs) = DList ((x:) . xs)
