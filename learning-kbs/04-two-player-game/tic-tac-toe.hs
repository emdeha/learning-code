{-
  Playing a game of Tic Tac Toe.
-}
module Main where


import System.Environment (getArgs)

import Data.List


data Turn = Me | Opponent
    deriving (Show, Eq)

data Node = Node
          { parent :: Node
          , board :: String
          , turn :: Turn
          }
          | Nil
    deriving Show

safeIndex :: [a] -> Int -> Maybe a
safeIndex ls i
  | 0 <= i && i < length ls = Just $ ls !! i
  | otherwise               = Nothing

evaluate :: Node -> Int
evaluate nd
  | subEval 'X' (board nd) = 1
  | subEval 'O' (board nd) = (-1)
  | subEval 'X' (concat . transpose . chunk 3 . board $ nd) = 1
  | subEval 'O' (concat . transpose . chunk 3 . board $ nd) = (-1)
  | otherwise = 0
  where subEval :: Char -> String -> Bool
        subEval ch str
          | (replicate 3 ch) `isPrefixOf` str          = True
          | (replicate 3 ch) `isSuffixOf` str          = True
          | (replicate 3 ch) `isPrefixOf` (drop 3 str) = True
          | str !! 0 == ch && str !! 4 == ch && str !! 8 == ch = True
          | str !! 2 == ch && str !! 4 == ch && str !! 6 == ch = True
          | otherwise = False

getChildren :: Node -> [Node]
getChildren nd
  | evaluate nd == 0 = fillNextEmpty 0 nd
  | otherwise        = []

fillNextEmpty :: Int -> Node -> [Node]
fillNextEmpty i nd =
  let str = board nd
  in  case str `safeIndex` i of
        Just a -> 
          if a == ' '
          then 
            let next = Node { parent = nd
              , board = take i str ++ [playerToken nd] ++ drop (i+1) str
              , turn = neg . turn $ nd
              }
            in  next : fillNextEmpty (i+1) nd
          else fillNextEmpty (i+1) nd
        Nothing -> []
  where playerToken Nil                 = ' '
        playerToken (Node _ _ Me)       = 'O'
        playerToken (Node _ _ Opponent) = 'X'

        neg Me = Opponent
        neg Opponent = Me


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


playTheGame :: Node -> [Node]
playTheGame initial =
  let nextTurn = case turn initial of
                   Me -> getTurnMe initial
                   Opponent -> getTurnOpponent initial
  in  case nextTurn of
        Nil -> getPath initial
        n -> playTheGame n

getPath :: Node -> [Node]
getPath = unfoldr (\nd -> case parent nd of
                            Nil -> Nothing
                            pnd -> Just (nd, pnd))

getTurnMe :: Node -> Node
getTurnMe = fst . minMax

getTurnOpponent :: Node -> Node
getTurnOpponent = getTurnMe

stringToNode :: String -> Node
stringToNode str
  | 'X' `elem` str = node { turn = Me }
  | 'O' `elem` str = node { turn = Opponent }
  | otherwise      = error "Board without nodes..."
  where node = Node { parent = Nil, board = str, turn = Me }


main :: IO ()
main = do
  args <- getArgs
  case args of
    [initial] -> case (validate initial) of
                   Left err -> error err
                   Right first ->
                     let node = stringToNode first
                     in  putStrLn . movesToString $ node : reverse (playTheGame node)
    _         -> putStrLn usage
  where usage = "Usage: tic-tac-toe <initial_round>"

movesToString :: [Node] -> String
movesToString =
    concatMap ((++"\n") . 
      (concatMap (++"\n") . chunk 3 . map (replace ' ' '_')) . board)
  where replace r with ch = if ch == r then with else ch

chunk :: Int -> [a] -> [[a]]
chunk _ []  = []
chunk n str =
    case splitAt n str of
        (ch, rest) -> ch : chunk n rest

validate :: String -> Either String String
validate str
  | (length (filter (=='X') str) == 1 ||
     length (filter (=='O') str) == 1) &&
     length (filter (==' ') str) == 8 = Right str
  | otherwise = Left ("Board must be with one 'X' or one 'O' for initial" ++
                      " player and spaces for empty squares")
