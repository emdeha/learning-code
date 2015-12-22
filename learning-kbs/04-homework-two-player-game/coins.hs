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
          , board :: Int
          , turn :: Turn
          }
          | Nil
    deriving Show

generateChild :: Node -> Int -> Node
generateChild p n = Node { parent = p, board = n, turn = neg . turn $ p }
  where
    neg Me = Opponent
    neg Opponent = Me

evaluate :: Node -> Int
evaluate nd = undefined

getChildren :: Node -> [Node]
getChildren nd =
  let coins_count = board nd
  in  map (generateChild nd) (takeWhile (>=0) $ iterate (flip (-) 1) (coins_count - 1))


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


getBestMove :: Int -> (Int, Int, Int)
getBestMove startIdx =
  let (firstCount, moves) = minMax Node {parent = Nil, board = startIdx, turn = Me}
  in  (0, board firstCount, moves)


main :: IO ()
main = do
  args <- getArgs
  case args of
    [coins_count] -> case (validate coins_count) of
                   Left err -> error err
                   Right count -> printResult $ getBestMove count
    _         -> putStrLn usage
  where printResult (idx, count, moves) =
          putStrLn $ "{ " ++ (show idx) ++ ", " ++ 
                             (show count) ++ ", " ++ 
                             (show moves) ++ " }"
        usage = "Usage: coins <coins_count>"

validate :: String -> Either String Int
validate n
  | isNumber' n && (read n) > 0 = Right (read n)
  | otherwise = Left ("There must be a positive number of coins.")

isNumber' :: String -> Bool
isNumber' = and . map isDigit
