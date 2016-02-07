module Paths_parconc_examples (
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
version = Version [0,3,4] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/emdeha/.cabal/bin"
libdir     = "/home/emdeha/.cabal/lib/x86_64-linux-ghc-7.8.4/parconc-examples-0.3.4"
datadir    = "/home/emdeha/.cabal/share/x86_64-linux-ghc-7.8.4/parconc-examples-0.3.4"
libexecdir = "/home/emdeha/.cabal/libexec"
sysconfdir = "/home/emdeha/.cabal/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "parconc_examples_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "parconc_examples_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "parconc_examples_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "parconc_examples_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "parconc_examples_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
