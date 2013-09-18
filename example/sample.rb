require 'object_tree'

module D
end

module E
end

module F
end

module G
end

class A 
  prepend F
end

class B < A
  include D
  include E
  prepend G
end

class C < A
  include E
  include D
end


tree = ObjectTree::Tree.create(A)
tree.draw

tree = ObjectTree::Tree.create(Object, true)
tree.draw
