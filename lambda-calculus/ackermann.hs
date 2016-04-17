module Main where

ackermann :: Integer -> Integer -> Integer
ackermann 0 y = y + 1
ackermann x 0 = ackermann (x-1) 1
ackermann x y = ackermann (x-1) (ackermann x (y-1))

main :: IO ()
main = do
  putStrLn . show $ ackermann 0 0
  putStrLn . show $ ackermann 1 0
  putStrLn . show $ ackermann 0 1
  putStrLn . show $ ackermann 1 1
  putStrLn . show $ ackermann 2 0
  putStrLn . show $ ackermann 0 2
  putStrLn . show $ ackermann 1 2
  putStrLn . show $ ackermann 2 1
  putStrLn . show $ ackermann 2 2
  putStrLn . show $ ackermann 3 3
