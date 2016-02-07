import System.Environment
import Control.Parallel.Strategies
import Control.DeepSeq


quicksort :: (Ord a, NFData a) => [a] -> [a]
quicksort [] = []
quicksort ls@(x:xs)
    | otherwise       =
        let l = [a | a <- xs, a < x]
            m = [b | b <- xs, b >= x]
            (less, more) = (quicksort l `using` rseq,
                            quicksort m `using` rseq)
        in  less ++ [x] ++ more

main :: IO ()
main = do
    [f] <- getArgs
    file <- readFile f

    let list = map read $ lines file :: [Int]
        sorted = quicksort list

    print $ length sorted
