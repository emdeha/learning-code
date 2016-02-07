import Network.XmlRpc.Client

server = "http://localhost/mnt/sdc1/PROJECTS/learning-code/learning-par/RPC/simple/rpcServer"

add :: String -> Int -> Int -> IO Int
add url = remote url "learning-par.add"

main = do
    let x = 4
        y = 7
    z <- add server x y
    putStrLn (show x ++ " + " ++ show y ++ " = " ++ show z)
