# encoding: utf-8
require "object_tree/version"

module ObjectTree
  class Module
    def prepended_modules
      ancestors = self.ancestors
      ancestors[0..ancestors.find_index(self)] - [self]
    end 
  end

  class Tree
    attr_reader :tree
    SPACE_SIZE = 8

    def initialize(klass, mod = false)
      @tree = Hash.new{|h, k| h[k] = [] }
      @mod = mod
      @klass = klass
      @check_list = Hash.new
      @diff = 1

      if klass == BasicObject
        klass = Object
        @diff = 0
        @superclass = BasicObject
        if mod
          @tree[BasicObject] << Kernel
        end
      else
        @superclass = klass.superclass
      end

      if mod
        @tree_in_module = Hash.new{|h, k| h[k] = [] }
        object_list_in_module(klass)
        create_object_tree_in_module
      else
        create_object_tree(object_list(klass))
      end
    end

    class << self
      def create(klass, mod = false)
        Tree.new(klass, mod)
      end
    end

    def singleton(klass)
      class << klass; self end
    end

    def compare_object(a, b)
      if a.class == Class && b.class == Class
        a > b
      elsif a.class == Class && b.class == Module
        a.prepended_modules.include?(b)
      elsif a.class == Module && b.class == Class
        !b.prepended_modules.include?(a)
      elsif a.class == Module && b.class == Module
        a.prepended_modules.include?(b)
      end
    end

    def object_list(klass)
      ObjectSpace.each_object(singleton(klass)) do |subclass| 
        if klass != subclass
          @tree[klass] << subclass
          object_list(subclass) unless @tree.has_key?(subclass)
        end
      end

      @tree
    end

    def object_list_in_module(klass, nest = 0)
      @tree[klass] = klass.ancestors[0..klass.ancestors.find_index(@superclass)-@diff].reverse

      ObjectSpace.each_object(singleton(klass)) do |subclass|
        if klass != subclass
          object_list_in_module(subclass, (nest + 1)) unless @tree.has_key?(subclass)
        end
      end

      @tree
    end

    def create_object_tree(tree)
      p @tree
      tree.each do |key1 , value1|
        tree.each do |key2, value2|
          if key1 > key2
            tree[key1] -= (value2 - [key2])
          end
        end
      end
      p @tree

      tree
    end

    def create_tree_module(tree)
      tree.each do |key, value|
        value.each_cons(2) do |k, v|
          if !@tree_in_module[k].include?(v) && !@tree_in_module.has_key?(v)
            @tree_in_module[k] << v 
          end
        end
      end

      @tree_in_module
    end 


    def create_object_tree_in_module
      @tree.each do |key1 , value1|
        @tree.each do |key2, value2|
          if compare_object(key1, key2)
            @tree[key2] -= [key1]
          end
        end
      end

      @tree = create_tree_module(@tree)
    end

    def draw
      @last_list = []
      @node = (@mod)? @tree_in_module : @tree
      if @node.size.zero? 
        puts @klass
      else
        draw_tree({ @node.first.first => @node.first.last }, 0)
      end
    end

    def draw_tree(tree, nest, root = true, last = false)

      @last_list[nest-1] = last if nest > 0

      tree.each do |key, value|

        print ( key.class == Class )? "<C>" : "<M>"
        puts key

        value.each do |v|
          @last_list[nest] = true if v == value.last

          if (!root && !last) || (nest > 0 && last)
            nest.times do |index|
              print (@last_list[index])? "  " : "│ "
              print " " * SPACE_SIZE
            end
          end

          if @node.has_key?(v)
            if v == value.last
              print "└─ ─ ── "
              draw_tree({ v => @node[v]}, nest + 1, false, true)
            else
              print "├─ ─ ── "
              draw_tree({ v => @node[v]}, nest + 1, false, false)
            end
          else
            print ( v == value.last )? "└─ ─ ── " : "├─ ─ ── "
            print ( v.class == Class )? "<C>" : "<M>"
            p v
          end
        end
      end
    end
  end
end
