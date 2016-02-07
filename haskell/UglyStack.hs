{-# LANGUAGE GeneralizedNewtypeDeriving #-}

import System.Directory
import System.FilePath
import Control.Monad.Reader
import Control.Monad.Writer
import Control.Monad.State

data AppConfig = AppConfig {
        maxDepth :: Int
    } deriving (Show)

data AppState = AppState {
        deepest :: Int
    } deriving (Show)

data AppInfo = AppInfo {
        filePath :: FilePath
      , count :: Int
    } deriving (Show)

type App = WriterT [AppInfo] (ReaderT AppConfig (StateT AppState IO))

runMyApp :: App a -> Int -> IO ((a, [AppInfo]), AppState)
runMyApp k maxDepth = 
    let config = AppConfig maxDepth
        state = AppState 0
    in  runStateT (runReaderT (runWriterT k) config) state

constrainedCount :: Int -> FilePath -> App ()
constrainedCount currDepth path = do
    contents <- liftIO . listDirectory $ path
    cfg <- ask
    tell [AppInfo path (length contents)]
    forM_ contents $ \name -> do
            let newPath = path </> name
            isDir <- liftIO $ doesDirectoryExist newPath
            when (isDir && currDepth < maxDepth cfg) $ do
                let newDepth = currDepth + 1
                st <- get
                when (deepest st < newDepth) $
                    put st { deepest = newDepth }
                constrainedCount newDepth newPath

listDirectory :: FilePath -> IO [String]
listDirectory = liftM (filter notDots) . getDirectoryContents
    where notDots p = p /= "." && p /= ".."
