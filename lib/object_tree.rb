# encoding: utf-8
require "object_tree/version"

class Module
  def prepended_modules
    ancestors = self.ancestors
    ancestors[0..ancestors.find_index(self)] - [self]
  end
end

module ObjectTree

  class Tree
    attr_reader :tree
    SPACE_SIZE = 6
    MCOLOR = 33
    CCOLOR = 32

    def initialize(klass, mflag = false)
      @tree = Hash.new{|h, k| h[k] = [] }
      @mflag = mflag
      @klass = klass

      if klass == BasicObject
        klass = Object
        @superclass = BasicObject
        if mflag
          @tree[BasicObject] << Object
        end
      else
        @superclass = klass.superclass
      end

      create_object_tree(object_list(klass))
    end

    class << self
      alias :create :new
    end

    def singleton(klass)
      class << klass; self end
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

    def create_object_tree(tree)
      tree.each do |key1 , value1|
        tree.each do |key2, value2|
          if key1 > key2
            tree[key1] -= (value2 - [key2])
          end
        end
      end

      tree
    end

    def draw
      @last_check = []
      if @tree.size.zero? 
        puts @klass
      else
        draw_tree({ @tree.first.first => @tree.first.last }, 0)
      end
    end

    def draw_tree(tree, nest, root = true, last = false)

      @last_check[nest-1] = last if nest > 0

      tree.each do |key, value|
        if ( @mflag && key.kind_of?(Class) && !key.superclass.nil? )
          module_list = key.ancestors[0..key.ancestors.find_index(key.superclass)-1].reverse - [key, key.superclass] - key.prepended_modules
          module_list.each_with_index do |m, add|
            puts "<M>\e[#{MCOLOR}m#{m.name}\e[m"
            @last_check[nest] = true
            nest.times do |index|
              print (@last_check[index])? "  " : "│ "
              print " " * SPACE_SIZE
            end
            print "└─ ─ ── "
            nest += 1
          end
        end

        print ( key.kind_of?(Class) )? "<C>\e[#{CCOLOR}m" : "<M>\e[#{MCOLOR}m"
        puts "#{key.name}\e[m"

        value.each do |v|
          @last_check[nest] = true if v == value.last

          nest.times do |index|
            print (@last_check[index])? "  " : "│ "
            print " " * SPACE_SIZE
          end

          if @tree.has_key?(v)
            print ( v == value.last )? "└─ ─ ── " : "├─ ─ ── "
            if v == value.last
              draw_tree({ v => @tree[v]}, nest + 1, false, true)
            else
              draw_tree({ v => @tree[v]}, nest + 1, false, false)
            end
          else
            print ( v == value.last )? "└─ ─ ── " : "├─ ─ ── "
            nest_num = 0
            if( @mflag && v.kind_of?(Class) ) 
              module_list = v.ancestors[0..v.ancestors.find_index(key)-1].reverse - [v, key] - v.prepended_modules
              @last_check[nest] = ( v == value.last )? true : false
              module_list.each_with_index do |m, add|
                print "<M>\e[#{MCOLOR}m"
                puts "#{m.name}\e[m"
                @last_check[nest+add+1] = true
                (nest+add+1).times do |index|
                  print (@last_check[index])? "  " : "│ "
                  print " " * SPACE_SIZE
                end
                print "└─ ─ ── "
                nest_num += 1
              end
            end
            print ( v.kind_of?(Class) )? "<C>\e[#{CCOLOR}m" : "<M>\e[#{MCOLOR}m"
            puts "#{v.name}\e[m"

            if ( @mflag && v.kind_of?(Class) )
              prepended_modules = v.prepended_modules
              prepended_modules.each_with_index do |m, add|
                (nest+nest_num+add+1).times do |index|
                  print (@last_check[index])? "  " : "│ "
                  print " " * SPACE_SIZE
                end
                print "└─ ─ ── "
                print "<M>\e[#{MCOLOR}m"
                puts "#{m.name}\e[m"
                @last_check[nest+add+1] = true
              end
            end
          end
        end
      end
    end
  end
end
