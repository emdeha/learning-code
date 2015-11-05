{-
  This program queries a database containing cities and the
  respective paths between them. It then tries to compute the
  cheapes way to travel from one city to another.
-}
module Main where


import Data.List (intercalate)

import Database.HDBC
import Database.HDBC.PostgreSQL

import System.Environment (getArgs)


data City = City 
          { name :: String
          , lon :: Double
          , lat :: Double
          }
    deriving Show


type CityName = String
newtype Path = Path [CityName]

instance Show Path where
  show (Path path) = intercalate (", ") path


-- Delicious SQL Injection awaits ^_^
replaceView :: String -> String
replaceView city =
    "CREATE OR REPLACE VIEW origin AS\n" ++
    "    (SELECT city_no, name, lon, lat, to_city\n" ++
    "        FROM cities\n" ++
    "        JOIN paths ON (city_no = from_city)\n" ++
    "        WHERE name = '" ++ city ++ "')"

pathQuery :: String
pathQuery =
    "SELECT origin.name, origin.lon, origin.lat,\n" ++
    "       dest.name, dest.lon, dest.lat\n" ++
    "    FROM origin,\n" ++
    "         (SELECT c.city_no, c.name, c.lon, c.lat\n" ++
    "            FROM origin o\n" ++
    "            JOIN cities c ON (o.to_city = c.city_no))\n" ++
    "         AS dest\n" ++
    "    WHERE dest.city_no = origin.to_city"


getPaths :: String -> IO [(City, City)]
getPaths fromCity =
  withPostgreSQL "dbname=paths" $ \conn -> do
    _ <- run conn (replaceView fromCity) []
    cities <- quickQuery' conn pathQuery []
    return $ map toCityPair cities
  where toCityPair :: [SqlValue] -> (City, City)
        toCityPair vals =
          let cityFrom = City { name = fromSql $ vals !! 0
                              , lon = fromSql $ vals !! 1
                              , lat = fromSql $ vals !! 2
                              }
              cityTo = City { name = fromSql $ vals !! 3
                            , lon = fromSql $ vals !! 4
                            , lat = fromSql $ vals !! 5
                            }
          in  (cityFrom, cityTo)

printPath :: Path -> IO ()
printPath = putStrLn . show

findShortest :: CityName -> CityName -> IO Path
findShortest from to = 
  return $ Path [from, "Pleven",  "Varna", to]


main :: IO ()
main = do
  args <- getArgs
  case args of
    [start, end] -> findShortest start end >>= printPath
    _            -> putStrLn usage
  where usage = "Usage: searching-paths <start_city> <end_city>"
