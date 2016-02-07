concat (map g ls)
[1..6] >>= f
f = [1..6] >>= g
g n1 n2 = if n1 + n2 == 7 then return (n1,n2) else []

concat (map ([1..6] >>= g) [1..6])

concat (map (concat (map g [1..6])) [1..6])

    g 1 -> g 1 1, g 1 2, g 1 3, g 1 4, g 1 5, g 1 6
    g 2 -> g 2 1, g 2 2, g 2 3, g 2 4 
    g 3
    g 4
    g 5
    g 6
