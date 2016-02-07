module Glob (namesMatching) where

import System.Directory (doesDirectoryExist, doesFileExist,
                         getCurrentDirectory, getDirectoryContents)
import System.FilePath (dropTrailingPathSeparator, splitFileName, (</>), 
                        pathSeparators, splitDirectories, takeFileName)

import Control.Exception (handle)
import Control.Monad (forM, foldM, join)

import Data.List (isInfixOf, elemIndex, intercalate)

import GlobRegex (matchesGlob)

isPattern :: String -> Bool
isPattern = any (`elem` "[*?")

namesMatching :: String -> IO [String]
namesMatching pat
    | not (isPattern pat) = do
        exists <- doesNameExist pat
        return (if exists then [pat] else [])
    | otherwise = do
        case splitFileName pat of
            ("", baseName) -> do
                currDir <- getCurrentDirectory
                listMatches currDir baseName
            (dirName, baseName) -> do
                dirs <- if isPattern dirName
                        then namesMatching (dropTrailingPathSeparator dirName)
                        else return [dirName]
                let listDir = if isPattern baseName
                              then listMatches
                              else listPlain
                pathNames <- forM dirs $ \dir -> do
                                baseNames <- listDir dir baseName
                                return (map (dir </>) baseNames)
                return (concat pathNames)

doesNameExist :: FilePath -> IO Bool
doesNameExist name = do
    fileExists <- doesFileExist name
    if fileExists
        then return True
        else doesDirectoryExist name

listMatches :: FilePath -> String -> IO [String]
listMatches dirName pat = do
    dirName' <- if null dirName
                then getCurrentDirectory
                else return dirName
    handle ((const (return [])) :: IOError -> IO [String]) $ do
        names <- getNames dirName' pat
        let names' = if isHidden pat
                     then filter isHidden names
                     else filter (not . isHidden) names
            opts   = if '\\' `elem` pathSeparators
                     then "i"
                     else ""
        return (filter (\name -> matchesGlob name pat opts) names')

getNames :: FilePath -> String -> IO [String]
getNames dirName pat
    | isDirForGlobStar = getRecursiveDirContents dirName
    | otherwise        = getDirectoryContents dirName
    where isDirForGlobStar = 
              if "**" `isInfixOf` pat 
              then True
              else False

getRecursiveDirContents :: FilePath -> IO [String]
getRecursiveDirContents dirName = do
    putStrLn "Recursivenation"
    contents <- getDirectoryContents dirName
    accContents dirName contents [[]]

accContents :: String -> [String] -> [String] -> IO [String]
accContents root [] acc = return acc
accContents root (x:xs) acc
    | "." `isInfixOf` x = do
            accContents root xs (x : acc)
    | otherwise         = do 
            dirs <- getDirectoryContents (root ++ x)
            accContents (root ++ x ++ "/") (dirs ++ xs) acc

isHidden ('.':_) = True
isHidden _       = False

listPlain :: FilePath -> String -> IO [String]
listPlain dirName baseName = do
    exists <- if null baseName
              then doesDirectoryExist dirName
              else doesNameExist (dirName </> baseName)
    return (if exists then [baseName] else [])
