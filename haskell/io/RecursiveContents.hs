module RecursiveContents
    (
      getRecursiveContents
    , Info(..)
    ) where

import Control.Monad (forM, liftM, mapM)
import Data.Time.Clock (UTCTime(..))
import System.Directory (Permissions(..), doesDirectoryExist, getDirectoryContents,
                         getPermissions, getModificationTime)
import Control.Exception (bracket, handle, IOException(..))
import System.IO (IOMode(..), hClose, hFileSize, openFile)
import System.FilePath ((</>))
import Data.List(sort)


data Info = Info {
      infoPath :: FilePath
    , infoPerms :: Maybe Permissions
    , infoSize :: Maybe Integer
    , infoModTime :: Maybe UTCTime
    } deriving (Eq, Ord, Show)

data Iterate seed = Done     { unwrap :: seed }
                  | Skip     { unwrap :: seed }
                  | Continue { unwrap :: seed }
                    deriving (Show)

type Iterator seed = seed -> Info -> Iterate seed

foldTree :: (a -> a) -> Iterator a -> a -> FilePath -> IO a
foldTree order iter initSeed path = do
    endSeed <- fold initSeed path
    return $ order $ unwrap endSeed
  where 
    fold seed subPath = getUsefulContents subPath >>= walk seed
    walk seed (name:names) = do
        let path' = path </> name
        info <- getInfo path'
        case iter seed info of
            done@(Done _) -> return done
            Skip seed'    -> walk seed' names
            Continue seed'
                | isDirectory info -> do
                    next <- fold seed' path'
                    case next of
                        done@(Done _) -> return done
                        seed''        -> walk (unwrap seed'') names
                | otherwise -> walk seed' names
    walk seed _ = return (Continue seed)

traverse :: ([Info] -> [Info]) -> FilePath -> IO [Info]
traverse order path = do
    names <- getUsefulContents path
    contents <- mapM getInfo (path : map (path </>) names)
    liftM concat $ forM (order contents) $ \info -> do
        if isDirectory info && infoPath info /= path
            then traverse order (infoPath info)
            else return [info]

getUsefulContents :: FilePath -> IO [String]
getUsefulContents path = do
    names <- getDirectoryContents path
    return (filter (`notElem` [".", ".."]) names)

isDirectory :: Info -> Bool
isDirectory = maybe False searchable . infoPerms

maybeIO :: IO a -> IO (Maybe a)
maybeIO action = handle ((\_ -> return Nothing) :: IOException -> IO (Maybe a0))
                        (Just `liftM` action)

getInfo path = do
    perms <- maybeIO (getPermissions path)
    size <- maybeIO (bracket (openFile path ReadMode) hClose hFileSize)
    modified <- maybeIO (getModificationTime path)
    return (Info path perms size modified)

filterTraverse :: ([Info] -> [Info]) -> (Info -> Bool) -> FilePath -> IO [Info]
filterTraverse order pred path = do
    traversed <- traverse order path
    return $ filter pred traversed

getRecursiveContents :: FilePath -> IO [FilePath]
getRecursiveContents topDir = do
    names <- getDirectoryContents topDir
    let properNames = filter (`notElem` [".", ".."]) names
    paths <- forM properNames $ \name -> do
        let path = topDir </> name
        isDirectory <- doesDirectoryExist path
        if isDirectory
            then getRecursiveContents path
            else return [path]
    return (concat paths)


testTraverse f = traverse f "d:/books/notes-summaries/learning-haskell/io"
testFT f pr = filterTraverse f pr "d:/books/notes-summaries/learning-haskell/io"

infoPathT f = do
    traversed <- testTraverse f
    forM traversed $ \info ->
        putStrLn $ infoPath info

infoPathFT f pr = do
    traversed <- testFT f pr
    forM traversed $ \info ->
        putStrLn $ infoPath info

testIter count info =
    Continue (if isDirectory info
                then count + 1
                else count)

iterGet paths info =
    Continue $ infoPath info : paths

testFoldTree iter seed = do
    iterated <- foldTree (reverse . id) iter seed testPath
    forM iterated $ \item ->
        putStrLn item

testPath = "D:/BOOKS/notes-summaries/learning-haskell/io" 
