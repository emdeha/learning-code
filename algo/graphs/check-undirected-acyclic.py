from graph import VertexDFS, colors, Graph


def dfs_check_uag(graph):
    for u in sorted(graph.nodes, key=lambda n: n.name):
        if u.color == colors.WHITE:
            if dfs_visit(graph, u) == False:
                return False

    return True

def dfs_visit(graph, u):
    u.color = colors.GRAY

    if u.name in graph.vertices:
        for v in  graph.vertices[u.name]:
            if v.color in [colors.GRAY, colors.BLACK]:
                return False

            if v.color == colors.WHITE:
                if dfs_visit(graph, v) == False:
                    return False

    u.color = colors.BLACK

    return True


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


is_acyclic = dfs_check_uag(graph)
print "Is acyclic: " + str(is_acyclic)
