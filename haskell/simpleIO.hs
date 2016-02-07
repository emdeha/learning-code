import System.IO
import Control.Monad
import Data.Char

main = do
    withFile "graph.hs" ReadMode (\handle -> do
        contents <- hGetContents handle
        putStr contents)
