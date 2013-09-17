require 'object_tree'

p tree = ObjectTree::Tree.create(BasicObject, true)
#obj_list = tree.object_list
#obj_list = tree.object_tree(obj_list)
tree.draw
