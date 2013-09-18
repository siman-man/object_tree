require 'object_tree'
require 'active_record'

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


tree = ObjectTree::Tree.create(Numeric)
tree.draw

#tree = ObjectTree::Tree.create(Numeric, true)
tree = ObjectTree::Tree.create(Arel::Nodes::Node, true)
tree.draw
p tree.tree[Arel::Predications]
