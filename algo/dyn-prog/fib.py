#
# Finding the n-th Fibonacci number with memoization
#
def fib(n):
    found = []
    found.insert(0, 0)
    found.insert(1, 1)

    for i in range(2, n+1):
        found.insert(i, found[i-1] + found[i-2])

    return found[n-1]

def fib_rec(n):
    if n == 1:
        return 0
    if n == 2:
        return 1

    return fib_rec(n-1) + fib_rec(n-2)
    

print "n-th fib: " + str(fib_rec(32))
