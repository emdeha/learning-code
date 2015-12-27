{-
  Playing a game of Coins.
-}
module Main where


import System.Environment (getArgs)

import Data.Char
import Data.List


data Turn = Me | Opponent
    deriving (Show, Eq)

data Node = Node
          { parent :: Node
            -- TODO: Add starting index to board
          , board :: [Bool]
          , turn :: Turn
          }
          | Nil
    deriving Show

makeChild :: Node -> [Bool] -> Node
makeChild parent board =
    Node { parent = parent, board = board, turn = neg . turn $ parent }
  where 
    neg Me = Opponent
    neg Opponent = Me

getChildren :: Node -> [Node]
getChildren p =
    let boards = takeCoins $ board p
    in  map (makeChild p) boards
  where
    takeCoins board =
      let boardLen = length board
          cycleLen = boardLen + 3 - 1

          cycledBd = take cycleLen . cycle $ board
          cycledIndices = 
            take cycleLen . cycle $ take boardLen . cycle $ iterate ((+) 1) 0
          cycleListIndexed = zip cycledIndices cycledBd

          possibleTakes = unfoldr getTakes cycleListIndexed
          -- It's a shitty life we live...
          validTakes = concatMap (\take -> 
            nub $ concatMap (\i -> unfoldr (getValidTakes i) take) [1,2,3]) possibleTakes
      in  unfoldr (nextChildBoard board) validTakes

    spanMinus p ls = (takeWhile p ls, dropWhile (not . p) $ dropWhile p ls)

    getTakes ls
      | length ls == 0 = Nothing
      | otherwise      = Just $ spanMinus snd ls

    getValidTakes i ls
      | length ls == 0 = Nothing
      | otherwise      = Just (take i ls, drop 1 ls)

    nextChildBoard board toTake
      | length toTake == 0 = Nothing
      | otherwise          = Just (appendUpdateWith (toTake !! 0) board, drop 1 toTake)

    appendUpdateWith :: [(Int, Bool)] -> [Bool] -> [Bool]
    appendUpdateWith updateIndices ls =
        snd . unzip $
          map (updateOrLeaveAt updateIndices) (zip (iterate ((+) 1) 0) ls)
      where updateOrLeaveAt indices (i, e) =
              case find ((==i) . fst) indices of
                Nothing      -> (i, e)
                Just (_, e') -> (i, not e')
      
evaluate :: Node -> Int
evaluate nd =
  case turn nd of
    Me -> (-1)
    Opponent -> 1


-- TODO: Should we use lastEval?
-- TODO: Add alpha-beta slicing
minMax :: Node -> Int -> (Node, Int)
minMax n lastEval =
  case getChildren n of
    []       -> 
      let eval = evaluate n
      in  if eval < 0
          then (n, (-1) * lastEval)
          else (n, lastEval)
    children -> bestChild children (turn n) (lastEval+1)

bestChild :: [Node] -> Turn -> Int -> (Node, Int)
bestChild []     _ _        = error "No children"
bestChild (x:[]) _ lastEval = minMax x lastEval
bestChild (x:xs) t lastEval = best (minMax x lastEval) (bestChild xs t lastEval) t

best :: (Node, Int) -> (Node, Int) -> Turn -> (Node, Int)
best (n1, val1) (n2, val2) t
  | val1 >= val2 && t == Me ||
    val1 <= val2 && t == Opponent = (n1, val1)
  | otherwise = (n2, val2)


getBestMove :: [Bool] -> (Int, Int, Int)
getBestMove startBoard =
    let (firstCount, moves) = minMax (Node {parent = Nil, board = startBoard, turn = Me}) 0
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
  | isNumber' n && (read n) > 0 = Right (read n)
  | otherwise = Left ("There must be a positive number of coins.")

isNumber' :: String -> Bool
isNumber' = and . map isDigit
