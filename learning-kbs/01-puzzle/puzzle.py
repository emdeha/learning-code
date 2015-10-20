import sys
from collections import deque


def bfs(start, end):
    que = deque()
    que.append(start)
    visited = [start]

    while len(que) > 0:
        x = que.popleft()
        if x.val == end.val:
            reverse(construct_path_from_end(x, []))
        for chld in get_children(x):
            if chld not in visited:
                que.append(chld)

def gen_children(node):
    val = node['val']
    for i in range(0,3):
        if 'X' in val[i]:
            [node['val']
            break

def construct_path_from_end(node, path):
    path.append(node['val'])
    if node['parent']:
        construct_path_from_end(node['parent'], path)


rows = 3
def input_to_node(string):
    node = {}
    i = 0
    row = []
    for ch in string:
        row.append(ch)
        i+=1
        if i % 3 == 0:
            node['val'].append(row)
    node['parent'] = None
    node['xPos'] = [xCoord, yCoord]


def solve(start, end):
    [start, bfs(start, end)]


start = input_to_node(sys.argv[1])
end = input_to_node(sys.argv[2])

print solve(start, end)
