import System.IO
import Data.List
import Data.Array


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

inputToStates :: Input -> Node
inputToStates inp = 
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

findNode :: Node -> Node -> [Node] -> [Node] -> [Node]
findNode _     _   visited []     = reverse visited
findNode start end visited (x:xs)
    | getNodeVal x == getNodeVal end = reverse $ constructPathFromEnd x
    | elem x visited                 = findNode x end visited xs
    | otherwise = findNode x end (x:visited) ((generateChildren start) ++ xs)
  where constructPathFromEnd :: Node -> [Node]
        constructPathFromEnd initial =
            unfoldr (\nd@(Node p e) -> case p of
                                        Nil -> Nothing
                                        pnd -> Just (nd, pnd))
                    initial


main :: IO ()
main = do
    let start = inputToStates "123X45678"
        end = inputToStates "123456X78"
    putStrLn . 
        concatMap (\nd -> getNodeVal nd ++ " ") $ start : findNode start end [] [start]
