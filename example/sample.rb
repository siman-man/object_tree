require 'object_tree'

class A
end

class B < A
end

class C < A
end

tree = ObjectTree::Tree.create(BasicObject, true)
tree.draw
