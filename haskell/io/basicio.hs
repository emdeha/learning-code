name2reply :: String -> String
name2reply name = "Hello, " ++ name

main = do
    putStrLn "Greetings! What is your name?"
    inpStr <- getLine
    let outStr = name2reply inpStr
    putStrLn outStr
