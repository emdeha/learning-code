import System.IO
import Data.Matrix


type Input = String
type Element = Char
type Node = Matrix Element

data Tree = State Node [Tree]
          | Nil
         deriving Show
type PuzzleStates = Tree


inputToStates :: Input -> PuzzleStates
inputToStates inp = State (fromList 3 3 inp) []

generateChildren :: PuzzleStates -> PuzzleStates
generateChildren (State nd _) = undefined


main :: IO ()
main = do
  putStrLn "Hello!"
