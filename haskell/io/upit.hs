import Data.Char (toUpper)

main = interact (unlines . filter (elem 'a') . lines)
