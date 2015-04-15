{-# OPTIONS_GHC -Wall #-}
module calc where

import exprt


-- | Evaluates an ExprT
eval :: ExprT -> Integer
eval (Lit x) = x
eval (Mul x y) = eval x * eval y
eval (Add x y) = eval x + eval y
