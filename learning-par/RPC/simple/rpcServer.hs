import Network.XmlRpc.Server

add :: Int -> Int -> IO Int
add x y = return (x+y)

main = cgiXmlRpcServer [("learning-par.add", fun add)]
