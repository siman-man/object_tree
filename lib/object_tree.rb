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

    # 31: red, 32: green, 33: yellow, 34: blue, 35: pink, 36: aqua, 37: gray
    MCOLOR = 31
    CCOLOR = 32

    def initialize(klass, mflag = false)
      @tree = Hash.new{|h, k| h[k] = [] }
      @mflag = mflag
      @root_class = klass

      if RUBY_VERSION >= "1.9" && klass == BasicObject
        klass = Object
        @tree[BasicObject] << Object
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
      tree.each do |klass1, subclasses1|
        tree.each do |klass2, subclasses2|
          if klass1 > klass2
            tree[klass1] -= (subclasses2 - [klass2])
          end
        end
      end

      tree
    end

    def draw
      if @tree.size.zero? 
        puts "\e[#{CCOLOR}m<C>\e[m#{@root_class}"
      else
        @last_check = []
        draw_tree({ @root_class => @tree[@root_class] }, 0)
      end
    end

    def draw_tree(tree, nest, root = true, last = false)

      @last_check[nest-1] = last if nest > 0

      tree.each do |klass, subclasses|
        if ( @mflag && klass.kind_of?(Class) && !klass.superclass.nil? )
          module_list = klass.ancestors[0..klass.ancestors.find_index(klass.superclass)-1].reverse - [klass, klass.superclass] - klass.prepended_modules

          module_list.each_with_index do |m, add|
            puts "\e[#{MCOLOR}m<M>\e[m#{m.inspect}"
            @last_check[nest] = true

            nest.times do |column_number|
              print ((@last_check[column_number])? "  " : "│ ") + " " * SPACE_SIZE
            end
            print "└─ ─ ── "
            nest += 1
          end
        end

        puts ( klass.kind_of?(Class) )? "\e[#{CCOLOR}m<C>\e[m#{klass.inspect}" : "\e[#{MCOLOR}m<M>\e[m#{klass.inspect}"

        subclasses.each do |sub|
          @last_check[nest] = true if sub == subclasses.last

          nest.times do |column_number|
            print ((@last_check[column_number])? "  " : "│ ") + " " * SPACE_SIZE
          end

          if @tree.has_key?(sub)
            print ( sub == subclasses.last )? "└─ ─ ── " : "├─ ─ ── "
            if sub == subclasses.last
              draw_tree({ sub => @tree[sub]}, nest + 1, false, true)
            else
              draw_tree({ sub => @tree[sub]}, nest + 1, false, false)
            end
          else
            print "#{( sub == subclasses.last )? '└─ ─ ── ' : '├─ ─ ── '}"
            nest_count = 0
            if( @mflag && sub.kind_of?(Class) ) 
              module_list = sub.ancestors[0..sub.ancestors.find_index(klass)-1].reverse - ([sub, klass] + sub.prepended_modules)
              @last_check[nest] = ( sub == subclasses.last )? true : false

              module_list.each_with_index do |m, add|
                puts "\e[#{MCOLOR}m<M>\e[m#{m.inspect}"
                @last_check[nest+add+1] = true

                (nest+add+1).times do |column_number|
                  print ((@last_check[column_number])? "  " : "│ ") + " " * SPACE_SIZE
                end
                print "└─ ─ ── "
                nest_count += 1
              end
            end
            puts ( sub.kind_of?(Class) )? "\e[#{CCOLOR}m<C>\e[m#{sub.inspect}" : "\e[#{MCOLOR}m<M>\e[m#{sub.inspect}"

            if ( @mflag && sub.kind_of?(Class) )
              prepended_modules = sub.prepended_modules

              prepended_modules.each_with_index do |m, add|
                (nest+nest_count+add+1).times do |column_number|
                  print ((@last_check[column_number])? "  " : "│ ") + " " * SPACE_SIZE
                end
                puts "└─ ─ ── \e[#{MCOLOR}m<M>\e[m#{m.inspect}"
                @last_check[nest+add+1] = true
              end
            end
          end
        end
      end
    end
  end
end
