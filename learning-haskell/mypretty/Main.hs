module Main () where

import PrettyJSON
import SimpleJSON

main = putJValue (JObject [("foo", JNumber 1), ("bar", JBool False)])
