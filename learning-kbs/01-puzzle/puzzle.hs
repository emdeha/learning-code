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
import System.IO
import System.Environment (getArgs)
import Data.List
import qualified Data.Sequence as S


type Input = String

type Puzzle = String
type Element = ((Int, Int), Puzzle)

getXCol ((x, _), _) = x
getXRow ((_, y), _) = y
getVal  ((_, _), v) = v


data Node = Node Node Element
          | Nil
         deriving (Show, Eq)

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

findNode :: Node -> [Node] -> S.ViewL Node -> [Node]
findNode _   visited S.EmptyL = []
findNode end visited (x S.:< xs)
    | getNodeVal x == getNodeVal end = reverse $ constructPathFromEnd x
    | elem x visited                 = findNode end visited (S.viewl xs)
    | otherwise = findNode end (x:visited) (S.viewl $ xs S.>< (S.fromList $ generateChildren x))
  where constructPathFromEnd :: Node -> [Node]
        constructPathFromEnd initial =
            unfoldr (\nd@(Node p e) -> case p of
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
            -- start : (take 20 . generateChildren $ start)
            start : findNode end [] (S.viewl . S.singleton $ start)

chunk _ []  = []
chunk n str =
    case splitAt n str of
        (ch, rest) -> ch : chunk n rest
