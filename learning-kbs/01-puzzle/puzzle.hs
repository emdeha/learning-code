import System.IO
import Data.Matrix


type Input = Char
type Element = Char
type Node = (Int, Char)


tailOrNil [] = []
tailOrNil (x:xs) = xs

inputToStates :: Input -> Node
inputToStates inp = (1, inp)

generateChildren :: Node -> [Node]
generateChildren (i,c) = [(succ i, succ c),
                          (succ i, succ $ succ $ succ c)]

findNode :: Node -> Node -> [Node] -> [Node] -> [Node] -> [Node]
findNode _     _   _    visited []     = reverse visited
findNode start end path visited (x:xs)
    | snd x == snd end = reverse (x:path)
    | elem x visited =
        findNode x end (tailOrNil path) visited xs
    | otherwise      =
        findNode x end (start:path) (x:visited) ((generateChildren start) ++ xs)


main :: IO ()
main = do
    let start = inputToStates 'A'
        end = (4, 'J')
    putStrLn $ show $ findNode start end [] [] [start]
