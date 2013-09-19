require 'object_tree'

module D
end

module E
end

class A
  include D
end

class B < A
end

class C < A
  include E
end

tree = ObjectTree::Tree.create(A, true)
tree.draw
