positions = range(0, 21)
strlen = 21
iters = 0

memo = [[0 for i in range(0, strlen)] for j in range(0, strlen)]
s = [[0 for i in range(0, strlen)] for j in range(0, strlen)]

def break_string(i, j):
    global memo
    global iters

    if memo[i][j] > 0:
       return memo[i][j]

    best = float("inf")
    valid = [p for p in positions if p > i and p < j]
    if valid == []:
        best = 0

    bestK = -1
    for k in valid:
        iters = iters + 1
        bs = break_string(i, k) + break_string(k, j) + j - i
        if best > bs:
            best = bs
            bestK = k

    memo[i][j] = best
    s[i][j] = bestK

    return best

def print_breaks(s, i, j):
    if s[i][j] < 0:
        return

    nxt = s[i][j]
    print nxt

    print_breaks(s, i, nxt)
    print_breaks(s, nxt, j)

best = break_string(0, strlen-1)
print "Best: " + str(best)
print "Iters: " + str(iters)
print_breaks(s, 0, strlen-1)
