import Test.QuickCheck

import Folding


prop_fun1_model xs = fun1 xs == fun1' xs

prop_fun2_model n = 
    n > 0 ==>
        fun2 n == fun2' n
