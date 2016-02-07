module Paths_bassbull (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch


version :: Version
version = Version {versionBranch = [0,1,0,0], versionTags = []}
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "F:\\books\\notes-summaries\\learning-haskell\\bassbull\\.cabal-sandbox\\bin"
libdir     = "F:\\books\\notes-summaries\\learning-haskell\\bassbull\\.cabal-sandbox\\i386-windows-ghc-7.8.3\\bassbull-0.1.0.0"
datadir    = "F:\\books\\notes-summaries\\learning-haskell\\bassbull\\.cabal-sandbox\\i386-windows-ghc-7.8.3\\bassbull-0.1.0.0"
libexecdir = "F:\\books\\notes-summaries\\learning-haskell\\bassbull\\.cabal-sandbox\\bassbull-0.1.0.0"
sysconfdir = "F:\\books\\notes-summaries\\learning-haskell\\bassbull\\.cabal-sandbox\\etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "bassbull_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "bassbull_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "bassbull_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "bassbull_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "bassbull_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
