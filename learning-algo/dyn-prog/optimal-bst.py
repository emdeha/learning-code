def enum(**enums):
    return type('Enum', (), enums)

dirs = enum(ROOT = 0, LEFT = 1, RIGHT = 2)

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

def dirStr(dir_):
    if dir_ == dirs.ROOT:
        return "root"
    elif dir_ == dirs.LEFT:
        return "left child of"
    elif dir_ == dirs.RIGHT:
        return "right child of"

def construct_optimal_bst(i, j, root, parent, dir_):
    if i > j:
        print "d_" + str(j) + " is the " + dirStr(dir_) + " k_" + str(parent)
        return

    childIdx = root[i][j]
    out =  "k_" + str(childIdx) + " is the " + dirStr(dir_)
    if dir_ != dirs.ROOT:
        out = out + " k_" + str(parent)
    print out

    construct_optimal_bst(i, childIdx - 1, root, childIdx, dirs.LEFT)
    construct_optimal_bst(childIdx + 1, j, root, childIdx, dirs.RIGHT)


p = [0.00, 0.15, 0.10, 0.05, 0.10, 0.20]
q = [0.05, 0.10, 0.05, 0.05, 0.05, 0.10]

e, root = optimal_bst(p, q, 5)
print "Costs: " + str(e)
print "Tree: " + str(root)
construct_optimal_bst(1, 5, root, 0, dirs.ROOT)
