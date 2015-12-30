#
# Identifies connected components in a graph.
#
from graph import VertexDFS, colors, Graph


time = 0

def is_singly_connected(graph):
    for v in sorted(graph.nodes, key=lambda item: item.name):
        if v.color == colors.WHITE:
            if is_singly_connected_visit(graph, v) == False:
                return False
    return True

def is_singly_connected_visit(graph, start):
    global time

    start.color = colors.GRAY
    time = time + 1
    start.discovery_t = time

    if start.name in graph.vertices:
        for v in graph.vertices[start.name]:
            if v.color == colors.WHITE:
                v.path = start
                if is_singly_connected_visit(graph, v) == False:
                    return False
            elif (v.color == colors.BLACK and v.discovery_t > start.discovery_t) or\
                    (v.color == colors.GRAY and v.path != None):
                # We have another way of reaching a vertex
                return False

    time = time + 1
    start.finish_t = time
    start.color = colors.BLACK

    return True


def ok(value, expected, title):
    print "Runing `" + title + "`"
    if value == expected:
        print "\tsucceeded!"
    else:
        print "\tfailed :/"


a = VertexDFS('a')
b = VertexDFS('b')
c = VertexDFS('c')
d = VertexDFS('d')
e = VertexDFS('e')
f = VertexDFS('f')
g = VertexDFS('g')
h = VertexDFS('h')
i = VertexDFS('i')
j = VertexDFS('j')
k = VertexDFS('k')

graph = Graph()
graph.addVertex(a)
graph.addVertex(b)
graph.addVertex(c)
graph.addVertex(d)
graph.addVertex(e)
graph.addVertex(f)
graph.addVertex(g)
graph.addVertex(h)
graph.addVertex(i)
graph.addVertex(j)
graph.addVertex(k)


#
# Tests
#
graph.addEdge(a, [b,c,d])
graph.addEdge(b, [d])
graph.addEdge(d, [e])

ok(is_singly_connected(graph), False,\
        "five-node random graph")

graph.clearEdges()

###

graph.addEdge(a, [b])
graph.addEdge(b, [c])
graph.addEdge(c, [d])
graph.addEdge(d, [a])

ok(is_singly_connected(graph), True,\
        "four-node circular")

graph.clearEdges()

###

graph.addEdge(a, [b])
graph.addEdge(b, [c])
graph.addEdge(c, [d])
graph.addEdge(d, [e])
graph.addEdge(e, [b])

ok(is_singly_connected(graph), False,\
        "five-node circular")

print "Done!"
