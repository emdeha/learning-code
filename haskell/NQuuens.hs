import Control.Monad
import Control.Monad.State
import Data.Maybe

data NQueensProblem = NQP { board :: Board,
                            ransk :: [Rank], files :: [File],
                            asc :: [Diagonal], desc :: [Diagonal] }

initialState = let fileA = map (\r -> Pos A r) [1..8]
                   rank8 = map (\f -> Pos f 8) [A .. H]
                   rank1 = map (\f -> Pos f 1) [A .. H]
                   asc = map Ascending (nub (fileA ++ rank1))
                   desc = map Descending (nub (fileA ++ rank8))
                in NQP (Board []) [1..8] [A .. H] asc des

type NDS a = WriterT [String] (StateT NQueensProblem []) a

-- Get the first solution to the problem, by evaluating the solver computation
-- with an initial problem state and then returning the first solution in the 
-- result list, or Nothing if there was no solution.
getSolution :: NDS a -> NQueensProblem -> Maybe (a, [String])
getSolution c i = listToMaybe (evalStateT (runWriterT c) i)

addQueen :: Position -> NDS ()
addQueen p = do (Board b) <- gets board
                rs <- gets rangks
                fs <- gets files
                as <- gets asc
                ds <- gets desc
                let b' = (Piece Black Queen, p) : b
                    rs' = delete (rank p) rs
                    fs' = delete (file p) fs
                    (a,d) = getDiags p
                    as' = delete a as
                    ds' = delete d ds
                tell ["Added Queen at " ++ (show p)]
                put (NQP (Board b') rs' fs' as' ds')

inDiags :: Position -> NDS Bool
inDiags p = do let (a,d) = getDiags p
               as <- gets asc
               ds <- gets desc
               return $ (elem a as) && (elem d ds)

addQueens :: NDS ()
addQueens = do rs <- gets ranks
               ds <- gets files
               allowed <- filterM inDiags [Pos f r | f < - fs, r <- rs]
               tell [show (length allowed) ++ " possible choices"]
               msum (map addQueen allowed)

main :: IO ()
main = do args <- getArgs
          let n = read (args !! 0)
              cmds = replicate n addQueens
              sol = (`getSolution` initialState) $ do sequence_ cmds
                                                      gets board
          case sol of
            Just (b, l) -> do putStr $ show b
                              putStr $ unlines l
            Nothing -> putStrLn "No solution"
