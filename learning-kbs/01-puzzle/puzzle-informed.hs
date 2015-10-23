--
-- Informed search
-- Best-first search
-- Heuristics properties 
-- A -
-- |  \
-- |   C
-- |  /
-- B -
-- dist(A,B) + dist(B,C) > dist(A,C)
--
import System.Environment (getArgs)
import Data.List
import qualified Data.HashSet as HS
import qualified Data.PSQueue as PS


type Input = String

type Puzzle = String
type Element = ((Int, Int), Puzzle)

getXCol :: Element -> Int
getXCol ((x, _), _) = x

getXRow :: Element -> Int
getXRow ((_, y), _) = y

getVal :: Element -> Puzzle
getVal  ((_, _), v) = v


data Node = Node Node Element
          | Nil
         deriving (Show, Eq, Ord)

getNodeVal :: Node -> Puzzle
getNodeVal Nil        = ""
getNodeVal (Node _ v) = getVal v


rows :: Int
rows = 3

cols :: Int
cols = 3

inputToNode :: Input -> Node
inputToNode inp = 
    let xCol = indexX `mod` cols
        xRow = indexX `quot` rows
    in  Node Nil ((xCol, xRow), inp)
  where indexX = case elemIndex 'X' inp of
                    Nothing -> error "No 'X' in input!"
                    Just i  -> i
        

--
-- Generate children only at valid positions 
-- (x-1, y), (x+1, y), (x, y-1), (x, y+1).
--
generateChildren :: Node -> [Node]
generateChildren Nil          = []
generateChildren p@(Node _ v) = 
    let x = getXCol v
        y = getXRow v
    in  concatMap tryIndex [(x-1,y,x,y), (x+1,y,x,y), (x,y-1,x,y), (x,y+1,x,y)]
  where tryIndex (x', y',x,y) =
            if x' >= 0 && y' >= 0 && x' < cols && y' < rows
            then [Node p ((x', y'), swap (at' x y) (at' x' y'))]
            else []
        swap v1 v2 =
            map (\x -> if x == v1 then v2 else if x == v2 then v1 else x) (getVal v)
        at' x y =
            (getVal v) !! (y * rows + x)


calcPrio :: Node -> (Node, Int)
calcPrio nd = (nd, 1)
-- calcPrio Nil = (Nil, 0)
-- calcPrio nd@(Node _ ((_,_), x))
--   | ('1' `elemIndex` x) `elem` firstRow ||
--     ('2' `elemIndex` x) `elem` firstRow ||
--     ('3' `elemIndex` x) `elem` firstRow    = (nd,1)
--   | ('4' `elemIndex` x) `elem` secondRow ||
--     ('5' `elemIndex` x) `elem` secondRow ||
--     ('6' `elemIndex` x) `elem` secondRow    = (nd,2)
--   | ('7' `elemIndex` x) `elem` thirdRow ||
--     ('8' `elemIndex` x) `elem` thirdRow ||
--     ('X' `elemIndex` x) `elem` thirdRow    = (nd,3)
--   | otherwise                              = (nd,1)
--   where firstRow = [Just 0, Just 1, Just 2]
--         secondRow = [Just 3, Just 4, Just 5]
--         thirdRow = [Just 6, Just 7, Just 8]


findNode :: Node -> HS.HashSet Element -> PS.PSQ Node Int -> [Node]
findNode end visited pq =
    let que = PS.minView pq
    in  case que of
        Nothing      -> []
        Just (x, xs) -> go (PS.key x) xs
  where go :: Node -> PS.PSQ Node Int -> [Node]
        go Nil _ = []
        go x@(Node _ v) xs
            | getNodeVal x == getNodeVal end = reverse $ constructPathFromEnd x
            | HS.member v visited            = findNode end visited xs
            | otherwise = 
                let visited' = HS.insert v visited
                    front    = insertInPQ (map calcPrio (generateChildren x)) xs
                in  findNode end visited' front

        insertInPQ :: [(Node, Int)] -> PS.PSQ Node Int -> PS.PSQ Node Int
        insertInPQ []    pq' = pq'
        insertInPQ (prio:rest) pq' = insertInPQ rest (uncurry PS.insert prio pq')

        constructPathFromEnd :: Node -> [Node]
        constructPathFromEnd initial =
            unfoldr (\nd@(Node p _) -> case p of
                                        Nil -> Nothing
                                        pnd -> Just (nd, pnd))
                    initial


main :: IO ()
main = do
    args <- getArgs
    case args of
        [start, end] -> solvePuzzle (inputToNode start) (inputToNode end)
        _            -> putStrLn "Invalid args"

solvePuzzle :: Node -> Node -> IO ()
solvePuzzle start end =
    putStrLn . 
        concatMap ((++"\n") . concatMap (++"\n") . chunk 3 . getNodeVal) $
            start : findNode end HS.empty (uncurry PS.singleton . calcPrio $ start)

chunk :: Int -> [a] -> [[a]]
chunk _ []  = []
chunk n str =
    case splitAt n str of
        (ch, rest) -> ch : chunk n rest
