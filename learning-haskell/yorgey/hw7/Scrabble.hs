{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module Scrabble where

import Data.Monoid
import Data.List
import Data.Char


newtype Score = Score Int
  deriving (Eq, Ord, Show, Num)

getScore :: Score -> Int
getScore (Score i) = i

instance Monoid Score where
  mempty = Score 0
  mappend = (+)

scores :: [(Int, String)]
scores = [(1, "AEILNORSTU")
         ,(2, "DG")
         ,(3, "BCMP")
         ,(4, "FHVWY")
         ,(5, "K")
         ,(8, "JX")
         ,(10, "QZ")
         ]

score :: Char -> Score
score ch = 
    let val = find isScored scores
    in  case val of
        Just (s,_) -> Score s
        Nothing    -> mempty
  where isScored :: (Int, String) -> Bool
        isScored (_,l) = (toUpper ch) `elem` l

scoreString :: String -> Score
scoreString = mconcat . map score
