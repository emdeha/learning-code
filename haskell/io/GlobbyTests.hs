import Globby

data Test = Test { pattern :: String
                 , string :: String
                 , expected :: Bool
                 }

instance Show Test where
    show test =
        pattern test ++ " %= " ++ string test ++ " == " ++ (show $ expected test)

doTest :: Test -> Bool
doTest test = (pattern test %= string test) == expected test

tests = 
    [
        ("foo*.c", ["foobar.c"], [True]),
        ("pic.???", ["pic.png", "pic.jpg"], [True, True]),
        ("baroko", ["barko", "baroko"], [False, True]),
        ("foo?.", ["foo%", "foo.."], [False, True]),
        ("foo", ["tr"], [False]),
        ("goo", ["Ggoo"], [False]),
        ("?goo", ["Ggoo"], [True]),
        ("foo*", ["foo"], [True]),
        ("foo*.*", ["foobar.bar", "foo.", "foo.asdf"], [True, True, True]),
        ("foo*.", ["foo.", "foo.c", "foo..", "fooas>asd"], [True, False, False, False]),
        ("foo*.b*", ["foob.ba", "foo.b"], [True, True]),
        ("foo??.", ["fooa."], [False]),
        ("sad.[pP][nN][gG]", ["sad.png", "sad.PnG", "sad.pnG"], [True, True, True]),
        ("[a-z]![0-9]", ["a!9", "d!0", "A!1"], [True, True, False]),
        ("[0-9]*i", ["0abcei", "5.......i", "1i", "1."], [True, True, True, False]),
        ("[]a]", ["]", "a", "b"], [True, True, False]),
        ("[!aeoiu]*", ["abve", "vbefe", "dfe45.."], [False, True, True]),
        ("[a-zA-Z0-9][#-)].foo", ["a#.foo", "9).foo", "G*.foo"], [True, True, False])
    ]

runTests =
    mapM printStat $ separateTests tests 
    where printStat test =
            if doTest test
            then putStrLn $ ""
            else putStrLn $ (show test) ++ " failed..."

separateTests :: [(String, [String], [Bool])] -> [Test]
separateTests xs =
    foldr sep [] xs
    where 
        assemble (x,y,z) acc = Test x y z : acc
        sep (p,ls,le) acc =
            let allPat = repeat p
                zipped = zip3 allPat ls le
            in  acc ++ foldr assemble [] zipped
