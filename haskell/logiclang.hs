import Control.Monad
import Control.Monad.State
import Data.Maybe


-- Language to express logic problems
type Var = String
type Value = String
data Predicate = Is Var Value
               | Equal Var Var
               | And Predicate Predicate
               | Or Predicate Predicate
               | Not Predicate
            deriving (Eq, Show)

type Variables = [(Var, Value)]

isNot :: Var -> Value -> Predicate
isNot var value = Not (Is var value)

implies :: Predicate -> Predicate -> Predicate
implies a b = Not (a `And` (Not b))

orElse :: Predicate -> Predicate -> Predicate
orElse a b = (a `And` (Not b)) `Or` ((Not a) `And` b)

-- Check a predicate with the given variable bindings
-- An unbound variable causes a Nothing return value
check :: Predicate -> Variables -> Maybe Bool
check (Is var value) vars = do val <- lookup var vars
                               return (val == value)
check (Equal v1 v2) vars = do val1 <- lookup v1 vars
                              val2 <- lookup v2 vars
                              return (val1 == val2)
check (And p1 p2) vars = liftM2 (&&) (check p1 vars) (check p2 vars)
check (Or p1 p2) vars = liftM2 (||) (check p1 vars) (check p2 vars)
check (Not p) vars = liftM (not) (check p vars)

-- Logicl problem solver
data ProblemState = PS { vars :: Variables, constraints :: [Predicate] }

-- Non-deterministic computations with state monad transformer
type NDS a = StateT ProblemState [] a


getVar :: Var -> NDS (Maybe Value)
getVar v = do vs <- gets vars
              return $ lookup v vs

setVar :: Var -> Value -> NDS ()
setVar v x = do st <- get
                vs' <- return $ filter ((v/=) . fst) (vars st)
                put $ st { vars = (v,x) : vs' }

-- Check if variable assignments satisfy all of the predicates.
-- The partial argument determines the value used when a predicate
-- returns Nothing because some variable it uses is not set.
-- Setting this to True allows us to accept partial solutions, then 
-- we can use a value of False at the end to signify that all
-- solutions should be complete.
isConsistent :: Bool -> NDS Bool
isConsistent partial = do cs <- gets constraints
                          vs <- gets vars
                          let results = map (\p -> check p vs) cs
                          return $ and (map (maybe partial id) results)

-- Return only the variable bindings that are complete consistent solutions.
getFinalVars :: NDS Variables
getFinalVars = do c <- isConsistent False
                  guard c
                  gets vars

-- Get the first solution to the problem, by evaluating the solver computation
-- with an initial problem state and then returning the first solution in the 
-- result list, or Nothing if there was no solution.
getSolution :: NDS a -> ProblemState -> Maybe a
getSolution c i = listToMaybe (evalStateT c i)

-- Get a list of all possible solutions to the problem by evaluating the solver
-- computation with an initial problem state.
getAllSollutions :: NDS a -> ProblemState -> [a]
getAllSollutions c i = evalStateT c i


--- Kalotan puzzle
said :: Var -> Predicate -> Predicate
said v p = (v `Is` "male") `implies` p

saidBoth :: Var -> Predicate -> Predicate -> Predicate
saidBoth v p1 p2 = And ((v `Is` "male") `implies` (p1 `And` p2))
                       ((v `Is` "female") `implies` (p1 `orElse` p2))

lied :: Var -> Predicate -> Predicate
lied v p = ((v `said` p) `And` (Not p)) `orElse` ((v `said` (Not p)) `And` p)

tryAllValues :: Var -> NDS ()
tryAllValues var = do (setVar var "male") `mplus` (setVar var "female")
                      c <- isConsistent True
                      guard c

main :: IO ()
main = do let variables = []
              constraints = [ Not (Equal "parent1" "parent2"),
                              "parent1" `said` ("child" `said` ("child" `Is` "male")),
                              saidBoth "parent2" ("child" `Is` "female")
                                                 ("child" `lied` ("child" `Is` "male")) ] 
              problem = PS variables constraints
          print $ (`getSolution` problem) $ do tryAllValues "parent1"
                                               tryAllValues "parent2"
                                               tryAllValues "child"
                                               getFinalVars 
