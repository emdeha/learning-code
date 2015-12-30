from graph import VertexDFS, colors, Graph


time = 0

def dfs(graph):
    for u in sorted(graph.nodes, key=lambda n: n.name):
        if u.color == colors.WHITE:
            dfs_visit(graph, u)

def dfs_visit(graph, u):
    global time

    time = time + 1
    u.discovery_t = time
    u.color = colors.GRAY

    if u.name in graph.vertices:
        for v in graph.vertices[u.name]:
            if v.color == colors.WHITE:
                v.path = u
                dfs_visit(graph, v)

    time = time + 1
    u.finish_t = time
    u.color = colors.BLACK


def topo_sort(graph):
    dfs(graph)
    return sorted(graph.nodes, key=lambda n: n.finish_t)


m = VertexDFS('m')
n = VertexDFS('n')
o = VertexDFS('o')
p = VertexDFS('p')
q = VertexDFS('q')
r = VertexDFS('r')
s = VertexDFS('s')
t = VertexDFS('t')
u = VertexDFS('u')
v = VertexDFS('v')
w = VertexDFS('w')
x = VertexDFS('x')
y = VertexDFS('y')
z = VertexDFS('z')

graph = Graph()
graph.addVertex(m)
graph.addVertex(n)
graph.addVertex(o)
graph.addVertex(p)
graph.addVertex(q)
graph.addVertex(r)
graph.addVertex(s)
graph.addVertex(t)
graph.addVertex(u)
graph.addVertex(v)
graph.addVertex(w)
graph.addVertex(x)
graph.addVertex(y)
graph.addVertex(z)

graph.addEdge(m, [r,q,x], True)
graph.addEdge(n, [q,u,o], True)
graph.addEdge(o, [r,v,s], True)
graph.addEdge(p, [o,s,z], True)
graph.addEdge(q, [t], True)
graph.addEdge(r, [u,y], True)
graph.addEdge(s, [r], True)
graph.addEdge(u, [t], True)
graph.addEdge(v, [x,w], True)
graph.addEdge(w, [z], True)
graph.addEdge(y, [v], True)

sorted_nodes = topo_sort(graph)
print "Done!"
