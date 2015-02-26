import Control.Concurrent
import Control.Monad
import System.IO
import System.Random


writeOut :: IO ()
writeOut = do
    freq <- randomRIO (1::Int, 3)
    putStr $ show freq

main :: IO ()
main = do
    count <- newEmptyMVar
    putMVar count 0
    hSetBuffering stdout NoBuffering
    forM_ [1..10] $ \_ -> do
        forkIO ((threadDelay $ 500 * 1000) >> writeOut)
        inc count
    v <- takeMVar count
    putStrLn $ "\n --- " ++ show v ++ " --- "
    threadDelay $ 5 * 1000 * 1000

inc count = do
    v <- takeMVar count
    putMVar count (v+1)
