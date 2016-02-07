module Parse where

import qualified Data.ByteString.Lazy.Char8 as L8
import qualified Data.ByteString.Lazy as L
import Data.Char(chr, isDigit, isSpace)
import Data.Int(Int64)
import Data.Word(Word8, Word16)    
import Data.Binary.Get(getWord16be)
import Control.Applicative((<$>))    

data Greymap = Greymap {
      greyWidth :: Int
    , greyHeight :: Int
    , greyMax :: Int
    , greyData :: L.ByteString
    }

instance Show Greymap where
    show (Greymap w h m _) =
        "Greymap " ++ show w ++ "x" ++ show h ++ " " ++ show m

data ParseState = ParseState {
      string :: L.ByteString
    , offset :: Int64
    } deriving (Show)

newtype Parse a = Parse {
        runParse :: ParseState -> Either String (a, ParseState)
    }

instance Functor Parse where
    fmap f parser = parser ==> \result -> identity (f result)

identity :: a -> Parse a
identity a = Parse (\s -> Right (a, s))

parse :: Parse a -> L.ByteString -> Either String a
parse parser initState =
    case runParse parser (ParseState initState 0) of
        Left err          -> Left err
        Right (result, _) -> Right result

parseWhile :: (Word8 -> Bool) -> Parse [Word8]
parseWhile pred = (fmap pred <$> peekByte) ==> \mp ->
                    if mp == Just True
                    then parseByte ==> \b ->
                            (b:) <$> parseWhile pred
                    else identity []

peekByte :: Parse (Maybe Word8)
peekByte = (fmap fst . L.uncons . string) <$> getState

peekChar :: Parse (Maybe Char)
peekChar = fmap w2c <$> peekByte

w2c :: Word8 -> Char
w2c = chr . fromIntegral

getState :: Parse ParseState
getState = Parse (\s -> Right (s, s))

putState :: ParseState -> Parse ()
putState s = Parse (\_ -> Right ((), s))

bail :: String -> Parse a
bail err = Parse $ \s -> Left ("byte offset " ++ show (offset s) ++ ": " ++ err)

modifyOffset :: ParseState -> Int64 -> ParseState
modifyOffset initState newOffset =
    initState { offset = newOffset }

parseRawPGM :: Parse Greymap
parseRawPGM =
    parseWhileWith w2c notWhite ==> \header -> skipSpaces ==>&
    assert (header == "P5") "invalid raw header" ==>&
    parseNat ==> \width -> skipSpaces ==>&
    parseNat ==> \height -> skipSpaces ==>&
    parseNat ==> \maxGrey ->
        parseByte ==>& parseBytes ((getSize maxGrey) * width * height) ==> \bitmap ->
            identity (Greymap width height maxGrey bitmap)

getSize :: Int -> Int
getSize maxGrey
    | maxGrey <= 255   = 1
    | maxGrey <= 65535 = 2
    | otherwise        = error "invalid PGM image"

parsePlainPGM :: Parse Greymap
parsePlainPGM =
    parseWhileWith w2c notWhite ==> \header -> skipSpaces ==>&
    assert (header == "P2") "invalid plain header" ==>&
    parseNat ==> \width -> skipSpaces ==>&
    parseNat ==> \height -> skipSpaces ==>&
    parseNat ==> \maxGrey ->
        parseChar ==>& parseChars (width * height) ==> \asciiMap ->
            identity (Greymap width height maxGrey (L8.pack asciiMap))

notWhite = (`notElem` " \r\n\t")

parseWhileWith :: (Word8 -> a) -> (a -> Bool) -> Parse [a]
parseWhileWith f p = fmap f <$> parseWhile (p . f)

parseNat :: Parse Int
parseNat = parseWhileWith w2c isDigit ==> \digits ->
            if null digits
            then bail "no more input"
            else let n = read digits
                 in  if n < 0
                     then bail "intger overflow"
                     else identity n

(==>&) :: Parse a -> Parse b -> Parse b
p ==>& f = p ==> \_ -> f

(==>) :: Parse a -> (a -> Parse b) -> Parse b
firstParser ==> secondParser = Parse chainedParser
  where chainedParser initState =
            case runParse firstParser initState of
                Left errMessage -> Left errMessage
                Right (firstResult, newState) ->
                    runParse (secondParser firstResult) newState 

(=|>) :: Either String b -> (b -> c) -> c
Left err =|> _ = error err
Right val =|> f = f val

skipSpaces :: Parse ()
skipSpaces = parseWhileWith w2c isSpace ==>& identity ()

assert :: Bool -> String -> Parse ()
assert True _    = identity ()
assert False err = bail err

parseChar :: Parse Char
parseChar = w2c <$> parseByte

parseByte :: Parse Word8
parseByte =
    getState ==> \initState ->
        case L.uncons (string initState) of
            Nothing                -> bail "no more input"
            Just (byte, remainder) -> putState newState ==> \_ ->
                identity byte
              where newState = initState { string = remainder,
                                           offset = newOffset }
                    newOffset = offset initState + 1

parseBytes :: Int -> Parse L.ByteString
parseBytes n =
    getState ==> \st ->
        let n' = fromIntegral n
            (h, t) = L.splitAt n' (string st)
            st' = st { offset = offset st + L.length h, string = t }
        in  putState st' ==>&
            assert (L.length h == n') "end of input" ==>&
            identity h

parseChars :: Int -> Parse String
parseChars n = fmap w2c <$> L.unpack <$> parseBytes n 

parseHeader :: Parse String
parseHeader =
    parseWhileWith w2c notWhite ==> \header -> identity header

parsePGM :: FilePath -> IO ()
parsePGM fName = do
    contents <- L.readFile fName
    parse parseHeader contents =|> \str ->
        case str of
            "P5" -> parseRaw contents
            "P2" -> parsePlain contents
  where parseRaw cnts = parse parseRawPGM cnts =|> (print . greyData)
        parsePlain cnts = parse parsePlainPGM cnts =|> (print . greyData)
