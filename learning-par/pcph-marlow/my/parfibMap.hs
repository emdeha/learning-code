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
        solutions = runEval (myparMap (fib . read) fibnums)
        
    print solutions

myparMap :: (a -> b) -> [a] -> Eval [b]
myparMap _ [] = return []
myparMap f (a:as) = do
    b <- rpar (f a)
    bs <- myparMap f as
    return (b:bs)
