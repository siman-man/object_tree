# encoding: utf-8
require "object_tree/version"

module ObjectTree
  class Tree
    attr_reader :tree
    SIZE = 6

    def initialize(klass, mod: false)
      @tree = Hash.new{|h, k| h[k] = [] }
      @klass = klass
      @hash = Hash.new
      @check_list = Hash.new
      @diff = 1

      if klass == BasicObject
        klass = Object
        @diff = 0
        @base = BasicObject
        if mflag
          @hash = Hash.new
        else
          @tree[BasicObject] << Object
        end
      else
        @base = klass.superclass
      end
    end

    def singleton(klass)
      class << klass; self end
    end

    def object_list(klass = @klass)
      @hash[klass] = klass.ancestors[0..klass.ancestors.index(@base)-@diff].reverse

      object_list = []

      ObjectSpace.each_object(singleton(klass)) do |sub| 
        if klass != sub
          @tree[klass] << sub
          object_list << sub
          object_list(sub) unless @tree.has_key?(sub)
        end
      end

      @tree
    end

    def object_tree(tree)
      tree.each do |key1 , value1|
        tree.each do |key2, value2|
          if key1 > key2
            tree[key1] -= (value2 - [key2])
          end
        end
      end
      tree
    end

    def create_tree(key, value)
      (value.size-1).times do |index|
        @tree_module[value[index]] << value[index+1] unless @tree_module[value[index]].include?(value[index+1])

        if value[index+1] == value.last
          @hash.delete(key)
          @hash.each do |k, v|
            if v.first == key
              v.first = value.last
              @hash[k] = v
            end
          end
        end
      end
    end

    def module_proc
      @hash.each do |key, value|
        create_tree(key, value)
      end
    end

    def draw(node)
      @last_list = []
      @node = node
      @node.each{|k, v| v.uniq! }
      draw_tree(@node, 0)
    end

    def draw_tree(node, nest, root = true, last = false)
      if nest > 0 
        @last_list[nest-1] = last
      end
      node.each do |key, value|
        puts key
        next if @check_list[key]
        @check_list[key] = true

        value.each do |v|
          @last_list[nest] = true if v == value.last

          if !root && !last
            nest.times do |index|
              print @last_list[index]? "  " : "│ "
              print " " * SIZE
            end
          elsif nest > 0 && last
            nest.times do |index|
              print (@last_list[index])? "  " : "│ "
              print " " * SIZE
            end
          end

          unless @node.has_key?(v)
            print ( v == value.last )? "└─ ─ ── " : "├─ ─ ── "
            p v
          else
            if v == value.last
              print "└─ ─ ── "
              draw_tree({ v => @node[v]}, nest + 1, false, true)
            else
              print "├─ ─ ── "
              draw_tree({ v => @node[v]}, nest + 1, false, false)
            end
          end
        end

        @node.delete(key)
      end
    end
  end
end
