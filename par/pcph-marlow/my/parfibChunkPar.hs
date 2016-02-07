import System.Environment
import Control.Monad.Par
import Data.Traversable

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
        solutions = parChunk chunks
        
    print $ concat solutions

parChunk :: NFData a => [a] -> [a]
parChunk chunks = runPar $ do
    solutions <- traverse (spawn . return) chunks
    traverse get solutions

chunk :: Int -> [a] -> [[a]]
chunk _ []   = []
chunk 0 list = [list]
chunk n list =  
    let (x, xs) = splitAt n list
    in  x : chunk n xs
