import Control.Monad (filterM)
import System.Directory (Permissions(..), getModificationTime, getPermissions)
import Data.Time.Clock (UTCTime(..))
import System.FilePath (takeExtension)
import Control.Exception (bracket, handle, IOException(..))
import System.IO (IOMode(..), hClose, hFileSize, openFile)

import RecursiveContents (getRecursiveContents, Info(..))

type FileSize = Maybe Integer

getFileSize :: FilePath -> IO FileSize
getFileSize path = handle ((\_ -> return Nothing) :: IOException -> IO FileSize) $
    bracket (openFile path ReadMode) hClose $ \h -> do
        size <- hFileSize h
        return (Just size)

find :: (Info -> Bool) -> FilePath -> IO [FilePath]
find pred path = getRecursiveContents path >>= filterM check
    where check name = do
            perms <- getPermissions name
            size <- getFileSize name
            modified <- getModificationTime name
            return (pred (Info name (Just perms) size (Just modified)))

pathP :: (Info -> FilePath)
pathP info = infoPath info

sizeP :: (Info -> Integer)
sizeP info = case infoSize info of
                Just size -> size
                Nothing -> -1

liftP :: (a -> b -> c) -> (Info -> a) -> b -> (Info -> c)
liftP q f k info = f info `q` k

liftP2 :: (a -> b -> c) -> (Info -> a) -> (Info -> b) -> (Info -> c)
liftP2 q f g info = f info `q` g info

liftPath :: (FilePath -> a) -> (Info -> a)
liftPath f info = f $ infoPath info

equalP, greaterP, lesserP :: (Ord a) => (Info -> a) -> a -> (Info -> Bool)
equalP = liftP (==)
greaterP = liftP (>)
lesserP = liftP (<)

andP, orP :: (Info -> Bool) -> (Info -> Bool) -> (Info -> Bool)
andP = liftP2 (&&)
orP = liftP2 (||)    

(==?) :: (Ord a) => (Info -> a) -> a -> (Info -> Bool)
(==?) = equalP
infix 4 ==?

(&&?) = andP
infixr 3 &&?

(>?) :: (Ord a) => (Info -> a) -> a -> (Info -> Bool)
(>?) = greaterP
infix 4 >?

test = liftPath takeExtension ==? ".cpp" &&? sizeP >? 131072
