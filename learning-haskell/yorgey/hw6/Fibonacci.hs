{-# OPTIONS_GHC -Wall -fno-warn-missing-methods #-}
{-# LANGUAGE FlexibleInstances #-}
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
streamToList (Cons a as) = a : streamToList as

-- | Creates a stream where each element is the same
streamRepeat :: a -> Stream a
streamRepeat a = Cons a $ streamRepeat a

-- | Maps a function of the type (a->b) to a Stream of values
streamMap :: (a -> b) -> Stream a -> Stream b
streamMap f (Cons a as) = Cons (f a) $ streamMap f as

-- | Generates a stream from @seed@ and unfolding rule @ur@
streamFromSeed :: (a -> a) -> a -> Stream a
streamFromSeed ur seed = Cons seed $ streamFromSeed ur (ur seed)

-- | Stream of natural numbers
nats :: Stream Integer
nats = streamFromSeed (+1) 0

-- | Stream corresponding to the ruler function
ruler :: Stream Integer
ruler = streamInterleave (streamRepeat 0) powerStream
  where powerStream = streamMap divA $ streamFromSeed (+1) 1
        divA :: Integer -> Integer
        divA a
            | a `mod` 2 == 0 = 1 + divA (a`quot`2)
            | otherwise      = 1

-- | Interleaves two streams by alternating their values
streamInterleave :: Stream a -> Stream a -> Stream a
streamInterleave (Cons a as) (Cons b bs) = Cons a (Cons b $ streamInterleave as bs)


-- | Fibonacci numbers using generating functions
x :: Stream Integer
x = (Cons 0 (Cons 1 (streamRepeat 0)))

instance Num (Stream Integer) where
    fromInteger n = Cons n $ streamRepeat 0
    negate = streamMap (*(-1))
    (Cons a as) + (Cons b bs) = Cons (a+b) (as + bs)
    (Cons a0 a') * b@(Cons b0 b') = Cons (a0*b0) ((streamMap (*a0) b') + a'*b)

instance Fractional (Stream Integer) where
    (Cons a0 a') / (Cons b0 b') = q
        where q = Cons (a0`div`b0) (streamMap (*(1`div`b0)) (a' - q * b'))

fibs3 :: Stream Integer
fibs3 = x / (1 - x - x^2)
