import System.IO
import System.Directory (getTemporaryDirectory, removeFile)
import System.IO.Error (catchIOError)
import Control.Exception (finally)

main :: IO ()
main = withTempFile "mytemp.txt" myAction

myAction :: FilePath -> Handle -> IO ()
myAction tempname tempH =
    do 
        putStrLn "Welcome to tempfile.hs"
        putStrLn $ "I have a temp file at " ++ tempname

        pos <- hTell tempH
        putStrLn $ "Initial position " ++ show pos

        let tempdata = show [1..10]
        putStrLn $ "Writing one line containing " ++ show (length tempdata) ++ 
                   " bytes: " ++ tempdata
        hPutStrLn tempH tempdata

        pos <- hTell tempH
        putStrLn $ "After writing, pos: " ++ show pos

        putStrLn $ "The file content is: "
        hSeek tempH AbsoluteSeek 0
        c <- hGetContents tempH
        putStrLn c

        putStrLn $ "Which could be expressed as this Haskell literal: "
        print c

withTempFile :: String -> (FilePath -> Handle -> IO a) -> IO a
withTempFile pattern fun =
    do
        tempDir <- catchIOError (getTemporaryDirectory) (\_ -> return ".")
        (tempfile, tempH) <- openTempFile tempDir pattern

        finally (fun tempfile tempH)
                (do hClose tempH
                    removeFile tempfile)
