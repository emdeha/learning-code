import random


def heap_left(i):
    return 2 * i

def heap_right(i):
    return 2 * i + 1

def max_heapify(ls, i, heap_size):
    l = heap_left(i)
    r = heap_right(i)
    largest = i
    if l < heap_size and ls[largest] < ls[l]:
        largest = l
    if r < heap_size and ls[largest] < ls[r]:
        largest = r
    if largest != i:
        ls[largest], ls[i] = ls[i], ls[largest]
        max_heapify(ls, largest, heap_size)

def build_max_heap(ls):
    heap_size = len(ls)
    for i in reversed(range(1, len(ls)/2)):
        max_heapify(ls, i, heap_size)

def heap_sort(ls):
    build_max_heap(ls)
    heap_size = len(ls)
    for i in reversed(range(2, len(ls))):
        ls[i], ls[1] = ls[1], ls[i]
        heap_size -= 1
        max_heapify(ls, 1, heap_size)


# We start from idx 1
ls = [-1] + random.sample(range(10000), 10000)
heap_sort(ls)

print ls[1:]
