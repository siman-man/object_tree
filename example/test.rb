a = ObjectSpace.each_object(Class).to_a
require 'rails'
b = ObjectSpace.each_object(Class).to_a

puts (b - a)
