import System.IO
import Data.Char (toUpper)

main :: IO ()
main = do
        inHandle <- openFile "input.txt" ReadMode
        outHandle <- openFile "output.txt" WriteMode
        mainLoop inHandle outHandle
        hClose inHandle
        hClose outHandle

mainLoop :: Handle -> Handle -> IO ()
mainLoop inHandle outHandle = do
    inEOF <- hIsEOF inHandle
    if inEOF
        then return ()
        else do inpStr <- hGetLine inHandle
                hPutStrLn outHandle (map toUpper inpStr)
                mainLoop inHandle outHandle
