{-# LANGUAGE GeneralizedNewtypeDeriving #-}

import Data.Monoid

newtype AInt = A { unA :: Int }
    deriving (Show, Eq, Num)

instance Monoid AInt where
    mempty = 0
    mappend = (+)

newtype MInt = M { unM :: Int }
    deriving (Show, Eq, Num)

instance Monoid MInt where
    mempty = 1
    mappend = (*)
