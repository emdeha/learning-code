import qualified Data.Map as Map


duplicateElements :: [a] -> [a]
duplicateElements = concatMap (\x -> [x, x])

slice :: Int -> Int -> [a] -> [a]
slice i j = drop i . take (j+1)

primeSum :: Int -> (Int, Int)
primeSum n = helper (n-1) 1
  where
    helper p q
      | p <= 0 || q >= n                     = (0, 0)
      | isPrime p && isPrime q && p + q == n = (p, q)
      | otherwise                            =
          let candidate = helper p (q+1)
          in  if candidate == (0, 0) then helper (p-1) q else candidate
    isPrime k = all (\i -> k `rem` i /= 0) [2..(k-1)]

{-
  A phone book
-}
type PhoneBook = Map.Map String [String]

createPhoneBook :: [(String, [String])] -> PhoneBook
createPhoneBook = Map.fromList

addContact :: String -> String -> PhoneBook -> PhoneBook
addContact name number pb
  | Map.member name pb = Map.adjust (\x -> number : x) name pb
  | otherwise          = Map.insert name [number] pb

getNumber :: String -> PhoneBook -> [String]
getNumber = Map.findWithDefault []
