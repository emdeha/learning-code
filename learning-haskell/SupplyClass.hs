{-# LANGUAGE GeneralizedNewtypeDeriving, MultiParamTypeClasses,
    FunctionalDependencies, FlexibleInstances #-}
module SupplyClass
    (
      MonadSupply(..)
    , S.Supply
    , S.runSupply
    ) where

import qualified Supply as S

class (Monad m) => MonadSupply s m | m -> s where
    next :: m (Maybe s)

instance MonadSupply s (S.Supply s) where
    next = S.next
