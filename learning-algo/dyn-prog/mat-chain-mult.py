import sys


def matrix_chain_order(p):
    n = len(p) - 1
    m = [[0 for x in range(n+1)] for x in range(n+1)]
    s = [[0 for x in range(n+1)] for x in range(n+1)]

    for l in range(2, n+1):
        for i in range(1, n - l + 2):
            j = i + l - 1
            m[i][j] = float("inf")
            for k in range(i, j):
                q = m[i][k] + m[k+1][j] + p[i-1]*p[k]*p[j]
                if q < m[i][j]:
                    m[i][j] = q
                    s[i][j] = k

    return (m, s)

def print_mult(s, i, j):
    if i == j:
        sys.stdout.write("A" + str(i))
    else:
        sys.stdout.write("(")
        print_mult(s, i, s[i][j])
        sys.stdout.write("*")
        print_mult(s, s[i][j] + 1, j)
        sys.stdout.write(")")


(m, s) = matrix_chain_order([5,10,3,12,5,50,6])
print_mult(s, 1, 6)
print "\nDone!"
