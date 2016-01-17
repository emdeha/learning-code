def optimal_bst(p, q, n):
    e = [[0 for x in range(0, n+1)] for x in range(0, n+2)]
    w = [[0 for x in range(0, n+1)] for x in range(0, n+2)]
    root = [[0 for x in range(0, n+1)] for x in range(0, n+1)]

    for i in range(1, n+2):
        e[i][i-1] = q[i-1]
        w[i][i-1] = q[i-1]

    for l in range(1, n+1):
        for i in range(1, n-l+2):
            j = i + l - 1
            e[i][j] = float("inf")
            w[i][j] = w[i][j-1] + p[j] + q[j]
            for r in range(i, j+1):
                best = e[i][r-1] + e[r+1][j] + w[i][j]
                if best < e[i][j]:
                    e[i][j] = best
                    root[i][j] = r

    return e, root

p = [0.00, 0.15, 0.10, 0.05, 0.10, 0.20]
q = [0.05, 0.10, 0.05, 0.05, 0.05, 0.10]

e, root = optimal_bst(p, q, 5)
print "Costs: " + str(e)
print "Tree: " + str(root)
