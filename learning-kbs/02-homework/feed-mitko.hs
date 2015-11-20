{-
  Mitko is a hungry monster. He has to find his food in a labyrinth.

  We have four types of tiles:
  1. Empty tile -> it costs 1 for Mitko to go through it
  2. Wall -> Mitko can't go through it because he's hungry
  3. Water -> Mitko loves water! It costs him 2 to go through water
  4. X -> Mitko's food
-}
module Main where


import System.Environment (getArgs)

import qualified Data.Vector as V
import qualified Data.ByteString.Lazy as BS
import qualified Data.Map as M
import qualified Data.PQueue.Prio.Min as PS
import Data.Maybe (catMaybes)
import Data.List
import Data.Csv


{-
  Labyrinth data type. It's represented by an adjacency matrix.

  It provides convienience functions for:
  1. Calculating price between two adjacent nodes
  2. Getting a node at a position
  3. Getting neighbors of a node
  4. Construction from a CSV file based on some simple rules
-}
data Tile = Empty | Wall | Water
          deriving (Eq)

instance Show Tile where
  show Empty = " "
  show Wall = "N"
  show Water = "~"

data Labyrinth = Labyrinth (V.Vector (V.Vector Tile))

instance Show Labyrinth where
  show (Labyrinth arr) = 
    concatMap (++"\n")
      (map (intercalate ", " . map show . V.toList) (V.toList arr))

toVectorTiles :: [Char] -> (V.Vector Tile)
toVectorTiles = V.fromList . map toTile
  where toTile c
          | c == ' ' = Empty
          | c == 'N' = Wall
          | c == '~' = Water
          | otherwise = error "Invalid tile" -- Bad error!

loadLabyrinth :: BS.ByteString -> Either String Labyrinth
loadLabyrinth labData = 
  case decode NoHeader labData of
    Left err -> Left err
    Right rawLab ->
      let rows = V.map toVectorTiles rawLab
      in  Right $ Labyrinth rows

getAtPosition :: Labyrinth -> Point -> Maybe (Tile, Point)
getAtPosition (Labyrinth lab) (x,y) =
-- TODO: Simplify
  case lab V.!? y of
    Just row ->
      case row V.!? x of
        Just tile -> Just (tile, (x, y))
        Nothing   -> Nothing
    Nothing -> Nothing
  
getAtPositions :: Labyrinth -> [Point] -> [Maybe (Tile, Point)]
getAtPositions lab = map (getAtPosition lab)

children :: Labyrinth -> Point -> [(Tile, Point)]
children lab (x, y) = 
  catMaybes . getAtPositions lab $ [(x-1,y),(x,y-1),(x+1,y),(x,y+1),
                                    (x-1,y-1),(x-1,y+1),(x+1,y+1),(x+1,y+1)]

distance :: Point -> Point -> Int
distance (x1, y1) (x2, y2) = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1)

calcPrio :: (Tile, Point) -> Int
calcPrio child = 
  case fst child of
    Water -> 2
    Empty -> 1
    Wall -> 999

type Point = (Int, Int)
type Path = [Point]

findPath :: BS.ByteString -> Point -> Point -> Either String Path
findPath labData start end =
  case loadLabyrinth labData of
    Left err -> Left err
    Right lab -> Right $ solve lab start end

solve :: Labyrinth -> Point -> Point -> Path
solve lab start end =
  let came_from = M.singleton start Nothing 
      cost_so_far = M.singleton start 0
  in  aStarSearch lab end came_from cost_so_far (PS.singleton 0 start)


data NextChild = NextChild 
    { position :: Point
    , prio :: Int
    , cost :: Int
    }

getNextChildPrio :: NextChild -> (Int, Point)
getNextChildPrio nc = (prio nc, position nc)

getNextChildCost :: NextChild -> (Point, Int)
getNextChildCost nc = (position nc, cost nc)

aStarSearch :: 
    Labyrinth ->
    Point ->
    M.Map Point (Maybe Point) ->
    M.Map Point Int ->
    PS.MinPQueue Int Point ->
    Path
aStarSearch lab end came_from cost_so_far pq =
  let que = PS.minView pq
  in  case que of
        Nothing      -> []
        Just (x, xs) -> go x xs
  where go :: Point -> PS.MinPQueue Int Point -> Path
        go x xs
          | x == end  = x : constructPath came_from x
          | otherwise = 
              let next = foldr calcNext [] (children lab x)
                  cost_so_far' = foldr (\chld acc -> 
                    M.insert (position chld) (cost chld) acc) cost_so_far next
                  came_from' = foldr (\chld acc ->
                    M.insert (position chld) (Just x) acc) came_from next
                  front = foldr ((uncurry PS.insert) . getNextChildPrio) xs next
              in  aStarSearch lab end came_from' cost_so_far' front
              where calcNext child acc =
                      let new_cost = cost_so_far M.! x + distance x (snd child)
                      in  if (fst child /= Wall) && 
                             (not (M.member (snd child) came_from) || 
                             (new_cost < cost_so_far M.! (snd child)))
                          then NextChild { position = (snd child)
                                         , prio = new_cost + calcPrio child
                                         , cost = new_cost
                                         } : acc
                          else acc

constructPath :: M.Map Point (Maybe Point) -> Point -> Path
constructPath paths current = --error . show $ paths
  case M.lookup current paths of
    Just (Just parent) ->
      parent : constructPath (M.delete current paths) parent
    _ -> []


pathToString :: Either String Path -> String
pathToString (Left err) = err
pathToString (Right path) = show $ reverse path

main :: IO ()
main = do
  args <- getArgs
  case args of
    [labFile, startX, startY, endX, endY] -> do
        labData <- BS.readFile labFile
        let path = findPath labData 
                            (read startX, read startY) 
                            (read endX, read endY)
        putStrLn $ pathToString path

    _ -> putStrLn usage
  where usage = "Usage: feed-mitko " ++
                "<path_to_lab_file> <start_x> <start_y> <end_x> <end_y>"
