module FunctorEx where

data MyEither e x = L e
                  | R x
                  deriving (Show)


instance Functor (MyEither e) where
    fmap _ (L e) = L e
    fmap g (R x) = R (g x)
