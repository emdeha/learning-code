{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE DeriveFunctor, InstanceSigs #-}
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
             | Nodee [ITree a]

instance Functor ITree where
    fmap g (Leaf f)      = Leaf $ g . f
    fmap g (Nodee forest) = Nodee $ map (fmap g) forest


class CoMonoidal f where
    clean :: f () -> ()
    clean = (\_ -> ())
    split :: f (a, b) -> (f a, f b)

instance CoMonoidal ((,) a) where
    split (a, (a1,b)) = ((a,a1),(a,b))

instance CoMonoidal ((->) a) where
    split ff = ((\a -> fst (ff a)), (\a -> snd (ff a)))


data Free f a = Var a
              | Node (f (Free f a))

instance Functor f => Functor (Free f) where
    fmap :: (a -> b) -> Free f a -> Free f b
    fmap f (Var x)  = Var (f x)
    fmap f (Node g) = Node (fmap (fmap f) g)

instance Functor f => Monad (Free f) where
    return :: a -> Free f a
    return = Var

    (>>=) :: (Free f a) -> (a -> Free f b) -> Free f b
    (Var a)   >>= f = f a
    Node free >>= f = Node $ fmap (\rest -> rest >>= f) free

join' :: Monad m => m (m a) -> m a
join' m = m >>= (\ma -> ma)

fmap' :: Monad f => (a -> b) -> f a -> f b
fmap' k x = x >>= (\a -> return $ k a)
