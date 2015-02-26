import System.Random
import Data.IORef
import Data.List


memoize :: (Eq a) => IORef [(a, b)] -> (a -> b) -> a -> IO b
memoize memTbl f x = do
    memoized <- readIORef memTbl
    case lookup x memoized of
        (Just res) -> return $ res
        Nothing    -> do 
                let res = f x
                writeIORef memTbl ((x, res) : memoized)
                return res

fact :: Integer -> Integer
fact 0 = 1
fact n = n * (fact $ n-1)

genRand :: Int -> Int
genRand seed = 
    let gen = mkStdGen seed
    in  fst $ random gen
