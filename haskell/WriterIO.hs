{-# LANGUAGE GeneralizedNewtypeDeriving, MultiParamTypeClasses, FlexibleInstances #-}

import MonadHandle
import qualified System.IO

import Control.Monad.Writer
import System.IO (IOMode(..))


data Event = Open FilePath IOMode
           | Put String
           | Close String
           | GetContents String
           deriving (Show)

newtype WriterIO a = W { runW :: Writer [Event] a }
    deriving (Monad, MonadWriter [Event])

instance MonadHandle FilePath WriterIO where
    openFile path mode = tell [Open path mode] >> return path
    hPutStr _ str = tell [Put str]
    hClose h = tell [Close h]
    hGetContents h = tell [GetContents h] >> return "fake"

runWriterIO :: WriterIO a -> (a, [Event])
runWriterIO = runWriter . runW

safeHello :: MonadHandle h m => FilePath -> m () 
safeHello path = do
    h <- openFile path WriteMode
    hPutStrLn h "hello"
    hClose h
