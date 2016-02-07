from collections import deque
from graph import VertexDFS, Graph


def topo_sort(g):
    cntIn = {}
    for v in g.nodes:
        cntIn[v] = 0
    for v in g.nodes:
        if v.name in g.vertices:
            for u in g.vertices[v.name]:
                cntIn[u] = cntIn[u] + 1

    que = deque([])
    for v in g.nodes:
        if cntIn[v] == 0:
            que.append(v)

    while len(que):
        u = que.popleft()
        print u.name
        if u.name in g.vertices:
            for v in g.vertices[u.name]:
                cntIn[v] = cntIn[v] - 1
                if cntIn[v] == 0:
                    que.append(v)

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

graph.addEdge(m, [r,q,x])
graph.addEdge(n, [q,u,o])
graph.addEdge(o, [r,v,s])
graph.addEdge(p, [o,s,z])
graph.addEdge(q, [t])
graph.addEdge(r, [u,y])
graph.addEdge(s, [r])
graph.addEdge(u, [t])
graph.addEdge(v, [x,w])
graph.addEdge(w, [z])
graph.addEdge(y, [v])

topo_sort(graph)
