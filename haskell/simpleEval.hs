-- |
-- A simple language interpreter showing the usage of monad transformers.
-- |
module Transformers where

import Control.Monad.Identity
import Control.Monad.Error
import Control.Monad.Reader
import Control.Monad.State
import Control.Monad.Writer
import Data.Maybe
import qualified Data.Map as Map


-- variable names
type Name = String

-- Language expressions
data Exp = Lit Integer
         | Var Name
         | Plus Exp Exp
         | Abs Name Exp
         | App Exp Exp
         deriving (Show)

-- result values
data Value = IntVal Integer
           | FunVal Env Name Exp
           deriving (Show)

-- mapping from names to values
type Env = Map.Map Name Value

-- Monadic eval
type Eval a = ReaderT Env (ErrorT String 
                           (WriterT [String] (StateT Integer IO))) a
runEval :: Env -> Integer -> Eval a -> ((Either String a, [String]), Integer)
runEval env st ev = runStateT (runWriterT (runErrorT (runReaderT ev env))) st


tick :: (Num s, MonadState s m) => m ()
tick = do st <- get
          put (st+1)

-- evaluation of an expression in a given environment
eval :: Exp -> Eval Value
eval (Lit i) = do tick
                  liftIO $ print i
                  return $ IntVal i
eval (Var n) = do tick
                  tell [n]
                  env <- ask
                  case Map.lookup n env of
                    Nothing -> throwError ("unbound var: " ++ n)
                    Just val -> return val
eval (Plus e1 e2) = do tick
                       e1' <- eval e1
                       e2' <- eval e2
                       case (e1', e2') of
                        (IntVal i1, IntVal i2) -> return $ IntVal (i1 + i2)
                        _ -> throwError "type error in addition"
eval (Abs n e) = do tick
                    env <- ask
                    return $ FunVal env n e
eval (App e1 e2) = do tick
                      val1 <- eval e1
                      val2 <- eval e2
                      case val1 of
                        FunVal env' n body -> 
                                local (const (Map.insert n val2 env')) (eval body)
                        _ -> throwError "type error in application"

exampleExpr = Lit 12 `Plus` (App (Abs "x"(Var "x")) (Lit 4 `Plus` Lit 2))
errorExpr = Plus (Lit 1) (Abs "x" (Var "x"))
