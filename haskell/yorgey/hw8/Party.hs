{-# OPTIONS_GHC -Wall #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
module Party where


import Data.Monoid
import Data.Tree
import Data.List (sort)

import Employee


-- | Appends @emp@ to a @GuestList
glCons :: Employee -> GuestList -> GuestList
glCons emp (GL emps fscore) = (GL (emp:emps) (fscore+empFun emp))

instance Monoid GuestList where
  (GL emps1 fscore1) `mappend` (GL emps2 fscore2) = 
    (GL (emps1++emps2) (fscore1+fscore2))
  mempty = (GL [] 0)

-- | Returns the guest list which has more fun
moreFun :: GuestList -> GuestList -> GuestList
moreFun gl1 gl2
    | gl1 <= gl2 = gl2
    | otherwise  = gl1


-- | Implements fold over a rose tree
treeFold :: (a -> [b] -> b) -> Tree a -> b
treeFold f (Node root xs) = f root (map (treeFold f) xs)

-- | Given a boss and a list of pairs of each subtree under the boss, returns
--   a pair of the funniest GuestList containing the boss and the funniest 
--   subtree without the boss.
nextLevel :: Employee -> [(GuestList, GuestList)] -> (GuestList, GuestList)
nextLevel boss guestOptions = (withBoss, withoutBoss)
  where
    withoutBoss = (mconcat (map (uncurry moreFun) guestOptions))
    withBoss = glCons boss (mconcat (map snd guestOptions))

-- | Gets a company hierarchy as an input and returns a fun-maximizing 
--   guest list
type FunPair = (GuestList, GuestList)

maxFun :: Tree Employee -> GuestList
maxFun = uncurry moreFun . treeFold nextLevel 


-- | Parses a string containing a company hierarchy and returns it sorted
--   by first name
prettyPrintFun :: String -> String
prettyPrintFun company = extractFun . maxFun . read $ company
  where extractFun (GL [] _)       = ""
        extractFun (GL emps score) = header ++ list
          where header = "Total fun: " ++ show score
                list   = filter (/='\"') . concat . sort $ names
                names  = map (('\n':) . show . empName) $ emps

-- | Reads company.txt and outputs the max fun
main :: IO ()
main = readFile "company.txt" >>=
            (\company -> putStrLn $ prettyPrintFun company)
