import Control.Monad(liftM, liftM2)
import Test.QuickCheck
import Data.List(intersperse)

import Prettify

instance Arbitrary Doc where
    arbitrary =
        oneof [ return Empty
              , liftM Char arbitrary
              , liftM Text arbitrary
              , return Line
              , liftM2 Concat arbitrary arbitrary
              , liftM2 Union arbitrary arbitrary ]

prop_empty_id x =
    empty <> x == x
  &&
    x <> empty == x

prop_char c = char c == Char c

prop_text s = text s == if null s then Empty else Text s

prop_line = line == Line

prop_double d = double d == text (show d)

prop_hcat xs = hcat xs == glue xs
    where
        glue []     = empty
        glue (d:ds) = d <> glue ds

prop_punctuate s xs = punctuate s xs == combine (intersperse s xs)
    where
        combine [] = []
        combine [x] = [x]
        combine (x:Empty:ys) = x : combine ys
        combine (Empty:y:ys) = y : combine ys
        combine (x:y:ys) = x `Concat` y : combine ys

args = Args
    { replay = Nothing
    , maxSuccess = 100
    , maxDiscardRatio = 100
    , maxSize = 100
    , chatty = True }

main = do
    run prop_empty_id
    run prop_char
    run prop_text
    run prop_line
    run prop_double
  where
    run prop =
        do quickCheckWithResult args prop
