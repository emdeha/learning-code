#
# Identifies connected components in a graph.
#
from graph import VertexConnected, colors, Graph


time = 0
cc_class = 1

def find_cc(graph):
    global cc_class

    for v in sorted(graph.nodes, key=lambda item: item.name):
        if v.color == colors.WHITE:
            find_cc_visit(graph, v)
            cc_class = cc_class + 1

def find_cc_visit(graph, start):
    global time
    global cc_class

    start.color = colors.GRAY
    time = time + 1
    start.discovery_t = time
    start.cc = cc_class

    for v in graph.vertices[start.name]:
        if v.color == colors.WHITE:
            v.path = start
            find_cc_visit(graph, v)

    time = time + 1
    start.finish_t = time
    start.color = colors.BLACK


a = VertexConnected('a')
b = VertexConnected('b')
c = VertexConnected('c')
d = VertexConnected('d')
x = VertexConnected('x')
y = VertexConnected('y')
z = VertexConnected('z')
u = VertexConnected('u')
v = VertexConnected('v')
w = VertexConnected('w')

graph = Graph()
graph.addVertex(a)
graph.addVertex(b)
graph.addVertex(c)
graph.addVertex(d)
graph.addVertex(x)
graph.addVertex(y)
graph.addVertex(z)
graph.addVertex(u)
graph.addVertex(v)
graph.addVertex(w)

graph.addEdge('a', [y, z])
graph.addEdge('b', [c])
graph.addEdge('c', [b])
graph.addEdge('d', [d])
graph.addEdge('x', [y])
graph.addEdge('y', [a, x, z])
graph.addEdge('z', [a, y])
graph.addEdge('u', [v, w])
graph.addEdge('v', [u, w])
graph.addEdge('w', [u, v])


find_cc(graph)
print "Done!"
