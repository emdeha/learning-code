module Supply
    (
      Supply
    , next
    , runSupply
    ) where

import Control.Monad.State


newtype Supply s a = S (State [s] a)

next = S $ do st <- get
              case st of
                [] -> return Nothing
                (x:xs) -> do put xs
                             return (Just x)

runSupply (S m) xs = runState m xs
