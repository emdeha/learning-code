type ListZipper a = ([a],[a])

goForward :: ListZipper a -> Maybe (ListZipper a)
goForward (l:ls, xs) = Just (ls, l:xs)
goForward ([], _) = Nothing

goBackward :: ListZipper a -> Maybe (ListZipper a)
goBackward (ls, x:xs) = Just (x:ls, xs)
goBackward (_, []) = Nothing

simpleList = [1,2,3,4,5]
