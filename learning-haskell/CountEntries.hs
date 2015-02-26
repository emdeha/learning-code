module CountEntries (listDirectory, countEntriesTrad, countEntriesMonad) where

import System.Directory (doesDirectoryExist, getDirectoryContents)
import System.FilePath ((</>))
import Control.Monad (forM, forM_, liftM, when)
import Control.Monad.Trans (liftIO)
import Control.Monad.Writer (WriterT, tell, execWriterT)

listDirectory :: FilePath -> IO [String]
listDirectory = liftM (filter notDots) . getDirectoryContents
  where notDots p = p /= "." && p /= ".."

countEntriesTrad :: FilePath -> IO [(FilePath, Int)]
countEntriesTrad path = do
    entries <- listDirectory path
    rest <- forM entries $ \entry -> do
                let pathName = path </> entry
                isDir <- doesDirectoryExist pathName
                if isDir
                then countEntriesTrad pathName
                else return []
    return $ (path, length entries) : concat rest

countEntriesMonad :: FilePath -> WriterT [(FilePath, Int)] IO ()
countEntriesMonad path = do
    entries <- liftIO $ listDirectory path
    tell [(path, length entries)]
    forM_ entries $ \entry -> do
        let pathName = path </> entry
        isDir <- liftIO $ doesDirectoryExist pathName
        when isDir $ countEntriesMonad pathName
