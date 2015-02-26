module Prettify where

import SimpleJSON


data Doc = Empty
         | Char Char
         | Text String
         | Line
         | Concat Doc Doc
         | Union Doc Doc
           deriving (Show, Eq)

empty :: Doc
empty = Empty

char :: Char -> Doc
char c = Char c

text :: String -> Doc
text "" = Empty
text str = Text str

double :: Double -> Doc
double num = text (show num)

line :: Doc
line = Line


(<>) :: Doc -> Doc -> Doc
Empty <> y = y
x <> Empty = x
x <> y     = x `Concat` y

fsep :: [Doc] -> Doc
fsep = foldr (</>) empty

(</>) :: Doc -> Doc -> Doc
x </> y = x <> softline <> y

softline :: Doc
softline = group line

group :: Doc -> Doc
group x = flatten x `Union` x

flatten :: Doc -> Doc
flatten (x `Concat` y) = flatten x `Concat` flatten y
flatten Line           = Char ' '
flatten (x `Union` _)  = flatten x
flatten other          = other

hcat :: [Doc] -> Doc
hcat = foldr (<>) empty

concat :: [[a]] -> [a]
concat = foldr (++) []

punctuate :: Doc -> [Doc] -> [Doc]
punctuate p []     = []
punctuate p [d]    = [d]
punctuate p (d:ds) = (d <> p) : punctuate p ds

compact :: Doc -> String
compact x = transform [x]
    where transform [] = ""
          transform (d:ds) =
              case d of
                Empty        -> transform ds
                Char c       -> c : transform ds
                Text s       -> s ++ transform ds
                Line         -> "\n" ++ transform ds
                a `Concat` b -> transform (a:b:ds)
                _ `Union` b  -> transform (b:ds)

pretty :: Int -> Doc -> String
pretty width x = best 0 [x]
    where best col (d:ds) =
              case d of
                Empty        -> best col ds
                Char c       -> c : best (col + 1) ds
                Text s       -> s ++ best (col + length s) ds
                Line         -> '\n' : best 0 ds
                a `Concat` b -> best col (a:b:ds)
                a `Union` b  -> nicest col (best col (a:ds))
                                           (best col (b:ds))
          best _ _ = ""

          nicest col a b | (width - least) `fits` a = a
                         | otherwise                = b
                         where least = min width col

fits :: Int -> String -> Bool
w `fits` _ | w < 0 = False
w `fits` ""        = True
w `fits` ('\n':_)  = True
w `fits` (c:cs)    = (w - 1) `fits` cs

fill :: Int -> Doc -> Doc
fill width x = fillSpace 0 [x]
    where fillSpace _ [] = Text (replicate width ' ')
          fillSpace width (d:ds) =
                case d of
                  Empty        -> Empty <> fillSpace width ds
                  Char c       -> Char c <> fillSpace (width + 1) ds
                  Text s       -> Text s <> fillSpace (width + length s) ds
                  Line         -> Text (replicate width ' ') <> Line <> fillSpace 0 ds
                  a `Concat` b -> fillSpace width (a:b:ds)
                  a `Union` b  -> fillSpace width (a:ds) `Union` fillSpace width (b:ds)

nest :: Int -> Doc -> Doc
nest width x = indent 0 [x]
    where indent nC [] = doIndent nC
          indent nC (d:ds) =
                case d of
                  Empty        -> indent nC ds
                  Char c       -> 
                    case c of
                        '{' -> Char c <> Line <> (doIndent nC) <> indent (nC+1) ds
                        '[' -> Char c <> Line <> (doIndent nC) <> indent (nC+1) ds
                        '}' -> Line <> (doIndent (nC-1)) <> Char c <> indent (nC-1) ds
                        ']' -> Line <> (doIndent (nC-1)) <> Char c <> indent (nC-1) ds
                        ',' -> Char c <> Line <> (doIndent (nC-1)) <> indent nC ds
                        _   -> Char c <> indent nC ds

                  Text s       -> Text s <> indent nC ds
                  Line         -> Line <> (doIndent nC) <> indent nC ds
                  a `Concat` b -> indent nC (a:b:ds)
                  a `Union` b  -> indent nC (a:ds) `Union` indent nC (b:ds)
          doIndent nC = Text (replicate (nC*width) ' ')
