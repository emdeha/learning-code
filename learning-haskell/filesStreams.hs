import Control.Monad
import Data.Char

main = interact $ unlines . filter ((<20) . length) . lines

shortLinesOf :: String -> String
shortLinesOf input =
    let allLines = lines input
        shortLines = filter (\line -> length line < 20) allLines
        result = unlines shortLines
    in  result
