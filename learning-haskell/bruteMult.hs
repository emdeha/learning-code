guarded :: Bool -> [a] -> [a]
guarded True xs = xs
guarded False _ = []

-- Flowing through the edge
multiplyTo :: Int -> [(Int, Int)]
multiplyTo n = do
    x <- [1..n]
    y <- [x..n]
    guarded (x * y == n) $
        return (x, y)

-- |
-- | of consciousness
-- V 

multiplyTo' n =
    [1..n] >>= \x ->
    [x..n] >>= \y ->
    guarded (x * y == n) $
        return (x, y)
 
-- |
-- | we find the truth
-- V 

multiplyTo'' n =
    (concat (map (\x ->
                  concat (map (\y -> 
                      guarded (x * y == n) $
                            return (x, y))
                          [x..n])
                 )
                 [1..n]
            )
    )
