data Color = Red | Green | Blue

instance Show Color where
    show Red = "Red"
    show Green = "Green"
    show Blue = "Blue"

instance Read Color where
    readsPrec _ value =
        tryParse [("Red", Red), ("Green", Green), ("Blue", Blue)]
        where tryParse [] = []
              tryParse ((attempt,result):xs) =
                if (take (length attempt) (trim value "")) == attempt
                    then [(result, drop (length attempt) (trim value ""))]
                    else tryParse xs
              trim [] acc = acc
              trim (x:xs) acc
                | x == ' '  = trim xs acc
                | otherwise = trim xs (acc ++ [x])
