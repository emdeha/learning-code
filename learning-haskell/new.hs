type Node = String

data Graph = Node Graph | Node deriving (Show)

dfs :: Graph -> Graph
dfs graph =
    
