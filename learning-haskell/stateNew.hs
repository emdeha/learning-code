data State s b = State (s -> (b, s))

instance Monad (State s) where
    mv >>= f = State (\st -> 
                    let (y, st') = runState mv st
                    in runState (f y) st')
    return x = State (\st -> (x, st))

runState :: State s a -> s -> (a, s)
runState (State f) initState = f initState

evalState :: State s a -> s -> a
evalState st initState = fst (runState st initState)

execState :: State s a -> s -> s
execState st initState = snd (runState st initState)

---------------
-- State GCD --
---------------
type GCDState = (Int, Int)

runGCD :: Int -> Int -> Int
runGCD x y = fst (runState gcdState (x, y))

gcdState :: State GCDState Int
gcdState = do
    getState >>= (\(x, y) ->
        case compare x y of
            EQ -> return x
            LT -> do putState (y, x) >> gcdState
            GT -> do putState (y, x - y) >> gcdState)
  where
    getState :: State GCDState GCDState
    getState = State (\(x, y) -> ((x, y), (x, y)))

    putState :: GCDState -> State GCDState ()
    putState (x', y') = State (\_ -> ((), (x',y')))

gcdWhile :: State GCDState Int
gcdWhile = do
    while (\(x,y) -> x /= y) $ do
        (x, y) <- get
        if x < y
        then put (x, (y - x))
        else put ((x - y), y)
    (x, _) <- get
    return x
  where

runGCDWhile x y = evalState gcdWhile (x, y)

---------------------
-- State Factorial --
---------------------
fact :: Int -> Int
fact x = fact' x 1
  where fact' x acc
            | x > 0     = fact' (x-1) (acc * x)
            | otherwise = acc

factState :: State (Int, Int) Int 
factState = do
    get >>= (\(x, acc) -> 
                if x > 0
                then put (x-1, acc * x) >> factState
                else return acc)

runFactState :: Int -> Int
runFactState x = evalState factState (x, 1)

---------------------
-- State Fibonacci --
---------------------
fib :: Int -> Int
fib 0 = 0
fib 1 = 1
fib n = fib (n - 1) + fib (n - 2)

fibState :: State (Int, Int, Int) Int
fibState = do
    get >>= (\(x, acc1, acc2) ->
                if x > 0
                then put (x-1, acc2, acc1 + acc2) >> fibState
                else return acc1)

runFibState :: Int -> Int
runFibState x = evalState fibState (x, 0, 1)

-------------
-- Helpers --
-------------
while :: (s -> Bool) -> State s () -> State s ()
while test body =
    do st <- get
       if (test st)
       then do modify (execState body)
               while test body
       else return ()

get :: State s s
get = State (\st -> (st, st))

put :: s -> State s ()
put s = State (\_ -> ((), s))

modify f = do
    get >>= put . f
