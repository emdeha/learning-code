import Control.Monad.State

type Stack = [Int]

pop :: State Stack Int
pop = State $ \(x:xs) -> (x,xs)

push :: Int -> State Stack ()
push a = State $ \xs -> ((), a:xs)

stackManip :: State Stack Int
stackManip = do
    push 3
    a <- pop
    pop
