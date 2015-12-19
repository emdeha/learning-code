def enum(**enums):
    return type('Enum', (), enums)

colors = enum(WHITE=0, GRAY=1, BLACK=2)


class Vertex:
    def __init__(self, name):
        self.name = name
        self.path = None
        self.color = colors.WHITE
        self.distance = float("inf")


class Graph:
    def __init__(self):
        self.vertices = {}

    def addVertex(self, v, children):
        self.vertices[v] = children
