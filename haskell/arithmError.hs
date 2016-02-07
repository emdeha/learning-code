import Control.Monad.Error

data ArithmeticError = DivideByZero
                     | NotDivisible Int Int
                     | OtherError String
                     deriving Show

instance Error ArithmeticError where
    strMsg = OtherError

safeDivide :: Int -> Int -> Either ArithmeticError Int
safeDivide _ 0 = throwError DivideByZero
safeDivide i j | i `mod` j /= 0 = throwError (NotDivisible i j)
safeDivide i j = return (i `div` j)

divide :: Int -> Int -> Either ArithmeticError Int
divide i j = (i `safeDivide` j)
                `catchError` \e ->
                    case e of
                        OtherError s     -> throwError (OtherError s)
                        DivideByZero     -> throwError DivideByZero
                        NotDivisible i j -> return (i `div` j)
