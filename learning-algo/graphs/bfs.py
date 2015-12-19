from collections import deque
from graph import *


def breadth_first_search(graph, start):
    start.color = colors.GRAY
    start.distance = 0

    que = deque([start])
    while len(que):
        u = que.popleft()
        for v in graph.vertices[u.name]:
            if v.color == colors.WHITE:
                v.color = colors.GRAY
                v.path = u
                v.distance = u.distance + 1
                que.append(v)
        u.color = colors.BLACK

def print_path(start, end):
    if start.name == end.name:
        print start.name
    elif end.path == None:
        print "No path from " + start.name + " to " + end.name
    else:
        print_path(start, end.path)
        print end.name


r = Vertex('r')
s = Vertex('s')
t = Vertex('t')
u = Vertex('u')
v = Vertex('v')
w = Vertex('w')
x = Vertex('x')
y = Vertex('y')

testGraph = Graph()
testGraph.addVertex('r', [s, v])
testGraph.addVertex('s', [r, w])
testGraph.addVertex('t', [w, x, u])
testGraph.addVertex('u', [t, x, y])
testGraph.addVertex('v', [r])
testGraph.addVertex('w', [s, t, x])
testGraph.addVertex('x', [w, t, u, y])
testGraph.addVertex('y', [x, u])


breadth_first_search(testGraph, s)
print_path(s, y)
