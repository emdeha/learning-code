{-
  Mitko is a hungry monster. He has to find his food in a labyrinth.

  We have four types of tiles:
  1. Empty tile -> it costs 1 for Mitko to go through it
  2. Wall -> Mitko can't go through it because he's hungry
  3. Water -> Mitko loves water! It costs him 2 to go through water
  4. X -> Mitko's food
-}
module Main where


import qualified Data.Vector as V
import qualified Data.ByteString.Lazy as BS
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
      (map ((intersperse ',') . show . V.toList) (V.toList arr))

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
  



main :: IO ()
main = do
  labData <- BS.readFile "lab1.txt"
  case loadLabyrinth labData of
    Left err -> putStrLn ("Error: " ++ err)
    Right lab -> putStrLn $ show lab
