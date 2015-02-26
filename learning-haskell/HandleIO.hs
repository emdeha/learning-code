{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module HandleIO
    (
      HandleIO
    , Handle
    , IOMode(..)
    , runHandleIO
    , openFile
    , hClose
    , hPutStrLn
    ) where

import System.IO (Handle, IOMode(..))
import Control.Monad.Trans (MonadIO(..))
import qualified System.IO


newtype HandleIO a = HandleIO { runHandleIO :: IO a }
    deriving (Monad)

instance MonadIO HandleIO where
    liftIO = HandleIO


openFile :: FilePath -> IOMode -> HandleIO Handle
openFile path mode = HandleIO (System.IO.openFile path mode)

hClose :: Handle -> HandleIO ()
hClose = HandleIO . System.IO.hClose

hPutStrLn :: Handle -> String -> HandleIO ()
hPutStrLn h s = HandleIO (System.IO.hPutStrLn h s)

safeHello :: FilePath -> HandleIO ()
safeHello path = do
    h <- openFile path WriteMode
    hPutStrLn h "hello world"
    hClose h
