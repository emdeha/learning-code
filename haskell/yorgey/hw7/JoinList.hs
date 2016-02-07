{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleInstances, TypeSynonymInstances #-}
module JoinList where

import Data.Monoid

import Sized
import Scrabble
import Buffer
import Editor


data JoinList m a = Empty
                  | Single m a
                  | Append m (JoinList m a) (JoinList m a)
  deriving (Eq, Show)


-- | Concatenates two join lists
(+++) :: Monoid m => JoinList m a -> JoinList m a -> JoinList m a
jl +++ jr = Append (tag jl `mappend` tag jr) jl jr

-- | Extracts the tag of a given join list
tag :: Monoid m => JoinList m a -> m
tag Empty          = mempty
tag (Single m _)   = m
tag (Append m _ _) = m

-- | Converts a sized join list's tag to an Int
nodeSize :: (Sized b, Monoid b) => JoinList b a -> Int
nodeSize = getSize . size . tag

-- | Gets the element at index @i@ in a join list
indexJ :: (Sized b, Monoid b) => Int -> JoinList b a -> Maybe a
indexJ _ Empty     = Nothing
indexJ i _ | i < 0 = Nothing
indexJ i (Single s x)
    | (getSize . size $ s) - 1 == i = Just x
    | otherwise                     = Nothing
indexJ i (Append _ jl jr)
    | (nodeSize jl - 1) < i = indexJ (i - nodeSize jl) jr
    | otherwise             = indexJ i jl

-- | Drops the first @n@ elements from a join list
dropJ :: (Sized b, Monoid b) => Int -> JoinList b a -> JoinList b a
dropJ _ Empty   = Empty
dropJ 0 jls     = jls
dropJ n jls | n < 0 = jls
dropJ _ (Single _ _) = Empty
dropJ n (Append _ jl jr)
    | (nodeSize jl - 1) < n = dropJ (n - nodeSize jl) jr
    | otherwise             = (dropJ n jl) +++ jr

-- | Takes the first @n@ elements from a join list
takeJ :: (Sized b, Monoid b) => Int -> JoinList b a -> JoinList b a
takeJ _ Empty = Empty
takeJ 0 _   = Empty
takeJ n _ | n < 0 = Empty
takeJ _ jls@(Single _ _) = jls
takeJ n (Append _ jl jr)
    | (nodeSize jl - 1) < n = jl +++ takeJ (n - nodeSize jl) jr
    | otherwise             = takeJ n jl

 
-- | Creates a join list with the string's scrabble score
scoreLine :: String -> JoinList Score String
scoreLine str = Single (scoreString str) str


-- | Buffer instance for JoinList
instance Buffer (JoinList (Score, Size) String) where
    toString Empty = ""
    toString (Single _ str) = str
    toString (Append _ jl jr) = toString jl ++ toString jr

    fromString "" = Empty
    fromString str =
        let lined = lines str
            (left,right) = splitAt (length lined `div` 2) lined
        in  case left of
            [] -> Single (scoreString (unlines right), Size 1) (unlines right)
            _  -> fromString (unlines left) +++ fromString (unlines right)

    line = indexJ

    replaceLine n ln jl = takeJ n jl +++ (fromString ln) +++ dropJ (n+1) jl

    numLines = nodeSize
    value = getScore . fst . tag


-- | App entry point
main :: IO ()
main = runEditor editor $ (fromString "sad" :: JoinList (Score, Size) String)
