from graph import VertexDFS, colors, Graph


time = 0

def dfs_check_dag(graph):
    for u in sorted(graph.nodes, key=lambda n: n.name):
        if u.color == colors.WHITE:
            if dfs_visit(graph, u) == False:
                return False

    return True

def dfs_visit(graph, u):
    global time

    time = time + 1
    u.discovery_t = time
    u.color = colors.GRAY

    if u.name in graph.vertices:
        for v in graph.vertices[u.name]:
            if v.color == colors.GRAY:
                return False

            if v.color == colors.WHITE:
                v.path = u
                if dfs_visit(graph, v) == False:
                    return False

    time = time + 1
    u.finish_t = time
    u.color = colors.BLACK

    return True


def topo_sort(graph):
    if dfs_check_dag(graph):
        return sorted(graph.nodes, key=lambda n: n.finish_t)
    return None


def find_simple_paths_count(graph, start, end):
    cnt = 0

    sorted_nodes = topo_sort(graph)
    if sorted_nodes:
        visited = []
        find_simple_paths_count_step(start, end.parents, visited, cnt)

    return cnt


def find_simple_paths_count_step(start, parents, visited, cnt):
    for p in parents:
        if p == start:
            cnt += 1
            break
        elif p in visited:
            cnt += 1
        else:
            if p.parents:
                visited.append(p)
                find_simple_paths_count_step(start, p.parents, visited, cnt)


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

paths_cnt = find_simple_paths_count(graph, p, v)
print "Done! " + str(paths_cnt)
