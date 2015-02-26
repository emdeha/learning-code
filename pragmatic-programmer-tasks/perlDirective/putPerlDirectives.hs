import System.Environment
import System.Directory
import System.IO
import Data.List

main = do
    -- dir <- getArgs
    -- files <- getDirectoryContents $ head dir
    files <- getArgs
    addDirectives files

addDirectives :: [FilePath] -> IO ()
addDirectives [] = return ()
addDirectives files = do
    handle <- openFile (head files) ReadMode
    contents <- hGetContents handle
    let currentFile = head files
    addDirective currentFile (lines contents) False 
    hClose handle
    removeFile currentFile
    renameFile (currentFile ++ "123") currentFile
    addDirectives $ tail files

addDirective :: FilePath -> [String] -> Bool -> IO ()
addDirective _ [] _ = return ()
addDirective fileName contents isPut = do
    let currentLine = head contents
        newContents = delete (contents !! 0) contents
    handle <- openFile (fileName ++ "123") AppendMode
    if isPut == True
        then do
            hPutStrLn handle currentLine
            hClose handle
            addDirective fileName newContents isPut
        else do
            if "use strict;" `isInfixOf` currentLine
                then do
                    hPutStrLn handle currentLine 
                    hClose handle
                    addDirective fileName newContents True
                else 
                    if (elemIndex '#' currentLine) /= Nothing
                        then do
                            hPutStrLn handle currentLine
                            hClose handle
                            addDirective fileName newContents False
                        else do
                            hPutStrLn handle ("use strict;\n\n" ++ currentLine)
                            hClose handle
                            addDirective fileName newContents True
