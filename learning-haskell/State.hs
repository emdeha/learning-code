module State 
    ( State (runState)
    , get
    , put
    ) where

import Control.Monad

newtype State s a = State {
        runState :: s -> (a, s)
    }

instance Monad (State s) where
    return = returnState
    (>>=) = bindState

returnState :: a -> State s a
returnState a = State $ \s -> (a, s)

bindState :: (State s a) -> (a -> State s b) -> (State s b)
bindState m k = State $ \s -> let (a, s') = runState m s
                              in  runState (k a) s'

get :: State s s
get = State $ \s -> (s, s)

put :: s -> State s ()
put s = State $ \_ -> ((), s)
