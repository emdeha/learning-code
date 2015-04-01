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
        solutions =  map (fib . read) fibnums `using` parListChunk 10 rseq
        
    print solutions
