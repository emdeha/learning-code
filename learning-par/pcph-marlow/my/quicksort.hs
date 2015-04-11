import System.Environment


quicksort :: Ord a => [a] -> [a]
quicksort [] = []
quicksort (x:xs) = 
    let less = [a | a <- xs, a < x]
        more = [b | b <- xs, b >= x]
    in  quicksort less ++ [x] ++ quicksort more

main :: IO ()
main = do
    [f] <- getArgs
    file <- readFile f

    let list = map read $ lines file :: [Int]

    print $ quicksort list
