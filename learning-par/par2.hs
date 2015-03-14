import Control.Concurrent (forkIO, threadDelay)
import Control.Monad (forM_)


manyHellos :: Int -> IO ()
manyHellos idx = do
    threadDelay $ idx * 1000
    print $ "Hello " ++ show idx

main :: IO ()
main = do
    forM_ [0..10] $ \i ->
        forkIO $ manyHellos i
    print "bye!"
    threadDelay $ 1000 * 1000
