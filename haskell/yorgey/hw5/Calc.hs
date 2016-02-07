{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}
{-# OPTIONS_GHC -Wall #-}
module Calc where


import qualified Data.Map as M

import ExprT
import Parser
import qualified StackVM as SVM


-- | Evaluates an Expr
eval :: ExprT -> Integer
eval (Lit x) = x
eval (Mul x y) = eval x * eval y
eval (Add x y) = eval x + eval y

-- | Evaluates a string-represented expression
--   TODO: Report bug in computation (2+2*2+1 /= 7)
evalStr :: String -> Maybe Integer
evalStr = tryEval eval . parseExp Lit Add Mul
  where tryEval :: (ExprT -> Integer) -> Maybe ExprT -> Maybe Integer
        tryEval _ Nothing  = Nothing
        tryEval f (Just x) = Just (f x)


-- | Different kinds of expressions
class Expr a where
    lit :: Integer -> a
    add :: a -> a -> a
    mul :: a -> a -> a

instance Expr ExprT where
    lit a = Lit a
    add a b = Add a b
    mul a b = Mul a b

instance Expr Integer where
    lit a = a
    add a b = a + b
    mul a b = a * b

instance Expr Bool where
    lit a = a > 0
    add a b = a || b
    mul a b = a && b


newtype MinMax = MinMax Integer deriving (Eq, Show)

instance Expr MinMax where
    lit a = MinMax a
    add (MinMax a) (MinMax b) = MinMax $ max a b
    mul (MinMax a) (MinMax b) = MinMax $ min a b

newtype Mod7 = Mod7 Integer deriving (Eq, Show)

instance Expr Mod7 where
    lit a = Mod7 $ a `mod` 7
    add (Mod7 a) (Mod7 b) = Mod7 $ (a + b) `mod` 7
    mul (Mod7 a) (Mod7 b) = Mod7 $ (a * b) `mod` 7
    
testExp :: Expr a => Maybe a
testExp = parseExp lit add mul "(3 * -4) + 5"

testInteger :: Maybe Integer
testInteger = testExp
testBool :: Maybe Bool
testBool = testExp
testMinMax :: Maybe MinMax
testMinMax = testExp
testMod7 :: Maybe Mod7
testMod7 = testExp


-- | stackVM support
instance Expr SVM.Program where
    lit a = [SVM.PushI a]
    add a b = a ++ b ++ [SVM.Add]
    mul a b = a ++ b ++ [SVM.Mul]

compile :: String -> Maybe SVM.Program
compile expr = parseExp lit add mul expr


-- | Expressions containing variables
class HasVars a where
    var :: String -> a

data VarExprT = VLit Integer
              | VAdd VarExprT VarExprT
              | VMul VarExprT VarExprT
              | Var String
              deriving (Show)

instance HasVars VarExprT where
    var = Var

instance Expr VarExprT where
    lit = VLit
    add = VAdd
    mul = VMul

instance HasVars (M.Map String Integer -> Maybe Integer) where
    var = M.lookup

instance Expr (M.Map String Integer -> Maybe Integer) where
    lit a = (\_ -> Just a)
    add a b = (\x -> maybeApply (+) (a x) (b x))
    mul a b = (\x -> maybeApply (*) (a x) (b x))

maybeApply :: (Integer -> Integer -> Integer) -> 
              Maybe Integer -> Maybe Integer -> Maybe Integer
maybeApply _ Nothing Nothing  = Nothing
maybeApply _ _ Nothing = Nothing
maybeApply _ Nothing _ = Nothing
maybeApply f (Just a) (Just b) = Just $ a `f` b


withVars :: [(String, Integer)]
         -> (M.Map String Integer -> Maybe Integer)
         -> (Maybe Integer)
withVars vs expr = expr $ M.fromList vs
