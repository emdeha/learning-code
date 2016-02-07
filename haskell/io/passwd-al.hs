import Data.List
import System.IO
import Control.Monad(when)
import System.Exit
import System.Environment(getArgs)

main = do
    args <- getArgs

    when (length args /= 2) $ do
        putStrLn "Syntax: Incorrect number of args - filename uid"
        exitFailure

    passwds <- readFile (args !! 0) 

    let id = read (args !! 1) :: Integer
        username = findByUID passwds id

    case username of
        Just name -> putStrLn name
        Nothing -> putStrLn "Can't find that UID"

findByUID :: String -> Integer -> Maybe String
findByUID passwds uid =
    let all = map parseline . lines $ passwds
    in lookup uid all

parseline :: String -> (Integer, String)
parseline input =
    let fields = split ':' input
    in  (read (fields !! 2), fields !! 0)

split :: Eq a => a -> [a] -> [[a]]
split _ [] = [[]]
split delim str =
    let (before, after) = span (/= delim) str
    in  before : case after of
                    [] -> []
                    x  -> split delim (tail x)
