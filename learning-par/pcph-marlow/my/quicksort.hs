import System.Environment
import qualified Data.Vector as V
import Data.List


quicksort :: Ord a => V.Vector a -> V.Vector a
quicksort ls 
    | V.null ls = V.empty
    | otherwise = 
        let (x,xs) = (V.head ls, V.tail ls)
            less = V.filter (<x) xs
            more = V.filter (>=x) xs
        in  (quicksort less `V.snoc` x) V.++ quicksort more

main :: IO ()
main = do
    [f] <- getArgs
    file <- readFile f

    let list = map read $ lines file :: [Int]
        sorted = quicksort (V.fromList list)

    print $ V.length sorted
