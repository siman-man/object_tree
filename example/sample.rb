require 'object_tree'

module E
end

module D
  prepend E
end

module F
end

module C
  include D
end

class A
  prepend F
end

class B < A
  prepend C
end


#tree = ObjectTree::Tree.create(Object)
#tree.draw

tree = ObjectTree::Tree.create(Numeric, true)
p tree.tree
tree.draw
