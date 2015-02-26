import Control.Concurrent
import Control.Monad
import Control.Exception
import System.IO

parIO :: IO a -> IO a -> IO a
parIO a1 a2 = do
    m <- newEmptyMVar
    c1 <- forkIO (child m a1)
    c2 <- forkIO (child m a2)
    r <- takeMVar m
    throwTo c1 ThreadKilled
    throwTo c2 ThreadKilled
    return r
  where child m a = do
            r <- a
            putMVar m r

timeout :: Int -> IO a -> IO (Maybe a)
timeout n a = parIO (do { r <- a; return (Just r) })
                    (do { threadDelay n; return Nothing })

main :: IO ()
main = do
    res <- timeout 5000 (putStrLn $ show (sum [1..]))
    case res of
        Just _ -> putStrLn "Result"
        Nothing -> putStrLn "No result"
