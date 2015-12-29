from sets import Set


def enum(**enums):
    return type('Enum', (), enums)

colors = enum(WHITE=0, GRAY=1, BLACK=2)


def parent(s):
    return '' if s is None else str(s.name)

class Vertex:
    def __init__(self, name):
        self.name = name
        self.path = None
        self.color = colors.WHITE
        self.distance = float("inf")

    def __repr__(self):
        return ("\tName:  " + str(self.name) + "\n"
            "\tPath:  " + parent(self.path) + "\n"
            "\tColor: " + str(self.color) + "\n"
            "\tDist:  " + str(self.distance) + "\n")

class VertexDFS:
    def __init__(self, name):
        self.name = name
        self.path = None
        self.color = colors.WHITE
        self.discovery_t = 0
        self.finish_t = 0

    def __repr__(self):
        return ("\tName:  " + str(self.name) + "\n"
            "\tPath:  " + parent(self.path) + "\n"
            "\tColor: " + str(self.color) + "\n"
            "\tDiscovery Time:  " + str(self.discovery_t) + "\n"
            "\tFinish Time: " + str(self.finish_t) + "\n")

class VertexConnected(VertexDFS):
    def __init__(self, name):
        VertexDFS.__init__(self, name)
        self.cc = None

    def __repr__(self):
        base_repr = VertexDFS.__repr__(self)
        return base_repr + "\tConnected Component: " + str(self.cc) + "\n"


# Special type of vertex for solving the graph coloring problem
# in pro-wrestlers.py
class VertexColoring:
    def __init__(self, name):
        self.name = name
        self.passed = False
        self.color = colors.GRAY

    def __repr__(self):
        return ("\tName: " + str(self.name) + "\n"
            "\tColor: " + str(self.color) + "\n"
            "\tPassed: " + str(self.passed) + "\n")


class Graph:
    def __init__(self):
        self.vertices = {}
        self.nodes = Set()

    def __repr__(self):
        graph_repr = ""
        for n in self.nodes:
            graph_repr += str(n) + "\n"
        return graph_repr

    def addEdge(self, v, children):
        self.vertices[v] = children

    def addVertex(self, node):
        self.nodes.update([node])

    def clearEdges(self):
        self.vertices = {}
