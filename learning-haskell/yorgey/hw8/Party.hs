{-# OPTIONS_GHC -Wall #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
module Party where

import Data.Monoid

import Employee


glCons :: Employee -> GuestList -> GuestList
glCons emp (GL emps fscore) = (GL (emp:emps) (fscore+empFun emp))

instance Monoid GuestList where
  (GL emps1 fscore1) `mappend` (GL emps2 fscore2) = 
    (GL (emps1++emps2) (fscore1+fscore2))
  mempty = (GL [] 0)

moreFun :: GuestList -> GuestList -> GuestList
moreFun gl1 gl2
    | gl1 <= gl2 = gl2
    | otherwise  = gl1
