#
# Finds the diamater of a tree
#
from collections import deque
from graph import *


def bfs(graph, start):
    start.distance = 0
    start.color = colors.GRAY

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

def find_diameter(tree, treeRoot):
    bfs(tree, treeRoot)

    max_depth = 0
    for node in tree.nodes:
        if node.distance > max_depth:
            max_depth = node.distance

    return max_depth


root = Vertex('root')
one = Vertex('one')
two = Vertex('two')
three = Vertex('three')
four = Vertex('four')
five = Vertex('five')
six = Vertex('six')
seven = Vertex('seven')
eight = Vertex('eight')
nine = Vertex('nine')
ten = Vertex('ten')
eleven = Vertex('eleven')
twelve = Vertex('twelve')

tree = Graph()

tree.addVertex(root)
#tree.addVertex(one)
#tree.addVertex(two)
#tree.addVertex(three)
#tree.addVertex(four)
#tree.addVertex(five)
#tree.addVertex(six)
#tree.addVertex(seven)
#tree.addVertex(eight)
#tree.addVertex(nine)
#tree.addVertex(ten)
#tree.addVertex(eleven)
#tree.addVertex(twelve)

tree.addEdge(root, [])
#tree.addEdge(root, [one, two, three])
#tree.addEdge(one, [root, four, five])
#tree.addEdge(two, [root, six, seven])
#tree.addEdge(three, [root, eight])
#tree.addEdge(four, [one, nine])
#tree.addEdge(five, [nine])
#tree.addEdge(six, [two])
#tree.addEdge(seven, [two, ten])
#tree.addEdge(eight, [three])
#tree.addEdge(nine, [four])
#tree.addEdge(ten, [seven, eleven])
#tree.addEdge(eleven, [ten, twelve])
#tree.addEdge(twelve, [eleven])


diam = find_diameter(tree, root)
print "Done! Diameter: " + str(diam)
