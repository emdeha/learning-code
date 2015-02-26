module GlobRegex
    (
      globToRegex
    , matchesGlob
    ) where

import Text.Regex.Posix
import Data.Bits ((.|.))

type GlobError = String

globToRegex :: String -> Bool -> Either GlobError String
globToRegex cs isCS = case globToRegex' cs isCS of
                        Right str -> Right $ '^' : str ++ "$" -- anchors the converted regex
                        Left err -> Left err

globToRegex' :: String -> Bool -> Either GlobError String
globToRegex' "" isCS
    | isCS == True = Right "/i"
    | otherwise    = Right ""

globToRegex' ('*':cs) isCS = case globToRegex' cs isCS of
                                Right str -> Right $ ".*" ++ str
                                Left err -> Left err

globToRegex' ('?':cs) isCS = case globToRegex' cs isCS of
                                Right str -> Right $ '.' : str
                                Left err -> Left err

globToRegex' ('[':'!':c:cs) isCS = case charClass cs isCS of
                                    Right str -> Right $ "[^" ++ c : str
                                    Left err -> Left err

globToRegex' ('[':c:cs) isCs = case charClass cs isCs of
                                Right str -> Right $ '[' : c : str
                                Left err -> Left err

globToRegex' ('[':_) _ = Left "unterminated character class"

globToRegex' (c:cs) isCS = case globToRegex' cs isCS of
                            Right str -> Right $ escape c ++ str
                            Left err -> Left err

escape :: Char -> String
escape c | c `elem` regexChars = '\\' : [c]
         | otherwise = [c]
    where regexChars = "\\+()^$.{}]|"


charClass :: String -> Bool -> Either GlobError String
charClass (']':cs) isCS = case globToRegex' cs isCS of
                            Right str -> Right $ ']' : str
                            Left err -> Left err
charClass (c:cs) isCS   = case charClass cs isCS of
                            Right str -> Right $ c : str
                            Left err -> Left err
charClass [] isCS       = Left "unterminated character class"


matchesGlob :: FilePath -> String -> String -> Bool
matchesGlob name pat opts 
    | 'i' `elem` opts = case globToRegex pat False of 
                            Right str -> match (makeRegexOpts (defaultCompOpt .|. compIgnoreCase)
                                              defaultExecOpt str) name
                            Left err -> error err
    | otherwise       = case globToRegex pat True of
                            Right str -> name =~ str
                            Left err -> error err
