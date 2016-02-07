n = 3
m = 5

d = [[5, 5, 1],
     [2, 1, 1],
     [1, 2, 1],
     [2, 1, 1],
     [2, 3, 2]]

s = [[0 for j in range(n)] for i in range(m)]
memo = [[0 for j in range(n)] for i in range(m)]
iters = 0

def seam(i, j):
    global memo
    global s
    global iters

    if memo[i][j] > 0:
        return memo[i][j]

    iters = iters + 1

    if i+1 < m:
        best = seam(i+1, j) + d[i][j]
        s[i][j] = j
        if j-1 >= 0:
            fst = seam(i+1, j-1) + d[i][j]
            if fst < best:
                best = fst
                s[i][j] = j-1
        if j+1 < n:
            fst = seam(i+1, j+1) + d[i][j]
            if fst < best:
                best = fst
                s[i][j] = j+1
        memo[i][j] = best
        return best

def printSeam(i, j):
    if j < 0 or j >= n:
        return 
    if i >= m:
        return

    print '*' * (j) + 'X' + '*' * (n - j - 1)
    printSeam(i+1, s[i][j])

for j in range(n):
    memo[m-1][j] = d[m-1][j]

best = float("inf")
bestJ = 0
for j in range(n):
    fs = seam(0, j)
    if fs < best:
        best = fs
        bestJ = j

print "Cheapest seam: " + str(best)
print "Iters: " + str(iters)
printSeam(0, bestJ)
