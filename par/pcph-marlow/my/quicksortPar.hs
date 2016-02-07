import System.Environment
import Control.Parallel.Strategies
import Control.DeepSeq


quicksort :: (Ord a, NFData a) => [a] -> [a]
quicksort [] = []
quicksort ls@(x:xs)
    | length ls < 500 =
        let l = [a | a <- xs, a < x]
            m = [b | b <- xs, b >= x]
        in  quicksort l ++ [x] ++ quicksort m
    | otherwise       =
        let l = [a | a <- xs, a < x]
            m = [b | b <- xs, b >= x]
            (less, more) = runEval $ do
                                less <- rpar $ quicksort l
                                more <- rpar $ quicksort m
                                rseq less
                                rseq more
                                return (less, more)
        in  less ++ [x] ++ more

main :: IO ()
main = do
    [f] <- getArgs
    file <- readFile f

    let list = map read $ lines file :: [Int]
        sorted = quicksort list

    print $ length sorted
