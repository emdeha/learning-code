import Control.Applicative

myAction :: IO String
myAction = do
    a <- getLine
    b <- getLine
    return $ a ++ b

myAction' :: IO String
myAction' = (++) <$> getLine <*> getLine

main = do
    a <- myAction'
    putStrLn $ "Concat lines: " ++ a

sequenceA :: (Applicative f) => [f a] -> f [a]
sequenceA = foldr (liftA2 (:)) (pure [])

newtype Pair b a = Pair { getPair :: (a,b) }

instance Functor (Pair c) where
    fmap f (Pair (x,y)) = Pair (f x, y)

instance Applicative (Pair c) where
    pure (x,y) = Pair (x,y)
    Pair (fx,fy) <*> Pair (x,y) = (Pair (fx x, fy y)) 
