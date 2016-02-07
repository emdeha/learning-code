import Data.List (isSuffixOf)
import Data.Maybe (maybeToList)
import Control.Monad

data Sheep = Node (String, Sheep) | Empty
    deriving (Show)

toTuple :: Sheep -> (String, Sheep)
toTuple (Node (name, parent)) = (name, parent)


father :: Sheep -> Maybe Sheep
father Empty = Nothing
father (Node (name, parent))
    | "-f" `isSuffixOf` (pName parent) = Just parent
    | otherwise                        = Nothing

mother :: Sheep -> Maybe Sheep
mother Empty = Nothing
mother (Node (name, parent))
    | "-m" `isSuffixOf` (pName parent) = Just parent
    | otherwise                        = Nothing

pName :: Sheep -> String
pName = fst . toTuple


maternalGrandfather :: Sheep -> Maybe Sheep
maternalGrandfather s = mother s >>= father

fathersMaternalGrandfather :: Sheep -> Maybe Sheep
fathersMaternalGrandfather s = father s >>= mother >>= father

mothersPaternalGrandfather :: Sheep -> Maybe Sheep
mothersPaternalGrandfather s = mother s >>= father >>= father

parentM :: Sheep -> Maybe Sheep
parentM s = mother s `mplus` father s

grandParentM :: Sheep -> Maybe Sheep
grandParentM s = parentM s >>= parentM

parentL :: Sheep -> [Sheep]
parentL s = (maybeToList $ mother s) `mplus` (maybeToList $ father s)

grandParentL :: Sheep -> [Sheep]
grandParentL s = parentL s >>= parentL

parent :: (MonadPlus m) => Sheep -> m Sheep
parent s = toMonad $ mother s `mplus` father s

grandParent :: (MonadPlus m) => Sheep -> m Sheep
grandParent s = parent s >>= parent

toMonad :: (MonadPlus m) => Maybe Sheep -> m Sheep
toMonad (Just s) = return s
toMonad Nothing  = mzero

traceFamily :: Sheep -> [(Sheep -> Maybe Sheep)] -> Maybe Sheep
traceFamily s l = foldM getParent s l
  where getParent s f = f s


testSheep = (Node ("gosho", (Node ("peika-m", (Node ("gosho-f", (Node ("maika-m", Empty))))))))
