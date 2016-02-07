import System.Random
import Control.Monad

import State

rand :: IO Int
rand = getStdRandom (randomR (0, maxBound))

pureRand :: RandomGen g => g -> ((Int, Int), g)
pureRand gen = let (a, gen') = random gen
                   (b, gen'') = random gen'
               in  ((a,b), gen'')

type RandomState a = State StdGen a

getRandom :: Random a => RandomState a
getRandom = get >>= \gen ->
            let (val, gen') = random gen in
            put gen' >>
            return val

getRandom' :: Random a => RandomState a
getRandom' = do
    gen <- get
    let (val, gen') = random gen
    put gen' >> return val

getTwoRandoms :: Random a => RandomState (a, a)
getTwoRandoms = liftM2 (,) getRandom getRandom

runTwoRandoms :: IO (Int, Int)
runTwoRandoms = do
    oldState <- getStdGen
    let (result, newState) = runState getTwoRandoms oldState
    setStdGen newState
    return result

data CountedRandom = CountedRandom {
      crGen :: StdGen
    , crCount :: Int
    }

type CRState = State CountedRandom

getCountedRandom :: Random a => CRState a
getCountedRandom = do
    st <- get
    let (val, gen') = random (crGen st)
    put CountedRandom { crGen = gen', crCount = crCount st + 1 }
    return val

getCount :: CRState Int
getCount = crCount `liftM` get

putCount :: Int -> CRState ()
putCount a = do
    st <- get
    put st { crCount = a }
