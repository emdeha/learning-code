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
tree.addVertex('root', [])
#tree.addVertex('root', [one, two, three])
#tree.addVertex('one', [root, four, five])
#tree.addVertex('two', [root, six, seven])
#tree.addVertex('three', [root, eight])
#tree.addVertex('four', [one, nine])
#tree.addVertex('five', [nine])
#tree.addVertex('six', [two])
#tree.addVertex('seven', [two, ten])
#tree.addVertex('eight', [three])
#tree.addVertex('nine', [four])
#tree.addVertex('ten', [seven, eleven])
#tree.addVertex('eleven', [ten, twelve])
#tree.addVertex('twelve', [eleven])


diam = find_diameter(tree, root)
print "Done! Diameter: " + str(diam)
