import System.Environment
import Control.Parallel.Strategies
import Control.DeepSeq

fib :: Int -> Int
fib 0 = 1
fib 1 = 1
fib n = fib (n - 1) + fib (n - 2)

main :: IO ()
main = do
    [f] <- getArgs
    file <- readFile f

    let fibnums = lines file

        (as, bs) = splitAt (length fibnums `div` 2) fibnums

        solutions = runEval $ do
                        as' <- rpar (force (map (fib . read) as))
                        bs' <- rpar (force (map (fib . read) bs))
                        rseq as'
                        rseq bs'
                        return (as' ++ bs')
        
    print solutions
