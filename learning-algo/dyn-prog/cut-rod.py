#
# Brute-force solution
#
def cut_rod(p, n):
    if n == 0:
        return 0
    best = float("-inf")
    for i in range(0, n):
        best = max(best, p[i] + cut_rod(p, n-i-1))
    return best

#
# Dynamic programming solution using memoization
#
def cut_rod_memoized(p, n):
    r = [float("-inf")] * n
    return cut_rod_memoized_aux(p, n, r)

def cut_rod_memoized_aux(p, n, r):
    if r[n-1] >= 0:
        return r[n-1]

    best = float("-inf")
    if n == 0:
        best = 0
    else:
        for i in range(0, n):
            best = max(best, p[i] + cut_rod_memoized_aux(p, n-i-1, r))

    r[n-1] = best

    return best

#
# Dynamic programming solution using bottom-up method
#
def cut_rod_bottom_up(p, n):
    p.insert(0, 0)
    r = [0] * (n+1)

    for j in range(1, n+1):
        best = float("-inf")
        for i in range(1, j+1):
            best = max(best, p[i] + r[j - i])
        r[j] = best

    return r[n]

#
# Returning the places to cut
#
def cut_rod_extended(p, n, c):
    p.insert(0,0)
    r = [0] * (n+1)
    s = [0] * (n+1)

    for j in range(1, n+1):
        best = float("-inf")
        for i in range(1, j+1):
            if best < p[i] + r[j-i] - c:
                best = p[i] + r[j-i] - c
                s[j] = i
            else:
                best = best
        r[j] = best

    r[-1]
    return (r, s)

def cut_rod_print_solution(p, n, c):
    (r, s) = cut_rod_extended(p, n, c)
    while n > 0:
        print s[n]
        n = n - s[n]
    print r[-1]

#
# Adding a constant price for each cut
#
def cut_rod_price(p, n, c):
    p.insert(0, 0)
    r = [0] * (n+1)

    for j in range(1, n+1):
        best = float("-inf")
        for i in range(1, j+1):
            # We subtract the price from the current `best` solution
            best = max(best - c, p[i] + r[j - i])
        r[j] = best

    return r[n]


# p = [1, 5, 8, 9, 10, 17, 17, 20, 24, 30, 35, 35, 50, 70, 90, 96, 101, 112, 120, 125, 156]
p = [4, 4, 3, 3, 3]
# print "Best: " + str(cut_rod_price(p, 4, 1))
cut_rod_print_solution(p, 3, 2)
