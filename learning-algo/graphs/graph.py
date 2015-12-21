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
        for v in self.vertices.keys():
            graph_repr += v + ":\n" + str(self.vertices[v]) + "\n";
        return graph_repr

    def addVertex(self, v, children):
        self.vertices[v] = children
        self.nodes.update(children)
