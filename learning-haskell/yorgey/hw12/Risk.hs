{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Risk where

import Control.Monad.Random
import Control.Applicative
import Control.Monad
import Data.List

------------------------------------------------------------
-- Die values

newtype DieValue = DV { unDV :: Int } 
  deriving (Eq, Ord, Show, Num)

first :: (a -> b) -> (a, c) -> (b, c)
first f (a, c) = (f a, c)

instance Random DieValue where
  random           = first DV . randomR (1,6)
  randomR (low,hi) = first DV . randomR (max 1 (unDV low), min 6 (unDV hi))

die :: Rand StdGen DieValue
die = getRandom

------------------------------------------------------------
-- Risk

type Army = Int

data Battlefield = Battlefield { attackers :: Army, defenders :: Army }

-- | @battle@ simulates a single round of the game Risk
battle :: Battlefield -> Rand StdGen Battlefield
battle bf =
    let numAtt = min 3 (attackers bf - 1)
        numDef = min 2 (defenders bf)
        diceAtt = doRolls numAtt
        diceDef = doRolls numDef
    in  liftA2 getLosses diceAtt diceDef >>= applyLosses bf

  where doRolls num = (reverse . sort) <$> (replicateM num $ die)
        applyLosses bf (a, d) = return Battlefield { 
            attackers = attackers bf - a, 
            defenders = defenders bf - d 
        }

getLosses :: [DieValue] -> [DieValue] -> (Army, Army)
getLosses att def = foldr accLosses (0, 0) (zip (map unDV att) (map unDV def))
  where accLosses (a, d) (accA, accD)
            | a <= d    = (accA + 1, accD)
            | otherwise = (accA, accD + 1)

-- | @invade@ simulates a battle until there are no defenders remaining or
--   less than two attackers
invade :: Battlefield -> Rand StdGen Battlefield
invade bf@(Battlefield att def)
    | att > 2 && def > 0 = battle bf >>= invade
    | otherwise          = return bf

-- | @successProb@ simulates 1000 invasions and determines the success prob
successProb :: Battlefield -> Rand StdGen Double
successProb bf = 
    let invasions = replicateM 1000 $ invade bf
        success = invasions >>= (\ls ->
                         return $ length . filter isDefDestroyed $ ls)
    in  success >>= (\clean -> return $ fromIntegral clean / 1000)
  where isDefDestroyed (Battlefield _ def) = def == 0
