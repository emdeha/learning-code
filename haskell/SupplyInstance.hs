{-# LANGUAGE GeneralizedNewtypeDeriving #-}

import Control.Monad.Reader
import SupplyClass

newtype MySupply e a = MySupply { runMySupply :: Reader e a }
    deriving (Monad)

instance MonadSupply e (MySupply e) where
    next = MySupply $ ask >>= Just
