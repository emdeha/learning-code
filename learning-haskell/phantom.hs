newtype List a s = List [a]

data Safe
data Unsafe

createList :: List a Unsafe
createList = List []

sTail :: List a s -> List a Unsafe
sTail (List []) = List []
sTail (List (_:[])) = List []
sTail (List (_:xs)) = List xs

sHead :: List a Safe -> a
sHead (List (x:_)) = x

sAdd :: a -> List a s -> List a Safe
sAdd n (List xs) = List (n:xs)
