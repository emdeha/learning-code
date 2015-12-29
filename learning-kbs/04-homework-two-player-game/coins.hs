{-
  Playing a game of Coins.
-}
module Main where


import System.Environment (getArgs)

import Data.Char
import Data.List


type Board = [Bool]
type IndexedBoard = (Int, Bool)

type Take = [Bool]
type IndexedTake = (Int, Bool)

data Turn = Me | Opponent
    deriving (Show, Eq)

data Node = Node
          { parent :: Node
--          , startIdx :: Int
          , board :: Board
          , turn :: Turn
          }
          | Nil
    deriving Show

makeChild :: Node -> Board -> Node
makeChild p b =
    Node { parent = p, board = b, turn = neg . turn $ p }
  where 
    neg Me = Opponent
    neg Opponent = Me

getChildren :: Node -> [Node]
getChildren p =
    let boards = takeCoins $ board p
    in  map (makeChild p) boards
  where
    takeCoins b =
      let boardLen = length b
          cycleLen = boardLen + 3 - 1

          cycledBd = take cycleLen . cycle $ b
          cycledIndices = 
            take cycleLen . cycle $ take boardLen . cycle $ iterate ((+) 1) 0
          cycleListIndexed = zip cycledIndices cycledBd

          possibleTakes = unfoldr getTakes cycleListIndexed

          validTakes = concatMap (\t -> 
              concatMap (\i -> 
                unfoldr (getValidTakes i) t
              ) [1,2,3]
            ) possibleTakes
      in  nub $ unfoldr (nextChildBoard b) validTakes

spanMinus :: 
  (IndexedBoard -> Bool) -> 
  [IndexedBoard] ->
  ([IndexedTake], [IndexedTake])
spanMinus b ls =
  (takeWhile b ls, dropWhile (not . b) $ dropWhile b ls)

getTakes ::
  [IndexedBoard] -> 
  Maybe ([IndexedTake], [IndexedTake])
getTakes ls
  | length ls == 0 = Nothing
  | otherwise      = Just $ spanMinus snd ls

getValidTakes :: 
  Int -> 
  [IndexedTake] -> 
  Maybe ([IndexedTake], [IndexedTake])
getValidTakes i ls
  | length ls == 0 = Nothing
  | otherwise      = Just (take i ls, drop 1 ls)

appendUpdateWith :: 
  [IndexedTake] ->
  Board ->
  Board
appendUpdateWith updateIndices ls =
    snd . unzip $
      map (updateOrLeaveAt updateIndices) (zip (iterate ((+) 1) 0) ls)
  where updateOrLeaveAt indices (i, e) =
          case find ((==i) . fst) indices of
            Nothing      -> (i, e)
            Just (_, e') -> (i, not e')

nextChildBoard :: 
  Board ->
  [[IndexedTake]] ->
  Maybe (Board, [[IndexedTake]])
nextChildBoard b toTake
  | length toTake == 0 = Nothing
  | otherwise          = Just (appendUpdateWith (toTake !! 0) b, drop 1 toTake)
      
threeNode :: Node
threeNode = Node { parent=Nil, board=replicate 3 True, turn=Me }

fourNode :: Node
fourNode = Node { parent=Nil, board=replicate 4 True, turn=Me }

fiveNode :: Node
fiveNode = Node { parent=Nil, board=replicate 5 True, turn=Me }


evaluate :: Node -> Int
evaluate nd =
    let depth = moves nd
    in  case turn nd of
          Me -> (-1) * depth
          Opponent -> 1 * depth
  where moves nd =
          case parent nd of
            Nil -> 0
            p   -> 1 + moves p 


minMax :: Node -> (Node, Int)
minMax n =
  case getChildren n of
    []       -> (n, evaluate n)
    children -> bestChild children (turn n)

bestChild :: [Node] -> Turn -> (Node, Int)
bestChild []     _ = error "No children"
bestChild (x:[]) _ = minMax x
bestChild (x:xs) t = best (minMax x) (bestChild xs t) t

best :: (Node, Int) -> (Node, Int) -> Turn -> (Node, Int)
best (n1, val1) (n2, val2) t
  | val1 >= val2 && t == Me ||
    val1 <= val2 && t == Opponent = (n1, val1)
  | otherwise = (n2, val2)


getBestMove :: [Bool] -> (Int, Int, Int)
getBestMove startBoard =
    let (firstCount, moves) = minMax (Node {parent = Nil, board = startBoard, turn = Me})
    in  (0, getSecondRound firstCount, moves)
  -- The first move comes from the first child
  where getSecondRound nd =
          case parent nd of
            Nil -> 
              length . filter (==False) $ board nd
            p -> 
              case parent p of
                Nil -> length . filter (==False) $ board p
                _   -> getSecondRound p


main :: IO ()
main = do
  args <- getArgs
  case args of
    [coins_count] -> case (validate coins_count) of
                   Left err -> error err
                   Right count -> printResult $ getBestMove (countToBoard count)
    _         -> putStrLn usage
  where printResult (idx, count, moves) =
          putStrLn $ "{ " ++ (show idx) ++ ", " ++ 
                             (show count) ++ ", " ++ 
                             (show moves) ++ " }"
        usage = "Usage: coins <coins_count>"

countToBoard :: Int -> [Bool]
countToBoard = flip replicate True

validate :: String -> Either String Int
validate n
  | isNumber' n && (read n) > (0 :: Int) = Right (read n)
  | otherwise = Left ("There must be a positive number of coins.")

isNumber' :: String -> Bool
isNumber' = and . map isDigit
