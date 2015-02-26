{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}

data H = forall a. (Show a, MyOp a) => H a

class MyOp a where
    isNumber :: a -> Bool

instance MyOp Int where
    isNumber _ = True

instance MyOp Float where
    isNumber _ = True

instance MyOp String where
    isNumber _ = True

instance MyOp H where
    isNumber (H a) = isNumber a

instance Show H where
    show (H a) = show a

myList = [H (1::Int), H "Hello", H (2.4::Float)]
