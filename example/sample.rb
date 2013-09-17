require 'object_tree'

tree = ObjectTree::Tree.create(Object)
tree.draw

tree = ObjectTree::Tree.create(Numeric, true)
tree.draw
