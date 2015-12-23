#
# In professional wrestling there are two types of wrestlers -
# 'babyfaces' and 'heels'. Given `n` wrestlers, and `r` rivalries,
# can you designate some of the wrestlers as `babyfaces` and the rest 
# as `heels` such that there ain't matches between wrestlers of the
# same type.
#
from collections import deque
from graph import *


def neg_color(col):
    if col == colors.WHITE:
        return colors.BLACK
    if col == colors.BLACK:
        return colors.WHITE

# Determines whether a graph could be colored in such a way
# that each `white` vertex only leads to `black` vertices and each
# `black` vertex only leads to `white` vertices.
def bfs_color(graph, start):
    start.color = colors.WHITE
    que = deque([start])
    while len(que):
        u = que.popleft()
        for v in graph.vertices[u.name]:
            if not v.passed:
                if neg_color(u.color) in map(lambda x: x.color, graph.vertices[v.name]):
                    return False
                v.color = neg_color(u.color)
                que.append(v)
        u.passed = True
    return True


john     = VertexColoring('john')
badface  = VertexColoring('badface')
mike     = VertexColoring('mike')
vladimir = VertexColoring('vladimir')
ilian    = VertexColoring('ilian')
seiko    = VertexColoring('seiko')


rivalries = Graph()

rivalries.addVertex(john)
rivalries.addVertex(badface)
rivalries.addVertex(mike)
rivalries.addVertex(vladimir)
rivalries.addVertex(ilian)
rivalries.addVertex(seiko)

rivalries.addEdge('john', [mike, vladimir, badface])
rivalries.addEdge('badface', [mike, john])
rivalries.addEdge('mike', [ilian, badface, john])
rivalries.addEdge('vladimir', [john, ilian])
rivalries.addEdge('ilian', [mike, seiko, vladimir])
rivalries.addEdge('seiko', [ilian])

def get_babyfaces(wrestlers):
    babyfaces = []
    for w in wrestlers:
        if w.color == colors.WHITE:
            babyfaces.append(w.name)
    return babyfaces

def get_heels(wrestlers):
    heels = []
    for w in wrestlers:
        if w.color == colors.BLACK:
            heels.append(w.name)
    return heels

if bfs_color(rivalries, john):
    wrestlers = [john, badface, mike, vladimir, ilian, seiko]
    print "It's possible!"
    print "Babyfaces: " + ", ".join(get_babyfaces(wrestlers))
    print "Heels: " + ", ".join(get_heels(wrestlers))
else:
    print "It ain't possible!"
