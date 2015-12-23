from graph import *


time = 0

def dfs(graph):
    global time
    for node in graph.nodes:
        if node.color == colors.WHITE:
            dfs_visit_rec(graph, node)


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


def dfs_visit_iter(graph, start, time):
    stack = [start]
    while len(stack):
        u = stack.pop()

        time = time+1
        u.discovery_t = time
        u.color = colors.GRAY

        for v in graph.vertices[u.name]:
            if v.color == colors.WHITE:
                stack.append(v)


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
print "Done!"
