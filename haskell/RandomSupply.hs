import Supply
import System.Random hiding (next)
import Control.Arrow (first)

randomsIO :: Random a => IO [a]
randomsIO = getStdRandom (first randoms . split)
