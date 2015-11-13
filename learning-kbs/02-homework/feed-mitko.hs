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
import qualified Data.HashSet as HS
import qualified Data.PQueue.Prio.Max as PS
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


type Point = (Int, Int)
type Path = [Point]

findPath :: BS.ByteString -> Point -> Point -> Either String Path
findPath labData start end =
  case loadLabyrinth labData of
    Left err -> Left err
    Right lab -> Right $ solve lab start end

solve :: Labyrinth -> Point -> Point -> Path
solve lab start end = 
  aStarSearch lab end [] HS.empty (uncurry PS.singleton . calcPrio $ start end)

aStarSearch :: 
    Labyrinth -> 
    Point -> 
    [Int] ->
    HS.HashSet Point -> 
    PS.MaxPQueue Int Point ->
    Path
aStarSearch lab end gScores visited pq =
  let que = PS.maxView pq
  in  case que of
      Nothing -> []
      Just (x, xs) -> go x xs
  where go :: Point -> PS.MaxPQueue Int Point -> Path
        go x xs
          | x == end            = reverse $ constructPathFromEnd x
          | HS.member x visited = aStarSearch lab end gScores visited xs
          | otherwise =
              let visited' = HS.insert x visited
                  front f = 
                    foldl (flip . uncurry $ PS.insert) xs 
                          (map (toScore ((+) find (==x) gScores) . calcPrio) (getNeighbors lab x))
              -- TODO: Update gScores
              in  aStarSearch lab end gScores visited' front


pathToString :: Either String Path -> String
pathToString (Left err) = err
pathToString (Right path) = intersperse ',' . show $ path

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
