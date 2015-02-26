import Data.List
import Data.Char

type ErrorMessage = String

toInt :: String -> Either ErrorMessage Int
toInt [] = Right 0
toInt l@(x:xs) =
    foldr toDigit (Right 0) list
    where toDigit _ (Left err) = Left err
          toDigit x (Right acc)
            | x == '-'  = Right $ (-1) * acc
            | isDigit x = Right $ acc * 10 + digitToInt x
            | otherwise = Left $ "Symbol '" ++ [x] ++ "' not number."
          list = if x == '-' then x : (reverse xs) else reverse l
