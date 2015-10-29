--
-- This search uses a heap-based priority queue.
--
import System.Environment (getArgs)
import Data.List
import qualified Data.HashSet as HS
import qualified Data.PQueue.Prio.Max as PS


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


calcPrio :: Node -> (Int, Node)
calcPrio Nil = (0, Nil)
calcPrio nd@(Node _ ((_,_), x))
  | "12"  `isPrefixOf` x = (1, nd)
  | "34"  `isInfixOf` x = (2, nd)
  | "45"  `isInfixOf` x = (2, nd)
  | "56"  `isInfixOf`  x = (3, nd)
  | "78X" `isSuffixOf` x = (3, nd)
  | otherwise            = (0,nd)


findNode :: Node -> HS.HashSet Element -> PS.MaxPQueue Int Node -> [Node]
findNode end visited pq =
    let que = PS.maxView pq
    in  case que of
        Nothing      -> []
        Just (x, xs) -> go x xs
  where go :: Node -> PS.MaxPQueue Int Node -> [Node]
        go Nil _ = []
        go x@(Node _ v) xs
            | getNodeVal x == getNodeVal end = reverse $ constructPathFromEnd x
            | HS.member v visited            = findNode end visited xs
            | otherwise = 
                let visited' = HS.insert v visited
                    front    = 
                        -- Insertion order matters!
                        -- puzzle-informed "X12345678" "12345678X":
                        -- foldr -> 500 steps
                        -- foldl -> 234 steps
                        -- puzzle-informed "71534X862" "12345678X":
                        -- foldr -> 279 steps
                        -- foldl -> 313 steps
                        -- foldr (uncurry PS.insert) xs (map calcPrio (generateChildren x))
                        foldl (flip . uncurry $ PS.insert) xs (map calcPrio (generateChildren x))
                in  findNode end visited' front

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
