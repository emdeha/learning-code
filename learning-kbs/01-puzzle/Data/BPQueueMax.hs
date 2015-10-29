module Data.BPQueueMax (
      BPQueueMax

    , insert
    , singleton
    , maxView
    ) where

import qualified Data.Sequence as S
import Data.Array

data BPQueueMax a = BPQueueMax (Array Int (S.Seq a))
                 deriving (Show)


insert :: Int -> a -> BPQueueMax a -> BPQueueMax a
insert k a (BPQueueMax arr) =
    let (f, l) = bounds arr 
    in  if f <= k && k <= l
        then BPQueueMax $ arr // [(k, (arr ! k) S.|> a)]
        else BPQueueMax $ addPriority arr f l k a 

addPriority :: Array Int (S.Seq a) -> Int -> Int -> Int -> a -> Array Int (S.Seq a)
addPriority arr f l k a
    | k > l =
        let old = assocs arr
            new = (k, S.singleton a) : (take (k-l) $ enumBPQ (l+1, S.empty))
        in  array (f, k) (old ++ new)
    | otherwise =
        error $ "Priority out of bounds (" ++ (show f) ++ "," ++ (show l) ++ ")"


singleton :: Int -> a -> BPQueueMax a
singleton k a
    | k >= 0 =
        let first = (k, S.singleton a)
            rest = take k $ enumBPQ (0, S.empty)
        in  BPQueueMax (array (0, k) (first : rest))
    | otherwise =
        error "Priority must be positive"

enumBPQ :: Enum a => (a, S.Seq b) -> [(a, S.Seq b)]
enumBPQ bpq@(a, que) = bpq : enumBPQ (succ a, que)


maxView :: BPQueueMax a -> Maybe (a, BPQueueMax a)
maxView (BPQueueMax arr) =
    extractAt (snd . bounds $ arr) arr
  where extractAt :: Int -> Array Int (S.Seq a) -> Maybe (a, BPQueueMax a)
        extractAt 0  _    = Nothing
        extractAt ix arr' =
            let que = arr' ! ix
            in  if S.null que
                then extractAt (ix-1) arr'
                else detachHeadAt (S.viewl que) ix arr'

        detachHeadAt :: S.ViewL a -> Int -> Array Int (S.Seq a) -> Maybe (a, BPQueueMax a)
        detachHeadAt S.EmptyL    _ _    = Nothing
        detachHeadAt (x S.:< xs) k arr' = Just (x, BPQueueMax (arr' // [(k, xs)]))
