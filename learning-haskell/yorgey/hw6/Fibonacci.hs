module Fibonacci where


-- | Computing fibs
fib :: Integer -> Integer
fib 0 = 0
fib 1 = 1
fib n = (fib (n-1)) + (fib (n-2))

fibs1 :: [Integer]
fibs1 = map fib [0..]

-- | Uses memoization to compute the fibonacci sequence
fibs2 :: [Integer]
fibs2 = 0 : 1 : zipWith (+) (tail fibs2) (init fibs2)


-- | Streams
data Stream a = Cons a (Stream a)

instance Show a => Show (Stream a) where
    show = show . take 64 . streamToList

-- | Converts a Stream into an infinite list
streamToList :: Stream a -> [a]
streamToList (Cons x xs) = x : streamToList xs

-- | Creates a stream where each element is the same
streamRepeat :: a -> Stream a
streamRepeat x = Cons x $ streamRepeat x

-- | Maps a function of the type (a->b) to a Stream of values
streamMap :: (a -> b) -> Stream a -> Stream b
streamMap f (Cons x xs) = Cons (f x) $ streamMap f xs

-- | Generates a stream from @seed@ and unfolding rule @ur@
streamFromSeed :: (a -> a) -> a -> Stream a
streamFromSeed ur seed = Cons seed $ streamFromSeed ur (ur seed)

-- | Stream of natural numbers
nats :: Stream Integer
nats = streamFromSeed (+1) 0

-- | Stream corresponding to the ruler function
ruler :: Stream Integer
ruler = streamInterleave (streamRepeat 0) powerStream
  where powerStream = streamMap divX $ streamFromSeed (+1) 1
        divX x
            | x `mod` 2 == 0 = 1 + divX (x`quot`2)
            | otherwise      = 1

-- | Interleaves two streams by alternating their values
streamInterleave :: Stream a -> Stream a -> Stream a
streamInterleave (Cons x xs) (Cons y ys) = Cons x (Cons y $ streamInterleave xs ys)
