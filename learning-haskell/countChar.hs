countChar :: Char -> String -> Int
countChar ch str = length $ filter (==ch) str
