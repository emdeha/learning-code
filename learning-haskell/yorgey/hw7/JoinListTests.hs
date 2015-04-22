import JoinList
import Sized


emptyJL = Empty
oneLevelJL = Append (Size 2) (Single (Size 1) 'a') (Single (Size 1) 'b')
bigJL = Append (Size 5) 
          (Append (Size 4) 
             (Append (Size 3) 
                (Append (Size 2) 
                   (Single (Size 1) 'a') (Single (Size 1) 'b'))
                (Single (Size 1) 'c')) 
             (Single (Size 1) 'c')) 
        (Single (Size 1) 'c')
joinListText = Append (Size 9)
                 (Append (Size 4)
                    (Append (Size 2)
                       (Single (Size 1) 'j') (Single (Size 1) 'o'))
                    (Append (Size 2)
                       (Single (Size 1) 'i') (Single (Size 1) 'n'))
                 )
                 (Append (Size 5)
                    (Append (Size 2)
                       (Single (Size 1) ' ') (Single (Size 1) 'l'))
                    (Append (Size 3)
                       (Single (Size 1) 'i')
                       (Append (Size 2)
                          (Single (Size 1) 's') (Single (Size 1) 't')
                       )
                    )
                 )
                          


jlToList :: JoinList m a -> [a]
jlToList Empty          = []
jlToList (Single _ a)   = [a]
jlToList (Append _ a b) = jlToList a ++ jlToList b

(!!?) :: [a] -> Int -> Maybe a
[]     !!? _         = Nothing
_      !!? i | i < 0 = Nothing
(x:_)  !!? 0         = Just x
(_:xs) !!? i         = xs !!? (i-1)
