import Control.Monad

applyMaybe :: Maybe a -> (a -> Maybe b) -> Maybe b
applyMaybe Nothing f = Nothing
applyMaybe (Just x) f = f x

-- Pierre
type Birds = Int
type Pole = (Birds, Birds)

landLeft :: Birds -> Pole -> Maybe Pole
landLeft n (left, right)  
    | abs ((left + n) - right) < 4 = Just (left + n, right)
    | otherwise                    = Nothing

landRight :: Birds -> Pole -> Maybe Pole
landRight n (left, right) 
    | abs (left - (right + n)) < 4 = Just (left, right + n)
    | otherwise                    = Nothing

banana :: Pole -> Maybe Pole
banana _ = Nothing

routine :: Maybe Pole
routine = case landLeft 1 (0,0) of
    Nothing -> Nothing
    Just pole1 -> case landRight 4 pole1 of
        Nothing -> Nothing
        Just pole2 -> case landLeft 2 pole2 of
            Nothing -> Nothing
            Just pole3 -> landLeft 1 pole3

routine' :: Maybe Pole
routine' = do
    pole1 <- landLeft 1 (0,0)
    pole2 <- landRight 4 pole1
    pole3 <- landLeft 2 pole2
    landLeft 1 pole3

foo :: Maybe String
foo = Just 3   >>= (\x ->
      Just "!" >>= (\y ->
      Just (show x ++ y)))

foo' = do
    x <- Just 3
    y <- Just "!"
    Just (show x ++ y)

justFirst :: String -> Maybe Char
justFirst str = do
    (x:xs) <- Just str
    return x

guard' :: (MonadPlus m) => Bool -> m ()
guard' True = return ()
guard' False = mzero

x -: f = f x

binSmalls :: Int -> Int -> Maybe Int
binSmalls acc x
    | x > 9     = Nothing
    | otherwise = Just (acc + x)
