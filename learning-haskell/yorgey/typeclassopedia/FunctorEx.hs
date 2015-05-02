{-# OPTIONS_GHC -Wall #-}
module FunctorEx where



data MyEither e x = L e
                  | R x
                  deriving (Show)


instance Functor (MyEither e) where
    fmap _ (L e) = L e
    fmap g (R x) = R (g x)


data Pair a = Pair a a
    deriving (Show)

instance Functor Pair where
    fmap g (Pair a b) = Pair (g a) (g b)


data ITree a = Leaf (Int -> a)
             | Node [ITree a]

instance Functor ITree where
    fmap g (Leaf f)      = Leaf $ g . f
    fmap g (Node forest) = Node $ map (fmap g) forest


class CoMonoidal f where
    clean :: f () -> ()
    clean = (\_ -> ())
    split :: f (a, b) -> (f a, f b)

instance CoMonoidal ((,) a) where
    split (a, (a1,b)) = ((a,a1),(a,b))

instance CoMonoidal ((->) a) where
    split ff = ((\a -> fst (ff a)), (\a -> snd (ff a)))
