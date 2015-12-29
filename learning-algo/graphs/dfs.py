from graph import *


time = 0

def dfs(graph):
    for node in sorted(graph.nodes, key=lambda item: item.name):
        if node.color == colors.WHITE:
            print "Creating new tree: " + node.name
            dfs_visit_iter(graph, node)


def dfs_visit_rec(graph, start):
    global time

    time = time + 1
    start.discovery_t = time
    start.color = colors.GRAY

    for v in graph.vertices[start.name]:
        if v.color == colors.WHITE:
            v.path = start
            dfs_visit_rec(graph, v)

    start.color = colors.BLACK
    time = time + 1
    start.finish_t = time


def dfs_visit_iter(graph, start):
    global time

    start.color = colors.GRAY

    stack = [(start, None)]
    while len(stack):
        (u, p) = stack.pop()

        time = time+1
        u.discovery_t = time
        u.color = colors.GRAY

        allGray = True
        for v in sorted(graph.vertices[u.name], key=lambda item: item.name):
            if v.color == colors.WHITE:
                allGray = False
                stack.append((v, u))

        if allGray:
            time = time + 1
            u.finish_t = time
            u.color = colors.BLACK
            u.path = p

            time = time + 1
            p.color = colors.BLACK
            p.finish_t = time


u = VertexDFS('u')
v = VertexDFS('v')
w = VertexDFS('w')
x = VertexDFS('x')
y = VertexDFS('y')
z = VertexDFS('z')

testGraph = Graph()

testGraph.addVertex(u)
testGraph.addVertex(v)
testGraph.addVertex(w)
testGraph.addVertex(x)
testGraph.addVertex(y)
testGraph.addVertex(z)

testGraph.addEdge('u', [v, x])
testGraph.addEdge('v', [y])
testGraph.addEdge('w', [y, z])
testGraph.addEdge('x', [v])
testGraph.addEdge('y', [x])
testGraph.addEdge('z', [z])


dfs(testGraph)
import pdb; pdb.set_trace()
print "Done!"
