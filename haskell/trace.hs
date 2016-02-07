import Debug.Trace

-- doSomethingElse evals before doSomething, because we first demand s''
f = \s ->
        let (x, s') = doSomething s
            (y, s'') = doSomethingElse s'
        in  (3, s'')

-- case forces strictness
f' = \s ->
        case doSomething s of
            (x, s') -> case doSomethingElse s' of
                            (y, s'') -> (3, s'')

doSomething s = trace "doSomething" $ (0, s)
doSomethingElse s = trace "doSomethingElse" $ (3, s)

main = print (f' 2)
