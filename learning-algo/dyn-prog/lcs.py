def enum(**enums):
    return type('Enum', (), enums)

dirs = enum(LEFT=0, UP=1, UP_LEFT=2)


def find_lcs(x, y):
    lenX = len(x)
    lenY = len(y)
    c = [[0 for j in range(-1, lenY)] for i in range(-1, lenX)]
    b = [[0 for j in range(lenY)] for i in range(lenX)]

    for i in range(0, lenX):
        for j in range(0, lenY):
            if x[i] == y[j]:
                c[i][j] = c[i-1][j-1] + 1
                b[i][j] = dirs.UP_LEFT
            elif c[i-1][j] >= c[i][j-1]:
                c[i][j] = c[i-1][j]
                b[i][j] = dirs.UP
            else:
                c[i][j] = c[i][j-1]
                b[i][j] = dirs.LEFT

    return c, b

memo = [[]]

iters = 0

def find_lcs_memo(x, y): 
    global memo
    lenX = len(x)
    lenY = len(y)
    memo = [[0 for j in range(-1, lenY)] for i in range(-1, lenX)]

    return find_lcs_memo_aux(x, y, lenX-1, lenY-1)

def find_lcs_memo_aux(x, y, i, j):
    if i == -1 or j == -1:
        return 0

    global memo
    if memo[i][j] > 0:
        return memo[i][j]

    global iters
    iters = iters + 1

    best = 0
    if x[i] == y[j]:
        best = find_lcs_memo_aux(x, y, i-1, j-1) + 1
    else:
        best = max(find_lcs_memo_aux(x, y, i-1, j), find_lcs_memo_aux(x, y, i, j-1))

    memo[i][j] = best
    return best


def print_lcs(b, x, i, j):
    if i == -1 or j == -1:
        return
    if b[i][j] == dirs.UP_LEFT:
        print_lcs(b, x, i-1, j-1)
        print x[i]
    elif b[i][j] == dirs.UP:
        print_lcs(b, x, i-1, j)
    else:
        print_lcs(b, x, i, j-1)

def print_lcs_c_table(c, x, y, i, j):
    if i == -1 or j == -1:
        return

    if x[i] == y[j]:
        print_lcs_c_table(c, x, y, i-1, j-1)
        print x[i]
    elif c[i-1][j] >= c[i][j-1]:
        print_lcs_c_table(c, x, y, i-1, j)
    else:
        print_lcs_c_table(c, x, y, i, j-1)

x = [1,0,0,1,0,1,0,1]
y = [0,1,0,1,1,0,1,1,0]

#x = list("ABCBDAB")
#y = list("BDCABA")

#c, b = find_lcs(x, y)
#print_lcs_c_table(c, x, y, len(x) - 1, len(y) - 1)
length = find_lcs_memo(x, y)
print_lcs_c_table(memo, x, y, len(x) - 1, len(y) - 1)
print "len: " + str(length)
print "iters: " + str(iters)
