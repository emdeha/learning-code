from copy import copy


class Edge:
    # We just need the end vertex for an edge. The begin vertex would
    # be stored in ViterbiGraph::edges
    def __init__(self, v, label, prob):
        self.v = v
        self.label = label
        self.prob = prob

    def __repr__(self):
        return self.label + '->' + self.v + " " + str(self.prob * 100) + "%"

class ViterbiGraph:
    def __init__(self):
        self.edges = {}

    def addEdge(self, u, e):
        if u in self.edges:
            self.edges[u].append(e)
        else:
            self.edges[u] = [e]


iters = 0


def viterbi(g, s, v):
    if not v in g.edges:
        return 'No such path'

    nxt = s.pop(0)

    for e in g.edges[v]:
        if e.label == nxt:
            (isFound, label) = viterbi_step(g, copy(s), e.v, v)
            if isFound:
                return label

    return 'No such path'

def viterbi_step(g, rest_s, v, label):
    if len(rest_s) == 0:
        return True, label + v

    if not v in g.edges:
        return False, ''

    global iters
    iters = iters + 1

    nxt = rest_s.pop(0)

    for e in g.edges[v]:
        if e.label == nxt:
            (isFound, lbl) = viterbi_step(g, copy(rest_s), e.v, label + v)
            if isFound:
                return True, lbl

    return False, ''

################
#
# A rather complex graph

# speech = ViterbiGraph()
# 
# speech.addEdge('a', Edge('b', 'new'))
# speech.addEdge('a', Edge('c', 'new'))
# speech.addEdge('a', Edge('d', 'new'))
# speech.addEdge('b', Edge('e', 'yo'))
# speech.addEdge('b', Edge('f', 'yo'))
# speech.addEdge('c', Edge('g', 'ks'))
# speech.addEdge('c', Edge('h', 'k'))
# speech.addEdge('d', Edge('i', 'ma'))
# speech.addEdge('d', Edge('j', 'mi'))
# speech.addEdge('e', Edge('k', 'r'))
# speech.addEdge('f', Edge('k', 'r'))
# speech.addEdge('g', Edge('l', 'el'))
# speech.addEdge('g', Edge('m', 'el'))
# speech.addEdge('h', Edge('n', 'r'))
# speech.addEdge('i', Edge('n', 'ma'))
# speech.addEdge('i', Edge('r', 'ra'))
# speech.addEdge('j', Edge('i', 'ji'))
# speech.addEdge('k', Edge('o', 'ksh'))
# speech.addEdge('k', Edge('h', 'k'))
# speech.addEdge('m', Edge('p', 'er'))
# speech.addEdge('n', Edge('r', 'ni'))
# speech.addEdge('o', Edge('s', 'pr'))
# speech.addEdge('p', Edge('l', 't'))
# speech.addEdge('r', Edge('q', 'va'))
# speech.addEdge('q', Edge('n', 'pa'))

#
#
################


################
#
# Tests for Viterbi without probabilities

# choosing between two possible paths, one of which can't be used
# returns acgmp
# start = 'a'
# s = ['new', 'ks', 'el', 'er']

# cycling a couple of times
# returns hnrqnrqnrqn
# start = 'h'
# s = ['r', 'ni', 'va', 'pa', 'ni', 'va', 'pa', 'ni', 'va', 'pa']

# one edge
# returns ek
# start = 'e'
# s = ['r']

# no such path
# start = 'a'
# s = ['new', 'yo', 'ma']

# no such path after cycles
# start = 'h'
# s = ['r', 'ni', 'va', 'pa', 'ni', 'va', 'pa', 'ni', 'va', 'pa', 'ma']

# a path ending in a leaf
# returns abekos
# start = 'a'
# s = ['new', 'yo', 'r', 'ksh', 'pr']

# going from one forest to another
# returns dinrq
# start = 'd'
# s = ['ma', 'ma', 'ni', 'va']

#
#
################

################
#
# Tests for Viterbi with probabilities

#
#
################


print viterbi(speech, s, start)
print "iters: " + str(iters)
