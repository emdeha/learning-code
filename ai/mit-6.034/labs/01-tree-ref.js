var treeRef = function (tree, path) {
  var subtree = tree[path[0]]
  for (var i = 0; i < path.length; i++) {
    if (typeof subtree === 'undefined') {
      return null
    }
    if (i === 0) continue

    subtree = subtree[path[i]]
  }

  return subtree
}

var testTree = [[[1, 2], 3], [4, [5, 6]], 7, [8, 9, 10]]
console.log(treeRef(testTree, [5]))
console.log(treeRef(testTree, [1, 1, 1]))
console.log(treeRef(testTree, [3, 1]))
console.log(treeRef(testTree, [0]))
