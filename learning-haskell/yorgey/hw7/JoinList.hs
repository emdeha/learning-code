{-# OPTIONS_GHC -Wall #-}
module JoinList where

import Data.Monoid

import Sized


data JoinList m a = Empty
                  | Single m a
                  | Append m (JoinList m a) (JoinList m a)
  deriving (Eq, Show)


(+++) :: Monoid m => JoinList m a -> JoinList m a -> JoinList m a
jl +++ jr = Append (tag jl `mappend` tag jr) jl jr

tag :: Monoid m => JoinList m a -> m
tag Empty          = mempty
tag (Single m _)   = m
tag (Append m _ _) = m

nodeSize :: (Sized b, Monoid b) => JoinList b a -> Int
nodeSize = getSize . size . tag

indexJ :: (Sized b, Monoid b) => Int -> JoinList b a -> Maybe a
indexJ _ Empty     = Nothing
indexJ i _ | i < 0 = Nothing
indexJ i (Single s x)
    | (getSize . size $ s) - 1 == i = Just x
    | otherwise                     = Nothing
indexJ i (Append _ jl jr)
    | (nodeSize jl - 1) < i = indexJ (i - nodeSize jl) jr
    | otherwise             = indexJ i jl


dropJ :: (Sized b, Monoid b) => Int -> JoinList b a -> JoinList b a
dropJ _ Empty   = Empty
dropJ 0 jls     = jls
dropJ n jls | n < 0 = jls
dropJ _ (Single _ _) = Empty
dropJ n (Append _ jl jr)
    | (nodeSize jl - 1) < n = dropJ (n - nodeSize jl) jr
    | otherwise             = (dropJ n jl) +++ jr


takeJ :: (Sized b, Monoid b) => Int -> JoinList b a -> JoinList b a
takeJ _ Empty = Empty
takeJ 0 _   = Empty
takeJ n _ | n < 0 = Empty
takeJ _ jls@(Single _ _) = jls
takeJ n (Append _ jl jr)
    | (nodeSize jl - 1) < n = jl +++ takeJ (n - nodeSize jl) jr
    | otherwise             = takeJ n jl
