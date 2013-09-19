require 'object_tree'
require 'rails'

module D
end

module E
end

module F
end

class A 
end

module C
end

class B < A
  include C
  include D
end



tree = ObjectTree::Tree.create(Object)
tree.draw

puts 

tree = ObjectTree::Tree.create(Object, true)
tree.draw
