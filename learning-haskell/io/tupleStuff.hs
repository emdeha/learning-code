data Six a b c d e f = First a 
                     | Second b 
                     | Third c 
                     | Fourth d 
                     | Fifth e
                     | Sixth f
                    deriving (Show)

getElemAtIndex :: (a, b, c, d, e, f) -> Int -> Six a b c d e f
getElemAtIndex (a,_,_,_,_,_) 0 = First a
getElemAtIndex (_,b,_,_,_,_) 1 = Second b
getElemAtIndex (_,_,c,_,_,_) 2 = Third c
getElemAtIndex (_,_,_,d,_,_) 3 = Fourth d
getElemAtIndex (_,_,_,_,e,_) 4 = Fifth e
getElemAtIndex (_,_,_,_,_,f) 5 = Sixth f
getElemAtIndex _ _ = error "index out of range"


testTuple = (1,'a',2.0,'b')
