import Data.Ratio
import Data.List (all)

newtype ProbList a = ProbList { getProbList :: [(a,Rational)] } deriving Show

instance Functor ProbList where
    fmap f (ProbList xs) = ProbList $ map (\(x,p) -> (f x,p)) xs

flatten :: ProbList (ProbList a) -> ProbList a
flatten (ProbList xs) = ProbList $ concat $ map multAll xs
    where multAll (ProbList innerxs,p) = map (\(x,r) -> (x,p*r)) innerxs

instance Monad ProbList where
    return x = ProbList [(x,1%1)]
    m >>= f = flatten (fmap f m)
    fail _ = ProbList []

data Coin = Heads | Tails deriving (Show, Eq)

coin :: ProbList Coin
coin = ProbList [(Heads,1%2),(Tails,1%2)]

loadedCoin :: ProbList Coin
loadedCoin = ProbList [(Heads,1%10),(Tails,9%10)]

flipThree :: ProbList Bool
flipThree = do
    a <- coin
    b <- coin
    c <- loadedCoin
    return (all (==Tails) [a,b,c])


-- flattens the equal results with their chance
divideEqual :: ProbList Bool -> [ProbList Bool]
divideEqual (ProbList xs) = 
    [ProbList $ takeWhile pred xs] ++ [ProbList $ dropWhile pred xs]
    where pred (x,p) = x == False

sumCoef :: ProbList Bool -> (Bool,Rational)
sumCoef (ProbList xs) = foldl (\(_,r) (x,p) -> (x,p+r)) (False,0%1) xs

flatten' :: [ProbList Bool] -> ProbList Bool
flatten' ys = ProbList $ fmap sumCoef ys

removeEqual :: ProbList Bool -> ProbList Bool
removeEqual xs = flatten' $ divideEqual xs
