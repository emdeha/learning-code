module HttpRequestParser
    (
      HttpRequest(..)
    , Method(..)
    , p_request
    ) where

import Control.Applicative hiding (many, (<|>), optional)
import Control.Monad (liftM4, when)
import System.IO (Handle, openFile, hGetContents, hClose, IOMode(ReadMode))
import System.Timeout
import Numeric (readHex)
import Text.ParserCombinators.Parsec

data Method = Get | Post
            deriving (Eq, Ord, Show)

data HttpRequest = HttpRequest {
      reqMethod :: Method
    , reqURL :: String
    , reqHeaders :: [(String, String)]
    , reqBody :: Maybe String
    } deriving (Eq, Show)

p_request :: CharParser () HttpRequest
p_request =  p_query "GET" Get
         <|> p_query "POST" Post
  where p_query name ctor = do
            req' <- req
            url' <- url
            headers <- p_headers
            body <- parseBody ctor headers
            return $ HttpRequest req' url' headers body
          where req = ctor <$ string name <* char ' '
        url = optional (char '/') *>
              manyTill notEOL (try $ string " HTTP/1." <* oneOf "01")
              <* crlf
        parseBody Post headers = do
            case lookup "Content-Length" headers of
                Just l -> Just <$> count (read l) anyChar
                Nothing -> case lookup "Transfer-Encoding" headers of
                    Just "chunked" -> Just <$> parseChunks
                    Nothing -> Just <$> (smallerThan 4096)
        parseBody Get _ = pure Nothing

p_headers :: CharParser st [(String,String)]
p_headers = header `manyTill` crlf
  where header = liftA2 (,) fieldName (char ':' *> spaces *> contents)
        contents = liftA2 (++) (many1 notEOL <* crlf)
                               (continuation <|> pure [])
        continuation = liftA2 (:) (' ' <$ many1 (oneOf " \t")) contents
        fieldName = (:) <$> letter <*> many fieldChar
        fieldChar = letter <|> digit <|> oneOf "-_"

crlf :: CharParser st ()
crlf = (() <$ string "\r\n") <|> (() <$ newline)

notEOL :: CharParser st Char
notEOL = noneOf "\r\n"

smallerThan :: Int -> CharParser st String
smallerThan n = do
    x <- line
    newline
    if length x > n
    then error $ "line too long"
    else
        (eof >> return "")
        <|> do
        xs <- smallerThan n
        return (x++xs)
  where line = many $ noneOf "\n"

parseChunks :: CharParser st String
parseChunks =
    (eof >> return "")
    <|> do
    cnt <- many1 hexDigit
    newline
    chunk <- count (fst . head . readHex $ cnt) anyChar
    newline
    rest <- parseChunks
    return (chunk ++ rest)


timeoutParseHttp :: FilePath -> IO ()
timeoutParseHttp path = do
    handle <- openFile path ReadMode
    cnts <- hGetContents handle
    timeout 30000000 $ parseTest p_request cnts
    hClose handle


parseHttp = parse p_request "(unknown)"

testHttp = "POST /enlighten/calais.asmx HTTP/1.1\n" ++
           "Host: api.opencalais.com\n" ++
           "Transfer-Encoding: chunked\n" ++
           "Content-Type: text/xml; charset=utf-8\n" ++
           "SOAPAction: \"http://clearforest.com/Enlighten\"\n" ++
           "\n" ++
           "4\n" ++
           "Wiki\n" ++
           "5\n" ++
           "pedia\n" ++
           "c\n" ++
           " in\n\nchunks.\n" ++
           "0\n" ++
           "\n"

-- Demonstrates different return values problem
--
--smallerThan :: Int -> CharParser st String
--smallerThan n = do
--    s <- getInput
--    if (null s) 
--    then 
--        if length s < n
--        then do c <- many notEOL
--                cs <- liftA concat $ (smallerThan n)
--                return (c++cs)
--        else error $ "line too long: " ++ s
--    else pure ""
