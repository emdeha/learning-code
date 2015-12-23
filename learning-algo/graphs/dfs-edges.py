#
# While doing DFS, assigns one of the following types to the graph
# edges:
#    1. T (tree edge) - (u, v) is a tree edge if `v` was first discovered by
#        exploring `u`
#    2. B (back edge) - (u, v) is back edge if it connects `u` to an ancestor
#        `v`.
#    3. F (forward edge) - (u, v) is a non-tree edge connecting `u` to a 
#        descendant `v` in a depth-first tree.
#    4. C (cross edge) - (u, v) is a cross edge if it's neither one of the 
#        three other types.
#
from graph import *


time = 0

def dfs(graph):
    for v in sorted(graph.nodes, key=lambda item: item.name):
        if v.color == colors.WHITE:
            dfs_visit(graph, v)

def dfs_visit(graph, start):
    global time

    time = time + 1
    start.discovery_t = time
    start.color = colors.GRAY

    for v in graph.vertices[start.name]:
        if v.color == colors.WHITE: # We are going forward
            v.path = start
            print "[" + start.name + "->" + v.name + "] is a `tree` edge."
            dfs_visit(graph, v)
        if v.color == colors.GRAY: # We are going back
            print "[" + start.name + "->" + v.name + "] is a `back` edge."
        if v.color == colors.BLACK:
            if start in graph.vertices[v.name]: # If there's an undirected node
                print "[" + start.name + "->" + v.name + "] is a `back` edge."
            else:
                if start.discovery_t < v.discovery_t: # We are in the same forest
                    print "[" + start.name + "->" + v.name + "] is a `forward` edge."
                if start.discovery_t > v.discovery_t: # We come from another forest
                    print "[" + start.name + "->" + v.name + "] is a `cross` edge."

    time = time + 1
    start.finish_t = time
    start.color = colors.BLACK


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

# Undirected graph
# testGraph.addEdge('u', [v, x])
# testGraph.addEdge('v', [u, x, y])
# testGraph.addEdge('w', [y, z])
# testGraph.addEdge('x', [u, v, y])
# testGraph.addEdge('y', [x, v, w])
# testGraph.addEdge('z', [z, w])

# Directed graph
testGraph.addEdge('u', [v, x])
testGraph.addEdge('v', [y])
testGraph.addEdge('w', [y, z])
testGraph.addEdge('x', [v])
testGraph.addEdge('y', [x])
testGraph.addEdge('z', [z])


dfs(testGraph)
import pdb; pdb.set_trace()
print "Done!"
