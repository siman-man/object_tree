require 'object_tree'

tree = ObjectTree::Tree.new(Numeric)
obj_list = tree.object_list
obj_list = tree.object_tree(obj_list)
tree.draw(obj_list)

tree.module_proc
obj_list =  tree.object_list_module
tree.draw(obj_list)
