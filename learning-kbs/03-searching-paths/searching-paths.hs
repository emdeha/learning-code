{-
  This program queries a database containing cities and the
  respective paths between them. It then tries to compute the
  cheapes way to travel from one city to another.
-}
module Main where


import Database.HDBC
import Database.HDBC.PostgreSQL


data City = City 
          { name :: String
          , lon :: Double
          , lat :: Double
          }
    deriving Show


replaceView :: String
replaceView = "CREATE OR REPLACE VIEW origin AS\n" ++
    "    (SELECT city_no, name, lon, lat, to_city\n" ++
    "        FROM cities\n" ++
    "        JOIN paths ON (city_no = from_city)\n" ++
    "        WHERE name = 'Plovdiv')"

pathQuery :: String
pathQuery = "SELECT origin.name, origin.lon, origin.lat,\n" ++
    "       dest.name, dest.lon, dest.lat\n" ++
    "    FROM origin,\n" ++
    "         (SELECT c.city_no, c.name, c.lon, c.lat\n" ++
    "            FROM origin o\n" ++
    "            JOIN cities c ON (o.to_city = c.city_no))\n" ++
    "         AS dest\n" ++
    "    JOIN paths ON (dest.city_no = from_city)"


getPaths :: String -> IO [(City, City)]
getPaths fromCity =
  withPostgreSQL "dbname=paths" $ \conn -> do
    run conn replaceView [] --[toSql fromCity]
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


main :: IO ()
main =
  getPaths "Sofia" >>= 
    (\paths -> 
      putStrLn $ concatMap (\path -> show path++"\n") paths)
