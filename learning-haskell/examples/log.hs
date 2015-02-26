import Control.Monad.Writer

logNumber x = writer (x, ["Got number: " ++ show x])

multWithLog = do
    a <- logNumber 3
    b <- logNumber 5
    return (a*b)
