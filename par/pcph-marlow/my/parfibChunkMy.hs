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
        chunks = chunk 20 (map (fib . read) fibnums)
        solutions = chunks `using` (parList (evalList rseq))
        
    print $ concat solutions

chunk :: Int -> [a] -> [[a]]
chunk _ []   = []
chunk 0 list = [list]
chunk n list =  
    let (x, xs) = splitAt n list
    in  x : chunk n xs
