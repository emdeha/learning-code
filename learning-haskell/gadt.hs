{-# LANGUAGE GADTs #-}

data Term a where
    I :: Int -> Term Int
    V :: [Int] -> Term [Int]
    Plus :: Term a -> Term a -> Term a
