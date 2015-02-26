import System.Environment
import System.Directory
import System.IO
import Data.List
import Data.Char

type LangType = String
type Size = Int
type ValName = String

data ValType = Whole | Character deriving (Show, Eq)

data IdValue = Cmd { cmd :: String }
             | Val { valType :: ValType
                   , valName :: ValName
                   , size :: Size
                   } deriving (Show, Eq)

data Command = Command { getId :: Id
                       , getIdValue :: IdValue
                       } deriving (Show, Eq)

data Id = Comment | Field | Message deriving (Show, Eq)


fileWritingCommands :: [(String, [Command] -> [String] -> IO [String])]
fileWritingCommands =   [ ("c++", genCpp)
                        , ("pascal", genPascal)
                        ]                        

main = do
    files <- getArgs
    genCode (files !! 0) (files !! 1) (files !! 2)

genCode :: FilePath -> FilePath -> LangType -> IO ()
genCode sourceFile outFile langType
    | sourceFile == [] = return ()
    | outFile == [] = return ()
    | langType == [] = return ()
    | otherwise = do
        handle <- openFile sourceFile ReadMode
        contents <- hGetContents handle
        let (Just generator) = lookup langType fileWritingCommands
            tokens = getAllTokens (lines contents) []
        formattedContents <- generator tokens [""]
        writeFile outFile $ unlines formattedContents
        hClose handle

getAllTokens :: [String] -> [Command] -> [Command]
getAllTokens [] commands = commands
getAllTokens (currentLine:restLines) accCommands = 
    if head currentLine == '#'
        then getAllTokens restLines (accCommands ++ [takeCommentCommand currentLine])
        else if head currentLine == 'M'
            then getAllTokens restLines (accCommands ++ [takeMessageCommand currentLine])
            else if head currentLine == 'F'
                then getAllTokens restLines (accCommands ++ [takeFieldCommand currentLine])
                else getAllTokens [] accCommands

takeCommentCommand :: String -> Command
takeCommentCommand currentLine = Command (Comment) (Cmd (drop 1 currentLine))

takeMessageCommand :: String -> Command
takeMessageCommand currentLine = Command (Message) (Cmd (drop 2 currentLine))

takeFieldCommand :: String -> Command
takeFieldCommand currentLine = 
    let cleanedLine = drop 2 currentLine
        valType_ = getValType cleanedLine
        valSize_ = getArraySize cleanedLine
        valName_ = getValName cleanedLine
    in  Command (Field) (Val valType_ valName_ valSize_)
   
getValType :: String -> ValType
getValType currentLine =
    if "int" `isInfixOf` currentLine
        then Whole
        else Character

getArraySize :: String -> Size
getArraySize [] = 0
getArraySize (x:xs) =
    if x == '[' 
        then read $ takeWhile (\ch -> isNumber ch) xs 
        else getArraySize xs 

getValName :: String -> ValName
getValName currentLine =
    takeWhile (\ch -> not $ isSpace ch) currentLine

putCppLine :: Command -> String
putCppLine command =
    if (getId command) == Comment 
        then "/*" ++ cmd (getIdValue command) ++ " */"
        else if (getId command) == Field
            then
                if valType (getIdValue command) == Whole
                    then "\tint " ++ valName (getIdValue command) ++ ";"
                    else
                        if size (getIdValue command) > 0
                            then "\tchar " ++ valName (getIdValue command) ++ "[" ++
                                show (size (getIdValue command)) ++ "];"
                            else
                                "\tchar" ++ valName (getIdValue command) ++ ";"
            else if (getId command) == Message
                then "struct " ++ (cmd (getIdValue command)) ++ "Msg {"
                else ""

genCpp :: [Command] -> [String] -> IO [String]
genCpp [] acc = return $ acc ++ ["};"]
genCpp commands newContents = do
    let formattedLine = putCppLine $ (head commands)
    genCpp (tail commands) (newContents ++ [formattedLine])

putPascalLine :: Command -> String
putPascalLine command =
    if (getId command) == Comment
        then "{" ++ cmd (getIdValue command) ++ " }"
        else if (getId command) == Message
            then (cmd (getIdValue command)) ++ "Msg = packed record"
            else if (getId command) == Field
                then 
                    if valType (getIdValue command) == Whole
                        then "\t" ++ valName (getIdValue command) ++ ": LongInt;"
                        else 
                            if size (getIdValue command) > 0
                                then "\t" ++ valName (getIdValue command) ++ 
                                     ": array[0.." ++ show (size (getIdValue command) - 1)
                                     ++ "] of char;" 
                                else "\t" ++ valName (getIdValue command) ++ ": char;"
                else ""

genPascal :: [Command] -> [String] -> IO [String]
genPascal [] acc = return $ acc ++ ["end;"]
genPascal commands newContents = do
    let formattedLine = putPascalLine $ (head commands)
    genPascal (tail commands) (newContents ++ [formattedLine])
