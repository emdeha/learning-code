module Paths_mypretty (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch


version :: Version
version = Version {versionBranch = [0,1], versionTags = []}
bindir, libdir, datadir, libexecdir :: FilePath

bindir     = "D:/BOOKS/notes-summaries/learning-haskell/mypretty/installed/\\bin"
libdir     = "D:/BOOKS/notes-summaries/learning-haskell/mypretty/installed/mypretty-0.1\\ghc-7.6.3"
datadir    = "D:/BOOKS/notes-summaries/learning-haskell/mypretty/installed/mypretty-0.1"
libexecdir = "D:/BOOKS/notes-summaries/learning-haskell/mypretty/installed/\\mypretty-0.1"

getBinDir, getLibDir, getDataDir, getLibexecDir :: IO FilePath
getBinDir = catchIO (getEnv "mypretty_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "mypretty_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "mypretty_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "mypretty_libexecdir") (\_ -> return libexecdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
