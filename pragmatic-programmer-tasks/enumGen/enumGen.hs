import System.Environment
import System.Directory
import System.IO
import Data.List

main = do
    (fileName:headerFile:sourceFile:_) <- getArgs
    parseFile fileName headerFile sourceFile

parseFile :: FilePath -> FilePath -> FilePath -> IO ()
parseFile fileName headerFileName sourceFileName = do
    contents <- readFile fileName 
    writeHeaderFile headerFileName contents
    writeSourceFile sourceFileName contents

writeHeaderFile :: FilePath -> String -> IO ()
writeHeaderFile fileName contents = do
    handle <- openFile fileName WriteMode
    hPutStrLn handle "extern const char* NAME_names[];"
    hPutStrLn handle "typedef enum {"
    let states = lines contents
        formattedStates = map (\line -> "\t" ++ line ++ ",") $ delete (states !! 0) states
    hPutStr handle $ unlines formattedStates
    hPutStrLn handle "} NAME;"
    hClose handle

writeSourceFile :: FilePath -> String -> IO ()
writeSourceFile fileName contents = do
    handle <- openFile fileName WriteMode
    hPutStrLn handle "const char* NAME_names[] = {"
    let states = lines contents
        formattedStates = map (\line -> "\t\"" ++ line ++ "\",") $ delete (states !! 0) states
    hPutStr handle $ unlines formattedStates
    hPutStrLn handle "};"
    hClose handle
