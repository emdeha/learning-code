import random

def merge_sort(ls, st, end):
    if st < end-1:
        mid = (st + end) / 2
        merge_sort(ls, st, mid)
        merge_sort(ls, mid, end)
        merge(ls, st, mid, end)

def merge(ls, st, mid, end):
    left = []
    for i in range(st, mid):
        left.append(ls[i])
    right = []
    for i in range(mid, end):
        right.append(ls[i])

    i = 0
    j = 0
    k = st
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            ls[k] = left[i]
            i+=1
        else:
            ls[k] = right[j]
            j+=1
        k+=1

    while i < len(left):
        ls[k] = left[i]
        i+=1
        k+=1

    while j < len(right):
        ls[k] = right[j]
        j+=1
        k+=1


def insertion_sort(ls, lenls):
    for i in range(1, lenls):
        key = ls[i]
        j = i - 1
        while j >= 0 and ls[j] > key:
            ls[j+1] = ls[j]
            j-=1
        ls[j+1] = key


ls = random.sample(range(10000), 10000)
#insertion_sort(ls, len(ls))
merge_sort(ls, 0, len(ls))

print ls
