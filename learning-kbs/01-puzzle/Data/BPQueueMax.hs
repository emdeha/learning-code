module BPQueueMax (
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
insert k a bpq@(BPQueueMax arr) =
    let (f, l) = bounds arr 
    in  if f <= k && k <= l
        then BPQueueMax $ arr // [(k, (arr ! k) S.|> a)]
        else error $ "Priority out of bounds (" ++ (show f) ++ "," ++ (show l) ++ ")"


singleton :: Int -> a -> BPQueueMax a
singleton k a
    | k >= 0    =
        BPQueueMax (array (0, k) ((k, S.singleton a) : (take k (enumBPQ (0, S.empty)))))
    | otherwise =
        error "Priority must be positive"

enumBPQ :: Enum a => (a, S.Seq b) -> [(a, S.Seq b)]
enumBPQ bpq@(a, seq) = bpq : enumBPQ (succ a, seq)


maxView :: BPQueueMax a -> Maybe (a, BPQueueMax a)
maxView (BPQueueMax arr) =
    let (_, maxIx) = bounds arr
        que = arr ! maxIx
    in  if S.null que
        then Nothing
        else Just (detachHeadAt (S.viewl que) maxIx arr)
  where detachHeadAt :: S.ViewL a -> Int -> Array Int (S.Seq a) -> (a, BPQueueMax a)
        detachHeadAt (x S.:< xs) k arr = (x, BPQueueMax (arr // [(k, xs)]))
