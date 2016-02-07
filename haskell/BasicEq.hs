class BasicEq a where
    isEqual :: a -> a -> Bool
    isEqual a b = not (isNotEqual a b)

    isNotEqual :: a -> a -> Bool
    isNotEqual a b = not (isEqual a b)

instance BasicEq Bool where
    isEqual True True   = True
    isEqual False False = True
    isEqual _ _         = False
